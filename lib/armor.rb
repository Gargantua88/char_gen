class Armor
  attr_accessor :name, :basic_ac, :cost, :type, :stealth

  def initialize(name = "Unarmored", basic_ac = 10, cost = 0, type = "none", stealth = 0)
    @name = name
    @basic_ac = basic_ac
    @cost = cost
    @type = type
    @stealth = stealth
  end

  def info
    puts "Броня: #{@name}\nБазовая защита: #{@basic_ac}\nТип: #{@type}\n"\
      "Цена: #{@cost} золотых\nШтраф к скрытности: #{@stealth}"
  end
end