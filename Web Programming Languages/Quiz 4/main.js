function validateContactForm() {
    var firstname = document.getElementById("firstname").value;
    var lastname = document.getElementById("lastname").value;
    var age = document.getElementById("age").value;
    var email = document.getElementById("email").value;
    if ( !firstname.match(/^[A-Za-z]+$/) )
        document.getElementById("contact-form-error").innerHTML = "First name is invalid.";
    else if ( !lastname.match(/^[A-Za-z]+$/) )
        document.getElementById("contact-form-error").innerHTML = "Last name is invalid.";
    else if ( age < 1 || age > 120 )
        document.getElementById("contact-form-error").innerHTML = "Age is invalid.";
    else if ( !email.match(/@utd.edu/))
        document.getElementById("contact-form-error").innerHTML = "Email is invalid.";
    else{
        document.getElementById("contact-name").innerHTML = "<strong>Name: </strong>" + firstname + " " + lastname;
        document.getElementById("contact-age").innerHTML = "<strong>Age: </strong>" + age;
        document.getElementById("contact-email").innerHTML = "<strong>Email: </strong>" + email;
        document.getElementById("contact-form-error").innerHTML = "";
    }
}