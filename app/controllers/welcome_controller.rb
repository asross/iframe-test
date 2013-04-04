require 'cgi'

class WelcomeController < ApplicationController
  
  def index
    @url = CGI.unescape(params[:url])
  end

end
