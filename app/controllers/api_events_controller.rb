class ApiEventsController < ApplicationController
  before_action :set_event, only: [:show, :update]

  # GET /events
  def index
    @events = Event.all

    render json: @events
  end
  
  # GET /events/1
  def show
    render json: @event
  end
  
  # POST /events
  def create
    @event = Event.new(event_params)

    if @event.save
      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end
  
  # Only allow a trusted parameter "white list" through.
  def event_params
    params.require(:event).permit(:name, :description, :time, :location, :current_capacity, :total_capacity, :interest_rating, :category, :host_id, :review_host_prep, :review_matched_desc, :review_would_ret)
  end
end