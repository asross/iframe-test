require 'spec_helper'
require 'httparty'
require 'cgi'

urls = File.read(File.join(File.dirname(__FILE__), 'support/urls.txt')).split("\n").uniq
result_filename = File.join(File.dirname(__FILE__), '../result.txt').to_s
system "echo 'iframe test results' > #{result_filename}"

describe 'iframe test', :js => true do

  def x_frame_options(url)
    HTTParty.get(url, limit: 10, timeout: 10).headers['x-frame-options']
  end

  def framebuster?(url)
    visit "/?url=#{CGI.escape(url)}"
    sleep 0.75
    return true if page.has_content? 'framebuster'
    return true if current_host != 'http://127.0.0.1'
    false
  end

  urls.each do |url|
    specify "for #{url}" do
      if xfo = x_frame_options(url)
        system "echo '--- #{url}: X-FRAME-OPTIONS #{xfo}' >> #{result_filename}"
      elsif framebuster?(url)
        system "echo '--- #{url}: FRAMEBUSTER' >> #{result_filename} "
      else
        system "echo '--- #{url}: OK' >> #{result_filename}"
      end
    end
  end
end
