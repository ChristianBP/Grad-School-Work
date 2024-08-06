
$(document).ready(function() {
    $('#register-form').on("submit", function(event) {
        event.preventDefault();

        $.getJSON('php/getphonenumbers.php', function(data) {
            const usedPhoneNumbers = data;

            const firstname = $('#firstname').val().trim();
            const lastname = $('#lastname').val().trim();
            const phonenumber = $('#phonenumber').val().trim();
            const email = $('#email').val().trim();
            const password = $('#password').val().trim();
            const confirmPassword = $('#confirmpassword').val().trim();
    
            const nameRegex = /^[A-Za-z]+$/;
            const phoneRegex = /^\d{3}-\d{3}-\d{4}$/;

            const error =
                !firstname.match(nameRegex) || !lastname.match(nameRegex) ?
                    'First name and last name should only be alphabetic.' :
                firstname.charAt(0) !== firstname.charAt(0).toUpperCase() || lastname.charAt(0) !== lastname.charAt(0).toUpperCase() ?
                    'First letter of first name and last name should be capitalized.' :
                firstname === lastname ?
                    'First name and last name cannot be the same.' :
                password.length < 8 ?
                    'Password must be at least 8 characters long.' :
                password !== confirmPassword ?
                    'Passwords do not match.' :
                !phonenumber.match(phoneRegex) ?
                    'Phone number must be formatted as ddd-ddd-dddd.' :
                usedPhoneNumbers.includes(phonenumber) ?
                    'Phone number already in use.' :
                !email.includes('@') || !email.includes('.com') ?
                    'Email address must contain @ and .com' :
                false;

            if (!error) {
                $('#error').text('');
                $.ajax({
                    url: 'php/register.php',
                    method: 'POST',
                    data: {
                        phonenumber: phonenumber,
                        firstname: firstname,
                        lastname: lastname,
                        email: email,
                        dob: $('#dob').val(),
                        password: password,
                        gender: $('input[name="gender"]:checked').val()
                    },
                    success: function() {
                        if (confirm("Registered! Click OK to continue to the login page.")) {
                            window.location.href = 'login.html';
                        };
                    }
                });
            }
            else {
                $('#error').text(error);
            }
        });
    });
});