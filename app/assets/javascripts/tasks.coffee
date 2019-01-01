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
      onEnd: ->
        $.ajax
          url: ''.concat('/groups/', $(timerSpan).data('group'), '/tasks/', $(timerSpan).data('id'), '/estimate/stop')
          method: 'POST'
        return
      dateEnd: moment(data_expires).toDate())
    return
  return

displayRatingWidget = () ->
  if ($('#shown-rating').parent('#rating-div').length)
    $('#shown-rating').rating(displayOnly: true, step: 1, language: 'en', size: 'sm')
  return

@showCardRatings = (string_selector = '.card-rating') ->
  cardRatings = $(string_selector)
  $.each cardRatings, (_index, cardRating) ->
    if ($(cardRating).parent('.rating-column').length)
      $(cardRating).rating('create', {displayOnly: true, showCaption: false, size: 'xs'})
    return
  return

showCategoriesSelector = () ->
  $($('.category-select')[0]).select2
    width: 'resolve'
    theme: 'bootstrap'
    placeholder: 'Select category'
    minimumResultsForSearch: Infinity
    ajax:
      url: '/categories'
      dataType: 'json'
      type: "GET"
      delay: 350
    cache: true
  return

showTags = () ->
  $($('.tags-select')[0]).select2
    tags: true
    multiple: true
    theme: 'bootstrap'
    tokenSeparators: [',', ' ']
    ajax:
      url: '/tags'
      dataType: 'json'
      type: "GET"
      delay: 350
    cache: true
  return

$(document).on 'turbolinks:load', ->
  'use strict'
  startEveryTimer()
  showCardRatings()
  displayRatingWidget()
  showCategoriesSelector()
  showTags()
  return
