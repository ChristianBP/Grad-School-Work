$(document).ready(function() {
    $('#login-form').on("submit", function(event) {
        event.preventDefault();

        const phonenumber = $('#phonenumber').val().trim();
        const password = $('#password').val().trim();

        $.post('php/login.php', {
            phonenumber: phonenumber,
            password: password
        }, function(data) {
            if (data === 'success') {
                window.location.href = 'index.html';
            } else {
                $('#error').html(data);
            }
        });
    });
});