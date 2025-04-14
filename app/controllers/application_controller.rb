class ApplicationController < ActionController::Base
  include JsonWebToken
  include Paginatable

  skip_before_action :verify_authenticity_token
  before_action :authenticate_request, unless: :admin_path?
  before_action :set_locale
  before_action :set_url_options

  private

  attr_reader :current_user

  def set_url_options
    ActiveStorage::Current.url_options = { host: "https://#{ENV["HOST"]}" }
  end

  def authenticate_request
    token = request.headers[:Authorization]&.split(" ")&.last
    session_id = request.headers["Session-Id"]&.split(" ")&.last
    if token.present?
      session = UserSession.find_by(token: token)
      return render json: { message: "Session Expired" }, status: :unauthorized unless session

      decoded = jwt_decode(token)
      return render json: { message: "Token Expired" }, status: :unauthorized if decoded == :expired
      return render json: { message: "Unauthorized User" }, status: :unauthorized unless decoded

      @current_user = User.find_by(id: decoded[:user_id])
      session.update(last_active_at: Time.current)
      render json: { message: "Unauthorized User" }, status: :unauthorized unless @current_user

    elsif session_id.present?
      @current_user = guest_user(session_id)
    else
      render json: { message: "Unauthorized User" }, status: :unauthorized unless @current_user
    end
  end

  def guest_user(session_id)
    guest_user = User.find_or_create_guest(session_id)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def admin_path?
    request.path.match?(%r{^/(en|ja)/admin}) || request.path.match?(%r{^/admin})
  end
end
