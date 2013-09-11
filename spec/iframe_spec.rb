require 'spec_helper'
require 'httparty'
require 'cgi'

describe 'iframe test', :js => true, :type => :feature do

  before do
    @filename = File.join(File.dirname(__FILE__), "../test_result_#{Time.now.to_i}").to_s
    @urls = File.read(File.join(File.dirname(__FILE__), 'support/urls.txt')).split("\n")
    `echo "IFRAME TEST" > #{@filename}`
  end

  def log_result(url, result)
    `echo #{url}: #{result} >> #{@filename}`
  end

  specify do
    @urls.each do |url|
      begin
        # Test for X-FRAME_OPTIONS
        get_request = HTTParty.get(url)
        x_frame_options = get_request.headers['x-frame-options']
        if x_frame_options
          log_result url, "X-FRAME-OPTIONS #{x_frame_options}"
          next
        end

        # Test for framebusters
        visit "/?url=#{CGI.escape(url)}"
        sleep 1
        if current_host != 'http://127.0.0.1'
          log_result url, "FRAMEBUSTER (#{current_url})"
          next
        end

        # If we made it here, we're ok
        log_result url, "OK"

      rescue => e
        # If we made it here, we're not
        log_result url, "ERROR (#{e.message})"
      end
    end
  end
end
