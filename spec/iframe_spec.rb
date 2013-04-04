require 'spec_helper'
require 'httparty'
require 'cgi'

#$urls = %w(http://www.nytimes.com http://www.google.com http://gravatar.com)
$urls = File.read(Rails.root.join('spec/support/urls.txt')).split("\n")

feature 'iframe test', :js => true do

  before(:all) do
    @bad_file = File.open(Rails.root.join("test_result_#{Time.now.to_i}"), 'w')
  end

  $urls.each do |url|
    scenario "testing #{url}" do
      visit "/?url=#{CGI.escape(url)}"
      url_request = HTTParty.get(url)
      sleep 0.25
      if url_request.headers['x-frame-options'].present?
        @bad_file.puts "#{url}: X-FRAME-OPTIONS #{url_request.headers['x-frame-options']}" 
      elsif current_host != 'http://127.0.0.1'
        @bad_file.puts "#{url}: FRAMEBUSTER (#{current_url})"
      end
    end
  end

  after(:all) do
    $bad_file.close
  end

end
