class HomeController < ApplicationController
  def index
    render json: { status: "ok", message: "Welcome to Good Night API!" }
  end
end
