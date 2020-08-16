class ClipsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    clip = current_user.clips.build(post_id: params[:post_id])
    clip.save!
    flash[:notice] = '投稿をブックマークしました'
    redirect_to post_path(post.id)
  end

  def destroy
    post = Post.find(params[:post_id])
    current_user.clips.find_by(post_id: params[:post_id]).destroy!
    flash[:notice] = 'ブックマークから外しました'
    redirect_to post_path(post.id)
  end
end
