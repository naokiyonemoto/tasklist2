class TaskpostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user , only: [:destroy]
  
  def create
    @taskpost = current_user.taskposts.build(taskpost_params)
    if @taskpost.save
      flash[:success] = "投稿しました"
      redirect_to root_url
    else
      @taskposts = current_user.taskposts.order("created_at DESC").page(params[:page])
      flash.now[:danger] ="投稿に失敗しました"
      render "toppages/index"
    end
  end

  def destroy
    @taskpost.destroy
    flash[:success] ="投稿を削除しました"
    redirect_back(fallback_location:root_path)
  end
  
  private
  
  def correct_user
    @taskpost = current_user.taskposts.find_by(id: params[:id])
      unless  @taskpost
        redirect_to root_url
      end
  end
  
  def taskpost_params
    params.require(:taskpost).permit(:content)
  end
end
