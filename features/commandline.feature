Feature: Running text_to_noise

  Use the command-line to tell text-to-noise where to find your config file, the
  input to parse, and whether it should actually make any noise.

  Scenario: Calling with no arguments
    When I run `text_to_noise`

    Then the output should contain:
    """
    Could not locate a noise configuration.
    Specify a configuration with the -c option.

    Try this one if you're processing a Rails log:

      match /Rendered/  => %w(crickets canary)
      match /Rendering/ => "cardinal"
      match /User Load/ => "nightingale"
      match /Processing/ => "finch"
      match /SessionsController#new/ => "owl"
      match /404 Not Found/ => "hawk"

    Or maybe you're watching your ssh access:

      match /sshd.*Accepted/ => %w[rooster hawk chicken crow]

    Copy one of those into a file and pass it along to text_to_noise.

    For example:

      echo 'match /sshd.*Accepted/ => %w[rooster hawk chicken crow]' > ssh.sounds.rb
      tail -f /var/log/secure.log | text_to_noise -c ssh.sounds.rb
    """
