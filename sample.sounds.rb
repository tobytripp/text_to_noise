sound_path "tmp/sounds"

map /Rendered/  => %w(cardinal crickets canary), :every => 6
map /Processing/ => "crickets", :every => 4

map /User Load/ => %w"nightingale crickets canary"
map /SessionsController#new/ => "owl-short"

map /404 Not Found/ => "hawk"
map /RoutingError/  => "hawk"

map( /Completed in (\d+)ms/ )  { |match_data|
  match_data[1].to_i > 500
}
