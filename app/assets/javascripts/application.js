// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery-ui
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require popper
//= require bootstrap
//= require moment
//= require moment/en-gb.js
//= require moment/ru.js
//= require moment-timezone-with-data-2010-2020
//= require tempusdominus-bootstrap-4.js
//= require countdown.min
//= require js.cookie
//= require_tree .

const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
if (Cookies.get('timezone') === undefined) {
    Cookies.set('timezone', timezone, {expires: 24});
}