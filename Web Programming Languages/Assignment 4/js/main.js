$(document).ready(function() {
    $('header').load('fragments/header.html');
    $('footer').load('fragments/footer.html');

    $('#passengers-icon').click(function() {
        $('#passengers').toggle();
    });

    $('#adults-toggle').click(function() {
        $('.adults').toggle();
    });

    $('#children-toggle').change(function() {
        $('.children').toggle();
    });

    $('#infants-toggle').change(function() {
        $('.infants').toggle();
    });
});