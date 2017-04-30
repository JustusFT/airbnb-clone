class UsersController < Clearance::UsersController
  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_from_params)
    if @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      render template: "users/new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.avatar = params[:user][:avatar]
    if @user.save
      redirect_to "/users/#{params[:id]}"
    else
      flash[:notice] = "error?"
      redirect_to "/users/#{params[:id]}/edit"
    end
  end

  def user_from_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name)
  end
end
