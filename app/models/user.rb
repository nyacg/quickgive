# Someone who signs up for the site. They're either a campaigner or donor,
# depending on whether they signed up initially on the website or signed up
#  by a link that was tweeted at them by our twitter bot. At the moment, this
# distinction of status is not used for anything important.

class User
  include MongoMapper::Document

  # Campaigns the user has created
  many :campaigns
  # Different authentication methods the user can sign in using
  many :authentications
  # Donations the user has made to different campaigns (note that a user has
  # both campaigns and donations: we use the same data model for both a
  # "camaigner" and a "donor")
  many :payments

  # Data we store about the user
  key :first_name,    String
  key :last_name,     String
  key :type,          String, required: true # campaigner or donor
  key :paypal_email,  String  # User's paypal email address
  key :paypal_preapproval_key, String # A key paypal gives us that allows us to
                                      # take money from the user without
                                      # explicit authorisation in the future.

  # Create a new user from some data about them, but with their type
  # (campaigner or donor) preset to campaigner
  def self.new_campaigner(params = {})
    @campaigner = new params
    @campaigner.type = "campaigner"
    @campaigner
  end

  # The complement to new_campaigner: create a new user with their type
  # preset to donor
  def self.new_donor(params = {})
    @donor = new params
    @donor.type = "donor"
    @donor
  end

  # Is this user a campaigner?
  def campaigner?
    type == "campaigner"
  end

  # Has this user linked their account to twitter?
  def twitter_authentication?
    authentications.any? { |a| a.is_a? TwitterAuthentication }
  end

  # If this user's linked their account to twiter, what is their
  # twitter username?
  def twitter_screen_name
    if twitter_authentication?
      twitter_authentication.screen_name
    else
      nil
    end
  end

  # The TwitterAuthentication object that represents this user's signin with
  # Twitter
  def twitter_authentication
    authentications.select { |a| a.is_a? TwitterAuthentication }.first
  end

  # The FacebookAuthentication object that represents this user's signin with
  # Facebook
  def facebook_authentication
    authentications.select { |a| a.is_a? FacebookAuthentication }.first
  end

  # Has this user linked their account to Facebook?
  def facebook_authentication?
    authentications.any? { |a| a.is_a? FacebookAuthentication }
  end

  # Has this user linked their account to Instagram?
  def instagram_authentication?
    authentications.any? { |a| a.is_a? InstagramAuthentication }
  end

  # Send this user a message in any way possible
  # TODO At the moment we only do this by Twitter, in the future we should do
  # it by every means we can. e.g., send them a FB private message if they've
  # logged in with FB (user.facebook_authentication?), send them an email if
  # they've given us their email address (PasswordAuthentication), etc
  def notify(message)
    # Log the message for debugging
    puts message.inspect

    # If the user's not signed in with twitter, at the moment we don't do
    # anything
    if twitter_authentication?
      # Find the user's twitter name (TODO: refactor to use user.screen_name)
      screen_name = authentications.select { |a| a.is_a? TwitterAuthentication }.first.screen_name
      # Use our Twitter API client to tweet the user, sending the
      # passed-in mesage to their username
      # Log the output of TWITTER_CLIENT.update so we can easily see if we've
      # been blocked from the Twitter API again
      puts TWITTER_CLIENT.update("@#{screen_name} #{message}").inspect
      # TODO The user won't get this tweet as a notification unless they're
      # following our twitter account. Perhaps if the donation was kickstarted
      # (great pun or jetlag?) by a tweet, we should record the ID of that tweet
      # somewhere and send this tweet in response to that one. That means the
      # user will see it as a reply to their original tweet (good) and also
      # get a notification even if they're not following our twitter account
      # (vital!).
    end
  end

  # Given a Twitter username, find the User. Used when someone tweets at us to
  # see if they're registered and donate if they are.
  def self.find_by_twitter_screen_name(screen_name)
    # Turn the Twitter username into a Twitter user ID (the thing we store)
    uid = TwitterAuthentication.uid_of_screen_name(screen_name)
    # Use that to query all TwitterAuthentication's, find the one matching that
    # UID and find the user corresponding to that Authentication
    all.select(&:twitter_authentication?).select { |u| u.twitter_authentication.uid.to_s == uid.to_s }.first
  end

  # Given a Facebook user id, find the User. Used when someone FB likes at us to
  # see if they're registered and donate if they are.
  def self.find_by_facebook_uid(uid)
    all.select(&:facebook_authentication?).select { |u| u.facebook_authentication.uid.to_s == uid.to_s}.first
  end
end
