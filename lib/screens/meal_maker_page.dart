import 'package:ari_utils/ari_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:diet_planner/utils/local_widgets.dart';
import 'package:diet_planner/utils/utils.dart';
import 'package:diet_planner/domain.dart';
import '../blocs/custom_ing/custom_ing_bloc.dart';
import '../blocs/ingredients_page/ingredients_page_bloc.dart';
import '../blocs/init/init_bloc.dart';
import '../blocs/meal_maker/meal_maker_bloc.dart';
import 'custom_ingredient.dart';
import 'ingredients_page.dart';
import 'package:dataclasses/dataclasses.dart' as data;

class MealMakerPage extends StatelessWidget {
  const MealMakerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mmbloc = context.read<MealMakerBloc>();
    return Scaffold(
      appBar: AppBar(
        title: BlocConsumer<MealMakerBloc, MealMakerState>(
          listener: (context, state) {
            if (state is MMSuccess) {
              Navigator.pop(context, state.meal);
            }
          },
          builder: (context, state) {
            return Text('Meal Maker: ${state.name}');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: PaddedColumn(
          edgeInsets: const EdgeInsets.all(12),
          children: [
            Center(
              child: GestureDetector(onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                          value: mmbloc,
                          child: BlocListener<MealMakerBloc, MealMakerState>(
                            listener: (context, state) {
                              Navigator.pop(context);
                            },
                            listenWhen: (previous, current) =>
                                previous.image != current.image,
                            child: AlertDialog(
                              content: PaddedColumn(
                                mainAxisSize: MainAxisSize.min,
                                edgeInsets: const EdgeInsets.all(8),
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        final img = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.camera);
                                        if (img == null) {
                                          return;
                                        }
                                        mmbloc.add(ChangePhoto(Uri.file(
                                            img.path,
                                            windows: Platform.isWindows)));
                                      },
                                      child: const Text('Camera')),
                                  ElevatedButton(
                                      onPressed: () async {
                                        final img = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (img == null) {
                                          return;
                                        }
                                        mmbloc.add(ChangePhoto(Uri.file(
                                            img.path,
                                            windows: Platform.isWindows)));
                                      },
                                      child: const Text('Gallery')),
                                ],
                              ),
                            ),
                          ),
                        ));
              }, child: BlocBuilder<MealMakerBloc, MealMakerState>(
                builder: (context, state) {
                  return GetImage(
                    state.image,
                    width: 200,
                    height: 200,
                    cH: 300,
                    cW: 300,
                  );
                },
              )),
            ),
            Row(
              children: [
                const Text('Name: '),
                Flexible(child: BlocBuilder<MealMakerBloc, MealMakerState>(
                  builder: (context, state) {
                    return TextFormField(
                      initialValue: state.name,
                      onChanged: (name) {
                        mmbloc.add(ChangeName(name));
                      },
                      decoration: InputDecoration(
                          labelText: 'name',
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          errorText: state.name.isEmpty && state.showErrors
                              ? "Required Field"
                              : null),
                    );
                  },
                )),
              ],
            ),
            Row(
              children: [
                const Text('Servings: '),
                Flexible(child: BlocBuilder<MealMakerBloc, MealMakerState>(
                  builder: (context, state) {
                    return TextFormField(
                        initialValue: state.servings,
                        onChanged: (servings) {
                          mmbloc.add(ChangeServings(servings));
                        },
                        decoration: InputDecoration(
                            errorText: !state.validServing() && state.showErrors
                                ? "Required Field"
                                : null,
                            labelText: 'Servings',
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 0, 0)),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number);
                  },
                )),
              ],
            ),
            BlocBuilder<MealMakerBloc, MealMakerState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total weight: ${roundDecimal(state.totalGrams, 1)}',
                          style: servingWeightTextStyle),
                      if (state.validServing() && int.parse(state.servings) > 1)
                        Text(
                            'Serving weight: ${roundDecimal(state.servingGrams, 1)}',
                            style: servingWeightTextStyle),
                    ],
                  );
                },
                buildWhen: (pre, curr) =>
                    pre.servingGrams != curr.servingGrams ||
                    pre.totalGrams != curr.totalGrams ||
                    curr is MMChangeGrams),
            BlocConsumer<MealMakerBloc, MealMakerState>(
              listener: (context, state) {
                if (state is MMError && state.nutrients == zeroNut) {
                  showErrorMessage(context, 'Meals must have food!');
                }
                if (state is MMError && state.containsSelf()) {
                  showErrorMessage(context,
                      'Meals cannot contain themselves! It\'s an infinite loop!');
                }
              },
              builder: (context, state) {
                return ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    BlocConsumer<MealMakerBloc, MealMakerState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              if (!state.validServing() ||
                                  state.servings == '1') {
                                return;
                              }
                              mmbloc.add(ChangeNutDisplayEvent());
                            },
                            child: mealStyleNutrientDisplay(state.nutrients),
                          );
                        },
                        buildWhen: (pre, curr) =>
                            pre.nutrients != curr.nutrients ||
                            pre.servings != curr.servings ||
                            curr is MMChangeGrams,
                        listener: (context, state) {
                          if (state.nutPerServing) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Nutrients are now per serving')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Nutrients are now the sum of all the ingredients')));
                          }
                        },
                        listenWhen: (pre, curr) =>
                            curr is ChangeNutDisplay &&
                            pre is! ChangeNutDisplay),
                    PlusSignTile((_) async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings:
                                  const RouteSettings(name: "/IngredientsPage"),
                              builder: (_) => BlocProvider<IngredientsPageBloc>(
                                  create: (context) => IngredientsPageBloc(
                                      context.read<InitBloc>().state.app!,
                                      MCFTypes.ingredient,
                                      include: true,
                                      backRef: true),
                                  child: IngredientPage())));
                      if (result is MealComponentFactory) {
                        final serving = result.toServing();
                        mmbloc.add(AddMC(serving));
                      }
                    }),
                    BlocBuilder<MealMakerBloc, MealMakerState>(
                      builder: (context, state) {
                        App app = context.read<InitBloc>().state.app!;
                        return ReorderableListView.builder(
                          itemBuilder: (context, index) => MCTile(
                            state.mealComponents[index],
                            servingSize:
                                state.nutPerServing ? state.servingsInt : 1,
                            onGramsChange: (MealComponent meal, num grams,
                                String serving) {
                              mmbloc.add(UpdateGramsMC(meal, grams, serving));
                            },
                            onDelete: (MealComponent meal) {
                              mmbloc.add(DeleteMC(meal));
                            },
                            onEdit: (MealComponent meal) async {
                              if (meal.reference is Ingredient) {
                                var thing = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MultiBlocProvider(
                                                providers: [
                                                  BlocProvider<CustomIngBloc>(
                                                      create: (context) =>
                                                          CustomIngBloc(meal
                                                                  .reference
                                                              as Ingredient)),
                                                ],
                                                child:
                                                    const CustomIngredientPage())));
                                if (thing is Ingredient) {
                                  mmbloc.add(EditMC(
                                      index: index,
                                      mc: meal,
                                      factory: thing,
                                      app: app));
                                }
                              } else if (meal.reference is Meal) {
                                var thing = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MultiBlocProvider(providers: [
                                              BlocProvider<MealMakerBloc>(
                                                  create: (context) =>
                                                      MealMakerBloc(meal
                                                          .reference as Meal)),
                                            ], child: const MealMakerPage())));
                                if (thing is Meal) {
                                  mmbloc.add(EditMC(
                                      index: index,
                                      mc: meal,
                                      factory: thing,
                                      app: app));
                                }
                              }
                            },
                            height: 75,
                            width: 55,
                            key: ValueKey<MealComponent>(
                                state.mealComponents[index]),
                          ),
                          itemCount: state.mealComponents.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          onReorder: (int oldIndex, int newIndex) {
                            mmbloc.add(ReorderMC(oldIndex, newIndex));
                          },
                        );
                      },
                    )
                  ],
                );
              },
              buildWhen: (pre, curr) {
                return !data.equals(pre.mealComponents, curr.mealComponents) &&
                    curr is! MMChangeGrams;
              },
            ),
            Center(
              child: Row(
                children: [
                  const Text('Sub-recipe ', style: TextStyle(fontSize: 20)),
                  BlocBuilder<MealMakerBloc, MealMakerState>(
                    builder: (context, state) {
                      return Switch(
                          value: state.subRecipe,
                          onChanged: (bool isSubRecipe) {
                            mmbloc.add(ToggleSub(isSubRecipe));
                          });
                    },
                  )
                ],
              ),
            ),
            const Text(
              'Alternate measures:',
              style: TextStyle(fontSize: 20),
            ),
            PlusSignTile((context) {
              mmbloc.add(AddAltMeasure());
            }),
            BlocBuilder<MealMakerBloc, MealMakerState>(
                builder: (context, state) {
              return ListView.builder(
                itemBuilder: (context, index) => AltMeasureFormFieldMM(index),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: state.altMeasures.length,
              );
            }),
            Container(
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey))),
              child: Column(
                children: [
                  const Text(
                    'Notes:',
                    style: TextStyle(fontSize: 20),
                  ),
                  TextFormField(
                    initialValue: mmbloc.state.notes,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(8, 8, 0, 8)),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (notes) {
                      mmbloc.add(UpdateNotes(notes));
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                mmbloc.add(SubmitMM());
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class AltMeasureFormFieldMM extends StatelessWidget {
  final int index;

  const AltMeasureFormFieldMM(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mmbloc = context.read<MealMakerBloc>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Name: '),
        Flexible(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
          child: TextFormField(
              decoration: const InputDecoration(
                  labelText: 'name',
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z \-]+'))
              // ],
              initialValue: mmbloc.state.altMeasures[index].key,
              onChanged: (name) {
                mmbloc.add(AltMeasureName(name, index));
              }),
        )),
        const Text('Grams: '),
        Flexible(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
          child: BlocBuilder<MealMakerBloc, MealMakerState>(
            builder: (context, state) {
              return TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    labelText: 'grams',
                    errorMaxLines: 4,
                    // invalid value and there is name and is error state
                    errorText: state.altMeasures[index].value.isEmpty &&
                            state.altMeasures[index].key.isNotEmpty &&
                            state.showErrors
                        ? 'Required (delete name to ignore)'
                        : null,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  initialValue: state.altMeasures[index].value,
                  onChanged: (val) {
                    mmbloc.add(AltMeasureValue(val, index));
                  });
            },
          ),
        )),
      ],
    );
  }
}

const TextStyle servingWeightTextStyle = TextStyle(
  color: Color.fromRGBO(125, 125, 125, 1),
  fontStyle: FontStyle.italic,
  // fontSize: ,
);
