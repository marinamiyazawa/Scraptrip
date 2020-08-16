class HomesController < ApplicationController
  def top
    @posts = Post.published.order(created_at: :desc).limit(4)
    render layout: false # application.html.erb
  end

  def about
    @posts = Post.published.order(created_at: :desc).limit(3)
    render layout: false # application.html.erb
  end
end
