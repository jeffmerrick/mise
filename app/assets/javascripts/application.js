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
//= require selectize

$(function() {

  $('#recipe_category_list, #recipe_tag_list').selectize({
      delimiter: ',',
      persist: false,
      create: function(input) {
          return {
              value: input,
              text: input
          }
      }
  });

  $('.tabs').each(function(index) {
    $(this).children('li').first().children('a').addClass('is-active').next().addClass('is-open').show();
  });

  $('.tabs').on('click', 'li > a.tab-link', function(event) {
    if (!$(this).hasClass('is-active')) {
      event.preventDefault();
      var accordionTabs = $(this).closest('.tabs');
      accordionTabs.find('.is-open').removeClass('is-open').hide();

      $(this).next().toggleClass('is-open').toggle();
      accordionTabs.find('.is-active').removeClass('is-active');
      $(this).addClass('is-active');
    } else {
      event.preventDefault();
    }
  });

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
      $(this).find("span").html("Show source website");
    } else {
      $("#source").attr("src", $(this).attr("href"));
      $("body").addClass("show-iframe");
      $(this).find("span").html("Hide source website");
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

  $(".instructions").find("ul").on("click", function(){
    s = window.getSelection();
    var range = s.getRangeAt(0);
    var node = s.anchorNode;
    while (range.toString().indexOf(' ') != 0) {
        range.setStart(node, (range.startOffset - 1));
    }
    range.setStart(node, range.startOffset + 1);
    do {
        range.setEnd(node, range.endOffset + 1);

    } while (range.toString().indexOf(' ') == -1 && range.toString().trim() != '' && range.endOffset < node.length);
    var str = range.toString().trim().replace(/[^A-Za-z ]+/g, '');
    $(".instructions").unmark()
    $(".ingredients").find("li").removeClass("highlight");
    $(".ingredients").unmark().mark(str, {
      accuracy: "partial"
    });
  });

  $(".ingredients").find("li").on("click", function(){
    var str = $(this).html().replace(/[^A-Za-z ]+/g, '').removeStopWords();
    $(".ingredients").unmark();
    $(".ingredients").find("li").removeClass("highlight");
    $(this).addClass("highlight");
    $(".instructions").unmark().mark(str, {
      accuracy: "exact"
    });
  });  

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
