require 'sinatra/base'
require './lib/bookmark'
require './lib/database_connection_setup.rb'
require 'uri'
require 'sinatra/flash'

class BookmarkManager < Sinatra::Base 
  enable :sessions
  register Sinatra::Flash
  enable :method_override

  get '/' do
    'Bookmark Manager'
  end

  get '/bookmarks' do
    @bookmarks = Bookmark.all
    erb (:'all_bookmarks')
  end

  get "/bookmarks/new" do
    erb(:add_bookmarks)
  end

  post "/bookmarks" do
    flash[:notice] = "You must submit a valid URL." unless Bookmark.create(url: params[:url], title: params[:title])
    redirect('/bookmarks')
  end 

  delete '/bookmarks/:id' do 
    Bookmark.delete(id: params[:id])
    redirect '/bookmarks'
  end 

  get '/bookmarks/:id/edit' do
    @bookmark_id = params[:id]
    erb(:'edit_bookmarks')
  end

  patch '/bookmarks/:id' do
    Bookmark.update(id: params[:id], title: params[:title], url: params[:url])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/comments/new' do 
    @bookmark_id = params[:id]
    erb(:'new_comment')
  end 

  post '/bookmarks/:id/comments' do
    connection = PG.connect(dbname: 'bookmark_manager_test')
    connection.exec("INSERT INTO comments (text, bookmark_id) VALUES('#{params[:comment]}', '#{params[:id]}');")
    redirect '/bookmarks'
  end
    
  run! if app_file == $0
end
