class UsersController < Clearance::UsersController
  def create
    @user = User.new(user_from_params)
    byebug
    if @user.save
      byebug
      sign_in @user
      redirect_back_or url_after_create
    else
      byebug
      render template: "users/new"
    end
  end

  def user_from_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name)
  end
end
