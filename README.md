# Scraptacular

[![Code Climate](https://codeclimate.com/github/rvandervort/scraptacular.png)](https://codeclimate.com/github/rvandervort/scraptacular)

Organized web-scraping. 
## Installation

Add this line to your application's Gemfile:

    gem 'scraptacular'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scraptacular

## Usage

### Defining Scrapers
The scraper describes what content should be plucked from the page and returned in the result.

*Example 1 : Basic Usage*
```ruby
 scraper :yahoo_front_page do
   result do
     highest_trending_url { page.search("ol.trending_now_trend_list li a").first.attributes["href"].value }
     anything { "My returned value" }
   end
 end
```

*Example 2 : Multiple Level Scraping*
```ruby
 scraper :event_index_page do
   # Find URLs, scrape the contents of those pages using the :event_detail_page scraper
   scrape_links("a.css_selector_for_links", with: :event_detail_page).each do |link|
     result do

       # Provide partial result from the index page
       event_title { page.search("h4").first.text }

       # Merge results from the detail page
       merge(link)
     end
   end
 end

 scraper :event_detail_page do
   result do
      date { ... }
      price { ... }
   end
 end
```
Scraping a page returns a Scraptacular::Result object :
```ruby
result = results.first  # See section below on running a scraping session

result.class  # Scraptacular::Result
result.to_h   # {:highest_trending_url => "http://www.harlemshakevideos.com", :anything => "My returned value" }
```

### Setting Up Scraping Sessions

Scraping sessions are divided into groups and suites. The group is a logical separation by content topic.
The suite generally refers to a set of urls which should be scraped using the same scraper

```ruby
scrape_group "Ruby Sites" do
  suite "Google", with: :google_result_index do

    # The url will be scraped using the :google_result_index scraper
    url "https://www.google.com/search?q=Ruby"

    # Tell Scraptacular to use a different scraper for an individual URL
    url "https://www.google.com/search?q=Ruby+On+Rails", with: :google_alternate_index
  end
end
```

### Running From The Command Line
Scraptacular comes with its own command line utility. Currently the only supported output format is JSON:
See scraptacular --help for more info.
```
$ scraptacular -d /path/to/scraper_definitions.rb -s /path/to/sessions.rb -o /path/to/outout.json
```

### Inside Your Project
```ruby
require 'scraptacular'

# Set up the definitions and sessions
scraper :my_scraper do
end

scrape_group "My Group" do
  suite "My Suite", with: :my_scraper do
    url "http..."
    url "http..."
  end
end

# Run all groups
results = Scraptacular.run

# Run a single group
results = Scraptacular.run({group: "My Group"})

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
