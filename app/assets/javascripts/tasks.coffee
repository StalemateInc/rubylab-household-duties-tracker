convertMinsToHoursMins = (minutes) ->
  hours = Math.floor(minutes / 60)
  mins = minutes % 60
  [
    hours
    mins
  ]

convertHoursMinsToMins = (hours, minutes) ->
  +hours * 60 + +minutes

formIntervalString = (hours, minutes) ->
  hours + ' hours ' + minutes + ' minutes'

$(document).on 'turbolinks:load', ->
  'use strict'

  slider = $('#no_model_ttc_slider')
  hours_input = $('#no_model_ttc_hours')
  minutes_input = $('#no_model_ttc_minutes')
  ttc = $('#task_ttc')

  slider.on 'input', ->
    results = convertMinsToHoursMins(slider.val())
    hours_input.val(results[0])
    minutes_input.val(results[1])
    ttc.val(formIntervalString(results[0], results[1]))
    return
  $('#no_model_ttc_hours, #no_model_ttc_minutes').on 'change', ->
    hours = hours_input.val();
    minutes = minutes_input.val();
    slider.val(convertHoursMinsToMins(hours, minutes))
    ttc.val(formIntervalString(hours, minutes))
    return
  return
