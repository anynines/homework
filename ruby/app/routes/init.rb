require 'sinatra/base'
require 'json'

require_relative '../middleware/auth'

require_relative 'health'
require_relative 'articles'
require_relative 'home'
