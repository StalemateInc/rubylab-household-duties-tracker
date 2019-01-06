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
    query = q.downcase.split(' ').map { |query_string| query_string + '*' }.join(' AND ')
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
              "accessible_by": user.id
            }
          }]
        }
      }
    }
    search_query.to_json
  end
end