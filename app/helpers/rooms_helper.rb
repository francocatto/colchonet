module RoomsHelper
  def belongs_to_user(room)
    user_signed_in? && room.user == current_user
  end

  def initializeReview(room)
    if user_signed_in?
      user_review = room.reviews.find_or_initialize_by(user_id: current_user.id)
    end
  end
end
