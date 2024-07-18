
$(document).ready(function() {
    $('#contact-us-form').on("submit", function(event) {
        event.preventDefault();

        const firstname = $('#firstname').val().trim();
        const lastname = $('#lastname').val().trim();
        const phonenumber = $('#phonenumber').val().trim();
        const email = $('#email').val().trim();
        const comment = $('#comment').val().trim();

        const nameRegex = /^[A-Za-z]+$/;
        const phoneRegex = /^\(\d{3}\) ?\d{3}-\d{4}$/;

        const error =
            !firstname.match(nameRegex) || !lastname.match(nameRegex) ?
                'First name and last name should only be alphabetic.' :
            firstname.charAt(0) !== firstname.charAt(0).toUpperCase() || lastname.charAt(0) !== lastname.charAt(0).toUpperCase() ?
                'First letter of first name and last name should be capitalized.' :
            firstname === lastname ?
                'First name and last name cannot be the same.' :
            !phonenumber.match(phoneRegex) ?
                'Phone number must be formatted as (ddd) ddd-dddd.' :
            !email.includes('@') || !email.includes('.') ?
                'Email address must contain @ and .' :
            comment.length < 10 ?
                'Comment must be at least 10 characters.' :
            false;

        if (!error) {
            $('#error').text('');
            $.ajax({
                url: 'php/contact_us.php',
                method: 'POST',
                data: {
                    firstname: firstname,
                    lastname: lastname,
                    phonenumber: phonenumber,
                    email: email,
                    gender: $('input[name="gender"]:checked').val(),
                    comment: comment
                },
                success: function() {
                    alert("Saved!");
                }
            });
        }
        else {
            $('#error').text(error);
        }
    });
});