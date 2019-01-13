class ConstructSearchQuery
  include Interactor

  def call
    query = context.query
    user = context.user
    context.elastic_query = build_elastic_query(query, user)
    context.db_query = query
  end

  private

  def build_elastic_query(q, user)
    search_query = {
      "query": {
        "bool": {
          "must": [
            must_term(q),
            {
              "bool": {
                "should": [
                  { "term": { "accessible_by": user.id } },
                  { "term": { "accessible_by": -1 } }
                ]
              }
            }
          ]
        }
      }
    }
    search_query.to_json
  end

  def must_term(q)
    if context.tag
      {
        "match": {
          "tag_list": q
        }
      }
    else
      query = q.downcase.split(' ').map { |query_string| query_string + '*' }.join(' AND ')
      {
        "query_string": {
          "query": query,
          "analyze_wildcard": true,
          "default_field": '*'
        }
      }
    end
  end

end