import "package:frankenstein/globals.dart";

class AbilityScore {
  int value;
  String name;

  AbilityScore({required this.name, required this.value});
}

class Character {
  //general
  final Map<String, int> currency;
  final String name;

  final String characterName;
  final String playerName;
  final List<int> levelsPerClass;

  final int characterExperiance;

  final Race initialRace = RACELIST.first;
  //Races
  final List<int> raceAbilityScoreIncreases;
  //Background
  final Background currentBackground;
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
    final name = data["Name"] as String;
    final currency = data["Currency"] as Map<String, int>;

    final backgroundFlaw = data["BackgroundFlaw"] as String;
    final backgroundPersonalityTrait =
        data["BackgroundPersonalityTrait"] as String;
    final backgroundBond = data["BackgroundBond"] as String;
    final backgroundIdeal = data["BackgroundIdeal"] as String;

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

    return Character(
      name: name,
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
      required this.backgroundIdeal,
      required this.backgroundPersonalityTrait,
      required this.backgroundBond,
      required this.backgroundFlaw,
      required this.raceAbilityScoreIncreases,
      required this.strength,
      required this.dexterity,
      required this.constitution,
      required this.intelligence,
      required this.wisdom,
      required this.charisma,
      required this.featsASIScoreIncreases,
      required this.currency});
}
