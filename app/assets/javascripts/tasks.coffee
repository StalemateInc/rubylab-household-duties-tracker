@startEveryTimer = (string_selector = '.expire_timer') ->
  clientTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  timersSpans = $(string_selector)
  locale = Cookies.get("locale")
  patterns = {
    expiration_line: {
      en: 'Expired'
      ru: 'Время истекло'
    },
    messsage_pattern : {
      en: '{days} days, {hours} hours, {minutes} minutes and {seconds} seconds left'
      ru: 'Осталось {days} дней, {hours} часов, {minutes} минут и {seconds} секунд'
    }
  }
  $.each timersSpans, (_index, timerSpan) ->
    data_expires = $(timerSpan).data('expires-at')
    timer = new Countdown(
      selector: '#' + $(timerSpan).attr('id')
      msgBefore: ''
      msgAfter: patterns.expiration_line[locale]
      msgPattern: patterns.messsage_pattern[locale]
      onEnd: ->
        $.ajax
          url: ''.concat('/groups/', $(timerSpan).data('group'), '/tasks/', $(timerSpan).data('id'), '/estimate/stop')
          method: 'POST'
        return
      dateEnd: moment(data_expires).toDate())
    return
  return

displayRatingWidget = () ->
  locale = Cookies.get('locale')
  if ($('#shown-rating').parent('#rating-div').length)
    $('#shown-rating').rating(displayOnly: true, step: 1, language: locale, size: 'sm')
  return

@showCardRatings = (string_selector = '.card-rating') ->
  cardRatings = $(string_selector)
  $.each cardRatings, (_index, cardRating) ->
    if ($(cardRating).parent('.rating-column').length)
      $(cardRating).rating('create', {displayOnly: true, showCaption: false, size: 'xs'})
    return
  return

showCategoriesSelector = () ->
  locale = Cookies.get("locale")
  patterns = {
    en: 'Select category'
    ru: 'Выберите категорию'
  }
  $($('.category-select')[0]).select2
    width: 'resolve'
    theme: 'bootstrap'
    placeholder: patterns[locale]
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

createDroppable = ()->

  $('.ui-widget-content.draggable').draggable({ revert: true })
  $('#droppable').droppable drop: (event, ui) ->
    $(this).html(ui.draggable[0].dataset.name)
    $('#task_executor_id').val(ui.draggable[0].dataset.id)
    return
  return


$(document).on 'turbolinks:load', ->
  'use strict'
  startEveryTimer()
  showCardRatings()
  displayRatingWidget()
  showCategoriesSelector()
  showTags()
  createDroppable()
  return
