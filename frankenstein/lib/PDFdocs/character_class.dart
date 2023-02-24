import "package:frankenstein/globals.dart";
import "dart:collection";

class AbilityScore {
  int value;
  String name;

  AbilityScore({required this.name, required this.value});
}

class Character {
  //general
  final List<String> languagesKnown;
  final List<String> featuresAndTraits;
  final List<String> classList;
  final Map<String, int> currency;
  final String name;
  final String playerName;
  final List<int> classLevels;
  final bool inspired;
  final List<String> mainToolProficiencies;
  final Queue<int>? skillsSelected;

  final List<String> savingThrowProficiencies;
  final List<String> skillProficiencies;
  final int maxHealth;

  final int characterExperience;
  final List<bool> classSkillsSelected;

  final Race race;
  final Subrace? subrace;
  //Races
  final List<int> raceAbilityScoreIncreases;
  //Background
  final Background background;
  final String backgroundPersonalityTrait;
  final String backgroundIdeal;
  final String backgroundBond;
  final String backgroundFlaw;

  //Ability scores
  final AbilityScore strength;
  final AbilityScore dexterity;
  final AbilityScore constitution;
  final AbilityScore intelligence;
  final AbilityScore wisdom;
  final AbilityScore charisma;

  //ASI feats
  final List<int> featsASIScoreIncreases;

  factory Character.fromJson(Map<String, dynamic> data) {
    final featuresAndTraits =
        data["FeaturesAndTraits"].cast<String>() as List<String>;
    final classList = data["ClassList"].cast<String>() as List<String>;
    final name = data["Name"] as String;
    final classSkillsSelected =
        data["ClassSkillsSelected"].cast<bool>() as List<bool>;
    final subrace = data["Subrace"] as Subrace;
    final skillsSelected = data["SkillsSelected"] as Queue<int>?;
    final mainToolProficiencies =
        data["MainToolProficiencies"].cast<String>() as List<String>;
    final savingThrowProficiencies =
        data["SavingThrowProficiencies"].cast<String>() as List<String>;
    final skillProficiencies =
        data["SkillProficiencies"].cast<String>() as List<String>;
    final maxHealth = data["MaxHealth"] as int;

    final playerName = data["PlayerName"] as String;
    final currency = data["Currency"] as Map<String, int>;
    final classLevels = data["ClassLevels"].cast<int>() as List<int>;
    final race = data["Race"] as Race;
    final background = data["Background"] as Background;
    final backgroundFlaw = data["BackgroundFlaw"] as String;
    final backgroundPersonalityTrait =
        data["BackgroundPersonalityTrait"] as String;
    final backgroundBond = data["BackgroundBond"] as String;
    final backgroundIdeal = data["BackgroundIdeal"] as String;
    final characterExperience = data["CharacterExperience"] as int;
    final raceAbilityScoreIncreases =
        data["RaceAbilityScoreIncreases"].cast<int>() as List<int>;

    final strength = data["Strength"] as AbilityScore;
    final dexterity = data["Dexterity"] as AbilityScore;
    final constitution = data["Constitution"] as AbilityScore;
    final intelligence = data["Intelligence"] as AbilityScore;
    final wisdom = data["Wisdom"] as AbilityScore;
    final charisma = data["Charisma"] as AbilityScore;
    final featsASIScoreIncreases =
        data["FeatsASIScoreIncreases"].cast<int>() as List<int>;
    final inspired = data["Inspired"] as bool;
    final languagesKnown =
        data["LanguagesKnown"].cast<String>() as List<String>;

    return Character(
      languagesKnown: languagesKnown,
      featuresAndTraits: featuresAndTraits,
      skillsSelected: skillsSelected,
      subrace: subrace,
      classSkillsSelected: classSkillsSelected,
      classList: classList,
      savingThrowProficiencies: savingThrowProficiencies,
      mainToolProficiencies: mainToolProficiencies,
      inspired: inspired,
      skillProficiencies: skillProficiencies,
      maxHealth: maxHealth,
      name: name,
      playerName: playerName,
      background: background,
      classLevels: classLevels,
      race: race,
      characterExperience: characterExperience,
      currency: currency,
      backgroundPersonalityTrait: backgroundPersonalityTrait,
      backgroundIdeal: backgroundIdeal,
      backgroundBond: backgroundBond,
      backgroundFlaw: backgroundFlaw,
      strength: strength,
      dexterity: dexterity,
      constitution: constitution,
      intelligence: intelligence,
      wisdom: wisdom,
      charisma: charisma,
      raceAbilityScoreIncreases: raceAbilityScoreIncreases,
      featsASIScoreIncreases: featsASIScoreIncreases,
    );
  }
  Character(
      {required this.name,
      required this.featuresAndTraits,
      required this.languagesKnown,
      required this.classList,
      required this.skillsSelected,
      required this.mainToolProficiencies,
      required this.savingThrowProficiencies,
      required this.skillProficiencies,
      required this.inspired,
      required this.maxHealth,
      required this.characterExperience,
      required this.playerName,
      required this.background,
      required this.classLevels,
      required this.race,
      required this.backgroundIdeal,
      required this.backgroundPersonalityTrait,
      required this.backgroundBond,
      required this.backgroundFlaw,
      required this.raceAbilityScoreIncreases,
      required this.strength,
      required this.dexterity,
      required this.classSkillsSelected,
      required this.constitution,
      required this.intelligence,
      required this.wisdom,
      required this.charisma,
      required this.featsASIScoreIncreases,
      required this.currency,
      this.subrace});
}
