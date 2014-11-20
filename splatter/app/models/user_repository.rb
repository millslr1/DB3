class UserRepository
	BUCKET = 'users'
	
	def initialize(client)
	   @client = client
	end
	
	def all
	    users = @client.bucket(BUCKET)
	end

	def delete(user)
	    @users = @client.find(BUCKET)
	    @users.delete(user)
	end

	def find(key)
	    riak_obj = @client.bucket(BUCKET)[key]
	    user = User.new
	    user.email = riak_obj.data['email']
	    user.name = riak_obj.data['name']
	    user.password = riak_obj.data['password']
	    user.blurb = riak_obj.data['blurb']
	    user.follows = riak_obj.data['follows']
	    user.followers = riak_obj.data['followers']
	    user
	end

	def save(user)
	    users = @client.bucket(BUCKET)
	    key = user.email
	    
	    unless users.exist?(key)
		riak_obj = users.new(key)
		riak_obj.data = user
		riak_obj.content_type = 'application/json'
		riak_obj.store
	    end
	end
	
	def update(user)
	    @key = user.email
	    @users = @client.find(key)
    	    @user.data = user
	    @user.store
	end

	def follow(follower, followed)
	    if follower.follows
		follower.follows << followed.email
	    else
		follower.followed = [followed.email]
	    end

	    if followed.followers
		followed.followers << follower.email
	    else
		followed.followers = [follows.email]
	    end

	    update(followed)
	    update(follower)
	end

	def unfollow(follower, followed)
	    if follower.follows
		follower.follows.delete(followed.email)
	    else
		follower.follows = [followed.email]
	    end

	    if followed.followers
		followed.followers.delete(follower.email)
	    end

	    update(followed)
       	    update(follower)
	end

	def splatts_feed(key)
	    @feed = [];
	    @user = find(key)
	    user_db = SplattRespository.new(@client, @user)
	    @feed.concat(user_db.all)
	    if @user.follows
		@user.follows.each do |follower|
		    flwr = find(follower)
		    flwr_db = SplattRepository.new(@client, flwr)
		    @feed.concat(flwr_db.all)
	    	end
	    end

	    @feed.sort! { |a,b| a.updated_at <=> b.updated_at }
	    @feed
	end
end
