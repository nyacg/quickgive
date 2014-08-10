# Start the Facebook bot
rake daemon:facebook:start
# Start the twitter bot
rake daemon:twitter_listen:start

# Start the Rails dev web server
rails server
