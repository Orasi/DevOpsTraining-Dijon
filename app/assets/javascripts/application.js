// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require timeago
//= require select2
//= require turbolinks
//= require_tree .

String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1).toLowerCase();
}
if (localStorage.getItem("sideBar") == null){
    localStorage.setItem("sideBar", true);
}
$(document).ready(function(){

    if (localStorage.getItem("sideBar") === "true"){
        $(".nav-link-text").show();
        $('.worker_count_large').show()
        $('.worker_count_show').hide()
        $(".sidebar").width("250px");
        $("#dashboard").css("margin-left", "250px");
        $(".collapse-sidebar-button").removeClass("glyphicon-chevron-right");
        $(".collapse-sidebar-button").addClass("glyphicon-chevron-left");
    }else{
        $(".nav-link-text").hide();
        $('.worker_count_large').hide()
        $('.worker_count_show').show()
        $(".sidebar").width("50px");
        $("#dashboard").css("margin-left", "50px");
        $(".collapse-sidebar-button").removeClass("glyphicon-chevron-left");
        $(".collapse-sidebar-button").addClass("glyphicon-chevron-right");
    }

    $(".nav-collapse").on("click", function(e){

        this.blur();
        e.preventDefault();

        var toggleWidth = $(".sidebar").width() == 250 ? "50px" : "250px";

        if (toggleWidth=="50px"){
            $(".nav-link-text").fadeOut('fast', function(){
                $('.worker_count_large').hide()
                $('.worker_count_show').show()
            });

            $(".collapse-sidebar-button").removeClass("glyphicon-chevron-left");
            $(".collapse-sidebar-button").addClass("glyphicon-chevron-right");
            localStorage.setItem("sideBar", false);
        }else{
            $(".nav-link-text").fadeIn('fast', function(){
                $('.worker_count_show').hide()
                $('.worker_count_large').show()
            });

            $(".collapse-sidebar-button").removeClass("glyphicon-chevron-right");
            $(".collapse-sidebar-button").addClass("glyphicon-chevron-left");
            localStorage.setItem("sideBar", true);
        }

        $('.sidebar').animate({ width: toggleWidth });
        $('#dashboard').animate({ 'margin-left' : toggleWidth });
    });

});
$(document).on("page:fetch", function(){
    $(".loading-overlay").show();
});

$(document).on("page:receive", function(){
    $(".loading-overlay").hide();
});
