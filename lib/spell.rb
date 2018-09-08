class Spell
  attr_reader :name, :casting_time, :components, :duration, :range, :level

  def initialize(name, casting_time, components, duration, range, level)
    @name = name
    @casting_time = casting_time
    @components = components
    @duration = duration
    @range = range
    @level = level
  end

end