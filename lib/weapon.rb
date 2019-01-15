class Weapon
  attr_accessor :name, :damage_type, :cost, :damage_dice, :properties

  def initialize(name, damage_type, cost, damage_dice, properties)
    @name = name
    @damage_type = damage_type
    @cost = cost
    @damage_dice = damage_dice
    @properties = properties
  end
end
