// jQuery
//= require jquery/jquery
//= require jquery-ujs/rails
//= require jquery.remotipart

// User by pixel-admin and in menu ordering (sortable, disableSelection) page
//= require jquery-ui/jquery-ui

// Bootstrap
//= require bootstrap-sass/javascripts/bootstrap-sprockets

// Used to present flash messages on AJAX calls
//= require jquery-growl/jquery.growl

// Used in quick start wizard
//= require jquery-steps/jquery.steps

// Used by pixel-admin and in datepickers
//= require moment/moment

// Used in push notifications page
//= require eonasdan-bootstrap-datetimepicker/bootstrap-datetimepicker.min

// Used in coupons page
//= require bootstrap-datepicker/bootstrap-datepicker

// Used in colors page
//= require jquery-minicolors/jquery.minicolors

// Used in cover image, screenshots pages
//= require dropzone/dropzone.min

// Used in pixel-admin and sign-up, sign-in pages
//= require jquery-validation/jquery.validate

// Used in home page for app downloads graph
//= require raphael/raphael
//= require morrisjs/morris

//= require jquery.pjax

// Application dependencies
//= require_tree ./global
//= require_tree .
//= stub ie

// pixel-admin
//= require Vague.js/Vague
//= require jquery.transit/jquery.transit
//= require fastclick/fastclick
//= require slimScroll/jquery.slimscroll.min
//= require pixel-admin

$(document).ready(function() {
  window.PixelAdmin.start();
  Dropzone.autoDiscover = false;
});
