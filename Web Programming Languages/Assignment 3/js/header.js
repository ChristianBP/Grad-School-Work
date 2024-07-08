$(document).ready(function() {
    function displayDateTime() {
        const now = new Date();
        $('#datetime').text(now.toLocaleString());
    }

    displayDateTime();
    setInterval(displayDateTime, 1000);

    $('#font-size').on("change", function() {
        $('body').css('font-size', $(this).val());
    });
    
    $('#bg-color').on("change", function() {
        $('main').css('background-color', $(this).val());
    });
});