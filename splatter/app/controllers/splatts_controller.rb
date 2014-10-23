class SplattsController < ApplicationController
  # GET /splatts
  # GET /splatts.json
  def index
    @splatts = Splatt.all

    render json: @splatts
  end

  # GET /splatts/1
  # GET /splatts/1.json
  def show
    @splatt = Splatt.find(params[:id])

    render json: @splatt
  end

  # POST /splatts
  # POST /splatts.json
  def create
    @splatt = Splatt.new
    @splatt.id = SecureRandom.uuid
    @splatt.created_at = Time.now
    @splatt.body = params[:body]
    client = Riak::Client.new
    user = UserRepository.new(client).find(params[:user])
    db = SplattRepository.new(client, user)

    if db.save(@splatt)
      render json: @splatt, status: :created, location: @splatt
    else
      render json: @splatt.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /splatts/1
  # PATCH/PUT /splatts/1.json

  # DELETE /splatts/1
  # DELETE /splatts/1.json
  def destroy
    @splatt = Splatt.find(params[:id])
    @splatt.destroy

    head :no_content
  end
private
  def splatts_params(params)
    params.permit(:body, :user_id)
  end
end
