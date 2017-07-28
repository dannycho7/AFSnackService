class SnackVoteController < ApplicationController
  include SnackHelper

  def index
    @sorted_snacks = sorted_snacks
  end
end
