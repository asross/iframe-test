require 'sinatra'

get '/' do
  "<iframe src='#{params[:url]}'></iframe>"
end
