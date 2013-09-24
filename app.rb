require 'sinatra'

get '/' do
  "<script type='text/javascript'>
    var prevent_bust = 0;
    var original_url = window.location.origin + window.location.pathname;
    window.onbeforeunload = function() { prevent_bust++ };
    setInterval(function() {
      if (prevent_bust > 0) {
        prevent_bust -= 2;
        window.top.location = original_url + '?busted=1';
      }
    }, 1);
  </script>
  <iframe style='width: 50%; height: 500px' src='#{params[:url]}'></iframe>
  #{"<span> framebuster </span>" if params[:busted]}"
end
