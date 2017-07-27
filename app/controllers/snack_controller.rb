class SnackController < ApplicationController
  protect_from_forgery :except => [:create]

  def new
  end

  def create
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end
end
