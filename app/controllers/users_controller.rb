class UsersController < ApplicationController

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  def logout
    session = current_user.user_sessions.find_by(token: request.headers['Authorization']&.split(" ")&.last)
    return render json: { error: 'Session not found' }, status: :not_found unless session

    session.destroy
    render json: { message: 'Logged out successfully' }, status: :ok
  end

  def logout_from_other_devices
    user_sessions = current_user.user_sessions.where.not(token: request.headers['Authorization']&.split(" ")&.last)
    return render json: { error: 'No any other active session found' }, status: :not_found unless user_sessions.present?

    user_sessions.destroy_all
    render json: { message: "Logged out from other devices" }, status: :ok
  end

  def users_addresses
    render json: {billing_details: ActiveModelSerializers::SerializableResource.new(current_user.billing_details, each_serializer: BillingDetailSerializer)}
  end

  def show
    current_user.user_sessions.where('expires_at < ?', Time.current).destroy_all
    sessions = current_user.user_sessions.order(last_active_at: :desc).map { |session| session.slice(:id, :device_name, :last_active_at) }
    render json: {user: ActiveModelSerializers::SerializableResource.new(current_user, serializer: UserSerializer), active_sessions: sessions }, status: :ok
  end

  # PATCH/PUT /users/:id
  def update
    if current_user.update(user_params)
      render json: current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    current_user.destroy
    head :no_content
  end

  private

  # Strong parameters for user data
  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :phone, :is_active, :username)
  end
end
