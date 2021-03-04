class TradesController < ApplicationController
  before_action :set_trade, only: %i[ show ]

  # GET /trades or /trades.json
  def index
    # @trades = Trade.includes(:pokemons)
    @pagy, @trades = pagy(Trade.includes(:pokemons).order(created_at: :desc))
  end

  # GET /trades/1 or /trades/1.json
  def show
  end

  # GET /trades/new
  def new
    @trade = Trade.new
    6.times { @trade.pokemons.build }
  end

  # POST /trades or /trades.json
  def create
    @trade = Trade.new(trade_params)
    response = PokemonService.new(@trade).call
    @trade = response.payload

    respond_to do |format|
      if response.success? && @trade.save
        format.html { redirect_to @trade, notice: "Trade was successfully created." }
        format.json { render :show, status: :created, location: @trade }
      else
        6.times { @trade.pokemons.build }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trade.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_trade
    @trade = Trade.includes(:pokemons).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def trade_params
    params.require(:trade).permit(:base_experience_difference, pokemons_attributes: %i[id name trade_group])
  end
end
