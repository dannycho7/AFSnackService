class SnackController < ApplicationController
  protect_from_forgery :except => [:create]

  def new
  end

  def create
    @snack = Snack.new(snack_params)

    @snack.save

    respond_to do |format|
      if @snack.valid?
        format.json { render json: @snack.to_json }
      else
        format.json { render json: { error_message: 'failed to save' }}
      end
    end
  end

  private

  def snack_params
    params.permit(:name, :store)
  end
end
