Feature: Mapping input lines to sounds for playback

  Use the mapping configuration file to specify which sounds are played for
  each line in the input stream.

  @wip
  Scenario: Mapping a regular expression to a single sound
    Given a file named "sound_mapping.rb" with:
    """
    map( /caw/ ).to "crow"

    """
    And an empty file named "stuff.log"
  
    When I run `./bin/text_to_noise --mapping sound_mapping.rb --file stuff.log`
    And I append to "stuff.log" with:
    """
    caw

    """

    Then the sound file "caw.wav" should be played
