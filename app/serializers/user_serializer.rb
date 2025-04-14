class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :phone, :username, :is_active, :orders, :address, :payment_history, :profile_image, :email, :first_name, :last_name, :created_at, :updated_at

  def initialize(object, options={})
    super(object, options)
    @include_orders = options[:include_orders]
    @include_payment_history = options[:include_payment_history]
    @only_attributes = options[:only]
    @except_attributes = options[:except]
  end

  def attributes(*args)
    hash = super
    if @only_attributes.present?
      hash.slice(*@only_attributes)
    elsif @except_attributes.present?
      hash.except(*@except_attributes)
    else
      hash
    end
  end

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def orders
    object.orders.map do |o|
      {
        total_amount: o.total_amount,
        loyalty_points_used: o.loyalty_points_used,
        status: o.status,
        created_at: o.created_at
      }
    end if @include_orders
  end

  def payment_history
    object.orders.includes(:payment_transaction).map(&:payment_transaction) if @include_payment_history
  end

  def profile_image
    object.profile_image.url
  end
end
