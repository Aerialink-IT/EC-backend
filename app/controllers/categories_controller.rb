class CategoriesController < ApplicationController
  skip_before_action :authenticate_request

  def index
    render json: Category.all
  end
end