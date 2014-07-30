quickgive
=========

A platform for allowing very quick donations via social media.


## Backend Flow
#### CAMPAIGNER FLOW
1. Signup as campaigner - done
2. Login/logout as campaigner - done
3. Create campaign - needs more info
4. Authenticate with twitter - not done
5. Add paypal to campaigner - not done

#### NEW DONATOR FLOW
1. Register as donor - done
2. Add paypal to donor - not done
2. Upgrade to full account (donor to campaigner) - not done

#### EXISTING DONATOR FLOW
1. Donate - not done

## URLs
### Campaigners Registration/Login
Campaigners and donors seperate thing.

At the moment campaigner registration is just an email address. Will add authentication later.

    POST /campaigners
    {
      email: hrickards@gmail.com
    }

`GET /campaigners/new` gives you your registration page `campaigners#new`, that needs to post via a form to `/campaigners`. That'll redirect you back to somewhere (homepage?).

Create a new session to log in as a campaigner.

    POST /sessions
    {
      email: hrickards@gmail.com
    }

`GET /sessions/destroy` (can alias to a nicer URL later) logs you out and redirects you back to the homepage.

`GET /sessions/new` (can alias to a nicer URL later) gives you your login page `sessions#new`. That needs to post to `/sessions`, and that will redirect you back to somewhere (homepage?).

### Campaigns
Register a new campaign. Need to be logged in (via sessions#create).

    POST /campaigns
    {
      email: hrickards@gmail.com
    }

`GET /campaigns/new` gives you your nice pretty campaign creation page `campaigns#new`, that needs to post to `/campaigns`, and that will redirect you to `/campaigns/campaign_id` (`campaigns#show`).


### Donors
Register a new donor.

    POST /donors
    {
      twitter_username: harryrickards
    }

`GET /donors/new` gives you the (simple!) signup form. That should post to `/donors`, which will do something. This will also include PayPal information, but not right now.

Donate.

    POST /donors/donate
    {
      campaign_id: foo,
      user_id: bar,
      amount: 50000000000.00
    }

I'll be the only one calling this straight from the backend.
