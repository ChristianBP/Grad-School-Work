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

    if (document.cookie.includes('userInfo')) {
        const cookieValue = decodeURIComponent(document.cookie
            .split('; ')
            .find(row => row.startsWith('userInfo='))
            .split('=')[1]);

        const { firstName, lastName } = JSON.parse(cookieValue);
        $('#userinfo').text(`Welcome, ${firstName} ${lastName}`);
        $('#logged-in-menu').css('display', 'flex');
        $('#logout').show();
        $('#logged-out-menu').hide();
    }

    $('#logout').on("click", function() {
        document.cookie = 'userInfo=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
        window.location.href = 'index.html';
    });
});