class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  def videos
    @videos=Video.paginate(page: params[:page])
  end

end
