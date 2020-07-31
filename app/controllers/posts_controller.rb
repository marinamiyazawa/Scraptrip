class PostsController < ApplicationController
	before_action :correct_user, only:[:edit]
	before_action :set_genre_parent, only:[:new, :create, :edit, :update]
	before_action :authenticate_user!, only: [:new, :get_genre_children, :create, :clips, :edit, :update, :destroy]

	def new
		@post = Post.new
		@post.post_images.build
		#下書き一覧
		@posts = Post.draft.where(:user_id => current_user.id).order("created_at DESC")
	end
	def get_genre_children #親カテゴリーが選択された後に動くアクション
		@genre_children = Genre.find_by(id: "#{params[:parent_name]}", ancestry: nil).children
	end

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		@user = current_user
		if @post.save
			flash[:notice]= '投稿に成功しました'
			redirect_to post_path(@post)
		else
			@post.post_images.build
			#下書き保存
			@posts = Post.draft.where(:user_id => current_user.id).order("created_at DESC")
			render :new
		end
	end

	def hashtag #ハッシュタグ
		@user = current_user
		@tag = Hashtag.find_by(hashname: params[:name])
		@posts = []
		PostHashtag.where(hashtag_id: @tag.id).includes(:post).each do |post_hashtag|
			@posts << post_hashtag.post
		end
	end

	def index
		@posts = Post.published.order("created_at DESC")#公開中かつ友好会員の投稿のみ表示
		             .joins(:user)
					 .where(users: {user_status: false}).page(params[:page]).per(6)
		@parents = Genre.where(ancestry: nil)
		@tag = Hashtag.all.order("created_at DESC")
	end

	def ranking #ランキング
		@all_ranks = Post.find(Favorite.group(:post_id).order('count(post_id) desc')
					 .limit(10).pluck(:post_id))
		@parents = Genre.where(ancestry: nil)
	end

	def clips #ブックマーク
		@posts = current_user.clip_posts.includes(:user).page(params[:page]).per(6)
		#google_map
		@hash = Gmaps4rails.build_markers(@posts) do |post, marker|
		      marker.lat post.latitude
		      marker.lng post.longitude
		      marker.infowindow post.title
		    end
	end

	def show
		@post = Post.find_by(id: params[:id])
		#google_map
		@hash = Gmaps4rails.build_markers(@post) do |post, marker|
		      marker.lat post.latitude
		      marker.lng post.longitude
		      marker.infowindow post.title
		    end

		if @post.nil?
			redirect_to root_path
		elsif @post.draft?
			login_required
		end
	end

	def login_required
		redirect_to user_session_path unless current_user
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])
		if  @post.update(post_params)
			flash[:notice]= '投稿を編集しました'
		    redirect_to @post
		else
			render :edit
		end
	end

	def destroy
		@post = Post.find(params[:id])
		if @post.destroy
			redirect_to posts_path
		else
			flash[:notice]= 'deleted post successfully.'
			render 'show'
		end
	end

	private
	def post_params
		params.require(:post).permit(:title, :body, :rate, :status, :latitude, :longitude, :genre_id, post_images_images: [])
	end

	def correct_user
		@post = Post.find(params[:id])
		if @post.user != current_user
			redirect_to posts_path
		end
	end

	def set_genre_parent
		@genre_parent_array = [{ name: "--", id: "--"}] #親カテゴリーのみ抽出、配列
			Genre.where(ancestry: nil).each do |parent|
				@genre_parent_array << { name: parent.name, id: parent.id}
			end
	end

end
