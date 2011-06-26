sound_path "tmp/sounds"

scale = 2

map /Rendered/   => %w(cardinal canary whipperwhill), :every => scale
map /Processing/ => "crickets", :every => scale * 2

map /User Load/  => %w"nightingale pigeons red_lories"
map /SessionsController#new/ => "owl-short"

map /404 Not Found/ => "hawk"
map /RoutingError/  => "hawk", :every => scale

map( /Completed in (\d+)ms/ )  { |match_data|
  match_data[1].to_i > 500
}.to "vulture"
