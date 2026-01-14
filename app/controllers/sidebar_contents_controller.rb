class SidebarContentsController < ApplicationController
  skip_before_action :authenticate_request
  
  def sidebar_content_show
    sidebar_content = SidebarContent.first
    if sidebar_content
      render json: sidebar_content.as_json(only: [:youtube_link, :gallery_image_1, :gallery_image_2, :gallery_image_3, :gallery_image_4, :gallery_image_5])
    else
      render json: { error: "Sidebar content not found" }, status: :not_found
    end
  end
end

