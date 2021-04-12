class UsersController < ApplicationController

  def index
    load_users
    authorize @users

    @evaluator = params[:evaluator].present?
  end

  def edit
    load_user
    authorize @user
  end

  def update
    load_user
    build_user

    if @user.save
      flash.now[:success] = 'Tu perfil se ha editado con éxito'
    else
      flash.now[:alert] = 'Existen errores en tu perfil. Favor de revisar sus datos'
    end

    render 'edit'
  end

  def search
    @user = User.find_by(email: params[:email])

    if @user
      render json: @user
    else
      render json: {error: true}
    end
  end

  def impersonate
    authorize User

    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    authorize User

    stop_impersonating_user
    redirect_to root_path
  end

  private

  def load_users
    @users ||= user_scope
  end

  def load_user
    @user ||= User.find_by(id: params[:id])
  end

  def build_user
    @user ||= User.new
    @user.attributes = user_params
  end

  def user_params
    user_params = params[:user]
    user_params ? user_params.permit(:id,
                                     :code,
                                     :institution_id,
                                     :institution_name,
                                     :institution_type_id,
                                     :institution_privacy_id,
                                     :country_id,
                                     :names,
                                     :last_names,
                                     :phone) : {}
  end

  def user_scope
    User.all
  end
end
