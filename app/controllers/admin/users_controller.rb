module Admin
    class UsersController < ApplicationController
      before_action :require_admin!
      before_action :set_user, only: [:edit, :update]
  
      def index
        @users = User.order(:email_address)
      end
  
      def new
        @user = User.new
      end
  
      def create
        @user = User.new(user_params)
        @user.assign_primary_role!(params[:user][:primary_role])
  
        if @user.save
          redirect_to admin_users_path, notice: "User created."
        else
          render :new, status: :unprocessable_entity
        end
      end
  
      def edit
      end
  
      def update
        @user.assign_primary_role!(params[:user][:primary_role])
  
        if @user.update(update_user_params)
          redirect_to admin_users_path, notice: "User updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end
  
      private
  
      def require_admin!
        redirect_to root_path, alert: "Not authorized." unless current_user&.has_role_name?("admin") || current_user&.admin_role?
      end
  
      def set_user
        @user = User.find(params[:id])
      end
  
      def user_params
        params.require(:user).permit(:email_address, :password, :password_confirmation)
      end
  
      def update_user_params
        # allow email change; password optional on edit
        params.require(:user).permit(:email_address, :password, :password_confirmation).tap do |p|
          if p[:password].blank?
            p.delete(:password)
            p.delete(:password_confirmation)
          end
        end
      end
    end
  end
  