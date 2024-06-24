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

function navigateTable(){
    var tableChildren = document.getElementsByTagName("table")[0].tBodies[0].childNodes;
    var output = "";
    for (let i = 0; i < tableChildren.length; i++) {
        output += `Node Name: ${tableChildren[i].nodeName}<br>`;
        output += `Node Value: ${tableChildren[i].nodeValue}<br>`;
        output += `Parent Node: ${tableChildren[i].parentNode}<br>`;
        output += `Next Sibling: ${tableChildren[i].nextSibling}<br>`;
        output += `First Child: ${tableChildren[i].firstChild}<br>`;
        output += `Attributes:<br>`;
        if(tableChildren[i].attributes) {
            for (const attr of tableChildren[i].attributes) {
                output += `&nbsp;&nbsp;&nbsp;&nbsp;${attr.name}=${attr.value}<br>`;
            }
        }
        output += "<br>";
    }
    document.getElementById("navigateTable").innerHTML = output;
}