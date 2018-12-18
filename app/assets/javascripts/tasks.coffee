startEveryTimer = (string_selector = '.expire_timer') ->
  timersSpans = $(string_selector)
  $.each timersSpans, (_index, timerSpan) ->
    timer = new Countdown(
      selector: '#' + $(timerSpan).attr('id')
      msgBefore: ''
      msgAfter: 'Expired.'
      msgPattern: '{days} days, {hours} hours, {minutes} minutes and {seconds} seconds left'
      dateEnd: new Date($(timerSpan).data('expires-at')))
    return
  return

$(document).on 'turbolinks:load', ->
  'use strict'
  startEveryTimer()
  return
