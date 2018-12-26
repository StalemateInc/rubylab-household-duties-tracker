@startEveryTimer = (string_selector = '.expire_timer') ->
  clientTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  timersSpans = $(string_selector)
  $.each timersSpans, (_index, timerSpan) ->
    data_expires = $(timerSpan).data('expires-at')
    timer = new Countdown(
      selector: '#' + $(timerSpan).attr('id')
      msgBefore: ''
      msgAfter: 'Expired.'
      msgPattern: '{days} days, {hours} hours, {minutes} minutes and {seconds} seconds left'
      dateEnd: moment(data_expires).tz(clientTimeZone)._d)
    return
  return

$(document).on 'turbolinks:load', ->
  'use strict'
  startEveryTimer()
  return
