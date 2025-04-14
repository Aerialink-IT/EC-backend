class AboutController < ApplicationController
  skip_before_action :authenticate_request

  def show
    about = About.first
    if about
      render json: about.as_json(methods: [:gallery_images])
    else
      render json: { error: "About details not found" }, status: :not_found
    end
  end
end
