fetchQuery = null
fetchResultsCallback = null
fetchResults = _.debounce((->
  $.get '/search.json?query=' + fetchQuery + '&only[]=groups&only[]=tasks', (data) ->
    data = rebuild_response(data)
    if fetchResultsCallback
      fetchResultsCallback data
    return
  return
), 350)

shorten = (data, char_amount) ->
  return data if data.length <= char_amount
  data.substring(0, char_amount) + '...'

@rebuild_response = (data) ->
  mapped = $.map(data, (a) ->
    {
      id: a._source.id
      index: a._index
      name: if a._index == 'groups' then a._source.name else a._source.title
      group_id: if a._index == 'tasks' then a._source.group_id else a._source.id
      description: a._source.description
    }
  )
  return mapped

$(document).on 'turbolinks:before-cache', ->
  $('.typeahead').typeahead('destroy')

$(document).on 'turbolinks:load', ->
  header =
    ru: "Группы и задачи",
    en: "Groups and tasks"
  locale = Cookies.get("locale")
  $('.typeahead').typeahead { minLength: 3 },
    name: 'tasks'
    display: 'name'
    limit: Infinity
    source: (query, syncResults, asyncResults) ->
      fetchQuery = query
      fetchResultsCallback = asyncResults
      fetchResults()
      return
    templates:
      header: '<h3 class="text-center">' + header[locale] + '</h3>',
      suggestion: (data) ->
        if (data.index == "groups")
          template = "<div><i class='fas fa-users m-1'></i>" + shorten(data.name, 40) +
            "<a class='btn-sm btn-success float-right search-result-button' href='/groups/" + data.id +
            "'><i class='fas fa-arrow-circle-right'></i></a></div>"
        else
          template = "<div><i class='fas fa-clock m-1'></i>" + shorten(data.name, 40) +
            "<br/><span class='search-result-description'><i>" + shorten(data.description, 70) + "</i></span>" +
            "<a class='btn-sm btn-success float-right search-result-button' href='/groups/" + data.group_id + "/tasks/" + data.id +
            "'><i class='fas fa-arrow-circle-right'></i></a></div>"
          return template
  return