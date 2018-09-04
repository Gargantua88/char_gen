require_relative 'character'

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

char = Character.new
char.name
char.race
char.race_bonuses
char.class
char.characteristic
char.characteristics_mod
char.hit_points
char.skills
char.info
