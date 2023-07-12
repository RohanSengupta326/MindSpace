var about = document.getElementById("About");
var contact = document.getElementById("Contact");
var download = document.getElementById("Download");
var targetpos = 4500;
var currentpos = 0;
var scrollInterval;
function scrollabout() {
    if (currentpos >= targetpos) {
        clearInterval(scrollInterval);
        return;
    }
    currentpos += 100;
    window.scrollBy(0, 100);
}
function scrollcontact() {
    targetpos = 4500;
    if (currentpos >= targetpos) {
        clearInterval(scrollInterval);
        return;
    }
    currentpos += 100;
    window.scrollBy(0, 100);
}
function scrolldownload() {
    targetpos=400;
    if (currentpos >= targetpos) {
        clearInterval(scrollInterval);
        return;
    }
    currentpos += 100;
    window.scrollBy(0, 100);
}

about.addEventListener('click', function() {
      scrollInterval = setInterval(scrollabout,100);
});
contact.addEventListener('click', function() {
      scrollInterval = setInterval(scrollcontact,100);
});
download.addEventListener('click', function() {
      scrollInterval = setInterval(scrolldownload,100);
});
