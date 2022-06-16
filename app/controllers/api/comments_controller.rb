module Api
  class CommentsController < ApplicationController
    def create
      @comment = Comment.create(comment_params)
      if @comment.save
        render json: @comment, status: :created
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    def update
      @comment = Comment.find(params[:id])
      if @comment.update(comment_params)
        render json: @comment
      else 
        render json: @comment.errors, status: :unprocessable_entity
      end
    end


    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy
    end

    private

    def comment_params
      params.permit(:content, :user_id, :tweet_id)
    end
  end
end