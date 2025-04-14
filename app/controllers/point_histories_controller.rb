class PointHistoriesController < ApplicationController
  def index
    histories = paginate(current_user.point_histories)
    render json: { point_histories: histories, meta: pagination_meta(histories) }
  end
end
