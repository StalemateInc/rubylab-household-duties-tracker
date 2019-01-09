class PerformSearch
  include Interactor

  def call
    user = context.user
    searched_models = [Task, Group]
    searched_models.select! { |model| context.only.any? model.name.downcase.pluralize }
    begin
      results = Elasticsearch::Model.search(context.elastic_query, searched_models)
      results.size
    rescue Faraday::ConnectionFailed => e
      context.elastic_failed = e.message
      results = []
      searched_models.each do |model|
        results.concat(model.full_text_search(context.db_query))
      end
      results.select! { |entity| Ability.new(user).can?(:read, entity) }
    end
    context.content = results
  end

end