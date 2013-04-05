require 'spec_helper'
require 'httparty'
require 'cgi'

$urls = File.read(Rails.root.join('spec/support/urls.txt')).split("\n")
$filename = Rails.root.join("test_result_#{Time.now.to_i}")
`echo "Test for presence of iframe busters / x-frame-options:" > #{$filename}`

feature 'iframe test', :js => true do

  $urls.each do |url|

    scenario "testing #{url}" do

      visit "/?url=#{CGI.escape(url)}"
      url_request = HTTParty.get(url)
      sleep 0.75

      if url_request.headers['x-frame-options'].present?
        `echo "--- #{url}: X-FRAME-OPTIONS #{url_request.headers['x-frame-options']}" >> #{$filename}`
      elsif current_host != 'http://127.0.0.1'
        `echo "--- #{url}: FRAMEBUSTER (#{current_url})" >> #{$filename}`
      else
        `echo "#{url}: OK" >> #{$filename}`
      end

    end

  end

end
