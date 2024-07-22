import 'package:ari_utils/ari_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/blocs/diet/diet_bloc.dart';
import 'package:diet_planner/blocs/micro_blocs/shopping_list_bloc.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/screens/diet_details_screen.dart';
import 'package:diet_planner/screens/shopping_list_page.dart';
import 'package:diet_planner/utils/storage.dart';
import 'package:diet_planner/utils/utils.dart';
import '../blocs/init/init_bloc.dart';
import '../blocs/micro_blocs/saver.dart';
import '../screens/dri_configs.dart';

class PlusSignTile extends StatelessWidget {
  final void Function(BuildContext context) onTap;
  final void Function()? onLongPress;
  final EdgeInsets? padding;

  const PlusSignTile(this.onTap, {this.padding, this.onLongPress, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: ListTile(
        onTap: () {
          onTap(context);
        },
        onLongPress: onLongPress,
        title: const Center(
          child: Icon(Icons.add),
        ),
        tileColor: const Color.fromRGBO(240, 240, 240, 30),
        shape: const BeveledRectangleBorder(
          side: BorderSide(color: Color.fromRGBO(150, 150, 150, 80), width: 1),
          // borderRadius: BorderRadius.(5),
        ),
      ),
    );
  }
}

class NutrientText extends StatelessWidget {
  final Nutrients nutrients;
  final num? grams;
  final String? baseUnit;
  late final String? initText;
  final TextStyle? style;

  NutrientText(
      {required this.nutrients,
      this.grams,
      String? initText,
      this.baseUnit,
      this.style,
      Key? key})
      : super(key: key) {
    String unit = 'g';
    if (toBool(baseUnit) && !baseUnit!.startsWith('gram')) {
      unit = baseUnit!;
    }
    final serving = grams == null ? '' : ' ($grams$unit)';
    this.initText = initText ?? 'Serving$serving:  ';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$initText'
      "${nutrients.calories.value.round()}\u{1F525}  "
      '${nutrients.carbohydrate.value.round()}\u{1F35E}  '
      '${nutrients.protein.value.round()}\u{1F969}  '
      // '${meal.baseNutrient.nutrients.unsaturatedFat.value.round()}\u{1FAD2}  '
      '${nutrients.unsaturatedFat.value.round()}$olive  '
      // '${meal.baseNutrient.nutrients.saturatedFat.value.round()}\u{1F9C8}',
      '${nutrients.saturatedFat.value.round()}$butter',
      style: style,
    );
  }
}

Widget dayStyleNutrientDisplay(Nutrients nutrients, DRIS dris) {
  final trackedNuts = dris.comparator(nutrients);
  List<Widget> nutWidgets = [];
  for (MapEntry<String, List> nut in trackedNuts.entries) {
    final color =
        nut.value[2].startsWith(RegExp(r'[+-]')) ? Colors.red : Colors.green;
    nutWidgets.add(Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(children: [
        Text(DRIS.representor[nut.key] ?? replaceTextForForm(nut.key)),
        Text(nut.value[2], style: TextStyle(color: color))
      ]),
    ));
  }
  return Container(
    height: 50,
    width: double.infinity,
    // child: ListView(
    //   scrollDirection: Axis.horizontal,
    //   shrinkWrap: true,
    //   children: nutWidgets,
    // ),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) => nutWidgets[index],
      itemCount: nutWidgets.length,
    ),
  );
}

String dayStyleNutrientsToText(Nutrients nutrients, DRIS dris) {
  final trackedNuts = dris.comparator(nutrients);
  String result = 'Name | Comparison | Nutrient | DRI\n'
      '------------------------------------\n';
  for (List nut in trackedNuts.values) {
    String middle =
        (nut[2] as String).contains('+') || (nut[2] as String).contains('-')
            ? '| ${roundDecimal((nut[1] as Nutrient).value, 2)}'
            : '';
    result += '${(nut[0] as DRI).name} | ${nut[2]} $middle | ${nut[0]}';
    if (nut[0] != trackedNuts.values.last[0]) {
      result += '\n';
      result += '------------------------------------';
      result += '\n';
    }
  }
  return result;
}

class DayStyleNutrientDisplay extends StatefulWidget {
  final Nutrients nutrients;
  final DRIS dris;

  const DayStyleNutrientDisplay(this.nutrients, this.dris, {Key? key})
      : super(key: key);

  @override
  State<DayStyleNutrientDisplay> createState() =>
      _DayStyleNutrientDisplayState();
}

class _DayStyleNutrientDisplayState extends State<DayStyleNutrientDisplay> {
  List<Widget> nutWidgets = [];

  @override
  void initState() {
    final trackedNuts = widget.dris.comparator(widget.nutrients);
    for (MapEntry<String, List> nut in trackedNuts.entries) {
      final color =
          nut.value[2].startsWith(RegExp(r'[+-]')) ? Colors.red : Colors.green;
      nutWidgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        child: Column(children: [
          Text(DRIS.representor[nut.key] ?? replaceTextForForm(nut.key)),
          Text(nut.value[2], style: TextStyle(color: color))
        ]),
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      // child: ListView(
      //   scrollDirection: Axis.horizontal,
      //   shrinkWrap: true,
      //   children: nutWidgets,
      // ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => nutWidgets[index],
        itemCount: nutWidgets.length,
      ),
    );
  }
}

Widget mealStyleNutrientDisplay(Nutrients nutrients) {
  List<Widget> nutWidgets = [];
  for (MapEntry<String, dynamic> nut in nutrients.attributes__.entries) {
    nutWidgets.add(Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(children: [
        Text(DRIS.representor[nut.key] ?? replaceTextForForm(nut.key)),
        Text(nut.value.value % 1 == 0
            ? nut.value.value.toInt().toString()
            : roundDecimal(nut.value.value.toDouble(), 2).toString())
      ]),
    ));
  }
  return Container(
    height: 50,
    width: double.infinity,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) => nutWidgets[index],
      itemCount: nutWidgets.length,
      // children: nutWidgets,
    ),
  );
}

class MealStyleNutrientDisplay extends StatefulWidget {
  final Nutrients nutrients;

  const MealStyleNutrientDisplay(this.nutrients, {Key? key}) : super(key: key);

  @override
  State<MealStyleNutrientDisplay> createState() =>
      _MealStyleNutrientDisplayState();
}

class _MealStyleNutrientDisplayState extends State<MealStyleNutrientDisplay> {
  List<Widget> nutWidgets = [];

  @override
  void initState() {
    for (MapEntry<String, dynamic> nut
        in widget.nutrients.attributes__.entries) {
      nutWidgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        child: Column(children: [
          Text(DRIS.representor[nut.key] ?? replaceTextForForm(nut.key)),
          Text(roundDecimal(nut.value.value.toDouble(), 2).toString())
        ]),
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => nutWidgets[index],
        itemCount: nutWidgets.length,
        // children: nutWidgets,
      ),
    );
  }
}

class DietDrawer extends StatelessWidget {
  final Diet diet;

  const DietDrawer(this.diet, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.all(0),
            child: Center(
                child: Text(
              diet.name,
              style: const TextStyle(fontSize: 40),
            )),
          ),
          ListTile(
            title: const Text('Days'),
            onTap: () {
              Saver().app(context.read<InitBloc>().state.app!);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => DietBloc(diet),
                            child: DietPage(diet),
                          )));
            },
          ),
          ListTile(
            title: const Text('Shopping List'),
            onTap: () {
              Saver().app(context.read<InitBloc>().state.app!);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return BlocProvider(
                  create: (context) => ShoppingListBloc(diet),
                  child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
                      builder: (context, state) => const ShoppingListPage()),
                );
              }));
            },
          ),
          ListTile(
            title: const Text('DRI Configuration'),
            onTap: () {
              Saver().app(context.read<InitBloc>().state.app!);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DRIConfigPage(diet)));
            },
          ),
          ListTile(
            title: const Text('Return to Home Page'),
            onTap: () {
              Saver().app(context.read<InitBloc>().state.app!);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
        // DrawerHeader(child: Text(),)
      ),
    );
  }
}

// final zeroNut = Nutrients.zero();
final List<Nutrient> nutList = List<Nutrient>.from(zeroNut.attributes__.values);

/// Alert Dialogue to prompt user for a string
AlertDialog nameAThing(BuildContext context,
    {required String title, String? labelText}) {
  TextEditingController controller = TextEditingController();
  return AlertDialog(
    title: Text(title),
    content: TextFormField(
      decoration: InputDecoration(labelText: labelText),
      controller: controller,
      autofocus: true,
    ),
    actions: [
      Row(
        children: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('cancel')),
          const Spacer(),
          TextButton(
              onPressed: () {
                if (!toBool(controller.text)) {
                  Navigator.pop(context);
                  return;
                } else {
                  // onSubmit(context, controller.text);
                  Navigator.pop(context, controller.text);
                }
              },
              child: const Text('submit'))
        ],
      ),
    ],
  );
}

String replaceTextForForm(String input) {
  final lowercase = input.toLowerCase();
  if (lowercase == 'ala' ||
      lowercase == 'epa' ||
      lowercase == 'dha' ||
      lowercase == 'dpa') {
    return input.toUpperCase();
  }
  final uppercaseRegex = RegExp(r'([A-Z])', caseSensitive: true);
  input =
      input.replaceAllMapped(uppercaseRegex, (Match m) => ' ${m[1]}').trim();
  input = input.substring(0, 1).toUpperCase() + input.substring(1);
  return input;
}

void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: ListTile(
        leading: const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        title: Text(
          message,
          maxLines: 5,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        selectedColor: Colors.red,
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}

class MealComponentTile extends StatelessWidget {
  final MealComponent meal;
  final expansionController = ExpansionTileController();

  MealComponentTile(this.meal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.trailing,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        if (meal.reference is Meal)
          if (toBool((meal.reference as Meal).notes))
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        mealNotesPopUp(meal.reference as Meal, context));
              },
              icon: const Icon(Icons.info_outline),
            ),
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: MealComponentPopUpEnumHolder(meal, PopUpOptions.edit),
              child: const Text('Edit'),
            ),
            PopupMenuItem(
                value: MealComponentPopUpEnumHolder(meal, PopUpOptions.delete),
                child: const Text('Delete')),
            PopupMenuItem(
              value: MealComponentPopUpEnumHolder(meal, PopUpOptions.duplicate),
              child: const Text('Duplicate'),
            ),
          ],
        ),
        ExpandIcon(onPressed: (bool val) {
          val ? expansionController.expand() : expansionController.collapse();
        })
      ]),

      leading: GetImage(meal.reference.photo),
      title: Text(meal.name),
      expandedCrossAxisAlignment: CrossAxisAlignment.center,
      onExpansionChanged: (exp) {},
      controller: expansionController,
      // childrenPadding: const EdgeInsets.fromLTRB(40, 0, 0, 5),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 2),
          child: MealStyleNutrientDisplay(meal.nutrients),
        ),
        const Text(
          'Serving Size',
          style: TextStyle(fontSize: 16),
        ),
        TextFormField(
          initialValue: meal.grams.isInt
              ? meal.grams.toInt().toString()
              : roundDecimal(meal.grams.toDouble(), 3).toString(),
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            border: InputBorder.none,
            // label: Center(child: Text('grams')),
            // alignLabelWithHint: true,
            // hintText: 'grams',
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        DropdownButton<String>(
            value: 'grams',
            items: meal.reference.altMeasures2grams.keys
                .map<DropdownMenuItem<String>>(
                    (e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (String? newAltMeasure) {})
      ],
    );
  }
}

class MCTile extends StatefulWidget {
  final Function(MealComponent meal, num grams, String servingValue)
      onGramsChange;
  final Function(MealComponent meal)? onEdit;
  final Function(MealComponent meal) onDelete;
  final Function(MealComponent meal)? onDuplicate;
  final double? height;
  final double? width;
  final MealComponent meal;
  final int? servingSize;

  const MCTile(this.meal,
      {Key? key,
      this.height,
      this.width,
      required this.onGramsChange,
      this.onEdit,
      required this.onDelete,
      this.onDuplicate,
      this.servingSize})
      : super(key: key);

  // String servingValue = 'grams';

  @override
  State<MCTile> createState() => _MCTileState();
}

class _MCTileState extends State<MCTile> {
  final textController = TextEditingController();
  bool _isExpanded = false;
  late String servingValue = widget.meal.reference.unit;

  // late Nutrients _nutrientDisplay;
  _getAltMeasure(String alt) => widget.meal.reference.altMeasures2grams[alt]!;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.trailing,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        if (widget.meal.reference is Meal)
          if (toBool((widget.meal.reference as Meal).notes))
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        mealNotesPopUp(widget.meal.reference as Meal, context));
              },
              icon: const Icon(Icons.info_outline),
            ),
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            if (toBool(widget.onEdit))
              PopupMenuItem(
                value: MealComponentPopUpEnumHolder(
                    widget.meal, PopUpOptions.edit),
                child: const Text('Edit'),
              ),
            PopupMenuItem(
                value: MealComponentPopUpEnumHolder(
                    widget.meal, PopUpOptions.delete),
                child: const Text('Delete')),
            if (toBool(widget.onDuplicate))
              PopupMenuItem(
                value: MealComponentPopUpEnumHolder(
                    widget.meal, PopUpOptions.duplicate),
                child: const Text('Duplicate'),
              ),
          ],
          onSelected: (val) {
            switch (val.popUpOption) {
              case PopUpOptions.edit:
                if (widget.onEdit != null) {
                  widget.onEdit!(val.mealComponent);
                }
                break;
              case PopUpOptions.delete:
                widget.onDelete(val.mealComponent);
                break;
              case PopUpOptions.duplicate:
                if (widget.onDuplicate != null) {
                  widget.onDuplicate!(val.mealComponent);
                }
                break;
            }
          },
        ),
        Transform.flip(
            flipY: _isExpanded, child: const Icon(Icons.expand_more)),
      ]),

      leading: GetImage(
        widget.meal.reference.photo,
        height: widget.height ?? 75,
        width: widget.width ?? 50,
      ),
      title: Text(widget.meal.name),
      expandedCrossAxisAlignment: CrossAxisAlignment.center,
      onExpansionChanged: (newExpState) {
        setState(() {
          _isExpanded = newExpState;
        });
      },
      // childrenPadding: const EdgeInsets.fromLTRB(40, 0, 0, 5),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 2),
          // child: MealStyleNutrientDisplay(widget.meal.nutrients),
          child: mealStyleNutrientDisplay(
              widget.meal.nutrients / (widget.servingSize ?? 1)),
        ),
        const Text(
          'Serving Size',
          style: TextStyle(fontSize: 16),
        ),
        TextFormField(
          // initialValue: widget.meal.grams.isInt
          //     ? widget.meal.grams.toInt().toString()
          //     : roundDecimal(widget.meal.grams.toDouble(), 3).toString(),
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            border: InputBorder.none,
            // label: Center(child: Text('grams')),
            // alignLabelWithHint: true,
            // hintText: 'grams',
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: textController,
          validator: (val) => val == null || val.isEmpty || val == '.'
              ? 'Required Field'
              : null,
          onChanged: (valString) {
            num val = fixDecimal(valString) ?? 0;
            widget.onGramsChange(widget.meal, val, servingValue);
            setState(() {
              // widget.meal = widget.meal.reference.toMealComponent(
              //     servingValue, val, widget.meal.reference);
            });
          },
        ),
        DropdownButton<String>(
            value: servingValue,
            items: widget.meal.reference.altMeasures2grams.keys
                .map<DropdownMenuItem<String>>(
                    (e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (String? newAltMeasure) {
              if (newAltMeasure == null) {
                return;
              }
              setState(() {
                final ratio = widget.meal.grams / _getAltMeasure(newAltMeasure);
                textController.text = ratio.isInt
                    ? ratio.toInt().toString()
                    : roundDecimal(ratio.toDouble(), 3).toString();
                servingValue = newAltMeasure;
              });
            }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    textController.text = widget.meal.grams.isInt
        ? widget.meal.grams.toInt().toString()
        : roundDecimal(widget.meal.grams.toDouble(), 3).toString();
  }
}

class SaveDietButton extends StatelessWidget {
  final Diet diet;

  const SaveDietButton(this.diet, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaverBloc, SaverState>(
      listener: (context, state) {
        if (Saver.messageIsDiet(state.message)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Diet saved!'),
            backgroundColor: Colors.green,
          ));
        }
      },
      child: IconButton(
          onPressed: () {
            Saver().app(context.read<InitBloc>().state.app!).then((value) {
              if (!value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('A save is currently running!'),
                  backgroundColor: Colors.orange,
                ));
              }
            });
          },
          icon: const Icon(Icons.sync)),
    );
  }
}
