require "pp"
require "etc"
require "gosu"
require "securerandom"

require_relative "lib/display"
require_relative "lib/grid"
require_relative "lib/cell"
require_relative "lib/ai"

require_relative "lib/ais/random_ai"
require_relative "lib/ais/cost_ai"

Point = Struct.new(:x, :y)
Display.new(640, 480, fullscreen: false).show