$(document).ready(function(){
    var content = $(".email");
    content.load("ihatespam.htm");
});

jQuery(document).ready(function($) {
    $("#content").find("h1,h2,h3,h4,h5,h6").addAnchor(_("Link to this section"));
    $("#content").find(".wikianchor").each(function() {
        $(this).addAnchor(babel.format(_("Link to #%(id)s"), {id: $(this).attr('id')}));
    });
    $(".foldable").enableFolding(true, true);
});
