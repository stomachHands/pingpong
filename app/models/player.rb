class Player < ActiveRecord::Base

	validates_uniqueness_of :name
	#validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
	validates :name, presence: true

  def matches
  	Match.where("player1_id = ? OR player2_id = ?", id, id)
  end

  def wins
  	self.matches.where(:winner_id => self.id).count
  end

  def matchs_played
    self.matches.count
  end

  def losses
  	self.matches.count - self.matches.where(:winner_id => self.id).count
  end

  def win_ratio
  	(self.wins * 100) / self.matches.count
  end

  def my_score(match)
    if match.player1_id == self.id
      match.score_player1
    else
      match.score_player2
    end
  end

  def average_points_scored
    counter = 0.0
    self.matches.each do |match|
      counter += self.my_score(match)
    end 
    counter / self.matchs_played
  end

end
