Text-To-Noise
=============
Ambient log file monitoring.

Imagine if your servers created ambient noise instead of silent log messages.
What if your application infrastructure sounded like a jungle? Page views are
the chittering of crickets, logins are the cackle of monkeys, and errors are
the roar of a lion.  This is what `text_to_noise` can do.


Installation
------------

Stuff that I had to do to get this running:

1. Install the [SDL Mixer][sdlmixer] library.  I used [Homebrew][homebrew]:
    `brew install sdl sdl_mixer`

2. Install `text_to_noise` via [Rubygems][rubygems]:
    `gem install text-to-noise`

Usage
-----

First, create a sound mapping configuration as shown below. Then you can pipe
a log into the `text_to_noise` script and it will start chirping:

    tail -f /var/log/mylog | text_to_noise my.sounds.rb

Alternatively, you can run `text_to_noise` on an existing file:

    text_to_noise my.sounds.rb -f file.log

Text-To-Noise will cease processing when it reaches the end of the file.


Configuration
=============

Text-To-Noise is configured with a Ruby file. The configuration contains a set
of rules for mapping a line of input text to a sound. Each mapping is a single
method of the form `map( pattern ).to "sound"`:

    map( /a regex matching log lines to trigger sounds/ ).to "a sound name to play"

For example,

    map( /Processing/ ).to "finch"

will match any input line that matches `/Processing/` and play the sound of a finch chirping.

A mapping may target multiple sounds for a given rule.  It can get boring to
hear the same sound every time a page is loaded.  Specify a set of sounds for 
a rule by passing it a list of sound names:

    map( /Processing/ ).to ["canary", "finch"]
   
the sounds will each be played in turn for each time the rule matches.


Dynamic Patterns
----------------

You can also apply more advanced rules for sound generation by supplying a
block to the match rule. The block is passed the [MatchData][MatchData:RDoc]
object returned from the regular expression match:

    map( /Completed in (\d+)ms/ ) { |match_data|
      match_data[1].to_i > 500
    }.to "vulture"

The above rule will play a vulture sound **iff** a line matches the expression
_and_ the block returns true. Applied to a Rails log, the above rule will play
a vulture sound whenever a page takes longer than 500ms to render.

Additional patterns may be added with the `when` condition:

    map( /Completed in (\d+)ms/ ) { |match_data|
      match_data[1].to_i > 500
    }.when { |match_data|
      match_data[1].to_i < 55
    }.to "vulture"

The sound will play if _any_ of the given conditions match.

Since the configuration file is Ruby, you could conceivably do just about
anything you want in the condition block.


For additional details, see the Cucumber [features][Features].  Also, have a 
look at the [sample][SampleConfig] configuration.

Included Sounds
---------------

`text-to-noise` currently comes with the following sounds for use in your
configurations:

    australian_frogmouth
    blue_amazon_macaw
    canary
    canary2
    cardinal
    chicken
    crickets
    crow-1
    crow
    finch
    geese
    hawk
    lapwing
    meadow_lark_long
    meadow_lark_short
    mexican_red_parrot
    mockingbird
    nightingale
    owl
    owl-short
    peacock
    pigeons
    red_lories
    rooster
    vulture
    whipperwhill


Adding Your Own Sounds
----------------------

To make your own sounds available for play, add `sound_path` declarations to
your mapping configuration:

     sound_path "my_sounds/jungle"
     sound_path "my_sounds/circus"

     map /Session/ => "clown"
     map /404/     => "monkeys"

Each `sound_path` is a directory containing wav files. Now you can specify
mappings to wav files in the specified directories. As with the included
sounds, the '.wav' extension is optional.



Example
=======

Here's a starting point if you're sampling a Rails log:

    # rails.configuration.rb
    sound_path "tmp/sounds" # if you've got some of your own sounds you'd like to try

    map /Rendered/   => %w(cardinal crickets canary), :every => 6
    map /Processing/ => "crickets", :every => 4
     
    map /User Load/  => %w(nightingale crickets canary)
    map /SessionsController#new/ => "owl-short"
     
    map /404 Not Found/ => "hawk"
    map /RoutingError/  => "hawk"
     
    map( /Completed in (\d+)ms/ )  { |match_data|
      match_data[1].to_i > 500
    }

Start it up with:

    tail -f /var/www/myrailsapp/shared/logs/production.log | text_to_noise sample.configuration.rb

Or perhaps you're interested in SSH activity on your server:

    # ssh.sounds.rb
    match /sshd.*Accepted/ => %w[rooster hawk chicken crow]
    
Get this started with:

    echo 'match /sshd.*Accepted/ => %w[rooster hawk chicken crow]' > ssh.sounds.rb
    tail -f /var/log/secure.log | text_to_noise ssh.sounds.rb
    

TODO
----

At the moment, this only supports playing some free bird songs that are included in the gem.
Highest priority is the ability to add your own sound sets for playback.

  * Capistrano integration
  * Automatically refresh configurations


[Homebrew]:http://mxcl.github.com/homebrew
[Rubygems]:http://rubygems.org
[sdlmixer]:http://www.libsdl.org/projects/SDL_mixer/
[MatchData:RDoc]:http://ruby-doc.org/core/classes/MatchData.html
[Features]:https://github.com/tobytripp/text_to_noise/blob/master/features/configuration.feature
[SampleConfig]:https://github.com/tobytripp/text_to_noise/blob/master/sample.sounds.rb
