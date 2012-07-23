class ArchivesController < ApplicationController
  layout 'memoir'  
  include Archives
  include Tags
  
  def index
    archives_months_count
    tagsIndex
  end

  def month
    case params[:t]
    when 'note'
      @all = @user.notes.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).order('created_at desc')
    when 'blog'
      @all = @user.blogs.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).order('created_at desc')
    when 'photo'
      @all = Photo.where(album_id: @user.albums).where("to_char(created_at, 'YYYYMM') = ?", params[:month]).includes(:album).order('id desc')
    when 'recommend'
      rnotes = @user.rnotes.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).includes(:note => :user)
      rblogs = @user.rblogs.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).includes(:blog => :user)
      rphotos = @user.rphotos.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).includes(:photo => [:album => :user])
      @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!
    else
      notes = @user.notes.where("to_char(created_at, 'YYYYMM') = ?", params[:month])
      blogs = @user.blogs.where("to_char(created_at, 'YYYYMM') = ?", params[:month])
      photos = Photo.where(album_id: @user.albums).where("to_char(created_at, 'YYYYMM') = ?", params[:month]).includes(:album)
      @all = (notes | blogs | photos).sort_by{|x| x.created_at}.reverse!
    end
    
    index
  end

end