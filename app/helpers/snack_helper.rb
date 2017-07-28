module SnackHelper
  def sorted_snacks
    snacks = Snack.all.map do |snack|
      {
        name: snack.name,
        vote_count_yes: snack.votes.count { |vote| vote.value == 1 },
        vote_count_no: snack.votes.count { |vote| vote.value == -1 },
        id: snack.id
      }
    end
    snacks.select { |entry| entry[:vote_count_yes] > -1 }.sort_by { |snack| snack[:vote_count_yes] }.reverse.take(30)
  end

  def add_vote_using_payload
    payload = JSON.parse(params[:payload])
    payload_action = payload['actions'].first
    username = payload['user']['name']
    snackname = payload_action['name']
    add_vote(username: username, snackname: snackname, value: payload_action['value'])
  end

  def add_vote_using_command
    username = params[:user_name]
    snackname = params[:text]
    if add_vote(username: username, snackname: snackname, value: 1)
      yield(success: true, snackname: snackname)
    else
      yield(success: false, snackname: snackname)
    end
  end

  def add_vote(username:, snackname:, value:)
    user = find_or_create_user(username)
    snack = find_or_create_snack(snackname)
    vote = Vote.find_by(user_id: user.id, snack_id: snack.id)
    if vote
      vote.value = value
    else
      vote = Vote.new(user_id: user.id, snack_id: snack.id, value: value)
    end
    vote.save
  end

  def find_or_create_user(username)
    user = User.find_by(username: username)
    unless user
      user = User.new(username: username)
      user.save
    end
    user
  end

  def find_or_create_snack(snackname)
    snack = Snack.find_by(name: snackname)
    unless snack
      snack = Snack.new(name: snackname)
      snack.save
    end
    snack
  end
end
