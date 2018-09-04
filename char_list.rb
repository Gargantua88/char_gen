class Character
  def initialize
    @name = nil
    @race = ["человек", "эльф"]
    @class = ["варвар", "друид"]
    @characteristics = {"сила" => 0, "ловкость" => 0, "телосложение" => 0, "интеллект" => 0, "мудрость" => 0, "харизма" => 0}
    @characteristics_mod = {"сила" => 0, "ловкость" => 0, "телосложение" => 0, "интеллект" => 0, "мудрость" => 0, "харизма" => 0}
    @speed = 0
    @hit_points = 0
    @skills = {"атлетика" => 0, "внимательность" => 0, "выживание" => 0, "запугивание" => 0, "природа" => 0, "уход за животными" => 0}
    @prof_bonus = 2
    @weapons = {"секира" => 12, "метательное копье" => 6}
    @equipment = {"набор путешественника" => "спальник, свечи(4шт.), огниво..."}
  end

  def name
    puts "\nВведите имя персонажа:"
    @name = gets.chomp
  end

  def race
    puts "\nВыберите расу:"
    @race.each_with_index { |race,i| puts "#{i}. #{race}"}
    user_input = gets.to_i
    @race = @race[user_input]
  end

  def class
    puts "\nВыберите класс:"
    @class.each_with_index { |char_class,i| puts "#{i}. #{char_class}"}
    user_input = gets.to_i
    @class = @class[user_input]
  end

  def dice_roller
    dices = []
    6.times do
      dice = (rand(6) + 1) * 3
      dices << dice
    end
    dices
  end

  def characteristic
    current_char = @characteristics.keys
    dices = dice_roller
    puts "\nРаспределите следующие значения: #{dices}"

    dices.each do |dice|
      puts
      puts dice
      puts "Куда запишем это значение?"
      current_char.each {|char| puts char }
      user_input = gets.chomp
      @characteristics[user_input] += dice
      current_char.delete(user_input)
    end
    @characteristics
  end

  def race_bonuses
    case @race
    when "человек"
      @speed = 6
      @characteristics = @characteristics.transform_values {|v| v + 1 }
    end
  end

  def characteristics_mod
    @characteristics_mod = @characteristics.transform_values {|v| (v-10)/2}
  end

  def hit_points
    case @class
    when "варвар"
      @hit_points = 12 + @characteristics_mod["телосложение"]
    end
  end

  def skills
    skills = @skills.keys
    case @class
    when "варвар"
      2.times do
        puts
        puts "Выберите навык для изучения:"
        skills.each {|skill| puts skill }
        user_input = gets.downcase.chomp
        @skills[user_input] += @prof_bonus
        skills.delete(user_input)
      end
    end
  end

  def weapons
    #to_do
  end

  def equipment
    #to_do
  end

  def info
    puts
    puts "*" * 20
    puts "Имя: #{@name}\nРаса: #{@race}\nКласс: #{@class}\nСкорость: #{@speed}\nХарактеристики: #{@characteristics}\n"\
           "Хиты: #{@hit_points}\nНавыки: #{@skills}\nОружие: #{@weapons.keys}\nРюкзак: #{@equipment.keys}"
  end
end
