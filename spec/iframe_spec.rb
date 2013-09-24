require 'spec_helper'
require 'httparty'
require 'cgi'

describe 'iframe test', :js => true, :type => :feature do

  def result_filename
    File.join(File.dirname(__FILE__), '../result.txt').to_s
  end

  def x_frame_options(url)
    HTTParty.get(url).headers['x-frame-options']
  end

  def framebuster?(url)
    visit "/?url=#{CGI.escape(url)}"
    sleep 0.75
    page.has_content?('framebuster')
  end

  def log_result(url, message)
    `echo '#{url}: #{message}' >> #{result_filename}`
  end

  before(:all) do
    `echo 'iframe test' > #{result_filename}`
  end

  urls = File.read(File.join(File.dirname(__FILE__), 'support/urls.txt')).split("\n")

  urls.each do |url|
    specify "for #{url}" do
      if xfo = x_frame_options(url)
        log_result(" --- " + url, "x-frame-options #{xfo}")
      elsif framebuster?(url)
        log_result(" --- " + url, "framebuster")
      else
        log_result(url, "ok")
      end
    end
  end
end
