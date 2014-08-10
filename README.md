quickgive
=========

A platform for allowing very quick donations via social media.

# Backend Documentation
## 10 Second Rails Crash Course

Models = representations of objects (e.g., a `User`, a `Charity`) that almost-always correspond to database collections (tables).

Views = the front-end things that users see.

Controllers = the glue linking the models and views together.

As a general rule of thumb, you want big fat models and small lean controllers. That hasn't been strictly adhered to in QuickGive, but hey: hackathons...

You'll find models in `app/models`, views in `app/views` and controllers in `app/controllers`. The Twitter stream bot lives in `lib/daemons/twitter_listen.rb`, and the Facebook one in `lib/daemons/facebook.rb`. See `start.sh` (a script that starts both of those bots as well as the Rails server) for how to start and stop these.

The only other things you may want are `config/routes.rb` which controls the routing for the application (i.e., when you go to a certain URL, which controller it takes to), `config/mongo.yml` which controls mongo settings, `config/initializers/tweetstream.rb` which contains code to initialise the Twitter API clients, `config/twitter.yml` which contains Twitter API keys and `config/paypal_adaptive.yml` which contains Paypal API key.

## Models

All of the models described below can be found in `app/models` (with more detailed documentation). All of them use `MongoMapper` to store data in a mongo DB, but this is abstracted so you only ever need to use Ruby code rather than actually writing Mongo queries.

`User` - someone who signs up for the site. They're either a campaigner or donor, depending on whether they signed up initially on the website or signed up by a link that was tweeted at them by our twitter bot. At the moment, this distinction of status is not used for anything important.

A `User` has many `Authentication`s: these are ways the user has to login to the site, e.g., via password, twitter, etc. `Authentication` is a general class that refers to all the different types, and `PasswordAuthentication`, `FacebookAuthentication`, `TwitterAuthentication`, `InstagramAuthentication` (just an empty skeleton at the moment) are children classes of `Authentication` that do the actual heavy lifting.

A `Charity` is simply a class representing a charity from the Charities Commission data we have.

A `Campaign` is what we in the team have been calling a campaign (hence the name). It's owned by both a `User` (the person who created it) and a `Charity` (the charity it's raising money for).

A `Campaign` has many `Payment`s, each of which represents an individual donation. A `Payment` is owned by both a `Campaign` (the campaign the donation was made to) and a `User` (the user who made the payment). The PayPal payment is taken by this model.

Somewhat isolated from the other models is a `Status`. This is not actually linked to any stored data in mongo or anywhere, but is instead used as a convenient class for parsing things out of and making payments from a social media status (e.g., a tweet).

## Controllers

All controllers are fully documented; see `config/routes.rb` to see which controller controls which URLs.
