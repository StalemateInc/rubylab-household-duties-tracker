class CategoriesController < ApplicationController

  def show
    respond_to do |format|
      format.json { render json: helpers.format_categories_array.to_json }
    end
  end

end
