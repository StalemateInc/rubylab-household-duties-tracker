# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  'use strict'
  $ ->
    $('#task_expires_at').datetimepicker
      locale: 'en-gb'
      inline: true
      format: 'YYYY-MM-DD HH:mm'
      minDate: moment().add(5, 'minutes')
      defaultDate: moment().add(5, 'minutes')
      icons:
        time: 'fas fa-clock'
    return
  return