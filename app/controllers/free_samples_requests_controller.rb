class FreeSamplesRequestsController < ApplicationController

  def create
    selected_product_ids = params[:free_samples_request][:product_ids]&.uniq || []

    if selected_product_ids.size > 6
      return render json: { error: "You can select up to 6 products only." }, status: :unprocessable_entity
    end

    products = Product.where(id: params[:free_samples_request][:product_ids])

    if products.count != params[:free_samples_request][:product_ids].uniq.count
      return render json: {
        error: "Some products are invalid or do not exist."
      }, status: :unprocessable_entity
    end

    free_samples_request = current_user.free_samples_requests.new(free_samples_request_params)
    free_samples_request.products = products

    if free_samples_request.save
      render json: { message: "Request submitted successfully", data: free_samples_request }, status: :created
    else
      render json: { errors: free_samples_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def free_samples_request_params
    params.require(:free_samples_request).permit(
      :email,
      :delivery_address_id,
      product_ids: []
    )
  end
end
