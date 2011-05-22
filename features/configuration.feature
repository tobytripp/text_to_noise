Feature: Mapping input lines to sounds for playback

  Use the mapping configuration file to specify which sounds are played for
  each line in the input stream.
  
  Scenario: Mapping a regular expression to a single sound
    Given a file named "sound_mapping.rb" with:
    """
    map( /caw/ ).to "crow"

    """
    And a file named "stuff.log" with:
    """
    caw

    """

    When I run `text_to_noise sound_mapping.rb --file stuff.log --mute`

    Then the output should contain:
    """
    Playing crow.wav
    """

  Scenario: Using a Hash to specify mappings
    Given a file named "sound_mapping.rb" with:
    """
    map /caw/    => "crow"
    map /bakawk/ => "chicken"
    """

    And a file named "input.log" with:
    """
    caw
    bakawk!
    """

    When I run `text_to_noise sound_mapping.rb -f input.log -m`

    Then the output should contain "Playing crow.wav"
     And the output should contain "Playing chicken.wav"

  Scenario: Configuring a dynamic matcher with a block
    Given a file named "sound_mapping.rb" with:
    """
    map( /Completed in (\d+)ms/ ) { |match_data|
      match_data[1].to_i > 500
    }.to "slow_request"

    map( /Load \(([\d.]+)ms\)/ ) { |match_data|
      match_data[1].to_i > 5
    }.to "slow_query"

    """

    And a file named "input.log" with:
    """
    Completed in 250ms
    User Load (7.1ms)
    """

    When I run `text_to_noise sound_mapping.rb -f input.log -m`
    
    Then the output should contain "Playing slow_query.wav"
     And the output should not contain "Playing slow_request.wav"

  Scenario: Inputs that match multiple rules should fire all sounds
    Given a file named "sound_mapping.rb" with:
    """
    map /caw/    => "crow"
    map /bakawk/ => "chicken"
    """

    And a file named "input.log" with:
    """
    caw    bakawk!
    """

    When I run `text_to_noise sound_mapping.rb -f input.log -m`

    Then the output should contain "Playing crow.wav"
     And the output should contain "Playing chicken.wav"

  Scenario: Throttling a match
    Given a file named "sound_mapping.rb" with:
    """
    map /Rendered/ => 'crickets', :every => 5
    map( /page/ ).to( 'crickets' ).every( 5 )
    """

    And a file named "input.short.log" with:
    """
    Rendered a page
    Rendered a page
    Rendered a page
    """

    And a file named "input.long.log" with:
    """
    Rendered a page
    Rendered a page
    Rendered a page
    Rendered a page
    Rendered a page
    """

    When I run `text_to_noise sound_mapping.rb -f input.short.log -m`

    Then the output should not contain "Playing crickets.wav"

    When I run `text_to_noise sound_mapping.rb -f input.long.log -m`

    Then the output should contain "Playing crickets.wav"

  @wip
  Scenario: Throttling with a Proc
    Given a file named "sound_mapping" with:
    """
    map /Rendered (\w+) page/ => 'crickets', :when => lambda { |md| md[1] == 'B' }
    """

    And a file named "input.log" with:
    """
    Rendered A page
    """
    
    When I run `text_to_noise sound_mapping -f input.log -m`

    Then the output should not contain "Playing crickets.wav"

  @wip
  Scenario: Adding sound directories
    Given a file named "sound_mapping" with:
    """
    sound_path other_sounds
    """

    And a directory named "other_sounds"
    And an empty file named "blurp.wav"

    And a file named "input.log" with:
    """
    Rendered a page
    """

    When I run `text_to_noise sound_mapping -f input.log -m`

    Then the output should contain "Playing blurp.wav"
