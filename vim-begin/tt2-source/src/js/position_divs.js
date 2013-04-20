function position_divs() {
    var client_w = document.body.clientWidth ;

    $("#content").css("width",
        client_w - 20 - ($("#right-sidebar") ? 410 : 250) + "px"
    );
}

$(document).ready(position_divs);
$(window).resize(position_divs);
