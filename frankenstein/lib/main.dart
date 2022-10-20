///Imports
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'dart:convert';
//add this back if there are errors:
//import 'package:flutter/services.dart';
import 'dart:io';

int abilityScoreCost(int x) {
  if (x > 12) {
    return 2;
  }
  return 1;
}

var pageLinker = {
  0: const MainMenu(),
  1: CreateACharacter(),
  2: const SearchForContent(),
  3: const MyCharacters(),
  4: const RollDice(),
  5: const CustomContent()
};

class AbilityScore {
  int value;
  String name;

  AbilityScore({required this.name, required this.value});
}

class Subrace {
  final String name;
  final List<int> subRaceScoreIncrease;
  //final String sourceBook;
  final List<String>? languages;
  final List<String>? resistances;
  final List<String>? abilities;
  final List<String>? proficiencies;
  final int darkVision;
  final int walkingSpeed;
  factory Subrace.fromJson(Map<String, dynamic> data) {
    final name = data['Name'] as String;
    final subRaceScoreIncrease =
        data['AbilityScoreMap'].cast<int>() as List<int>;
    final languages = data['Languages']?.cast<String>() as List<String>?;
    final darkVision = data['Darkvision'] as int?;
    //final sourceBook = data["Sourcebook"];
    final resistances = data["Resistances"]?.cast<String>() as List<String>?;
    final abilities = data['Abilities']?.cast<String>() as List<String>?;
    final proficiencies =
        data['Proficiencies']?.cast<String>() as List<String>?;
    final walkingSpeed = data["WalkingSpeed"];
    return Subrace(
        name: name,
        subRaceScoreIncrease: subRaceScoreIncrease,
        languages: languages,
        darkVision: darkVision ?? 0,
        walkingSpeed: walkingSpeed ?? 30,
        //sourceBook: sourceBook,
        resistances: resistances,
        abilities: abilities,
        proficiencies: proficiencies);
  }
  Subrace(
      {required this.name,
      required this.subRaceScoreIncrease,
      required this.darkVision,
      required this.walkingSpeed,
      //required this.sourcebook,
      this.languages,
      this.resistances,
      this.abilities,
      this.proficiencies});
}

class Race {
  final String name;
  final List<int> raceScoreIncrease;
  //final String sourceBook;
  final List<String> languages;
  final List<Subrace>? subRaces;
  final List<String>? resistances;
  final List<String>? abilities;
  final List<String>? proficiencies;
  final int darkVision;
  final int walkingSpeed;
  factory Race.fromJson(Map<String, dynamic> data) {
    final name = data['Name'] as String;
    final raceScoreIncrease = data['AbilityScoreMap'].cast<int>() as List<int>;
    final languages = data['Languages'].cast<String>() as List<String>?;
    final darkVision = data['Darkvision'] as int?;
    //final sourceBook = data["Sourcebook"]?;
    final subRaceData = data['Subraces'] as List<dynamic>?;
    final subRaces = subRaceData
        ?.map((subRaceData) => Subrace.fromJson(subRaceData))
        .toList();
    final resistances = data["Resistances"]?.cast<String>() as List<String>?;
    final abilities = data['Abilities']?.cast<String>() as List<String>?;
    final proficiencies =
        data['Proficiencies']?.cast<String>() as List<String>?;
    final walkingSpeed = data["WalkingSpeed"];
    return Race(
        name: name,
        raceScoreIncrease: raceScoreIncrease,
        languages: languages ?? ["Common"],
        darkVision: darkVision ?? 0,
        walkingSpeed: walkingSpeed ?? 30,
        //sourceBook: sourceBook ?? "N/A",
        subRaces: subRaces,
        resistances: resistances,
        abilities: abilities,
        proficiencies: proficiencies);
  }
  Race(
      {required this.name,
      required this.raceScoreIncrease,
      required this.languages,
      required this.darkVision,
      required this.walkingSpeed,
      //required this.sourcebook,
      this.subRaces,
      this.resistances,
      this.abilities,
      this.proficiencies});
}

//CONTENT WILL BE ADDED IN ITS OWN FILE AND LINKED IN A SINGLE FILE WHICH CONTAINS ALL LINKED FILES AS WELL AS THEIR TYPE
//THEY WILL ALL THEN BE IMPORTED AND SORTED INTO JOINED LISTS THROUGH A BETTER REPEATING FUNCTION E.G. FOR EVERY SPELL: READ, ADD TO SPELL LIST THEN FOR EVERY WEAPON....
//Classes to unload JSON into
class Spell {
  //ADD SPELL TYPE THINGY
  final String name;
  final String effect;
  final int level;
  final String? verbal;
  final String? somatic;
  final String? material;
  factory Spell.fromJson(Map<String, dynamic> data) {
    // note the explicit cast to String
    // this is required if robust lint rules are enabled
    //COULD GO THROUGH EVERY DATA[SPELL[X,Y,Z*]] TO ALLOW LESS FILES TO BE ADDED WITH CONTENT
    final name = data['Name'] as String;
    final effect = data['Effect'] as String;
    final level = data['Level'] as int?;
    final verbal = data['Verbal'] as String?;
    final somatic = data['Somatic'] as String?;
    final material = data['Material'] as String?;
    return Spell(
        name: name,
        effect: effect,
        level: level ?? 0,
        verbal: verbal ?? "None",
        somatic: somatic ?? "None",
        material: material ?? "None");
  }
  Spell(
      {required this.name,
      required this.level,
      required this.effect,
      this.material,
      this.somatic,
      this.verbal});
}

class Weapon {
  final String name;
  final String? range;
  final List<String>? tags;
  final String damage;
  final Int weight;

  ///MAY REMOVE AND COMBINE WITH TAGS AND SET TO STRENGTH
  Weapon(
      {required this.name,
      this.range,
      this.tags,
      required this.damage,
      required this.weight});
}

//JSON unloading process
const JsonDecoder decoder = JsonDecoder();
const String filepath =
    "C:\\Users\\arieh\\OneDrive\\Documents\\Dartwork\\frankenstein\\lib\\SRDspells.json";

///file loaded as a string 'jsonString'
String jsonString = File(filepath).readAsStringSync();

///file decoded into 'jsonmap'
final dynamic jsonmap = decoder.convert(jsonString);

// ignore: non_constant_identifier_names
List<Race> RACELIST = [for (var x in jsonmap["Races"]) Race.fromJson(x)];
List<Spell> list = [for (var x in jsonmap["Spells"]) Spell.fromJson(x)];
Spell listgetter(String spellname) {
  //huge issue with adding content WITH DUPLICATE NAME AND (TYPE)
  for (int x = 0; x < list.length; x++) {
    if (list[x].name == spellname) {
      return list[x];
    }
  }
  //ADD SOMETHING FOR FAILED COMPARISONS
  ///fix really  really really
  return list[0];
}

void main() => runApp(const Homepage());

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  //String jsonString = File(filepath).readAsStringSync();
  //late final Map<String, dynamic> jsonmap = decoder.convert(jsonString);

  static const String _title = 'Frankenstein\'s - a D&D 5e character builder';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.image),
              tooltip: 'Put logo here',
              onPressed: () {}),
          title: const Center(child: Text(_title)),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'settings??',
                onPressed: () {}),
          ],
        ),
        //appBar: AppBar(title: const Text(_title)),

        //appBar: AppBar(title: new Center(child: const Text(_title))),
        body: const MainMenu(),
      ),
    );
  }
}

class ScreenTop extends StatelessWidget {
  final int? pagechoice;
  const ScreenTop({Key? key, this.pagechoice}) : super(key: key);
  static const String _title = 'Frankenstein\'s - a D&D 5e character builder';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: (pagechoice == 0)
                  ? const Icon(Icons.image)
                  : const Icon(Icons.home),
              tooltip: (pagechoice == 0)
                  ? "Put logo here"
                  : "Return to the main menu",
              onPressed: () {
                if (pagechoice != 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ScreenTop(pagechoice: 0)));
                }
              }),
          title: const Center(child: Text(_title)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Return to the previous page',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Settings??',
                onPressed: () {}),
          ],
        ),
        //pick relevent call
        body: pageLinker[pagechoice],
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: const Text(
                  textAlign: TextAlign.center,
                  'Main Menu',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 1)),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'Create a \ncharacter',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 100),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 2)),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'Search for\ncontent',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 100),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 3)),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'My \ncharacters',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(30, 42, 30, 42),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 4)),
                );
              },
              child: const Text(
                'Roll dice',
                style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 100),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 5)),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'Custom \ncontent',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CreateACharacter extends StatefulWidget {
  @override
  MainCreateCharacter createState() => MainCreateCharacter();
}

class MainCreateCharacter extends State<CreateACharacter> {
  AbilityScore strength = AbilityScore(name: "Strength", value: 8);
  AbilityScore dexterity = AbilityScore(name: "Dexterity", value: 8);
  AbilityScore constitution = AbilityScore(name: "Constitution", value: 8);
  AbilityScore intelligence = AbilityScore(name: "Intelligence", value: 8);
  AbilityScore wisdom = AbilityScore(name: "Wisdom", value: 8);
  AbilityScore charisma = AbilityScore(name: "Charisma", value: 8);
  int pointsRemaining = 27;
  //STR/DEX/CON/INT/WIS/CHAR
  List<int> abilityScoreIncreases = [1, 1, 1, 1, 1, 1];

  //const MainCreateCharacter({Key? key}) //: super(key: key);
  Spell spellExample = list.first;
  String? levellingMethod;
  Race raceExample = RACELIST.first;
  Subrace? subraceExample;
  //options in the initial menu initialised

  bool? featsAllowed = false;
  bool? averageHitPoints = false;
  bool? multiclassing = false;
  bool? milestoneLevelling = false;
  bool? myCustomContent = false;
  bool? optionalClassFeatures = false;

  bool? criticalRoleContent = false;
  bool? encumberanceRules = false;
  bool? includeCoinsForWeight = false;
  bool? unearthedArcanaContent = false;
  bool? firearmsUsable = false;
  bool? extraFeatAtLevel1 = false;
  String? characterLevel = "1";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              textAlign: TextAlign.center,
              'Create a character',
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("Basics")),
              Tab(child: Text("Race")),
              Tab(child: Text("Class")),
              Tab(child: Text("Backround")),
              Tab(child: Text("Ability scores")),
              Tab(child: Text("Spells")),
              Tab(child: Text("Equipment")),
              Tab(child: Text("Boons and magic items")),
              Tab(child: Text("Backstory")),
              Tab(child: Text("Finishing up")),
            ],
          ),
        ),
        body: TabBarView(children: [
          Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                      child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                        Container(
                          width: 280,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                              child: Text(
                            textAlign: TextAlign.center,
                            "Character info",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            height: 50,
                            child: TextField(
                                cursorColor: Colors.blue,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Enter character's name",
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 212, 208, 224)),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 124, 112, 112),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(12))))),
                        //ask level or exp
                        //add switch + list tittle stuff for lvl/exp
                        const SizedBox(height: 15),
                        SizedBox(
                            width: 250,
                            height: 50,
                            child: TextField(
                                cursorColor: Colors.blue,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Enter the player's name",
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 212, 208, 224)),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 124, 112, 112),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(12))))),
                        const SizedBox(height: 15),
                        SizedBox(
                            width: 250,
                            height: 50,
                            child: TextField(
                                cursorColor: Colors.blue,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Enter the character's gender",
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 212, 208, 224)),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 124, 112, 112),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(12))))),
                        const SizedBox(height: 15),
                        SizedBox(
                            width: 300,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RadioListTile(
                                    title: const Text("Use experience"),
                                    value: "Experience",
                                    groupValue: levellingMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        levellingMethod = value.toString();
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                      child: levellingMethod == "Experience"
                                          ? SizedBox(
                                              width: 250,
                                              height: 50,
                                              child: TextField(
                                                  cursorColor: Colors.blue,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Enter the character's exp",
                                                      hintStyle: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              212,
                                                              208,
                                                              224)),
                                                      filled: true,
                                                      fillColor:
                                                          const Color.fromARGB(
                                                              255, 124, 112, 112),
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12)))))
                                          : RadioListTile(
                                              title: const Text("Use levels"),
                                              value: "Levels",
                                              groupValue: levellingMethod,
                                              onChanged: (value) {
                                                setState(() {
                                                  levellingMethod =
                                                      value.toString();
                                                });
                                              },
                                            )),
                                  const SizedBox(height: 5),
                                  Container(
                                    child: levellingMethod == "Experience"
                                        ? RadioListTile(
                                            title: const Text("Use levels"),
                                            value: "Levels",
                                            groupValue: levellingMethod,
                                            onChanged: (value) {
                                              setState(() {
                                                levellingMethod =
                                                    value.toString();
                                              });
                                            },
                                          )
                                        : SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: DropdownButton<String>(
                                              value: characterLevel,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Color.fromARGB(
                                                      255, 7, 26, 239)),
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 20),
                                              underline: Container(
                                                height: 2,
                                                color: const Color.fromARGB(
                                                    255, 7, 26, 239),
                                              ),
                                              onChanged: (String? value) {
                                                // This is called when the user selects an item.
                                                setState(() {
                                                  characterLevel = value!;
                                                });
                                              },
                                              items: [
                                                "1",
                                                "2",
                                                "3",
                                                "4",
                                                "5",
                                                "6",
                                                "7",
                                                "8",
                                                "9",
                                                "10",
                                                "11",
                                                "12",
                                                "13",
                                                "14",
                                                "15",
                                                "16",
                                                "17",
                                                "18",
                                                "19",
                                                "20"
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Center(
                                                      child: Text(value)),
                                                );
                                              }).toList(),
                                            )),
                                  ),
                                  const SizedBox(height: 10),
                                ]))
                      ])),
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        width: 325,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(
                            color: const Color.fromARGB(255, 7, 26, 239),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                            child: Text(
                          textAlign: TextAlign.center,
                          "Build Parameters",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        )),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 325,
                        child: Column(
                          children: [
                            CheckboxListTile(
                              title: const Text('Feats in use'),
                              value: featsAllowed,
                              onChanged: (bool? value) {
                                setState(() {
                                  featsAllowed = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text('Use average for hit dice'),
                              value: averageHitPoints,
                              onChanged: (bool? value) {
                                setState(() {
                                  averageHitPoints = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text('Allow multiclassing'),
                              value: multiclassing,
                              onChanged: (bool? value) {
                                setState(() {
                                  multiclassing = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text('Use milestone levelling'),
                              value: milestoneLevelling,
                              onChanged: (bool? value) {
                                setState(() {
                                  milestoneLevelling = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text('Use created content'),
                              value: myCustomContent,
                              onChanged: (bool? value) {
                                setState(() {
                                  myCustomContent = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text('Use optional class features'),
                              value: optionalClassFeatures,
                              onChanged: (bool? value) {
                                setState(() {
                                  optionalClassFeatures = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        width: 325,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(
                            color: const Color.fromARGB(255, 7, 26, 239),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                            child: Text(
                          textAlign: TextAlign.center,
                          "Rarer Parameters",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        )),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 325,
                        child: Column(
                          children: [
                            CheckboxListTile(
                              title: const Text('Use critical role content'),
                              value: criticalRoleContent,
                              onChanged: (bool? value) {
                                setState(() {
                                  criticalRoleContent = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text('Use encumberance rules'),
                              value: encumberanceRules,
                              onChanged: (bool? value) {
                                setState(() {
                                  encumberanceRules = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text("Incude coins' weights"),
                              value: includeCoinsForWeight,
                              onChanged: (bool? value) {
                                setState(() {
                                  includeCoinsForWeight = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text('Use UA content'),
                              value: unearthedArcanaContent,
                              onChanged: (bool? value) {
                                setState(() {
                                  unearthedArcanaContent = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text('Allow firearms'),
                              value: firearmsUsable,
                              onChanged: (bool? value) {
                                setState(() {
                                  firearmsUsable = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 15),
                            CheckboxListTile(
                              title: const Text('Give an extra feat at lvl 1'),
                              value: extraFeatAtLevel1,
                              onChanged: (bool? value) {
                                setState(() {
                                  extraFeatAtLevel1 = value;
                                });
                              },
                              secondary: const Icon(Icons.insert_photo),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              )
            ],
          ),

          Column(children: [
            DropdownButton<String>(
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  //efficient this up at some point so ASI[i] isn't accessed twice
                  for (int i = 0; i < 6; i++) {
                    abilityScoreIncreases[i] -= (abilityScoreIncreases[i] +
                        ((subraceExample?.subRaceScoreIncrease[i]) ?? 0));
                  }

                  raceExample = RACELIST.singleWhere((x) => x.name == value);
                  subraceExample = raceExample.subRaces?.first;
                  for (int i = 0; i < 6; i++) {
                    abilityScoreIncreases[i] +=
                        raceExample.raceScoreIncrease[i] +
                            ((subraceExample?.subRaceScoreIncrease[i]) ?? 0);
                  }
                });
              },
              value: raceExample.name,
              icon: const Icon(Icons.arrow_downward),
              items: RACELIST.map<DropdownMenuItem<String>>((Race value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(value.name),
                );
              }).toList(),
              elevation: 2,
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.w700),
              underline: Container(
                height: 1,
                color: Colors.deepPurpleAccent,
              ),
            ),
            raceExample.subRaces != null
                ? DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        for (int i = 0; i < 6; i++) {
                          abilityScoreIncreases[i] -=
                              subraceExample?.subRaceScoreIncrease[i] ?? 0;
                        }
                        subraceExample = raceExample.subRaces
                            ?.singleWhere((x) => x.name == value);
                        for (int i = 0; i < 6; i++) {
                          abilityScoreIncreases[i] +=
                              subraceExample?.subRaceScoreIncrease[i] ?? 0;
                        }
                      });
                    },
                    value: subraceExample?.name,
                    icon: const Icon(Icons.arrow_downward),
                    items: raceExample.subRaces
                        ?.map<DropdownMenuItem<String>>((Subrace value) {
                      return DropdownMenuItem<String>(
                        value: value.name,
                        child: Text(value.name),
                      );
                    }).toList(),
                    elevation: 2,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w700),
                    underline: Container(
                      height: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                  )
                : Container(
                    height: 50,
                    width: 50,
                    color: Colors.blue,
                    child: const Center(child: Text("No Subraces")))
          ]),

          Column(children: [
            DropdownButton<String>(
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  spellExample = listgetter(value!);
                });
              },
              value: spellExample.name,
              icon: const Icon(Icons.arrow_downward),
              items: list.map<DropdownMenuItem<String>>((Spell value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(value.name),
                );
              }).toList(),
              elevation: 2,
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.w700),
              underline: Container(
                height: 1,
                color: Colors.deepPurpleAccent,
              ),
            ),
            DropdownButton<String>(
              value: characterLevel,
              icon: const Icon(Icons.arrow_drop_down,
                  color: Color.fromARGB(255, 7, 26, 239)),
              elevation: 16,
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
              underline: Container(
                height: 2,
                color: const Color.fromARGB(255, 7, 26, 239),
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  characterLevel = value!;
                });
              },
              items: [
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
                "10",
                "11",
                "12",
                "13",
                "14",
                "15",
                "16",
                "17",
                "18",
                "19",
                "20"
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(child: Text(value)),
                );
              }).toList(),
            )
          ]),
          const Icon(Icons.directions_bike),
          //ability scores
          Column(children: [
            const SizedBox(height: 40),
            Text(
              textAlign: TextAlign.center,
              "Points remaining: $pointsRemaining",
              style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 0, 168, 252)),
            ),
            const SizedBox(height: 60),
            Row(
              children: [
                const Expanded(flex: 12, child: SizedBox()),
                Expanded(
                    flex: 11,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          strength.name,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          height: 110,
                          width: 116,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(children: [
                            Text(
                              textAlign: TextAlign.center,
                              strength.value.toString(),
                              style: const TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (8 < strength.value && strength.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (strength.value > 8) {
                                              strength.value--;
                                              if (strength.value < 13) {
                                                pointsRemaining++;
                                              } else {
                                                pointsRemaining += 2;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white))
                                    : const SizedBox(height: 20, width: 29),
                                (strength.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: (abilityScoreCost(
                                                      strength.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 10, 126, 54)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (strength.value < 15) {
                                              if (abilityScoreCost(
                                                      strength.value) <=
                                                  pointsRemaining) {
                                                pointsRemaining -=
                                                    abilityScoreCost(
                                                        strength.value);
                                                strength.value++;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.add,
                                            color: Colors.white))
                                    : OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            strength.value--;
                                            pointsRemaining += 2;
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white)),
                              ],
                            )
                          ]),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          " (+${abilityScoreIncreases[0]})",
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 7, 26, 239)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 90,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            (strength.value + abilityScoreIncreases[0])
                                .toString(),
                            style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 11,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          dexterity.name,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          height: 110,
                          width: 116,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(children: [
                            Text(
                              textAlign: TextAlign.center,
                              dexterity.value.toString(),
                              style: const TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (8 < dexterity.value && dexterity.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (dexterity.value > 8) {
                                              dexterity.value--;
                                              if (dexterity.value < 13) {
                                                pointsRemaining++;
                                              } else {
                                                pointsRemaining += 2;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white))
                                    : const SizedBox(height: 20, width: 29),
                                (dexterity.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: (abilityScoreCost(
                                                      dexterity.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 10, 126, 54)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (dexterity.value < 15) {
                                              if (abilityScoreCost(
                                                      dexterity.value) <=
                                                  pointsRemaining) {
                                                pointsRemaining -=
                                                    abilityScoreCost(
                                                        dexterity.value);
                                                dexterity.value++;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.add,
                                            color: Colors.white))
                                    : OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            dexterity.value--;
                                            pointsRemaining += 2;
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white)),
                              ],
                            )
                          ]),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          " (+${abilityScoreIncreases[1]})",
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 7, 26, 239)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 90,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            (dexterity.value + abilityScoreIncreases[1])
                                .toString(),
                            style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          constitution.name,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          height: 110,
                          width: 116,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(children: [
                            Text(
                              textAlign: TextAlign.center,
                              constitution.value.toString(),
                              style: const TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (8 < constitution.value &&
                                        constitution.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (constitution.value > 8) {
                                              constitution.value--;
                                              if (constitution.value < 13) {
                                                pointsRemaining++;
                                              } else {
                                                pointsRemaining += 2;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white))
                                    : const SizedBox(height: 20, width: 29),
                                (constitution.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: (abilityScoreCost(
                                                      constitution.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 10, 126, 54)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (constitution.value < 15) {
                                              if (abilityScoreCost(
                                                      constitution.value) <=
                                                  pointsRemaining) {
                                                pointsRemaining -=
                                                    abilityScoreCost(
                                                        constitution.value);
                                                constitution.value++;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.add,
                                            color: Colors.white))
                                    : OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            constitution.value--;
                                            pointsRemaining += 2;
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white)),
                              ],
                            )
                          ]),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          " (+${abilityScoreIncreases[2]})",
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 7, 26, 239)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 90,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            (constitution.value + abilityScoreIncreases[2])
                                .toString(),
                            style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 13,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          intelligence.name,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          height: 110,
                          width: 116,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(children: [
                            Text(
                              textAlign: TextAlign.center,
                              intelligence.value.toString(),
                              style: const TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (8 < intelligence.value &&
                                        intelligence.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (intelligence.value > 8) {
                                              intelligence.value--;
                                              if (intelligence.value < 13) {
                                                pointsRemaining++;
                                              } else {
                                                pointsRemaining += 2;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white))
                                    : const SizedBox(height: 20, width: 29),
                                (intelligence.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: (abilityScoreCost(
                                                      intelligence.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 10, 126, 54)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (intelligence.value < 15) {
                                              if (abilityScoreCost(
                                                      intelligence.value) <=
                                                  pointsRemaining) {
                                                pointsRemaining -=
                                                    abilityScoreCost(
                                                        intelligence.value);
                                                intelligence.value++;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.add,
                                            color: Colors.white))
                                    : OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            intelligence.value--;
                                            pointsRemaining += 2;
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white)),
                              ],
                            )
                          ]),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          " (+${abilityScoreIncreases[3]})",
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 7, 26, 239)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 90,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            (intelligence.value + abilityScoreIncreases[3])
                                .toString(),
                            style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          wisdom.name,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          height: 110,
                          width: 116,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(children: [
                            Text(
                              textAlign: TextAlign.center,
                              wisdom.value.toString(),
                              style: const TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (8 < wisdom.value && wisdom.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (wisdom.value > 8) {
                                              wisdom.value--;
                                              if (wisdom.value < 13) {
                                                pointsRemaining++;
                                              } else {
                                                pointsRemaining += 2;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white))
                                    : const SizedBox(height: 20, width: 29),
                                (wisdom.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              (abilityScoreCost(wisdom.value) >
                                                      pointsRemaining)
                                                  ? const Color.fromARGB(
                                                      247, 56, 53, 52)
                                                  : const Color.fromARGB(
                                                      150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 10, 126, 54)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (wisdom.value < 15) {
                                              if (abilityScoreCost(
                                                      wisdom.value) <=
                                                  pointsRemaining) {
                                                pointsRemaining -=
                                                    abilityScoreCost(
                                                        wisdom.value);
                                                wisdom.value++;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.add,
                                            color: Colors.white))
                                    : OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            wisdom.value--;
                                            pointsRemaining += 2;
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white)),
                              ],
                            )
                          ]),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          " (+${abilityScoreIncreases[4]})",
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 7, 26, 239)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 90,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            (wisdom.value + abilityScoreIncreases[4])
                                .toString(),
                            style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 11,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          charisma.name,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          height: 110,
                          width: 116,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(children: [
                            Text(
                              textAlign: TextAlign.center,
                              charisma.value.toString(),
                              style: const TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (8 < charisma.value && charisma.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (charisma.value > 8) {
                                              charisma.value--;
                                              if (charisma.value < 13) {
                                                pointsRemaining++;
                                              } else {
                                                pointsRemaining += 2;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white))
                                    : const SizedBox(height: 20, width: 29),
                                (charisma.value < 15)
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: (abilityScoreCost(
                                                      charisma.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 10, 126, 54)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (charisma.value < 15) {
                                              if (abilityScoreCost(
                                                      charisma.value) <=
                                                  pointsRemaining) {
                                                pointsRemaining -=
                                                    abilityScoreCost(
                                                        charisma.value);
                                                charisma.value++;
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.add,
                                            color: Colors.white))
                                    : OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150, 61, 33, 243),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 172, 46, 46)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            charisma.value--;
                                            pointsRemaining += 2;
                                          });
                                        },
                                        child: const Icon(Icons.remove,
                                            color: Colors.white)),
                              ],
                            )
                          ]),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          " (+${abilityScoreIncreases[5]})",
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 7, 26, 239)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 90,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            (charisma.value + abilityScoreIncreases[5])
                                .toString(),
                            style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                const Expanded(flex: 13, child: SizedBox()),
              ],
            )
          ]),

          const Icon(Icons.directions_bike),
          const Icon(Icons.directions_car),
          const Icon(Icons.directions_transit),
          const Icon(Icons.directions_bike),
          const Icon(Icons.directions_car),
        ]),
      ),
    ));
  }
}

class SearchForContent extends StatelessWidget {
  const SearchForContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: const Text(
                  textAlign: TextAlign.center,
                  'Search for content',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyCharacters extends StatelessWidget {
  const MyCharacters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: const Text(
                  textAlign: TextAlign.center,
                  'My Characters',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RollDice extends StatelessWidget {
  const RollDice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: const Text(
                  textAlign: TextAlign.center,
                  'Roll dice',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomContent extends StatelessWidget {
  const CustomContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: const Text(
                  textAlign: TextAlign.center,
                  'Custom content',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
