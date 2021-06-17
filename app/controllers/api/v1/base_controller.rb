module Api::V1
  class BaseController < ApplicationController
    include Response
    include ErrorHandler
  end
end
