class Weapon
  attr_accessor :name, :damage_type, :cost, :damage_dice, :properties

  def initialize(name, damage_type, cost, damage_dice, properties)
    @name = name
    @damage_type = damage_type
    @cost = cost
    @damage_dice = damage_dice
    @properties = properties
  end

  def info
    puts "Оружие: #{@name}\nТип урона: #{@damage_type}\nУрон:1d#{damage_dice}\n"\
      "Цена: #{cost} золотых\nСвойства: #{@properties}"
  end
end
