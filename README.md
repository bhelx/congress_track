## Congress Track (WIP)

### Purpose

The purpose of this project is to create a really simple way to track what your legislators are doing and give you a direct track to providing feedback. The user will enter in their zipcode and their email then choose which of their legislators they want to track. They will get email reports of how their legislators are voting on what issues.

### TODO

* Design front end
* Design email (need links to information about the votes and direct links to legislators social media pages, emails, phone numbers)
* Change zip lookup to geolocate or geocoding address
* Add information about each congressman to introduction email (have it as another email)
* Give user ability to choose legislators to follow
* Give user ability to set email settings
* Setup SMTP with a real mailserver

### Setup

I'm using rbenv and ruby 1.9.3. Setup ruby how you like.

Install gems
```
bundle install
```

First update legislator data:

```
bundle exec rake legislators
```

Copy over .env.example file to .env and edit with key.
```
cp .env.example .env
```

To run the web app:
```
foreman start
```

To see the available commands and descriptions:
```
rake -T
```

You need to preface each command with *bundle exec*

Current commands:

```
rake console            # Pull up a pry console with access to models
rake emails             # sends emails
rake legislators        # both sync and parse legislator entries
rake parse_legislators  # parses legislator data into database entries
rake sync_legislators   # syncs our legislator data using rsync
rake votes              # parses latest votes
```
