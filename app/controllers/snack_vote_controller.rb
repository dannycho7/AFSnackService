class SnackVoteController < ApplicationController
  protect_from_forgery :except => [:create]

  def new
  end

  def create
    @snack = Snack.find_by(snack_params)
    if @snack.present?
      puts "~~~~~~~~~snack found: #{@snack.inspect}"
      @snack_vote = SnackVote.find_by(snack_vote_params)
      if @snack_vote.present?
        puts"~~~~~~~~~snack vote found: #{@snack_vote.inspect}"
      else
        @snack_vote = SnackVote.new(snack_vote_params)
        if @snack_vote.valid?
          @snack_vote.save
          respond_to do |format|
            format.json { render json: { message: 'saved snack vote' }}
          end
        end
      end
    else
      respond_to do |format|
        if @snack.valid?
          @snack.save
          format.json { render json: @snack.to_json }
        else
          format.json { render json: { error_message: 'failed to save' }}
        end
      end
    end
  end

  private

  def snack_params
    params.permit(:name)
  end

  def snack_vote_params
    params.permit(:votes, :period).merge({ snack_id: @snack.id })
  end
end
