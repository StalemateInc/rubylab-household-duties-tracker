class TagsController < ApplicationController

  def show
    term = params[:term]
    respond_to do |format|
      format.json { render json: helpers.format_tags_array(term).to_json }
    end
  end

end
