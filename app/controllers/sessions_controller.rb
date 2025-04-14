require 'securerandom'
class SessionsController < ApplicationController
  skip_before_action :authenticate_request

  def login
    user = User.find_by(email: params[:email])
    if user.nil?
      return render json: { error: 'User not found' }, status: :unauthorized
    elsif !user.authenticate(params[:password])
      return render json: { error: 'Incorrect password' }, status: :unauthorized
    end
  
    token, refresh_token = generate_tokens(user)
    user.update(refresh_token: refresh_token)
    create_user_session(user, request, token)
    user.user_sessions.where('expires_at < ?', Time.current).destroy_all
  
    render json: { 
      user: ActiveModelSerializers::SerializableResource.new(user, each_serializer: UserSerializer, include_orders: false, include_payment_history: false), 
      access_token: token, 
      refresh_token: refresh_token 
    }, status: :ok
  end  

  def signup
    user = User.new(session_params)
    return render json: { errors: user.errors.full_messages }, status: :unprocessable_entity unless user.save

    token, refresh_token = generate_tokens(user)
    user.update(refresh_token: refresh_token)
    create_user_session(user, request, token)

    render json: { user: ActiveModelSerializers::SerializableResource.new(user, each_serializer: UserSerializer), access_token: token, refresh_token: refresh_token }, status: :created
    
  end

  def forgot_password
    return render json: { error: 'Email not present' }, status: :bad_request if params[:email].blank?

    user = User.find_by(email: params[:email])
    return render json: { error: 'Email address not found. Please check and try again.' }, status: :not_found unless user

    reset_code = generate_code
    user.update(reset_password_token: reset_code, reset_password_sent_at: Time.current)
    UserMailer.forgot_password(user, reset_code).deliver_now
    render json: { reset_token: jwt_encode(user_id: user.id), code: reset_code}, status: :ok
  end

  def resend_code
    return render json: { error: 'Token not present' }, status: :bad_request if params[:token].blank?

    user = find_user_by_token(params[:token])
    return render json: { error: 'User not found' }, status: :not_found unless user
  
    reset_code = generate_code
    user.update(reset_password_token: reset_code, reset_password_sent_at: Time.current)
    UserMailer.forgot_password(user, reset_code).deliver_now
  
    render json: { message: 'A new reset code has been sent to your email.', reset_token: jwt_encode(user_id: user.id), code: reset_code }, status: :ok
  end
  

  def verify_reset_code
    return render json: { error: 'Token not present' }, status: :bad_request if params[:token].blank?
    return render json: { error: 'Reset code is required' }, status: :bad_request if params[:code].blank?
  
    user = find_user_by_token(params[:token])
    return render json: { error: 'User not found' }, status: :not_found unless user
  
    if user.reset_password_token == params[:code]
      if user.reset_password_sent_at < 10.minutes.ago
        return render json: { error: 'Reset code expired. Please request a new one.' }, status: :unprocessable_entity
      end
  
      render json: { message: 'Reset code verified successfully', reset_token: jwt_encode(user_id: user.id) }, status: :ok
    else
      render json: { error: 'Invalid reset code' }, status: :unprocessable_entity
    end
  end

  def reset_password
    return render json: { error: 'Token not present' }, status: :bad_request if params[:token].blank?
    return render json: { error: 'New password is required' }, status: :bad_request if params[:password].blank?
    return invalid_request('Password and confirm password does not match') unless passwords_match?

    user = find_user_by_token(params[:token])
    return render_invalid_link unless user

    if user.reset_password!(params[:password])
      render json: { status: 'Password reset successfully' }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def refresh
    user = User.find_by(refresh_token: params[:refresh_token])
    return render json: { error: 'Could not find user. Please re-login' }, status: :unauthorized unless user

    token, refresh_token = generate_tokens(user)
    create_user_session(user, request, token)
    user.user_sessions.where('expires_at < ?', Time.current).destroy_all
    render json: { user: ActiveModelSerializers::SerializableResource.new(user, each_serializer: UserSerializer), access_token: token, refresh_token: refresh_token }, status: :ok
  end

  private

  def session_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone, :is_active, :username)
  end

  def generate_tokens(user)
    token = jwt_encode(user_id: user.id)
    refresh_token = jwt_encode({ user_id: user.id }, 7.days.from_now)
    [token, refresh_token]
  end

  def create_user_session(user, request, token)
    browser = Browser.new(request.user_agent)
    os = browser.platform.name # OS (e.g., "Windows", "Linux", "Mac")
    browser_name = browser.name # Browser (e.g., "Chrome", "Firefox")

    user_session = user.user_sessions.create(
      token: token,
      device_name: "#{os} - #{browser_name}",
      ip_address: request.remote_ip,
      last_active_at: Time.current,
      expires_at: 30.days.from_now
    )
  end

  def find_user_by_token(token)
    decoded = jwt_decode(token)
    User.find_by(id: decoded[:user_id]) rescue nil
  end

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def render_invalid_link
    render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :not_found
  end

  def passwords_match?
    params[:password] == params[:confirm_password]
  end

  def invalid_request(message)
    render json: { errors: [{ password: message }] }, status: :unprocessable_entity
  end

  def generate_code
    SecureRandom.hex(4).upcase
  end
end
