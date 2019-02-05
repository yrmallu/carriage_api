module Api::V1
  class CommentsController < ApiController
    before_action :set_card
    before_action :set_comment, only: [:show, :update]
    before_action :authorize, only: :destroy

    def create
      comment = @card.comments.build(comment_params.merge(created_by: @current_user.id))
      if comment.save
        render json: { data: comment }, status: :ok
      else
        render json: { error: comment.errors }, status: :unprocessable_entity
      end
    end


    def update
      if (@comment.created_by == @current_user.id) && @comment.update(comment_params)
        render json: { data: @comment }, status: :ok
      else
        render json: { error: @comment.errors }, status: :unprocessable_entity
      end
    end

    def show
      render json: { data: @comment.as_json(include: [:replies]) }, status: ok
    end

    def destroy
      # owner and admin only delete the card
      if @comment.destroy
         render json: { message: "success" }, status: :ok
       else
        render json: { message: "failed" }, status: :unprocessable_entity
       end
    end

    private

    def set_comment
      @comment = @card.comments.find params[:id]
    end

    def comment_params
      params.require(:list).permit( :content, :parent_comment_id)
    end

    def set_card
      @card = Card.find params[:card_id]
    end

    def authorize
      render_unauthorized unless (@comment.created_by == @current_user.id || (@current_user.admin? && @current_user.owned_lists.include? (@card.list)))
    end
  end
end