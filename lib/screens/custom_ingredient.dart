import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:diet_planner/blocs/custom_ing/custom_ing_bloc.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/utils/local_widgets.dart';
import 'package:diet_planner/utils/utils.dart';

class CustomIngredientPage extends StatelessWidget {
  const CustomIngredientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: BlocConsumer<CustomIngBloc, CustomIngState>(
        listener: (context, state) {
          if (state is CustomIngSuccess) {
            Navigator.pop(context, state.ingredient);

            // .popUntil(ModalRoute.withName('/IngredientsPage'), state.ingredient);
            // context
            //     .read<IngredientsPageBloc>()
            //     .add(OnSubmitSolo(state.ingredient, ingToReplace: state.refIngredient));
          }
        },
        builder: (context, state) {
          return Text('Ingredient: ${state.name}');
        },
      )),
      body: SingleChildScrollView(
        child: PaddedColumn(
          edgeInsets: const EdgeInsets.all(12),
          children: [
            Center(
              child: GestureDetector(onTap: () {
                final cibloc = context.read<CustomIngBloc>();
                showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                          value: cibloc,
                          child: BlocListener<CustomIngBloc, CustomIngState>(
                            listener: (context, state) {
                              if (state is CustomIngAddedPhoto) {
                                Navigator.pop(context);
                              }
                            },
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
                                        cibloc.add(NewImageCI(Uri.file(img.path,
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
                                        cibloc.add(NewImageCI(Uri.file(img.path,
                                            windows: Platform.isWindows)));
                                      },
                                      child: const Text('Gallery')),
                                ],
                              ),
                            ),
                          ),
                        ));
              }, child: BlocBuilder<CustomIngBloc, CustomIngState>(
                builder: (context, state) {
                  return GetImage(
                    state.image,
                    width: 200,
                    height: 200,
                  );
                },
              )),
            ),
            Row(
              children: [
                const Text('Serving Size in grams: '),
                Flexible(child: BlocBuilder<CustomIngBloc, CustomIngState>(
                  builder: (context, state) {
                    return TextFormField(
                      onChanged: (val) {
                        context.read<CustomIngBloc>().add(ChangeGramsCI(val));
                      },
                      decoration: InputDecoration(
                          errorText: invalidateNum(state.baseGrams) &&
                                  state is CustomIngErrors
                              ? 'Required Field'
                              : null,
                          labelText: 'grams',
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0)),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      initialValue: state.baseGrams,
                    );
                  },
                )),
              ],
            ),
            Row(
              children: [
                const Text('Ingredient Name: '),
                BlocBuilder<CustomIngBloc, CustomIngState>(
                  builder: (context, state) {
                    return Flexible(
                        child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'name',
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        errorText: invalidateNum(state.name) &&
                                state is CustomIngErrors
                            ? 'Required Field'
                            : null,
                      ),
                      // inputFormatters: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]+'))
                      // ],
                      keyboardType: TextInputType.text,
                      onChanged: (val) {
                        context.read<CustomIngBloc>().add(ChangeNameCI(val));
                      },
                      initialValue: state.name,
                    ));
                  },
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Alternate measures:'),
                    PlusSignTile((context) {
                      context.read<CustomIngBloc>().add(AddAltMeasureCI());
                    }, padding: const EdgeInsets.fromLTRB(0, 16, 0, 0)),
                    BlocBuilder<CustomIngBloc, CustomIngState>(
                      builder: (context, state) {
                        return ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (_, index) =>
                              AltMeasureFormFieldCI(index),
                          itemCount: state.altMeasures.length,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: ListView.builder(
                // children: type2dataclasses[Nutrients]!.attributes.keys.map((e) => nutrientFormField(e)).toList(),
                itemBuilder: (BuildContext context, int index) =>
                    NutrientFormField(nutList[index]),
                itemCount: nutList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // children: emptyNutrient.attributes__.values.map((e) => nutrientFormField(e)).toList(),
              ),
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      context.read<CustomIngBloc>().add(OnSubmitCI());
                    },
                    child: const Text('Submit')))
            // ...?type2dataclasses[Nutrients]?.attributes.keys.map((e) => nutrientFormField(e))
          ],
        ),
      ),
    );
  }
}

// Widget nutrientFormField(Nutrient nut)=>
//     Row(
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
//           child: Text('${replaceTextForForm(nut.name)}:'),
//         ),
//         Flexible(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(20, 5, 50, 5),
//             child: TextFormField(
//                 decoration: InputDecoration(
//                   contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
//                   // hintText: '0',
//                   labelText: nut.unit
//                 ),
//                 inputFormatters: <TextInputFormatter>[
//                   FilteringTextInputFormatter.allow(RegExp(r'[\d.]+'))
//                 ],
//               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//             ),
//           ),
//         ),
//       ],
//     );

class NutrientFormField extends StatelessWidget {
  final Nutrient nut;

  const NutrientFormField(this.nut, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
          child: Text('${replaceTextForForm(nut.name)}:'),
        ),
        BlocBuilder<CustomIngBloc, CustomIngState>(
          builder: (context, state) {
            return Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 50, 5),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      errorText:
                          invalidateNum(state.nutrientFields[nut.name]!) &&
                                  state is CustomIngErrors
                              ? 'Required Field'
                              : null,
                      // hintText: '0',
                      labelText: nut.unit),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    // \d*\.?\d+
                  ],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  initialValue: state.nutrientFields[nut.name],
                  onChanged: (val) {
                    context
                        .read<CustomIngBloc>()
                        .add(ChangeNutrientValueCI(nut, val));
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class AltMeasureFormFieldCI extends StatelessWidget {
  final int index;

  const AltMeasureFormFieldCI(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              initialValue:
                  context.read<CustomIngBloc>().state.altMeasures[index].key,
              onChanged: (val) {
                context
                    .read<CustomIngBloc>()
                    .add(ChangeAltMeasureNameCI(index, val));
              }),
        )),
        const Text('Grams: '),
        Flexible(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
          child: TextFormField(
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  labelText: 'grams',
                  errorMaxLines: 4,
                  // invalid value and there is name and is error state
                  errorText: invalidateNum(context
                              .read<CustomIngBloc>()
                              .state
                              .altMeasures[index]
                              .value) &&
                          context.read<CustomIngBloc>().state
                              is CustomIngErrors &&
                          context
                              .read<CustomIngBloc>()
                              .state
                              .altMeasures[index]
                              .key
                              .isNotEmpty
                      ? 'Value required: To ignore this delete "Name"'
                      : null),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              initialValue:
                  context.read<CustomIngBloc>().state.altMeasures[index].value,
              onChanged: (val) {
                context
                    .read<CustomIngBloc>()
                    .add(ChangeAltMeasureValueCI(index, val));
              }),
        )),
      ],
    );
  }
}

// Row altMeasureFormField()=>
//     Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Text('Name: '),
//         Flexible(child: Padding(
//           padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
//           child: TextFormField(
//               decoration: const InputDecoration(
//                 labelText: 'name',
//                 contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)
//               ),
//               inputFormatters: <TextInputFormatter>[
//                 FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z \-]+'))
//               ],
//           ),
//         )),
//         const Text('Grams: '),
//         Flexible(child: Padding(
//           padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
//           child: TextFormField(
//               decoration: const InputDecoration(
//
//                 contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//                 labelText: 'grams',
//               ),
//               inputFormatters: <TextInputFormatter>[
//                 FilteringTextInputFormatter.allow(RegExp(r'[\d.]+'))
//               ],
//             keyboardType: const TextInputType.numberWithOptions(decimal: true),
//           ),
//         )),
//       ],
//     );