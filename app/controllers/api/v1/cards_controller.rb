module Api::V1
  class CardsController < ApiController
    before_action :set_list
    before_action :set_card, only: [:show, :update]


    def index
      render json: @current_user.user_cards(params)
    end

    def create
      card = @list.cards.build(card_params.merge(created_by: @current_user.id))
      if card.save
        render json: { data: card }, status: :ok
      else
        render json: { error: card.errors }, status: :unprocessable_entity
      end
    end

    def show
      render json: { message: @card.get_cards }, status: ok
    end


    def update
      # owner only update the card
      if (@card.created_by == @current_user.id) && @card.update(card_params)
        render json: { data: @card }, status: :ok
      else
        render json: { error: @card.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      # owner and admin only delete the card
      if @card.destroy && (@card.created_by == @current_user.id || @current_user.admin?)
         render json: { message: "success" }, status: :ok
      else
        render json: { message: "failed" }, status: :unprocessable_entity
      end
    end



    private
    def card_params
      params.require(:card).permit(:title, :description)
    end

    def set_list
      @list =   if @current_user.admin?
                  @current_user.owned_lists.find params[:list_id]
                else
                  @current_user.lists.find params[:list_id]
                end
    end

    def set_card
      @card = @list.cards.find params[:id]
    end
  end
end
