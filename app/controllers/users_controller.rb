class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show]
  before_action :set_user, only: [:show]

  # TODO Enforce GUID uniqueness
  # TODO Enable delete

  # GET /users/1
  def show
    render :json => @user.to_json(:except => :_id), status: :ok
  end

  # POST /users
  def create
    p = post_params
    begin
      @user = User.find_by(email: p[:email])
      render status: :conflict
    rescue Mongoid::DocumentNotFound
      @user = User.new(p)
      @user.is_active = true
      @user.user_id = generate_guid
      if @user.save
        render :json => @user.to_json(:except => :_id), status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(user_id: params[:userId])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end

    def generate_guid
      SecureRandom.hex(10)
    end
end
