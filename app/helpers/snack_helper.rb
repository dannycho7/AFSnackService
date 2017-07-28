module SnackHelper
  def sorted_snacks
    snacks = Snack.all.map do |snack|
      {
        name: snack.name,
        vote_count_yes: snack.votes.count { |vote| vote.value == 1 },
        vote_count_no: snack.votes.count { |vote| vote.value == -1 }
      }
    end
    snacks.sort_by { |snack| snack[:vote_count_yes] }.reverse
  end
end
