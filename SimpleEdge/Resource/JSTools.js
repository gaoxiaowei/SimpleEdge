function getWebPageDescription() {
  let meta = document.querySelector('meta[property="og:description"]') || document.querySelector('meta[property="description"]');
  return meta ? meta.content : ''
}

function getWebPageShareIcon() {
    var meta = document.querySelector('*[property="og:img"]')
    if(meta){
        return  meta.content
    }
    var icon = document.querySelector('link[rel="shortcut icon"]');
    return icon.href
}
