TailSounds
==========
Ambient monitoring.

Imagine if your servers created ambient noise instead of silent log messages.  What if your
application infrastructure sounded like a jungle?  Page views are the chittering of crickets,
logins are the cackle of monkeys, and errors are the roar of a lion.


Installation
------------

Stuff that I had to do to get this running:

1. Install the SDL Mixer library.  I used [Homebrew][homebrew]:
    brew install sdl sdl_mixer

2. Install text_to_noise via [Rubygems][rubygems]:
    gem install rubygame rsdl text_to_noise


Usage
-----

Pipe a log into the +tail_sound+ script and it will start chirping:

    tail -f /var/log/mylog | text_to_noise


TODO
----

This is just getting started and is not really useful yet.  Soon we'll be able to:

 * Define a mapping between regular expressions and sounds we'd like to play


[Homebrew]:http://mxcl.github.com/homebrew
[Rubygems]:http://rubygems.org
