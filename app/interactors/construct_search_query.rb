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
                "query": query,
                "analyze_wildcard": true,
                "default_field": '*'
              }
            },
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
end