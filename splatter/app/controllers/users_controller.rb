class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params(params))

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update(user_params(params))
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end

  def splatts
    @user = User.find(params[:id])

    render json: @user.splatts
  end

  def show_follows
    @user = User.find(params[:id])
    render json: @user.follows
  end

  def show_followers
    @user = User.find(params[:id])
    render json: @user.followers
  end

  def add_follows
    @user = User.find(params[:id])
    @follows = User.find(params[:follows_id])

    if @user.follows << @follows and @follows.followers << @user
	render json: @user.follows
    else
	render json: @user.errors, status: :unprocessable_entity
    end
  end

  def delete_follows
    @user = User.find(params[:id])
    @follows = User.find(params[:follows_id])
    if @user.follows.delete(@follows) and @follows.followers.delete(@user)
   	head :no_content
	render json: @user.follows
    else
	render json: @user.errors, status: :unprocessable_entity
    end
  end

  #GET /users/splatts-feed/1
  def splatts_feed
#    @feed = Splatt.find_by_sql("SELECT body, created_at FROM splatts JOIN follows ON follows.followed_id = splatts.user_id WHERE follows.follower_id = #{(params[:id])} ORDER BY created_at")

 #   render json: @feed
    map = %Q{ function() {
  	if(this.splatts) {
	   emit("feed", {"list": this.splatts})
	}
    }
    }

    reduce = %Q{ function(key, values) {
	var myfeed = {"list": []};
	values.forEach(function(v) {
	    myfeed.list = myfeed.list.concat(v.list);
	});
    	return myfeed;
    }
    }

    finalise = %Q{ function(key, val) {
	var mylist = val.list;
	if(mylist) {
	    mylist.sort(function(a, b) {
		return b.created_at - a.created_at});
	}
	return {"list": mylist};
    }
    }
    user = User.find(params[:id])
    result = User.in(id: user.follow_ids).map_reduce(map, reduce).out(inline: true).finalize(finalise)
    render json: result.entries[0][:value][:list]
  end

  #Map reduce function to count Splatts
  def map_reduce

    map = %Q{ function() {
	var length = 0;
	if(this.splatts) {
		length = this.splatts.length
	}
	emit ("count", length);
  	}
    }

    reduce = %Q{ function(key, val) {
	var data = 0;
	val.forEach(function(v) {
		data += v;
	})
	return data;
  	}
    }
#    User.map_reduce(map,reduce).out(inline: true).each do |x|
#	puts x
 #   end
   User.map_reduce(map,reduce).out(inline: true)
  end
	
  private

	def user_params(params)
		params.permit(:email, :password, :name, :blurb)
	end
end
