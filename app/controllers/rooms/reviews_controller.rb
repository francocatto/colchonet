class Rooms::ReviewsController < ApplicationController
  before_action :require_authentication
  def create
    review = room.reviews.find_or_initialize_by(user_id: current_user.id)
    review.update!(review_params)
    # retorna status 201 created
    head :ok
  end

  def update
    create
  end

  # variavel privada room eh inicializada pelo parametro room_id
  private
  def room
    @room ||= Room.find(params[:room_id])
  end

  def review_params
    params.require(:review).permit(:points)
  end
end