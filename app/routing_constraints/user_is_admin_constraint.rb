class UserIsAdminConstraint
  def matches?(request)
    user_id = request.session[:user_id]
    if user_id.present? && u = User.find(user_id)
      return u.admin?
    end
    return false
  end
end
