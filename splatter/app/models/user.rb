class User < Hashie::Dash
  property :email
  property :name
  property :password
  property :blurb
  property :follows
  property :followers
end

#class Splatt < Hashie::Dash
 # property :created_at
 # property :body
#end
