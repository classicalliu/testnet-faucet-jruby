// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('turbolinks:load', () => {
  let src = $(".simple_captcha_refresh_button a").attr("href");
  let captchaImg = $("#captcha img");

  captchaImg.click((e) => {
    $.get(src, function(result){
      eval(result)
    });
  });

  captchaImg.addClass("col-sm-5");
  $("#captcha input").addClass("form-control col-sm-5")
});
