class SearchController < ApplicationController
  layout "dashboard"

  def index
    params = search_params
    return if params.blank?

    tag = params[:tag] || false
    search_result = PerformTextSearch.call(user: params[:user] ? User.find(params[:user]) : nil || current_user,
                                           only: params[:only],
                                           tag: tag,
                                           query: params[:query])
    respond_to do |format|
      if search_result.success?
        content = search_result.content
        if search_result.elastic_failed.nil?
          format.html { split_record_array(content.records.to_a) }
          format.json { render json: content.results.to_a }
        else
          format.html { split_record_array(content) }
          format.json { render json: records_to_json(content) }
        end
      else
        format.html { @results = nil }
        format.json { head :no_content }
      end
    end
  end

  private

  def split_record_array(content)
    @groups = content.select { |result| result.class == Group }
    @tasks = content.select { |result| result.class == Task }
  end

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

  def search_params
    params.permit(:format, :query, :user, :tag, only: [])
  end

end
