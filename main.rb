require_relative 'lib/character'
require_relative 'lib/weapon'
require_relative 'lib/armor'
require 'json'

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

 puts "Введите имя персонажа: "
 char_name = gets.chomp
 char = Character.new(char_name)

puts "\nВыберите расу:"
Character::RACES.each_with_index { |race,i| puts "#{i}. #{race}"}
user_input = gets.to_i
char.race = Character::RACES[user_input]

puts "\nВыберите класс:"
Character::CLASSES.each_with_index { |char_class,i| puts "#{i}. #{char_class}"}
user_input = gets.to_i
char.char_class = Character::CLASSES[user_input]

char.race_bonuses

dices = char.char_dice_roller
current_char = char.translate(char.characteristics.keys)
dices.size.times do
  puts "\nРаспределите следующие значения: #{dices}"
  puts "Куда запишем значение #{dices[0]}?"
  puts
  current_char.each_with_index {|char, i| puts "#{i}. #{char}"}
  user_input = gets.to_i
  char.characteristics[char.characteristics.keys[user_input]] += dices[0]
  current_char[user_input] = ""
  dices.delete_at(0)
end

char.characteristics_mod
char.class_bonuses
char.hit_points

skill_list = char.class_skills

char.skills_number.times do
  puts
  puts "Выберите навык для изучения:"
  skill_list.each_with_index {|skill,i| puts "#{i}. #{skill}"}
  user_input = gets.to_i
  char.skills[char.skills_list[user_input]] += char.prof_bonus
  skill_list[user_input] = ""
end

puts "Выберите оружие: "
file = File.read("data/" + char.weapons_by_char_class.to_s + "_weapon.json")
weapons_hash = JSON.parse(file, symbolize_names: true)
weapons_hash.each_with_index do |item, i|
  puts "#{i}. #{item[:Name]}"
end
user_weapon = gets.to_i
current_weapon = weapons_hash[user_weapon]
weapon = Weapon.new(current_weapon[:Name], current_weapon[:Damage_type], current_weapon[:Cost], current_weapon[:Damage],
                    current_weapon[:Properties])

armor_hash = JSON.parse(File.read("data/armor.json"), symbolize_names: true)
char_armor = armor_hash.select{|armor| char.armor_type.include?(armor[:type])}

unless char_armor.empty?
  puts "Выберите защиту:"
    char_armor.each_with_index do |item, i|
      puts "#{i}. #{item[:name]}"
    end
    user_armor = gets.to_i
    current_armor = char_armor[user_armor]
    armor = Armor.new(current_armor[:name], current_armor[:basic_ac], current_armor[:cost], current_armor[:type],
                      current_armor[:stealth])
else
  armor = Armor.new
end

char.armor_calculator(armor)

puts
puts "*" * 30
puts "Имя: #{char.name}\nРаса: #{char.race}\nКласс: #{char.char_class}\nХиты: #{char.hit_points}\n"\
  "Класс брони: #{char.armor_class}\nСкорость: #{char.speed}\nСпасброски: #{char.translate(char.saving_throw)}\n\n"\
  "Характеристики: #{char.translate(char.characteristics)}\n\n"\
  "Навыки: #{char.translate(char.skills)}\n\nСпособности: #{char.abilities}\n\n"

puts weapon.info
puts
puts armor.info