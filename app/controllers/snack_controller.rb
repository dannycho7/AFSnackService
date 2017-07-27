class SnackController < ApplicationController
  def new
  end

  def create
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end
end
