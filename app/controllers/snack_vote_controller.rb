class SnackVoteController < ApplicationController

  def new
  end

  def create
    @snack = Snack.find_by(snack_params)
    if @snack.present?
      @snack_vote = SnackVote.find_by(snack_vote_params)
      if @snack_vote.present?
        @snack_vote.votes = snack_vote_params[:votes]
        @snack_vote.save if @snack_vote.valid?
      else
        create_snack_vote
      end
    else
      snack_not_present
    end
  end

  private

  def snack_params
    params.permit(:name)
  end

  def snack_vote_params
    params.permit(:votes, :period).merge({snack_id: @snack.id})
  end

  def create_snack_vote
    @snack_vote = SnackVote.new(snack_vote_params)
    respond_to do |format|
      if @snack_vote.valid?
        @snack_vote.save
        format.json { render json: {message: 'saved snack vote'} }
      else
        format.json { render json: {message: 'snack failed to save'} }
      end
    end
  end

  def snack_not_present
    respond_to do |format|
      if @snack.valid?
        @snack.save
        format.json { render json: @snack.to_json }
      else
        format.json { render json: {error_message: 'failed to save'} }
      end
    end
  end


end
