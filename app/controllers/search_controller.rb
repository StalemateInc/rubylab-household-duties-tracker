require 'elasticsearch/dsl'

class SearchController < ApplicationController
  include Elasticsearch::DSL

  def search
    query = build_search_query(params[:query])
    begin
      results = Elasticsearch::Model.search(query, [Task, Group]).results.to_a
    rescue Faraday::ConnectionFailed
      results = [].concat(Task.full_text_search(params[:query]), Group.full_text_search(params[:query]))
                  .select { |entity| can?(:read, entity) }
      results = records_to_json(results)
    end
    respond_to do |format|
      format.json { render json: results }
    end
  end

  def index; end

  def records_to_json(records)
    items = records.to_a
    items.each_with_object([]) do |item, obj|
      hash = { _source: {} }
      hash[:_id] = item.id
      hash[:_index] = item.class.name.downcase.pluralize
      %i[id name title group_id description].each do |key|
        hash[:_source][key] = item.send(key) if item.respond_to?(key)
      end
      obj.push(hash)
    end.to_json
  end

  def build_search_query(q)
    query = q.downcase.split(' ').map { |query| query + '*' }.join(' AND ')
    search_query = {
      "query": {
        "bool": {
          "must": [
            {
              "query_string": {
                "query": query.to_s,
                "analyze_wildcard": true,
                "default_field": '*'
              }
            }
          ],
          "filter": [{
            "term": {
              "accessible_by": current_user.id
            }
         }]
        }
      }
    }
    search_query.to_json
  end

end
