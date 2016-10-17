// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {

  $("[data-toggle='collapse']").on("click", function(e){
    e.preventDefault();
    var $target;
    console.log("clicked")
    if($(this).is("[href]")) {
      $target = $($(this).attr("href"));
    } else {
      $target = $($(this).data("target"));
    }
    $target.toggleClass("hide");
  });

  $("#show-source").on("click", function(e){
    e.preventDefault();
    var attr = $("#source").attr("src");
    if (typeof attr !== typeof undefined && attr !== false) {
      $("#source").removeAttr("src");
      $("body").removeClass("show-iframe");
      $(this).html("Show source website");
    } else {
      $("#source").attr("src", $(this).attr("href"));
      $("body").addClass("show-iframe");
      $(this).html("Hide source website");
    }
  });

  $(".remove-double-spaces").on("click", function(){
    var $textarea = $(this).parent().next(".text").find("textarea");
    var instructions = $textarea.val();
    $textarea.val(instructions.replace(/  +/g, ""));
  });

  $(".remove-line-breaks").on("click", function(){
    var $textarea = $(this).parent().next(".text").find("textarea");
    var instructions = $textarea.val();
    $textarea.val(instructions.replace(/(\r\n|\n|\r)/gm,""));
  });


  if($(".ingredients").length) {
    var sticky = new Waypoint.Sticky({
      element: $(".ingredients")[0]
    });
  }

  function setAnchors(activeStep) {
    if(activeStep == 1) {
      $("#prev").addClass("disabled");
    } else {
      $("#prev").removeClass("disabled");
      $("#prev").attr("href", "#s-"+ (activeStep - 1)); 
    }
    if(activeStep == totalSteps) {
      $("#next").addClass("disabled");
    } else {   
      $("#next").removeClass("disabled");
      $("#next").attr("href", "#s-"+ (activeStep + 1));
    }
  }

  activeStep = 1;
  totalSteps = $(".step").length;

  $(".step").each(function(){
    $(this).waypoint(function(direction){
      if(direction == "up") {
        setAnchors($(this.element).data("step"));
      }
    }, { 
      offset: -10
    });

    $(this).waypoint(function(direction){
      if(direction == "down") {
        setAnchors($(this.element).data("step"));
      }
    }, { 
      offset: 10
    });

  });

});
