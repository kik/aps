require 'twitter'

class Bot
  def self.update(s)
    oauth = Twitter::OAuth.new('qbaJrz374bFyqwfvDAoyJw', 'BNrVeAmhVj9efhbxp1dfM8EoanSVJpiPxxtrpplWQ')
    oauth.authorize_from_access('185280431-wYQta0FTyaccdcykDjqacbQfOdazXsROasvQQv37', 'UtteOoxzxBu3dkIJXbKdmoYSHufMAE9yQOlvcgWCZx0')

    client = Twitter::Base.new(oauth)
    client.update(s)
  rescue
  end
end
