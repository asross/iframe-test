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
    current_host != 'http://127.0.0.1'
  end

  urls.each do |url|
    specify "for #{url}" do
      begin
        if xfo = x_frame_options(url)
          system "echo '#{url}, x-frame-options(#{xfo})' >> #{result_filename}"
        elsif framebuster?(url)
          system "echo '#{url}, framebuster' >> #{result_filename} "
        else
          system "echo '#{url}, ok' >> #{result_filename}"
        end
      rescue => e
        puts "errored on #{url}: #{e.message}"
        system "echo '#{url}, error' >> #{result_filename}"
      end
    end
  end
end
