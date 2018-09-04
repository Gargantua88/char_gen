class Character
  def initialize
    @name = nil
    @race = ["человек"]
    @class = ["варвар"]
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
    char_dices = []

    6.times do
      dices = []

      4.times do |dice|
        dice = (rand(6)+1)
        dices << dice
      end

      dices.delete_at(dices.index(dices.min))

      dice_summ = dices.inject(0){|sum,x| sum + x }

      char_dices << dice_summ
    end

    char_dices
  end

  def characteristic
    current_char = @characteristics.keys
    dices = dice_roller

    dices.size.times do
      puts "\nРаспределите следующие значения: #{dices}"
      puts "Куда запишем значение #{dices[0]}?"
      puts

      current_char.each_with_index {|char, i| puts "#{i}. #{char}"}

      user_input = gets.to_i
      @characteristics[@characteristics.keys[user_input]] += dices[0]
      current_char[user_input] = ""
      dices.delete_at(0)
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
        skills.each_with_index {|skill,i| puts "#{i}. #{skill}"}
        user_input = gets.to_i
        @skills[@skills.keys[user_input]] += @prof_bonus
        skills[user_input] = ""
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
