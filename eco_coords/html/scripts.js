window.addEventListener('message', function (event) {
    copyToClipboard(event.data.text)
});

function copyToClipboard(string) {
    let $temp = $("<input>");
    $("body").append($temp);
    $temp.val(string).select();
    document.execCommand("copy");
    $temp.remove();
}