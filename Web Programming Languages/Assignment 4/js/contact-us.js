
$(document).ready(function() {
    $('#contact-us-form').on("submit", function(event) {
        event.preventDefault();

        const comment = $('#comment').val().trim();

        const error =
            !document.cookie.includes('userInfo') ?
                'You must be logged in to submit a comment.' :
            comment.length < 10 ?
                'Comment must be at least 10 characters.' :
            false;

        if (!error) {
            $('#error').text('');
            $.ajax({
                url: 'php/contact_us.php',
                method: 'POST',
                data: {
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