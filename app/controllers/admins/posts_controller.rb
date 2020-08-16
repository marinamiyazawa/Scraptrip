class Admins::PostsController < ApplicationController
  before_action :set_genre_parent, only: [:new, :create, :edit, :update]

  def index
    @posts = Post.all.page(params[:page]).per(9)
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def genre_children # 親カテゴリーが選択された後に動くアクション
    @genre_children = Genre.find_by(id: "#{params[:parent_name]}", ancestry: nil).children
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to admins_post_path
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admins_posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :rate, :genre_id, :status, post_images_images: [])
  end

  def set_genre_parent
    @genre_parent_array = [{ name: "--", id: "--" }] # 親カテゴリーのみ抽出、配列
    Genre.where(ancestry: nil).each do |parent|
      @genre_parent_array << { name: parent.name, id: parent.id }
    end
  end
end
