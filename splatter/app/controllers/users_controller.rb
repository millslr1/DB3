class UsersController < ApplicationController
  before_filter :set_headers
 
 def set_headers
    header['Access-Control-Allow-Origin'] = '*' 
 end

# GET /users
  # GET /users.json
  def index
    db = UserRepository.new(Riak::Client.new)
    @users = db.all

    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    db = UserRepository.new(Riak::Client.new)
    @user = db.find(params[:id])
    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new
    @user.email = params[:user][:email]
    @user.name = params[:user][:name]
    @user.password = params[:user][:password]
    @user.blurb = params[:user][:blurb]
	
    db = UserRepository.new(Riak::Client.new)
    if db.save(@user)
         render json: @user, status: :created, location: @user
    else
         render json: "error", status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    db = UserRepository.new(Riak::Client.new)
    @user = db.find(params[:id])

    if db.update(user_params(params[:user]))
      render json: @user, status: :updated, location: @user
    else
      render json: "error", status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    db = UserRepository.new(Riak::Client.new)
    db.delete(params[:id])
    head :no_content
  end
  
  def validate_user
    @email = User.where(email: params[:email]).exists?(conditions = :none)
    if(@email)
       @password = User.where(email: params[:email], password: params[:password]).exists?(conditions = :none)
       if(@password)
          @user = User.find_by(email: params[:email], password: params[:password])
          render "show"
       else
          render "validation failed"
       end
     else
       render "validation failed"
     end
  end

  def splatts
    db = UserRepository.new(Riak::Client.new)
    @user = db.find(params[:id])
    db = SplattRepository.new(Riak::Client.new, @user)
    render json: db.all
  end

  def show_follows
    db = UserRepository.new(Riak::Client.new)
    @user = User.find(params[:id])
    render json: @user.follows
  end

  def show_followers
    db = UserRepository.new(Riak::Client.new)
    @user = User.find(params[:id])
    render json: @user.followed_by
  end

  def add_follows
    db = UserRepository.new(Riak::Client.new)
    @follower = db.find(params[:id])
    @followed = db.find(params[:follows_id])
   
    if db.follow(@follower, @followed)
	head :no_content
    else
	render json: "error saving follow relationship" , status: :unproccesable_entity
    end
  end

  def delete_follows
    db = UserRepository.new(Riak::Client.new)
    @user = db.find(params[:id])
    @follows = db.find(params[:follows_id])

    if db.unfollow(@user, @follows) 
       head :no_content
    else
       render json: "error deleting follows", status: :unprocessable_entity
    end
  end

  #GET /users/splatts-feed/1
  def splatts_feed
    @id = params[:id]
    db = UserRepository.new(Riak::Client.new)
    @feed = db.splatts_feed(@id)
    render json: @feed
  end


  private

	def user_params(params)
		params.permit(:id, :email, :password, :name, :blurb)
	end

  end
  

