//
//  NSString+PunycodeAdditions.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

enum {
	base = 36,
	tmin = 1,
	tmax = 26,
	skew = 38,
	damp = 700,
	initial_bias = 72,
	initial_n = 0x80,
	delimiter = '-'
};

/* basic(cp) tests whether cp is a basic code point: */
#define basic(cp) ((unsigned)(cp) < 0x80)

/* delim(cp) tests whether cp is a delimiter: */
#define delim(cp) ((cp) == delimiter)

/* decode_digit(cp) returns the numeric value of a basic code */
/* point (for use in representing integers) in the range 0 to */
/* base-1, or base if cp is does not represent a value.       */

static NSUInteger decode_digit(unsigned cp)
{
	return  cp - 48 < 10 ? cp - 22 :  cp - 65 < 26 ? cp - 65 :
	cp - 97 < 26 ? cp - 97 : base;
}

/* encode_digit(d,flag) returns the basic code point whose value      */
/* (when used for representing integers) is d, which needs to be in   */
/* the range 0 to base-1.  The lowercase form is used unless flag is  */
/* nonzero, in which case the uppercase form is used.  The behavior   */
/* is undefined if flag is nonzero and digit d has no uppercase form. */

static char encode_digit(unsigned d, int flag)
{
	return (char)(d + 22 + 75 * (d < 26) - ((flag != 0) << 5));
	/*  0..25 map to ASCII a..z or A..Z */
	/* 26..35 map to ASCII 0..9         */
}

/* flagged(bcp) tests whether a basic code point is flagged */
/* (uppercase).  The behavior is undefined if bcp is not a  */
/* basic code point.                                        */

#define flagged(bcp) ((unsigned)(bcp) - 65 < 26)

/*** Platform-specific constants ***/

/* maxint is the maximum value of a punycode_uint variable: */
static const unsigned maxint = UINT_MAX;

/*** Bias adaptation function ***/

static NSUInteger adapt(unsigned delta, unsigned numpoints, BOOL firsttime) {
	unsigned k;
	
	delta = firsttime ? delta / damp : delta >> 1;
	delta += delta / numpoints;
	
	for (k = 0;  delta > ((base - tmin) * tmax) / 2;  k += base) {
		delta /= base - tmin;
	}
	
	return k + (base - tmin + 1) * delta / (delta + skew);
}

@interface NSString (PunycodePrivate)

- (NSDictionary *)URLParts;

@end

@implementation NSString (PunycodeAdditions)

/*** Main encode function ***/

#if BYTE_ORDER == LITTLE_ENDIAN
#define UTF32_ENCODING NSUTF32LittleEndianStringEncoding
#elif BYTE_ORDER == BIG_ENDIAN
#define UTF32_ENCODING NSUTF32BigEndianStringEncoding
#else
#error Unsupported endianness!
#endif

- (const UTF32Char *)longCharactersWithCount:(NSUInteger *)count {
	NSData *data = [self dataUsingEncoding:UTF32_ENCODING];
	*count = [data length] / sizeof(UTF32Char);
	return [data bytes];
}

- (NSString *)punycodeEncodedString {
	NSMutableString *ret = [NSMutableString string];
	unsigned delta, outLen, bias, j, m, q, k, t;
	NSUInteger input_length;
	const UTF32Char *longchars = [self longCharactersWithCount:&input_length];	
	
	UTF32Char n = initial_n;
	delta = outLen = 0;
	bias = initial_bias;
		
	for (j = 0;  j < input_length;  ++j) {
		if (basic(longchars[j])) {
			[ret appendFormat:@"%C", (unichar)longchars[j]];
			++outLen;
		}
	}
	
	NSUInteger b;
	NSUInteger h = b = outLen;
	
	if (b > 0)
		[ret appendFormat:@"%C", (unichar)delimiter];
	
	/* Main encoding loop: */
	
	while (h < input_length) {
		for (m = maxint, j = 0;  j < input_length;  ++j) {
			unsigned c = longchars[j];
			
			if (c >= n && c < m)
				m = longchars[j];
		}
		
		if (m - n > (maxint - delta) / (h + 1))
			return nil; //punycode_overflow;
		delta += (m - n) * (h + 1);
		n = m;
		
		for (j = 0;  j < input_length;  ++j) {
			unsigned c = longchars[j];
			
			if (c < n /* || basic([self characterAtIndex:j]) */ ) {
				if (++delta == 0)
					return nil; //punycode_overflow;
			}
			
			if (c == n) {				
				for (q = delta, k = base;  ;  k += base) {
					t = k <= bias /* + tmin */ ? tmin :     /* +tmin not needed */
						k >= bias + tmax ? tmax : k - bias;
					if (q < t)
						break;
					[ret appendFormat:@"%C", (unichar)encode_digit(t + (q - t) % (base - t), 0)];
					q = (q - t) / (base - t);
				}
				
				[ret appendFormat:@"%c", encode_digit(q, 0)];
				bias = (unsigned)adapt(delta, (unsigned)h + 1, h == b);
				delta = 0;
				++h;
			}
		}
		
        (void)(++delta), ++n;
	}
	
	return ret;
}

/*** Main decode function ***/

- (NSString *)punycodeDecodedString {
	NSUInteger b, i, j;
	
	NSMutableData *utf32data = [NSMutableData data];
	
	/* Initialize the state: */
	NSUInteger input_length = [self length];
	UTF32Char n = initial_n;
	NSUInteger outLen = i = 0;
	NSUInteger max_out = NSUIntegerMax;
	NSUInteger bias = initial_bias;
	
	for (b = j = 0;  j < input_length;  ++j)
		if (delim([self characterAtIndex:j]))
			b = j;
	
	if (b > max_out)
		return nil; //punycode_big_output;
	
	for (j = 0;  j < b;  ++j) {
		UTF32Char c = (UTF32Char)[self characterAtIndex:j];
		
		if (!basic([self characterAtIndex:j]))
			return nil; //punycode_bad_input;
		
		[utf32data appendBytes:&c length:sizeof(c)];
		++outLen;
	}
	
	for (NSUInteger inPos = b > 0 ? b + 1 : 0; inPos < input_length; ++outLen, ++i) {
		NSUInteger k, w, t, oldi;
		
		for (oldi = i, w = 1, k = base; /* nada */ ; k += base) {
			if (inPos >= input_length)
				return nil; // punycode_bad_input;
			unsigned digit = (unsigned)decode_digit([self characterAtIndex:inPos++]);
			if (digit >= base)
				return nil; // punycode_bad_input;
			if (digit > (maxint - i) / w)
				return nil; // punycode_overflow;
			i += digit * w;
			t = k <= bias /* + tmin */ ? tmin :     /* +tmin not needed */
				k >= bias + tmax ? tmax : k - bias;
			if (digit < t)
				break;
			if (w > maxint / (base - t))
				return nil; // punycode_overflow;
			w *= (base - t);
		}
		
		bias = adapt((unsigned)i - (unsigned)oldi, (unsigned)outLen + 1, oldi == 0);
		
		if (i / (outLen + 1) > maxint - n)
			return nil; // punycode_overflow;
		n += i / (outLen + 1);
		i %= (outLen + 1);
		
		[utf32data replaceBytesInRange:NSMakeRange(i * sizeof(UTF32Char), 0) withBytes:&n length:sizeof(n)];
	}
	
#if __has_feature(objc_arc)
	return [[NSString alloc] initWithData:utf32data encoding:UTF32_ENCODING];
#else
	return [[[NSString alloc] initWithData:utf32data encoding:UTF32_ENCODING] autorelease];
#endif
}

- (NSString *)IDNAEncodedString {
	NSCharacterSet *nonAscii = [[NSCharacterSet characterSetWithRange:NSMakeRange(1, 127)] invertedSet];
	NSMutableString *ret = [NSMutableString string];
	NSScanner *s = [NSScanner scannerWithString:[self precomposedStringWithCompatibilityMapping]];
	NSCharacterSet *dotAt = [NSCharacterSet characterSetWithCharactersInString:@".@"];
	NSString *input = nil;
	
	while (![s isAtEnd]) {
		if ([s scanUpToCharactersFromSet:dotAt intoString:&input]) {
			if ([input rangeOfCharacterFromSet:nonAscii].location != NSNotFound) {
				[ret appendFormat:@"xn--%@", [input punycodeEncodedString]];
			} else
				[ret appendString:input];
		}
		
		if ([s scanCharactersFromSet:dotAt intoString:&input])
			[ret appendString:input];
	}
		
	return ret;
}

- (NSString *)IDNADecodedString {
	NSMutableString *ret = [NSMutableString string];
	NSScanner *s = [NSScanner scannerWithString:self];
	NSCharacterSet *dotAt = [NSCharacterSet characterSetWithCharactersInString:@".@"];
	NSString *input = nil;
	
	while (![s isAtEnd]) {
		if ([s scanUpToCharactersFromSet:dotAt intoString:&input]) {
			if ([[input lowercaseString] hasPrefix:@"xn--"]) {
				NSString *substr = [[input substringFromIndex:4] punycodeDecodedString];
				
				if (substr)
					[ret appendString:substr];
			} else
				[ret appendString:input];
		}
		
		if ([s scanCharactersFromSet:dotAt intoString:&input])
			[ret appendString:input];
	}
	
	return ret;
}

- (NSDictionary *)URLParts {
	NSCharacterSet *colonSlash = [NSCharacterSet characterSetWithCharactersInString:@":/"];
	NSScanner *s = [NSScanner scannerWithString:[self precomposedStringWithCompatibilityMapping]];
	NSString *scheme = @"";
	NSString *delim = @"";
	NSString *username = nil;
	NSString *password = nil;
	NSString *host = @"";
	NSString *path = @"";
	NSString *fragment = nil;
	
	if ([s scanUpToCharactersFromSet:colonSlash intoString:&host]) {
		if (![s isAtEnd] && [self characterAtIndex:[s scanLocation]] == ':') {
			scheme = host;
			
			if (![s isAtEnd])
				[s scanCharactersFromSet:colonSlash intoString:&delim];
			if (![s isAtEnd])
				[s scanUpToCharactersFromSet:colonSlash intoString:&host];
		}
	}
	
	if (![s isAtEnd])
		[s scanUpToString:@"#" intoString:&path];

	if (![s isAtEnd]) {
		[s scanString:@"#" intoString:nil];
		[s scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&fragment];
	}
	
	NSCharacterSet *colonAt = [NSCharacterSet characterSetWithCharactersInString:@":@"];
	
	s = [NSScanner scannerWithString:host];
	NSString *temp = nil;
	
	if ([s scanUpToCharactersFromSet:colonAt intoString:&temp]) {
		if (![s isAtEnd]) {
			username = temp;
			
			if ([host characterAtIndex:[s scanLocation]] == ':') {
				[s scanCharactersFromSet:colonAt intoString:&temp];
								
				if (![s isAtEnd] && [s scanUpToCharactersFromSet:colonAt intoString:&temp])
					password = temp;
			}
			
			[s scanCharactersFromSet:colonAt intoString:nil];
						
			if (![s isAtEnd] && [s scanUpToCharactersFromSet:colonAt intoString:&temp])
				host = temp;
		}
	}
	
	NSMutableDictionary *parts = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  scheme,	@"scheme",
								  delim,	@"delim",
								  host,		@"host",
								  path,		@"path",
								  nil];
	
	if (username)
		parts[@"username"] = username;
	if (password)
		parts[@"password"] = password;
	if (fragment)
		parts[@"fragment"] = fragment;
	
	return parts;
}

- (NSString *)encodedURLString {
	// We can't get the parts of an URL for an international domain name, so a custom method is used instead.
	NSDictionary *urlParts = [self URLParts];
	NSString *path = urlParts[@"path"];
	path = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)path, CFSTR("%"), NULL, kCFStringEncodingUTF8);
	
#if !__has_feature(objc_arc)
	[path autorelease];
#endif
    
    NSString *scheme = @"http";
    NSString *delim = @"://";
    if ([urlParts[@"scheme"] length] > 0) {
        scheme = urlParts[@"scheme"];
        delim = urlParts[@"delim"];
    }
	NSMutableString *ret = [NSMutableString stringWithFormat:@"%@%@", scheme, delim];
	if (urlParts[@"username"]) {
		if (urlParts[@"password"])
			[ret appendFormat:@"%@:%@@", urlParts[@"username"], urlParts[@"password"]];
		else
			[ret appendFormat:@"%@@", urlParts[@"username"]];
	}
    
    NSString *host = [urlParts[@"host"] stringByReplacingOccurrencesOfString:@"。" withString:@"."];
    
    [ret appendFormat:@"%@%@", [host IDNAEncodedString], path];
	
	if (urlParts[@"fragment"])
		[ret appendFormat:@"#%@", urlParts[@"fragment"]];
			
	return ret;
}

- (NSString *)decodedURLString {
	NSDictionary *urlParts = [self URLParts];
	NSString *ret = [NSString stringWithFormat:@"%@%@%@%@", urlParts[@"scheme"], urlParts[@"delim"], [urlParts[@"host"] IDNADecodedString], [urlParts[@"path"] stringByRemovingPercentEncoding]];
	
	if (urlParts[@"fragment"])
		ret = [ret stringByAppendingFormat:@"#%@", urlParts[@"fragment"]];
	
	return ret;
}

@end

static NSString *URLStringFromUnsafeUTF8String(const char *UTF8String) {
    if (NULL == UTF8String) {
        return nil;
    }
    NSMutableString *URLString = [[NSMutableString alloc] init];
    for (uint32_t i = 0; UTF8String[i]; ++i) {
        char c = UTF8String[i];
        switch (c) {
            case '`':
            case '^':
            case '{':
            case '}':
            case '\\':
            case '"':
            case '<':
            case '>':
            case '|':
            case ' ':
            case '\t':
                [URLString appendFormat:@"%%%02X", (unsigned char)c];
                break;
            case '%': {
                char s[] = {
                    UTF8String[i + 1],
                    UTF8String[i + 2],
                };
                bool valid = true;
                for (int i = 0, count = sizeof(s)/sizeof(s[0]); i < count; ++i) {
                    if ((s[i] >= '0' && s[i] <= '9') ||
                        (s[i] >= 'A' && s[i] <= 'F') ||
                        (s[i] >= 'a' && s[i] <= 'f')) {
                    } else {
                        valid = false;
                    }
                }
                if (valid) {
                    [URLString appendFormat:@"%c", c];
                } else {
                    [URLString appendFormat:@"%%%02X", (unsigned char)c];
                }
                break;
            }
            default:
                [URLString appendFormat:@"%c", c];
                break;
        }
    }
    return URLString;
}

@implementation NSURL (PunycodeAdditions)

+ (NSURL *)URLWithUnsafeString:(NSString *)URLString {
    return [NSURL URLWithString:URLStringFromUnsafeUTF8String(URLString.UTF8String)];
}

+ (NSURL *)URLWithUnicodeString:(NSString *)URLString {
	return [NSURL URLWithUnsafeString:[URLString encodedURLString]];
}

- (NSString *)decodedURLString {
	return [[self absoluteString] decodedURLString];
}

@end
