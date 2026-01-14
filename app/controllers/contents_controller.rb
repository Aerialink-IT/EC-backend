class ContentsController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_action :authenticate_request
  
  # GET /contents
  # GET /contents?section=header
  # GET /contents?locale=en
  def index
    locale = params[:locale] || I18n.locale.to_s
    section = params[:section]
    
    contents = Content.all
    contents = contents.by_section(section) if section.present?
    
    # Set url_options for ActiveStorage
    host = ENV["HOST"] || request.host_with_port
    host = host.gsub(/^https?:\/\//, '')
    protocol = Rails.env.production? ? "https" : "http"
    ActiveStorage::Current.url_options = { host: host, protocol: protocol }
    
    result = contents.inject({}) do |hash, content|
      # For image fields, return image URL if attached, otherwise return content_en (URL)
      if content.key&.start_with?('home.banner_image', 'home.second_banner_image', 'sidebar.gallery_image_', 'about_us.banner_image', 'about_us.product_image', 'about_us.map_image', 'about_us.gallery_image_')
        if content.image.attached?
          hash[content.key] = url_for(content.image)
        elsif content.content_en.present?
          hash[content.key] = content.content_en
        else
          hash[content.key] = nil
        end
      else
        hash[content.key] = content.content_for(locale)
      end
      hash
    end
    
    render json: {
      locale: locale,
      section: section,
      contents: result
    }
  end
  
  # GET /contents/:key
  # GET /contents/:key?locale=ja
  def show
    locale = params[:locale] || I18n.locale.to_s
    content = Content.find_by(key: params[:key])
    
    if content
      # Set url_options for ActiveStorage
      host = ENV["HOST"] || request.host_with_port
      host = host.gsub(/^https?:\/\//, '')
      protocol = Rails.env.production? ? "https" : "http"
      ActiveStorage::Current.url_options = { host: host, protocol: protocol }
      
      content_value = if content.key&.start_with?('home.banner_image', 'home.second_banner_image', 'sidebar.gallery_image_', 'about_us.banner_image', 'about_us.product_image', 'about_us.map_image', 'about_us.gallery_image_')
                        if content.image.attached?
                          url_for(content.image)
                        elsif content.content_en.present?
                          content.content_en
                        else
                          nil
                        end
                      else
                        content.content_for(locale)
                      end
      
      render json: {
        key: content.key,
        locale: locale,
        content: content_value,
        section: content.section
      }
    else
      render json: { error: "Content not found" }, status: :not_found
    end
  end
  
  # GET /contents/by_section/:section
  # GET /contents/by_section/header?locale=ja
  def by_section
    locale = params[:locale] || I18n.locale.to_s
    section = params[:section]
    
    contents = Content.by_section(section)
    
    # Set url_options for ActiveStorage
    host = ENV["HOST"] || request.host_with_port
    host = host.gsub(/^https?:\/\//, '')
    protocol = Rails.env.production? ? "https" : "http"
    ActiveStorage::Current.url_options = { host: host, protocol: protocol }
    
    result = contents.inject({}) do |hash, content|
      # For image fields, return image URL if attached, otherwise return content_en (URL)
      if content.key&.start_with?('home.banner_image', 'home.second_banner_image', 'sidebar.gallery_image_', 'about_us.banner_image', 'about_us.product_image', 'about_us.map_image', 'about_us.gallery_image_')
        if content.image.attached?
          hash[content.key] = url_for(content.image)
        elsif content.content_en.present?
          hash[content.key] = content.content_en
        else
          hash[content.key] = nil
        end
      else
        hash[content.key] = content.content_for(locale)
      end
      hash
    end
    
    render json: {
      locale: locale,
      section: section,
      contents: result
    }
  end
end

