class Character
  attr_accessor :name, :race, :char_class, :characteristics, :skills_number, :skills, :skills_list, :prof_bonus
  attr_accessor :speed, :hit_points, :abilities, :saving_throw, :armor_type, :armor_class

  RACES = %i(
    dwarf
    elf
    halfling
    human
    dragonborn
    gnome
    half_elf
    half_orc
    tiefling
  )

  CLASSES = %i(
    barbarian
    bard
    cleric
    druid
    fighter
    monk
    paladin
    ranger
    rogue
    sorcerer
    wizard
    warlock
  )

  SKILLS = {
    acrobatics: 0,
    animal_handling: 0,
    arcana: 0,
    athletics: 0,
    deception: 0,
    history: 0,
    insight: 0,
    intimidation: 0,
    medicine: 0,
    nature: 0,
    perception: 0,
    perfomance: 0,
    persuasion: 0,
    religion: 0,
    sleight_of_hand: 0,
    stealth: 0,
    survival: 0
  }
#доступные скилы каждому классу
  SKILLS_BY_CLASS = {
    barbarian: %i(animal_handling athletics intimidation nature perception survival),
    bard: SKILLS.keys,
    cleric: %i(history insight medicine persuasion religion),
    druid: %i(arcana animal_handling insight medicine nature perception religion survival),
    fighter: %i(acrobatics animal_handling athletics history insight intimidation perception survival),
    monk: %i(acrobatics athletics history insight religion stealth),
    paladin: %i(athletics insight intimidation medicine persuasion religion),
    ranger: %i(animal_handling athletics insight nature perception stealth survival),
    rogue: %i(acrobatics athletics deception insight intimidation perception perfomance persuasion sleight_of_hand stealth),
    sorcerer: %i(arcana deception insight intimidation persuasion religion),
    warlock: %i(arcana deception history intimidation nature religion),
    wizard: %i(arcana history insight medicine religion)
  }

#ключи для метода перевода. Возможно, стоит их вынести за пределы проги.
  TRANSLATIONS = {
    strength: "сила",
    dexterity: "ловкость",
    constitution: "телосложение",
    intelligence: "интеллект",
    wisdom: "мудрость",
    charisma: "харизма",
    acrobatics: "акробатика",
    animal_handling: "уход за животными",
    arcana: "магия",
    athletics: "атлетика",
    deception: "обман",
    history: "история",
    insight: "проницательность",
    intimidation: "запугивание",
    medicine: "медицина",
    nature: "природа",
    perception: "внимательность",
    perfomance: "выступление",
    persuasion: "убеждение",
    religion: "религия",
    sleight_of_hand: "ловкость рук",
    stealth: "скрытность",
    survival: "выживание",
    barbarian: "варвар",
    bard: "бард",
    cleric: "клерик",
    druid: "друид",
    fighter: "воин",
    monk: "монах",
    paladin: "паладин",
    ranger: "следопыт",
    rogue: "вор",
    sorcerer: "чародей",
    warlock: "волшебник",
    wizard: "колдун",
    dwarf: "дварф",
    elf: "эльф",
    halfling: "халфлинг",
    human: "человек",
    dragonborn: "драконорожденный",
    gnome: "гном",
    half_elf: "полуэльф",
    half_orc: "полуорк",
    tiefling: "тифлинг"
  }

  def initialize(name)
    @name = name
    @race = nil
    @char_class = nil
    @characteristics = {strength: 0, dexterity: 0, constitution: 0, intelligence: 0, wisdom: 0, charisma: 0}
    @characteristics_mod = {strength: 0, dexterity: 0, constitution: 0, intelligence: 0, wisdom: 0, charisma: 0}
    @skills = SKILLS
    @speed = 0
    @skills_number = 0
    @skills_list = []
    @prof_bonus = 2
    @abilities = []
    @saving_throw = []
    @armor_type = []
  end

  #сам метод перевода
  def translate(item_for_translate)
    if item_for_translate.is_a?(Array)
      translated_array = []
      item_for_translate.each do |word|
        translated_array << TRANSLATIONS[word]
      end
      return translated_array
    elsif item_for_translate.is_a?(Hash)
      translated_hash = {}
      item_for_translate.each do |key, value|
        translated_hash[TRANSLATIONS[key]] = value
      end
      return translated_hash
    else
      return TRANSLATIONS[item_for_translate]
    end
  end

  def roll_dice(n)
    rand(n) + 1
  end

  def roll_dices(m, n)
    result = []

    m.times do
      result << roll_dice(n)
    end

    result
  end

#метод бросает кубики конкретно для характеристик
  def char_dice_roller
    char_dices = []

    6.times do
      dices = roll_dices(4, 6)
      dices.delete_at(dices.index(dices.min))
      dice_summ = dices.inject(0){|sum,x| sum + x }
      char_dices << dice_summ
    end

    char_dices
  end

  #рассчет кучи расовых бонусов
  def race_bonuses
    case @race
    when :dwarf
      @speed = 5
      characteristics[:constitution] += 2
      characteristics[:strength] += 2
      @abilities.push("темное зрение", "дварфская стойкость", "знание камня")
    when :elf
      @speed = 7
      characteristics[:dexterity] += 2
      characteristics[:wisdom] += 1
      @skills[:perception] += 2
      @abilities.push("темное зрение", "фейское происхождение", "транс", "защита дикой природы")
    when :halfling
      @speed = 5
      characteristics[:dexterity] += 2
      characteristics[:charisma] += 1
      @abilities.push("везучий", "храбрый", "проворство", "природная скрытность")
    when :human
      @speed = 6
      characteristics.transform_values! {|v| v + 1 }
      @abilities.push("черта на выбор")
    when :dragonborn
      @speed = 6
      characteristics[:strength] += 2
      characteristics[:charisma] += 1
      @abilities.push("драконье происхождение", "дыхание дракона", "сопротивление стихии")
    when :gnome
      @speed = 5
      characteristics[:intelligence] += 2
      characteristics[:dexterity] += 1
      @abilities.push("темное зрение", "гномья хитрость", "природный иллюзионист", "язык зверушек")
    when :half_elf
      @speed = 6
      characteristics[:charisma] += 2
      characteristics[:dexterity] += 1
      characteristics[:wisdom] += 1
      @skills_number += 2
      @abilities.push("темное зрение", "фейское происхождение")
    when :half_orc
      @speed = 6
      characteristics[:constitution] += 1
      characteristics[:strength] += 2
      @skills[:intimidation] += 2
      @abilities.push("темное зрение", "невероятная стойкость", "безумная атака")
    when :tiefling
      @speed = 6
      characteristics[:intelligence] += 1
      characteristics[:charisma] += 2
      @abilities.push("темное зрение", "адская сопротивляемость", "дьявольское наследие")
    end
  end

  #рассчет модификаторов характеристик
  def characteristics_mod
    @characteristics_mod = @characteristics.transform_values {|v| (v-10)/2}
  end

  #рассчет кучи классовых бонусов
  def class_bonuses
    case @char_class
    when :barbarian
      @hit_dice = 12
      #количество очков навыков
      @skills_number += 2
      #сразу же выставим значения доступных типов брони для класса Armor
      @armor_type = ["medium", "light"]
      @saving_throw.push(:strength, :constitution)
      @abilities.push("ярость", "защита без доспехов")
    when :bard
      @hit_dice = 8
      @skills_number += 3
      @armor_type = ["light"]
      @saving_throw.push(:dexterity, :charisma)
      @abilities.push("колдовство", "бардовское вдохновение")
    when :cleric
      @hit_dice = 8
      @skills_number += 2
      @armor_type = ["medium", "light"]
      @saving_throw.push(:wisdom, :charisma)
      @abilities.push("колдовство", "божественный домен")
    when :druid
      @hit_dice = 8
      @skills_number += 2
      @armor_type = ["medium", "light"]
      @saving_throw.push(:intelligence, :wisdom)
      @abilities.push("рунный язык", "колдовство")
    when :fighter
      @hit_dice = 10
      @skills_number += 2
      @armor_type = ["medium", "light", "heavy"]
      @saving_throw.push(:strength, :constitution)
      @abilities.push("боевой стиль", "второе дыхание")
    when :monk
      @hit_dice = 8
      @skills_number += 2
      @armor_type = ["none"]
      @saving_throw.push(:strength, :dexterity)
      @abilities.push("защита без доспехов", "боевые искусства")
    when :paladin
      @hit_dice = 10
      @skills_number += 2
      @armor_type = ["medium", "light", "heavy"]
      @saving_throw.push(:wisdom, :charisma)
      @abilities.push("божественное чувство", "наложение рук")
    when :ranger
      @hit_dice = 10
      @skills_number += 3
      @armor_type = ["medium", "light"]
      @saving_throw.push(:strength, :dexterity)
      @abilities.push("избранный враг", "исследователь природы")
    when :rogue
      @hit_dice = 8
      @skills_number += 4
      @armor_type = ["light"]
      @saving_throw.push(:dexterity, :intelligence)
      @abilities.push("компетентность", "скрытая атака", "воровской жаргон")
    when :sorcerer
      @hit_dice = 6
      @skills_number += 2
      @armor_type = ["none"]
      @saving_throw.push(:constitution, :charisma)
      @abilities.push("колдовство", "колдовское происхождение")
    when :wizard
      @hit_dice = 6
      @skills_number += 2
      @armor_type = ["none"]
      @saving_throw.push(:intelligence, :wisdom)
      @abilities.push("колдовство", "тайное восстановление")
    when :warlock
      @hit_dice = 8
      @skills_number += 2
      @armor_type = ["light"]
      @saving_throw.push(:wisdom, :charisma)
      @abilities.push("потусторонний покровитель", "магия договора")
    end
  end

  def max_hit_points
    @hit_points = @hit_dice + @characteristics_mod[:constitution]
  end

  #возвращает список доступных скилов по имени класса
  def class_skills
    @skills_list = SKILLS_BY_CLASS[@char_class]
    translate(@skills_list)
  end

  #возвращает имя класса для интерполяции в ссылку на файл доступного оружия
  def weapons_by_char_class
    #дварфам сразу доступны все виды оружия
    return :fighter if @race == :dwarf
    @char_class.to_s
  end

  #рассчет бонусов от брони
  def armor_calculator(armor)
    @speed -= 1 if armor.type == "heavy"
    @skills[:stealth] += armor.stealth
    @armor_class = armor.basic_ac + characteristics_mod[:dexterity]
  end
end