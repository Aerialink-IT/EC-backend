class AboutController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_action :authenticate_request

  def show
    locale = params[:locale] || I18n.locale.to_s
    
    # Set url_options for ActiveStorage
    host = ENV["HOST"] || request.host_with_port
    host = host.gsub(/^https?:\/\//, '')
    protocol = Rails.env.production? ? "https" : "http"
    ActiveStorage::Current.url_options = { host: host, protocol: protocol }
    
    # Fetch all About Us content from CMS
    about_contents = Content.by_section('about_us').index_by(&:key)
    
    # Build response with all About Us fields
    response_data = {
      # Banner section
      title: get_content_value(about_contents['about_us.title'], locale),
      community_time: get_content_value(about_contents['about_us.community_time'], locale),
      banner_image_url: get_image_url(about_contents['about_us.banner_image']),
      
      # Our Product section
      description: get_content_value(about_contents['about_us.description'], locale),
      product_description: get_content_value(about_contents['about_us.product_description'], locale),
      product_image_url: get_image_url(about_contents['about_us.product_image']),
      
      # Contact Information
      email: get_content_value(about_contents['about_us.email'], locale),
      phone: get_content_value(about_contents['about_us.phone'], locale),
      address: get_content_value(about_contents['about_us.address'], locale),
      contact_us_time: get_content_value(about_contents['about_us.contact_us_time'], locale),
      
      # Map
      map_image_url: get_image_url(about_contents['about_us.map_image']),
      
      # Gallery images
      gallery_images: get_gallery_images(about_contents)
    }
    
    render json: response_data
  end
  
  private
  
  def get_content_value(content, locale)
    return nil unless content
    content.content_for(locale)
  end
  
  def get_image_url(content)
    return nil unless content
    if content.image.attached?
      url_for(content.image)
    elsif content.content_en.present?
      content.content_en # Fallback to URL if image not uploaded
    else
      nil
    end
  rescue => e
    Rails.logger.error "Error generating image URL: #{e.message}"
    nil
  end
  
  def get_gallery_images(about_contents)
    gallery_images = []
    (1..9).each do |i|
      key = "about_us.gallery_image_#{i}"
      content = about_contents[key]
      if content
        image_url = get_image_url(content)
        gallery_images << image_url if image_url
      end
    end
    gallery_images
  end
end
