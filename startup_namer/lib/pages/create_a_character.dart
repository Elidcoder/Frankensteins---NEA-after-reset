import 'package:flutter/material.dart';
import 'package:frankenstein/characterCreationGlobals.dart';
import "package:frankenstein/globals.dart";
import "dart:collection";
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

int abilityScoreCost(int x) {
  if (x > 12) {
    return 2;
  }
  return 1;
}

class AbilityScore {
  int value;
  String name;

  AbilityScore({required this.name, required this.value});
}

//would love to pass in a character class here
//Many parts remain unfinished but should be completed as their relevent tabs are
//value, ACLIST, SPEEDMAP, INT, WIS, STR, DEX,CAR,CON,CURRENCY
Widget? leveGainParser(
    List<dynamic> x,
    List<List<dynamic>> ACLIST,
    Map<String, List<String>> SPEEDMAP,
    AbilityScore INT,
    AbilityScore WIS,
    AbilityScore STR,
    AbilityScore DEX,
    AbilityScore CAR,
    AbilityScore CON,
    Map<String, int> CURRENCY,
    Class SELECTEDCLASS,
    List<String> FEATURESANDTRAITS) {
  //Levelup(class?)
  debugPrint("${x[0]}");
  if (x[0] == "Level") {
    // ("Level", "numb")
    return Text(
      "${SELECTEDCLASS.name} Level ${x[1]} choice(s):",
      style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: Color.fromARGB(255, 0, 168, 252)),
    );
  } else if (x[0] == "Nothing") {
    // ("Nothing", "numb")
    return Text(
      "No choices needed for ${SELECTEDCLASS.name} level ${x[1]}",
      style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: Color.fromARGB(255, 0, 168, 252)),
    );
  } else if (x[0] == "Bonus") {
    // ("Bonus","String description")
    FEATURESANDTRAITS.add(x[1]);
  } else if (x[0] == "AC") {
    // ("AC","intelligence + 2", "RQUIREMENT")
    ACLIST.add([x[1], x[2]]);
  } /* else if (x[0] == "ACModifier") {
    //("ACModifier", "2/intelligence", "armour"(requirement))
    SPEEDLIST.append([x[1], x[2]]);
  }*/
  else if (x[0] == "Speed") {
    //note base speed is given by race
    //("speed", (w/s/c/f/h), numb/expression")
    SPEEDMAP[x[1]]?.add(x[2]);
  } else if (x[0] == "AttributeBoost") {
    if (x[1] == "Intelligence") {
      INT.value += int.parse(x[2]);
    } else if (x[1] == "Strength") {
      STR.value += int.parse(x[2]);
    } else if (x[1] == "Constitution") {
      CON.value += int.parse(x[2]);
    } else if (x[1] == "Dexterity") {
      DEX.value += int.parse(x[2]);
    } else if (x[1] == "Wisdom") {
      WIS.value += int.parse(x[2]);
    } else if (x[1] == "charisma") {
      CAR.value += int.parse(x[2]);
    }
    //do this later
  } /*else if (x[0] == "Equipment") {
    //note base speed is given by race
    //("speed", "10", "(w/s/c/f)")
    SPEEDLIST.append([x[1], x[2]]);
  }*/
  else if (x[0] == "Money") {
    //("Money", "Copper Pieces", "10")
    CURRENCY[x[1]] = CURRENCY[x[1]]! + int.parse(x[2]);
  } //deal with these later
  /*else if (x[0] == "Spell") {
    ///
  } else if (x[0] == "ASI") {
    ("ASI")
      ASINUMB ++;
  } else if (x[0] == "Feat") {
    ("Feat","Any/ featname")
    if (x[1]== "Any"){
      FEATNUMB ++;
    }
    else{
      FEATLIST.add(correct feat)
    }
      
  }*/
  /*else if (x[0] == "Choice") {
    List<Widget> temporaryWidgetList = [];
    //("choice", [option].....)
    /*for (List<dynamic> string in x.sublist(2)) {
      temporaryWidgetList.add(OutlinedButton(
        child: Text(string[1]),
        onPressed: () {
          // When the button is pressed, add the string to the outputStrings list
          setState(() => outputStrings.add(string));
        },
      ));
    }*/
    return Row(children: temporaryWidgetList);
  }*/
}

//Map<String, String> characterTypeReturner = {0.0:"Martial",1.0:"Full Caster", 0.5: "Half Caster", 0.3:"Third caster"};
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
} //}

class CreateACharacter extends StatefulWidget {
  @override
  MainCreateCharacter createState() => MainCreateCharacter();
}

class ChoiceRow extends StatefulWidget {
  // Declare the input list of strings or lists of strings
  final List<dynamic>? x;

  // Declare a map to hold the selections
  final Map<String, List<dynamic>>? selections;

  ChoiceRow({this.x, this.selections});

  @override
  _ChoiceRowState createState() =>
      _ChoiceRowState(x: x, selections: selections);
}

class _ChoiceRowState extends State<ChoiceRow> {
  // Declare the input list of strings or lists of strings
  final List<dynamic>? x;

  // Declare a map to hold the selections
  Map<String, List<dynamic>>? selections;

  _ChoiceRowState({this.x, this.selections});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(x![0]), Text("Working"),
            // Call the buildRows method to create a row of buttons for each element in the x list
            ...buildRows(context, x?.sublist(1)),
            // Display the selections
            Text(selections.toString()),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRows(
      BuildContext context, List<dynamic>? inputStringLists) {
    return [
      for (var input in inputStringLists!)
        //check it isn't a choice
        if (!["Choice"].contains(x![0]))
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor:
                    selections![input.join()]?.contains(input) == true
                        ? Colors.blue
                        : null, //<-- SEE HERE
              ),
              onPressed: () {
                // When the button is pressed, update the selections map
                setState(() {
                  if (selections![input.join()]?.contains(input) == true) {
                    selections![input.join()]!.remove(input);
                    if (selections![input.join()]!.isEmpty) {
                      selections!.remove(input.join());
                    }
                  } else {
                    if (selections![input.join()] == null) {
                      selections![input.join()] = [input];
                    } else {
                      selections![input.join()]!.add(input);
                    }
                  }
                });
              },
              child: Text(input[1]))
        else
          Expanded(
            child: Row(
              children: [
                // Recursively call the buildRows method to create buttons for the inner list
                ...buildRows(context, input),
              ],
            ),
          )
    ];
  }
}

//null op here to locate if called by editor (to edit char so will contain info) or otherwise
class MainCreateCharacter extends State<CreateACharacter>
    with AutomaticKeepAliveClientMixin {
  //random stsuff
  @override
  bool get wantKeepAlive => true;
  Widget bufferWidget = const Text("BUFFERWIDGET");
  List<String> featuresAndTraits = [];
  Map<String, List<String>> speedBonusMap = {
    "Hover": [],
    "Flying": [],
    "Walking": [],
    "Swimming": [],
    "Climbing": []
  };
  Map<String, int> currencyStored = {
    "Copper Pieces": 0,
    "Silver Pieces": 0,
    "Electrum Pieces": 0,
    "Gold Pieces": 0,
    "Platinum Pieces": 0
  };
  //list of string + a condition
  // ignore: non_constant_identifier_names
  List<List<dynamic>> ACList = [
    ["10 + dexterity"]
  ];
  Spell spellExample = list.first;
  String? levellingMethod;
  //Basics variables initialised
  String? characterLevel = "1";
  String characterName = "";
  String playerName = "";
  String characterGender = "";
  int characterExperiance = 0;
  bool? featsAllowed = true;
  bool? averageHitPoints = false;
  bool? multiclassing = true;
  bool? milestoneLevelling = false;
  bool? myCustomContent = false;
  bool? optionalClassFeatures = false;
  bool? criticalRoleContent = false;
  bool? encumberanceRules = false;
  bool? includeCoinsForWeight = false;
  bool? unearthedArcanaContent = false;
  bool? firearmsUsable = false;
  bool? extraFeatAtLevel1 = false;
  Subrace? subraceExample;
  //Race variables initialised
  Race initialRace = RACELIST.first;
  List<int> abilityScoreIncreases = RACELIST.first.raceScoreIncrease;
  static List<List<bool>>? optionalOnesStates = [
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false]
  ];
  static List<List<bool>>? optionalTwosStates = [
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false],
    [false, false, false, false, false, false]
  ];
  List<Widget> mystery1slist = [];
  List<Widget> mystery2slist = [];

  //Class variables initialised
  List<Widget> widgetsInPlay = []; //added to each time a class is selected
  List<int> levelsPerClass = List.filled(CLASSLIST.length, 0);
  Map<String, List<dynamic>> selections = {};
  List<String> words = ["eli", "this", "works"];

  //Background variables initialised
  Background currentBackground = BACKGROUNDLIST.first;
  String backgroundPersonalityTrait =
      BACKGROUNDLIST.first.personalityTrait.first;
  String backgroundIdeal = BACKGROUNDLIST.first.ideal.first;
  String backgroundBond = BACKGROUNDLIST.first.bond.first;
  String backgroundFlaw = BACKGROUNDLIST.first.flaw.first;
  //creates an array where it auto selects the first (n) possible skills initially
  List<bool> backgroundSkillChoices =
      List.filled(BACKGROUNDLIST.first.numberOfSkillChoices ?? 0, true) +
          List.filled(
              (BACKGROUNDLIST.first.optionalSkillProficiencies?.length ?? 0) -
                  (BACKGROUNDLIST.first.numberOfSkillChoices ?? 0),
              false);

  Queue<int>? selectedSkillsQ = Queue<int>.from(
      Iterable.generate(BACKGROUNDLIST.first.numberOfSkillChoices ?? 0));

  //Ability score variables initialised
  AbilityScore strength = AbilityScore(name: "Strength", value: 8);
  AbilityScore dexterity = AbilityScore(name: "Dexterity", value: 8);
  AbilityScore constitution = AbilityScore(name: "Constitution", value: 8);
  AbilityScore intelligence = AbilityScore(name: "Intelligence", value: 8);
  AbilityScore wisdom = AbilityScore(name: "Wisdom", value: 8);
  AbilityScore charisma = AbilityScore(name: "Charisma", value: 8);
  int pointsRemaining = 27;
  //STR/DEX/CON/INT/WIS/CHAR
  //BackgroundVariables
  String characterAge = "";
  String characterHeight = "";
  String characterWeight = "";
  String characterEyes = "";
  String characterSkin = "";
  String characterHair = "";

  @override
  Widget build(
    BuildContext context,
  ) {
    super.build(context);
    final mystery1slist = [
      const SizedBox(
          height: 30,
          child: Text("Choose which score(s) to increase by 1",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w800))),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalOnesStates![0][index]) {
              abilityScoreIncreases[index] -= 1;
            } else {
              abilityScoreIncreases[index] += 1;
              for (int buttonIndex = 0;
                  buttonIndex < optionalOnesStates![0].length;
                  buttonIndex++) {
                if (optionalOnesStates![0][buttonIndex]) {
                  optionalOnesStates![0][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 1;
                }
              }
            }
            optionalOnesStates![0][index] = !optionalOnesStates![0][index];
          });
        },
        isSelected: optionalOnesStates![0],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalOnesStates![1][index]) {
              abilityScoreIncreases[index] -= 1;
            } else {
              abilityScoreIncreases[index] += 1;
              for (int buttonIndex = 0;
                  buttonIndex < optionalOnesStates![1].length;
                  buttonIndex++) {
                if (optionalOnesStates![1][buttonIndex]) {
                  optionalOnesStates![1][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 1;
                }
              }
            }
            optionalOnesStates![1][index] = !optionalOnesStates![1][index];
          });
        },
        isSelected: optionalOnesStates![1],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalOnesStates![2][index]) {
              abilityScoreIncreases[index] -= 1;
            } else {
              abilityScoreIncreases[index] += 1;
              for (int buttonIndex = 0;
                  buttonIndex < optionalOnesStates![2].length;
                  buttonIndex++) {
                if (optionalOnesStates![2][buttonIndex]) {
                  optionalOnesStates![2][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 1;
                }
              }
            }
            optionalOnesStates![2][index] = !optionalOnesStates![2][index];
          });
        },
        isSelected: optionalOnesStates![2],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalOnesStates![3][index]) {
              abilityScoreIncreases[index] -= 1;
            } else {
              abilityScoreIncreases[index] += 1;
              for (int buttonIndex = 0;
                  buttonIndex < optionalOnesStates![3].length;
                  buttonIndex++) {
                if (optionalOnesStates![3][buttonIndex]) {
                  optionalOnesStates![3][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 1;
                }
              }
            }
            optionalOnesStates![3][index] = !optionalOnesStates![3][index];
          });
        },
        isSelected: optionalOnesStates![3],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalOnesStates![4][index]) {
              abilityScoreIncreases[index] -= 1;
            } else {
              abilityScoreIncreases[index] += 1;
              for (int buttonIndex = 0;
                  buttonIndex < optionalOnesStates![4].length;
                  buttonIndex++) {
                if (optionalOnesStates![4][buttonIndex]) {
                  optionalOnesStates![4][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 1;
                }
              }
            }
            optionalOnesStates![4][index] = !optionalOnesStates![4][index];
          });
        },
        isSelected: optionalOnesStates![4],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
    ];
    final mystery2slist = [
      const SizedBox(
          height: 30,
          child: Text("Choose which score(s) to increase by 2",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w800))),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalTwosStates![0][index]) {
              abilityScoreIncreases[index] -= 2;
            } else {
              abilityScoreIncreases[index] += 2;
              for (int buttonIndex = 0;
                  buttonIndex < optionalTwosStates![0].length;
                  buttonIndex++) {
                if (optionalTwosStates![0][buttonIndex]) {
                  optionalTwosStates![0][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 2;
                }
              }
            }
            optionalTwosStates![0][index] = !optionalTwosStates![0][index];
          });
        },
        isSelected: optionalTwosStates![0],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalTwosStates![1][index]) {
              abilityScoreIncreases[index] -= 2;
            } else {
              abilityScoreIncreases[index] += 2;
              for (int buttonIndex = 0;
                  buttonIndex < optionalTwosStates![1].length;
                  buttonIndex++) {
                if (optionalTwosStates![1][buttonIndex]) {
                  optionalTwosStates![1][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 2;
                }
              }
            }
            optionalTwosStates![1][index] = !optionalTwosStates![1][index];
          });
        },
        isSelected: optionalTwosStates![1],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalTwosStates![2][index]) {
              abilityScoreIncreases[index] -= 2;
            } else {
              abilityScoreIncreases[index] += 2;
              for (int buttonIndex = 0;
                  buttonIndex < optionalTwosStates![2].length;
                  buttonIndex++) {
                if (optionalTwosStates![2][buttonIndex]) {
                  optionalTwosStates![2][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 2;
                }
              }
            }
            optionalTwosStates![2][index] = !optionalTwosStates![2][index];
          });
        },
        isSelected: optionalTwosStates![2],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalTwosStates![3][index]) {
              abilityScoreIncreases[index] -= 2;
            } else {
              abilityScoreIncreases[index] += 2;
              for (int buttonIndex = 0;
                  buttonIndex < optionalTwosStates![3].length;
                  buttonIndex++) {
                if (optionalTwosStates![3][buttonIndex]) {
                  optionalTwosStates![3][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 2;
                }
              }
            }
            optionalTwosStates![3][index] = !optionalTwosStates![3][index];
          });
        },
        isSelected: optionalTwosStates![3],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      ),
      const SizedBox(height: 5),
      ToggleButtons(
        selectedColor: const Color.fromARGB(255, 0, 79, 206),
        color: Colors.blue,
        fillColor: const Color.fromARGB(162, 0, 255, 8),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        borderColor: const Color.fromARGB(255, 7, 26, 239),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderWidth: 1.5,
        onPressed: (int index) {
          setState(() {
            if (optionalTwosStates![4][index]) {
              abilityScoreIncreases[index] -= 2;
            } else {
              abilityScoreIncreases[index] += 2;
              for (int buttonIndex = 0;
                  buttonIndex < optionalTwosStates![4].length;
                  buttonIndex++) {
                if (optionalTwosStates![4][buttonIndex]) {
                  optionalTwosStates![4][buttonIndex] = false;
                  abilityScoreIncreases[buttonIndex] -= 2;
                }
              }
            }
            optionalTwosStates![4][index] = !optionalTwosStates![4][index];
          });
        },
        isSelected: optionalTwosStates![4],
        children: const <Widget>[
          Text(" Strength "),
          Text(" Dexterity "),
          Text(" Constitution "),
          Text(" Intelligence "),
          Text(" Wisdom "),
          Text(" Charisma ")
        ],
      )
    ];

    return DefaultTabController(
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
          //basics
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Row(
                    children: [
                      //decide on the color of T.boxes
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                  decoration: const InputDecoration(
                                      hintText: "Enter character's name",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(
                                              255, 212, 208, 224)),
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(211, 42, 63, 226),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)))),
                                  onChanged: (characterNameEnteredValue) {
                                    characterName = characterNameEnteredValue;
                                  }),
                            ),
                            //ask level or exp
                            //add switch + list tittle stuff for lvl/exp
                            const SizedBox(height: 15),
                            const SizedBox(
                                width: 250,
                                height: 50,
                                child: TextField(
                                    cursorColor: Colors.blue,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        hintText: "Enter the player's name",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 212, 208, 224)),
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(255, 124, 112, 112),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)))))),
                            const SizedBox(height: 15),
                            const SizedBox(
                                width: 250,
                                height: 50,
                                child: TextField(
                                    cursorColor: Colors.blue,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        hintText:
                                            "Enter the character's gender",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 212, 208, 224)),
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(255, 124, 112, 112),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)))))),
                            const SizedBox(height: 15),
                            SizedBox(
                                width: 300,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                              color:
                                                                  Color.fromARGB(
                                                                      255,
                                                                      212,
                                                                      208,
                                                                      224)),
                                                          filled: true,
                                                          fillColor:
                                                              const Color.fromARGB(
                                                                  255,
                                                                  124,
                                                                  112,
                                                                  112),
                                                          border: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                              borderRadius:
                                                                  BorderRadius.circular(12)))))
                                              : RadioListTile(
                                                  title:
                                                      const Text("Use levels"),
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
                                                      fontWeight:
                                                          FontWeight.w800,
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
                                                  ]
                                                      .where((element) =>
                                                          int.parse(element) >=
                                                          int.parse(
                                                              characterLevel ??
                                                                  "1"))
                                                      .toList()
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
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
                                  title:
                                      const Text('Use optional class features'),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
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
                                  title:
                                      const Text('Use critical role content'),
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
                                  title:
                                      const Text('Give an extra feat at lvl 1'),
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
              )),
          //race
          Column(
            children: [
              const SizedBox(height: 20),
              DropdownButton<String>(
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    //efficient this up at some point so ASI[i] isn't accessed twice
                    //can actually speed this up but only if asi isn't used elsewhere
                    abilityScoreIncreases = [0, 0, 0, 0, 0, 0];

                    /*
                    for (int i = 0; i < 6; i++) {
                      abilityScoreIncreases[i] -=
                          (initialRace.raceScoreIncrease[i] +
                              ((subraceExample?.subRaceScoreIncrease[i]) ?? 0));
                    }
*/
                    initialRace = RACELIST.singleWhere((x) => x.name == value);
                    subraceExample = initialRace.subRaces?.first;
                    for (int i = 0; i < 6; i++) {
                      abilityScoreIncreases[i] +=
                          initialRace.raceScoreIncrease[i] +
                              ((subraceExample?.subRaceScoreIncrease[i]) ?? 0);

                      optionalOnesStates = [
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false]
                      ];
                      optionalTwosStates = [
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false],
                        [false, false, false, false, false, false]
                      ];
                    }
                  });
                },
                value: initialRace.name,
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
              initialRace.subRaces != null
                  ? DropdownButton<String>(
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          //may cauase issues later
                          abilityScoreIncreases = [0, 0, 0, 0, 0, 0];
                          /*for (int i = 0; i < 6; i++) {
                            abilityScoreIncreases[i] -=
                                subraceExample?.subRaceScoreIncrease[i] ?? 0;
                          }*/
                          subraceExample = initialRace.subRaces
                              ?.singleWhere((x) => x.name == value);
                          for (int i = 0; i < 6; i++) {
                            abilityScoreIncreases[i] +=
                                (subraceExample?.subRaceScoreIncrease[i] ?? 0) +
                                    initialRace.raceScoreIncrease[i];
                          }
                          optionalOnesStates = [
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false]
                          ];
                          optionalTwosStates = [
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false],
                            [false, false, false, false, false, false]
                          ];
                        });
                      },
                      value: subraceExample?.name,
                      icon: const Icon(Icons.arrow_downward),
                      items: initialRace.subRaces
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
                  : const SizedBox(),
              //codebook
              if (initialRace.mystery1S + (subraceExample?.mystery1S ?? 0) != 0)
                Expanded(
                  child: Column(
                    children: mystery1slist.sublist(
                        0,
                        2 *
                                (initialRace.mystery1S +
                                    (subraceExample?.mystery1S ?? 0)) +
                            1),
                  ),
                ),
              initialRace.mystery2S + (subraceExample?.mystery2S ?? 0) == 0
                  ? const SizedBox(height: 2)
                  : Expanded(
                      child: Column(
                        children: mystery2slist.sublist(
                            0,
                            2 *
                                    (initialRace.mystery2S +
                                        (subraceExample?.mystery2S ?? 0)) +
                                1),
                      ),
                    ),

              /*
              Expanded(
                child: Column(
                  children: [Text("List: $optionalOnesStates")],
                ),
              ),*/
            ],
          ),
          //class
          DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text(
                      '${int.parse(characterLevel ?? "1") - levelsPerClass.reduce((value, element) => value + element)} class levels available but unselected',
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(child: Text("Choose your classes")),
                    Tab(
                        child: Text(
                            "Make your selections for each level in your class")),
                  ],
                ),
              ),
              body: TabBarView(children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.center,
                    children:
                        // This is the list of buttons
                        List.generate(CLASSLIST.length, (index) {
                      return Container(
                          width: (["Martial", "Third Caster"]
                                  .contains(CLASSLIST[index].classType))
                              ? 210
                              : 225,
                          height: 168,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            children: [
                              Text(CLASSLIST[index].name,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              Text("Class type: ${CLASSLIST[index].classType}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              (["Martial", "Third Caster"]
                                      .contains(CLASSLIST[index].classType))
                                  ? Text(
                                      "Main ability: ${CLASSLIST[index].mainOrSpellcastingAbility}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))
                                  : Text(
                                      "Spellcasting ability: ${CLASSLIST[index].mainOrSpellcastingAbility}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                              Text(
                                  "Hit die: D${CLASSLIST[index].maxHitDiceRoll}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              Text(
                                  "Saves: ${CLASSLIST[index].savingThrowProficiencies.join(",")}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              const SizedBox(height: 7),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: (int.parse(
                                                characterLevel ?? "1") <=
                                            levelsPerClass.reduce(
                                                (value, element) =>
                                                    value + element))
                                        ? const Color.fromARGB(247, 56, 53, 52)
                                        : const Color.fromARGB(
                                            150, 61, 33, 243),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    side: const BorderSide(
                                        width: 3,
                                        color:
                                            Color.fromARGB(255, 10, 126, 54)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (int.parse(characterLevel ?? "1") >
                                          levelsPerClass.reduce(
                                              (value, element) =>
                                                  value + element)) {
                                        /*widgetsInPlay.addAll([
                                          for (var x in CLASSLIST[index]
                                                  .gainAtEachLevel[
                                              levelsPerClass[index]])
                                            leveGainParser(
                                                x,
                                                ACList,
                                                speedBonusMap,
                                                intelligence,
                                                wisdom,
                                                strength,
                                                dexterity,
                                                charisma,
                                                constitution,
                                                currencyStored,
                                                CLASSLIST[index])
                                        ].whereType<Widget>().toList());*/

                                        for (List<dynamic> x
                                            in CLASSLIST[index].gainAtEachLevel[
                                                levelsPerClass[index]]) {
                                          if (x[0] == "Choice") {
                                            widgetsInPlay.add(Expanded(
                                                child: ChoiceRow(
                                                    x: x.sublist(1),
                                                    selections: selections)));
                                          }
                                          if (leveGainParser(
                                                  x,
                                                  ACList,
                                                  speedBonusMap,
                                                  intelligence,
                                                  wisdom,
                                                  strength,
                                                  dexterity,
                                                  charisma,
                                                  constitution,
                                                  currencyStored,
                                                  CLASSLIST[index],
                                                  featuresAndTraits) !=
                                              null) {
                                            widgetsInPlay.add(leveGainParser(
                                                x,
                                                ACList,
                                                speedBonusMap,
                                                intelligence,
                                                wisdom,
                                                strength,
                                                dexterity,
                                                charisma,
                                                constitution,
                                                currencyStored,
                                                CLASSLIST[index],
                                                featuresAndTraits)!);
                                          }
                                        }
                                        levelsPerClass[index]++;
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.add,
                                      color: Colors.white, size: 35))
                            ],
                          ));
                    }),
                    /*Expanded(
                      child: ListView.builder(
                        itemCount: CLASSLIST.length,
                        itemBuilder: (context, index) {
                          return Container(
                              width: 210,
                              height: 168,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 26, 239),
                                  width: 2,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                children: [
                                  Text(CLASSLIST[index].name,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                                  Text(
                                      "Class type: ${CLASSLIST[index].classType}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  (["Martial", "Third Caster"]
                                          .contains(CLASSLIST[index].classType))
                                      ? Text(
                                          "Main ability: ${CLASSLIST[index].mainOrSpellcastingAbility}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white))
                                      : Text(
                                          "Spellcasting ability: ${CLASSLIST[index].mainOrSpellcastingAbility}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                  Text(
                                      "Hit die: D${CLASSLIST[index].maxHitDiceRoll}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  Text(
                                      "Saves: ${CLASSLIST[index].savingThrowProficiencies.join(",")}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  const SizedBox(height: 7),
                                  OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            (int.parse(characterLevel ?? "1") ==
                                                    levelsPerClass.reduce(
                                                        (value, element) =>
                                                            value + element))
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
                                          if (int.parse(characterLevel ?? "1") >
                                              levelsPerClass.reduce(
                                                  (value, element) =>
                                                      value + element)) {
                                            levelsPerClass[index]++;
                                          }
                                        });
                                      },
                                      child: const Icon(Icons.add,
                                          color: Colors.white, size: 35))
                                ],
                              ));
                        },
                      ),
                    )*/
                  ),
                ),
                Column(children: widgetsInPlay)
              ]),
            ),
          ),
          //Background
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        currentBackground =
                            BACKGROUNDLIST.singleWhere((x) => x.name == value);
                        backgroundPersonalityTrait =
                            currentBackground.personalityTrait.first;
                        backgroundIdeal = currentBackground.ideal.first;
                        backgroundBond = currentBackground.bond.first;
                        backgroundFlaw = currentBackground.flaw.first;
                        backgroundSkillChoices = List.filled(
                                currentBackground.numberOfSkillChoices ?? 0,
                                true) +
                            List.filled(
                                (currentBackground.optionalSkillProficiencies
                                            ?.length ??
                                        0) -
                                    (currentBackground.numberOfSkillChoices ??
                                        0),
                                false);
                        selectedSkillsQ = Queue<int>.from(Iterable.generate(
                            currentBackground.numberOfSkillChoices ?? 0));
                        //
                      });
                    },
                    value: currentBackground.name,
                    icon: const Icon(Icons.arrow_downward),
                    items: BACKGROUNDLIST
                        .map<DropdownMenuItem<String>>((Background value) {
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
                  //Personality Trait
                  const SizedBox(height: 10),
                  const Text("Select your character's personality trait",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        backgroundPersonalityTrait = currentBackground
                            .personalityTrait
                            .singleWhere((x) => x == value);
                      });
                    },
                    value: backgroundPersonalityTrait,
                    icon: const Icon(Icons.arrow_downward),
                    items: currentBackground.personalityTrait
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
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

                  //Ideal
                  const SizedBox(height: 10),
                  const Text("Select your character's ideal",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        backgroundIdeal = currentBackground.ideal
                            .singleWhere((x) => x == value);
                      });
                    },
                    value: backgroundIdeal,
                    icon: const Icon(Icons.arrow_downward),
                    items: currentBackground.ideal
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
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
                  //Bond
                  const SizedBox(height: 10),
                  const Text("Select your character's bond",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        backgroundBond = currentBackground.bond
                            .singleWhere((x) => x == value);
                      });
                    },
                    value: backgroundBond,
                    icon: const Icon(Icons.arrow_downward),
                    items: currentBackground.bond
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
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
                  //Flaw
                  const SizedBox(height: 10),
                  const Text("Select your character's flaw",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        backgroundFlaw = currentBackground.flaw
                            .singleWhere((x) => x == value);
                      });
                    },
                    value: backgroundFlaw,
                    icon: const Icon(Icons.arrow_downward),
                    items: currentBackground.flaw
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
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
                  //really poor programming in general with the over use of ! - try fix although it isn't an issue this way
                  if (currentBackground.numberOfSkillChoices != null)
                    Text(
                        "Pick ${(currentBackground.numberOfSkillChoices)} skill(s) to gain proficiency in",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 7,
                  ),
                  /*if (currentBackground.numberOfSkillChoices != null)
                ToggleButtons(
                    selectedColor: const Color.fromARGB(255, 0, 79, 206),
                    color: Colors.blue,
                    fillColor: const Color.fromARGB(162, 0, 255, 8),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    borderColor: const Color.fromARGB(255, 7, 26, 239),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderWidth: 1.5,
                    onPressed: (int index) {
                      setState(() {
                        //bsckgroundskillchoices
                        if (selectedSkillsQ!.contains(index)) {
                          selectedSkillsQ!.remove(index);
                          backgroundSkillChoices[index] = false;
                        } else {
                          if (selectedSkillsQ!.length ==
                              currentBackground.numberOfSkillChoices) {
                            int removed = selectedSkillsQ!.removeFirst();
                            backgroundSkillChoices[removed] = false;
                          }
                          selectedSkillsQ!.add(index);
                          backgroundSkillChoices[index] = true;
                        }
                      });
                    },
                    isSelected: backgroundSkillChoices,
                    children: currentBackground.optionalSkillProficiencies!
                        .map((x) => Text(" $x "))
                        .toList()),*/
                  if (currentBackground.numberOfSkillChoices != null)
                    ToggleButtons(
                        selectedColor: const Color.fromARGB(255, 0, 79, 206),
                        color: Colors.blue,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                        //color: Color.fromARGB(255, 15, 124, 174)
                        fillColor: const Color.fromARGB(162, 0, 255, 8),
                        borderColor: const Color.fromARGB(255, 7, 26, 239),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderWidth: 1.5,
                        onPressed: (int index) {
                          setState(() {
                            //bsckgroundskillchoices
                            if (selectedSkillsQ!.contains(index)) {
                              selectedSkillsQ!.remove(index);
                              backgroundSkillChoices[index] = false;
                            } else {
                              if (selectedSkillsQ!.length ==
                                  currentBackground.numberOfSkillChoices) {
                                int removed = selectedSkillsQ!.removeFirst();
                                backgroundSkillChoices[removed] = false;
                              }
                              selectedSkillsQ!.add(index);
                              backgroundSkillChoices[index] = true;
                            }
                          });
                        },
                        isSelected: backgroundSkillChoices,
                        children: currentBackground.optionalSkillProficiencies!
                            .map((x) => Text(" $x "))
                            .toList()),
                  if (currentBackground.numberOfSkillChoices != null)
                    MultiSelectContainer(
                        prefix: MultiSelectPrefix(
                            selectedPrefix: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.check,
                                color: Color.fromARGB(255, 0, 255, 8),
                                size: 20,
                              ),
                            ),
                            enabledPrefix: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                //Icons.do_disturb_alt_sharp,
                                Icons.close,
                                size: 20,
                                color: Color.fromARGB(255, 158, 154, 154),
                              ),
                            )),
                        textStyles: const MultiSelectTextStyles(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white),
                            selectedTextStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              //color: Color.fromARGB(255, 15, 124, 174)
                            )),
                        itemsDecoration: MultiSelectDecorations(
                          selectedDecoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(220, 52, 46, 243),
                                Color.fromARGB(220, 0, 242, 255)
                              ]),
                              border: Border.all(
                                  width: 0.8,
                                  color:
                                      const Color.fromARGB(220, 63, 254, 73)),
                              borderRadius: BorderRadius.circular(15)),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 124, 112, 112),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 61, 59, 59)),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        maxSelectableCount:
                            currentBackground.numberOfSkillChoices,
                        items: [
                          for (var x
                              in currentBackground.optionalSkillProficiencies ??
                                  [])
                            MultiSelectCard(value: x, label: x)
                        ],
                        onChange: (allSelectedItems, selectedItem) {}),
                  if (currentBackground.numberOfLanguageChoices != null)
                    Text(
                        "Pick ${(currentBackground.numberOfLanguageChoices)} language(s) to learn",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 7,
                  ),
                  if (currentBackground.numberOfLanguageChoices != null)
                    MultiSelectContainer(
                        prefix: MultiSelectPrefix(
                            selectedPrefix: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.check,
                                color: Color.fromARGB(255, 0, 255, 8),
                                size: 20,
                              ),
                            ),
                            enabledPrefix: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                //Icons.do_disturb_alt_sharp,
                                Icons.close,
                                size: 20,
                                color: Color.fromARGB(255, 158, 154, 154),
                              ),
                            )),
                        textStyles: const MultiSelectTextStyles(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white),
                            selectedTextStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              //color: Color.fromARGB(255, 15, 124, 174)
                            )),
                        itemsDecoration: MultiSelectDecorations(
                          selectedDecoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(220, 52, 46, 243),
                                Color.fromARGB(220, 0, 242, 255)
                              ]),
                              border: Border.all(
                                  width: 0.8,
                                  color:
                                      const Color.fromARGB(220, 63, 254, 73)),
                              borderRadius: BorderRadius.circular(15)),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 124, 112, 112),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 61, 59, 59)),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        maxSelectableCount:
                            currentBackground.numberOfLanguageChoices,
                        items: [
                          for (var x in LANGUAGELIST)
                            MultiSelectCard(value: x, label: x)
                        ],
                        onChange: (allSelectedItems, selectedItem) {}),
                ],
              )),
          //ability scores
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              strength.value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                    (8 < dexterity.value &&
                                            dexterity.value < 15)
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              dexterity.value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  (abilityScoreCost(constitution
                                                              .value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  (abilityScoreCost(intelligence
                                                              .value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                                  (abilityScoreCost(
                                                              wisdom.value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  (abilityScoreCost(
                                                              charisma.value) >
                                                          pointsRemaining)
                                                      ? const Color.fromARGB(
                                                          247, 56, 53, 52)
                                                      : const Color.fromARGB(
                                                          150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      150, 61, 33, 243),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
              ])),
          //spells

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
          //Equipment
          const Icon(Icons.directions_bike),
          //Boons and magic items
          const Icon(Icons.directions_bike),
          //Backstory
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                const SizedBox(
                  height: 20,
                  width: 10,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Character Information:",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 0, 168, 252)),
                ),
                const SizedBox(
                  height: 10,
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          textAlign: TextAlign.center,
                          "Age:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Enter character's age",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterAgeEnteredValue) {
                                characterAge = characterAgeEnteredValue;
                              }),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          textAlign: TextAlign.center,
                          "Eyes:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Describe your character's eyes",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterEyeEnteredValue) {
                                characterEyes = characterEyeEnteredValue;
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10, height: 100),
                    Column(
                      children: [
                        const Text(
                          textAlign: TextAlign.center,
                          "Height:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Enter character's height",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterHeightEnteredValue) {
                                characterHeight = characterHeightEnteredValue;
                              }),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          textAlign: TextAlign.center,
                          "Skin:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Describe your character's skin",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterSkinEnteredValue) {
                                characterSkin = characterSkinEnteredValue;
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10, height: 100),
                    Column(
                      children: [
                        const Text(
                          textAlign: TextAlign.center,
                          "Weight:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Enter character's weight",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterWeightEnteredValue) {
                                characterWeight = characterWeightEnteredValue;
                              }),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          textAlign: TextAlign.center,
                          "Hair:",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 168, 252)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                              cursorColor: Colors.blue,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Describe your character's Hair",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Color.fromARGB(255, 212, 208, 224)),
                                  filled: true,
                                  fillColor: Color.fromARGB(211, 42, 63, 226),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (characterHairEnteredValue) {
                                characterHair = characterHairEnteredValue;
                              }),
                        ),
                      ],
                    )
                  ],
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Backstory:",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 0, 168, 252)),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 1000,
                  height: 100,
                  child: TextField(
                      maxLines: 10000,
                      minLines: 4,
                      cursorColor: Colors.blue,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 126, 122, 122)),
                      decoration: const InputDecoration(
                          hintText:
                              "Write out your character's backstory. This should be a description of their past, including but not limited to: Who raised them/ how were they raised, any serious traumas or achievements in their life and then linking to justify your/ having another, reason for being in the campaign.",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 126, 122, 122)),
                          filled: false,
                          //fillColor: Color.fromARGB(211, 42, 63, 226),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 126, 122, 122)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onChanged: (characterEyeEnteredValue) {
                        characterEyes = characterEyeEnteredValue;
                      }),
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Additional Features:",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 0, 168, 252)),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 1000,
                  height: 100,
                  child: TextField(
                      maxLines: 10000,
                      minLines: 4,
                      cursorColor: Colors.blue,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 126, 122, 122)),
                      decoration: const InputDecoration(
                          hintText:
                              "Write any additional features, skills or abilities which are not a part of the character's race/class/background etc. These should have been agreed apon by your DM or whoever is running the game.",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 126, 122, 122)),
                          filled: false,
                          //fillColor: Color.fromARGB(211, 42, 63, 226),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 126, 122, 122)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onChanged: (characterEyeEnteredValue) {
                        characterEyes = characterEyeEnteredValue;
                      }),
                ),
              ])),
          //Finishing up
          const Icon(Icons.directions_car),
        ]),
      ),
    );
  }
}
