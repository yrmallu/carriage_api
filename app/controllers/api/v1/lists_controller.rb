module Api::V1
  class ListsController < ApiController
    before_action :authorize_user, only: [:create]
    before_action :set_list, only: [:update, :destroy, :assing_member, :show, :unassing_member]

    def index
      render json: @current_user.user_lists(params)
    end

    def create
      list = @current_user.owned_lists.build(list_params)
      if list.save
        render json: { data: list }, status: :ok
      else
        render json: { error: list.errors }, status: :unprocessable_entity
      end
    end

    def update
      if @list.update(list_params)
        render json: { data: @list }, status: :ok
      else
        render json: { error: @list.errors }, status: :unprocessable_entity
      end
    end

    def show
      render json: { data: @list.get_cards }, status: :ok
    end

    def destroy
      if @list.destroy
         render json: { message: "success" }, status: :ok
       else
        render json: { message: "failed" }, status: :unprocessable_entity
       end
    end

    def assing_member
      assigne = User.find params[:user_id]
      if assigne.lists.find_by_id @list.id
        render json: { error: "list already assigned to user" }, status: :unprocessable_entity
      else
        assigne.lists << @list
        render json: { data: @list }, status: :ok
      end
    end

    def unassing_member
      assigne = User.find params[:user_id]
      assinged_list = assigne.list_users.find_by_list_id @list.id
      if assinged_list
        assinged_list.destroy
        render json: { message: "success" }, status: :ok
      else
        render json: { error: "list not associated to the user" }, status: :unprocessable_entity
      end
    end

    private

    def list_params
      params.require(:list).permit(:title)
    end

    # only admin can authorize to create list
    def authorize_user
      render_unauthorized unless @current_user.admin?
    end

    def set_list
      @list = @current_user.owned_lists.find params[:id]
    end

  end
end
