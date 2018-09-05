class Character
  attr_accessor :name, :race, :char_class, :characteristics, :skills_number, :skills, :skills_list, :prof_bonus
  attr_accessor :speed, :hit_points, :abilities, :saving_throw

  RACES = %w(
    дварф
    эльф
    халфлинг
    человек
    драконорожденный
    гном
    полуэльф
    полуорк
    тифлинг
  )

  CLASSES = %w(
    варвар
    бард
    клерик
    друид
    воин
    монах
    паладин
    следопыт
    вор
    чародей
    волшебник
    колдун
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
    wizard: "колдун"
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
  end

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

  def race_bonuses
    case @race
    when "дварф"
      @speed = 5
      characteristics[:constitution] += 2
      characteristics[:strength] += 2
      @abilities.push("темное зрение", "дварфская стойкость", "знание камня")
    when "эльф"
      @speed = 7
      characteristics[:dexterity] += 2
      characteristics[:wisdom] += 1
      @skills[:perception] += 2
      @abilities.push("темное зрение", "фейское происхождение", "транс", "защита дикой природы")
    when "халфлинг"
      @speed = 5
      characteristics[:dexterity] += 2
      characteristics[:charisma] += 1
      @abilities.push("везучий", "храбрый", "проворство", "природная скрытность")
    when "человек"
      @speed = 6
      characteristics.transform_values {|v| v + 1 }
      @abilities.push("черта на выбор")
    when "драконорожденный"
      @speed = 6
      characteristics[:strength] += 2
      characteristics[:charisma] += 1
      @abilities.push("драконье происхождение", "дыхание дракона", "сопротивление стихии")
    when "гном"
      @speed = 5
      characteristics[:intelligence] += 2
      characteristics[:dexterity] += 1
      @abilities.push("темное зрение", "гномья хитрость", "природный иллюзионист", "язык зверушек")
    when "полуэльф"
      @speed = 6
      characteristics[:charisma] += 2
      characteristics[:dexterity] += 1
      characteristics[:wisdom] += 1
      @skills_number += 2
      @abilities.push("темное зрение", "фейское происхождение")
    when "полуорк"
      @speed = 6
      characteristics[:constitution] += 1
      characteristics[:strength] += 2
      @skills[:intimidation] += 2
      @abilities.push("темное зрение", "невероятная стойкость", "безумная атака")
    when "тифлинг"
      @speed = 6
      characteristics[:intelligence] += 1
      characteristics[:charisma] += 2
      @abilities.push("темное зрение", "адская сопротивляемость", "дьявольское наследие")
    end
  end

  def characteristics_mod
    @characteristics_mod = @characteristics.transform_values {|v| (v-10)/2}
  end

  def class_bonuses
    case @char_class
    when "варвар"
      @hit_dice = 12
      @skills_number += 2
      @saving_throw.push(:strength, :constitution)
      @abilities.push("ярость", "защита без доспехов")
    when "бард"
      @hit_dice = 8
      @skills_number += 3
      @saving_throw.push(:dexterity, :charisma)
      @abilities.push("колдовство", "бардовское вдохновение")
    when "клерик"
      @hit_dice = 8
      @skills_number += 2
      @saving_throw.push(:wisdom, :charisma)
      @abilities.push("колдовство", "божественный домен")
    when "друид"
      @hit_dice = 8
      @skills_number += 2
      @saving_throw.push(:intelligence, :wisdom)
      @abilities.push("рунный язык", "колдовство")
    when "воин"
      @hit_dice = 10
      @skills_number += 2
      @saving_throw.push(:strength, :constitution)
      @abilities.push("боевой стиль", "второе дыхание")
    when "монах"
      @hit_dice = 8
      @skills_number += 2
      @saving_throw.push(:strength, :dexterity)
      @abilities.push("защита без доспехов", "боевые искусства")
    when "паладин"
      @hit_dice = 10
      @skills_number += 2
      @saving_throw.push(:wisdom, :charisma)
      @abilities.push("божественное чувство", "наложение рук")
    when "следопыт"
      @hit_dice = 10
      @skills_number += 3
      @saving_throw.push(:strength, :dexterity)
      @abilities.push("избранный враг", "исследователь природы")
    when "вор"
      @hit_dice = 8
      @skills_number += 4
      @saving_throw.push(:dexterity, :intelligence)
      @abilities.push("компетентность", "скрытая атака", "воровской жаргон")
    when "чародей"
      @hit_dice = 6
      @skills_number += 2
      @saving_throw.push(:constitution, :charisma)
      @abilities.push("колдовство", "колдовское происхождение")
    when "волшебник"
      @hit_dice = 6
      @skills_number += 2
      @saving_throw.push(:intelligence, :wisdom)
      @abilities.push("колдовство", "тайное восстановление")
    when "колдун"
      @hit_dice = 8
      @skills_number += 2
      @saving_throw.push(:wisdom, :charisma)
      @abilities.push("потусторонний покровитель", "магия договора")
    end
  end

  def hit_points
    @hit_points = @hit_dice + @characteristics_mod[:constitution]
  end

  def class_skills
    @skills_list = SKILLS_BY_CLASS[TRANSLATIONS.key(@char_class)]
    translate(@skills_list)
  end

  def weapons
    case @char_class
    when "варвар"
      'martial_melee_weapons'
    when "бард"
      'simple_melee_weapons'
    when "клерик"
      'simple_melee_weapons'
    when "друид"
      'simple_melee_weapons'
    when "воин"
      'martial_melee_weapons'
    when "монах"
      'simple_melee_weapons'
    when "паладин"
      'martial_melee_weapons'
    when "следопыт"
      'martial_ranged_weapons'
    when "вор"
      'simple_randed_weapons'
    when "чародей"
      'simple_melee_weapons'
    when "волшебник"
      'simple_melee_weapons'
    when "колдун"
      'simple_melee_weapons'
    end
  end
end