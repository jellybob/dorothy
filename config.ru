
require 'toto'

class Redirects
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    
    if req.path == "/2011/04/15/text-tractor-a-tool-for-editing-copy/"
      return [ 301, { "Location" => "http://blog.blankpad.net/2011/04/15/copycat-a-tool-for-editing-copy/" }, "Redirecting." ]
    else
      @app.call(env)
    end
  end
end

# Rack config
use Redirects
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  set :author,      "Jon"                                     # blog author
  set :title,       "Jon's Blog"                              # site title
  # set :root,      "index"                                   # page to load on /
  # set :date,      lambda {|now| now.strftime("%d/%m/%Y") }  # date format for articles
  # set :markdown,  :smart                                    # use markdown + smart-mode
  set :disqus,      "blankpad"                                # disqus id, or false
  set :summary,   :max => 150, :delim => /~/                  # length of article summary and delimiter
  # set :ext,       'txt'                                     # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds

  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
end

run toto


