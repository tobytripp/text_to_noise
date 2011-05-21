# match /Rendered/  => %w(crickets canary), :every => 6
match /Rendering/ => %w(cardinal crickets canary)
match /User Load/ => %w"nightingale crickets canary"
match /Processing/ => "crickets"
match /SessionsController#new/ => "owl-short"
match /404 Not Found/ => "hawk"
match /RoutingError/ => "hawk"
