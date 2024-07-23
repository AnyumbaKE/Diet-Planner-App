import 'package:ari_utils/ari_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/blocs/dri_config/dri_config_bloc.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/domain/dri_notes.dart';
import 'package:diet_planner/utils/local_widgets.dart';

class DRIConfigPage extends StatelessWidget {
  final Diet diet;
  late final List<DRI> dris = List<DRI>.from(diet.dris.attributes__.values);

  DRIConfigPage(this.diet, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriConfigBloc(diet),
      child: Scaffold(
        appBar: AppBar(
          title: Text(diet.name),
          actions: [SaveDietButton(diet)],
        ),
        drawer: DietDrawer(diet),
        // body: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       driConfigIntro,
        //       ...diet.dris.attributes__.values.map((e) => driForm(e as DRI, context))
        //     ],
        //   ),
        // ),
        body: BlocListener<DriConfigBloc, DriConfigState>(
          listenWhen: (previous, current) {
            return current is DRIErrorState && previous is! DRIErrorState;
          },
          listener: (context, state) {
            if (state is DRIErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Column(
                  children: [
                    const Text('DRIs can\'t be greater than ULs!'),
                    const Text('Current Errors:'),
                    ...state.driErrors
                        .where((p0) => p0.value)
                        .keys
                        .map((e) => Text('    ${e.name}')),
                  ],
                ),
                duration: const Duration(milliseconds: 1500),
                backgroundColor: Colors.orange,
              ));
            }
          },
          child: ListView(
            children: [
              DriIntro(diet.name),
              ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    DriForm(dris[index]),
                itemCount: diet.dris.attributes__.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                // children: [
                //   driConfigIntro,
                //   ...diet.dris.attributes__.values.map((e) => driForm(e as DRI, context))
                // ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// change driForm to be a stless widget
/// Move the map code into an init state of bloc
/// Use ListView with lazyloader

class DriForm extends StatelessWidget {
  final DRI dri;

  const DriForm(this.dri, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      BlocBuilder<DriConfigBloc, DriConfigState>(
        builder: (context, state) {
          return Checkbox(
              value: dri.tracked,
              onChanged: (bool? changedTracked) {
                if (changedTracked is bool) {
                  context
                      .read<DriConfigBloc>()
                      .add(DRIActivation(changedTracked, dri));
                  // refreshDiet(context);
                }
              });
        },
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(2, 1, 8, 1),
        child: Text('${dri.name} (${dri.unit})'),
      ),
      Flexible(
        child: BlocBuilder<DriConfigBloc, DriConfigState>(
          builder: (context, state) {
            return TextFormField(
              onChanged: (val) {
                context
                    .read<DriConfigBloc>()
                    .add(DRIUpdate(dft: DFT.dri, dri: dri, newVal: val));
              },
              initialValue: dri.dri?.toString(),
              decoration: InputDecoration(
                  labelText: 'DRI',
                  errorText:
                      toBool(state.driErrors[dri]) ? 'DRIs < UL!' : null),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            );
          },
        ),
      ),
      Flexible(
        child: BlocBuilder<DriConfigBloc, DriConfigState>(
          builder: (context, state) {
            return TextFormField(
              initialValue: dri.upperLimit?.toString(),
              onChanged: (val) {
                context
                    .read<DriConfigBloc>()
                    .add(DRIUpdate(dft: DFT.ul, dri: dri, newVal: val));
              },
              decoration: const InputDecoration(
                // errorText: toBool(state.driErrors[dri])
                //     ? 'UL (${dri.upperLimit}) Must Be Higher than the DRI (${dri.dri})!'
                //     : null,
                labelText: 'UL',
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            );
          },
        ),
      ),
      if (toBool(driNotes[dri.name]))
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => driInformation(dri.name, context));
            },
            icon: const Icon(Icons.help)),
    ]);
  }
}

// Widget driForm(DRI dri, BuildContext context) {
//   // String? stringify(num? n) => n?.toString();
//   // print(dri.name);
//   return Row(
//       children: [
//         Checkbox(value: dri.tracked, onChanged: (bool? changedTracked){}),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(2, 1, 8, 1),
//           child: Text('${replaceTextForForm(dri.name)} (${dri.unit})'),
//         ),
//         Flexible(
//           child: TextFormField(
//             initialValue:dri.dri?.toString(),
//             decoration: const InputDecoration(
//               labelText: 'DRI',
//             ),
//             inputFormatters: <TextInputFormatter>[
//               FilteringTextInputFormatter.allow(RegExp(r'[\d.]+'))
//             ],
//             keyboardType: const TextInputType.numberWithOptions(decimal: true),
//           ),
//         ),
//         Flexible(
//           child: TextFormField(
//             initialValue:dri.upperLimit?.toString(),
//             decoration: const InputDecoration(
//               labelText: 'UL',
//             ),
//             inputFormatters: <TextInputFormatter>[
//               FilteringTextInputFormatter.allow(RegExp(r'[\d.]+'))
//             ],
//             keyboardType: const TextInputType.numberWithOptions(decimal: true),
//           ),
//         ),
//         if (toBool(driNotes[dri.name])) IconButton(
//             onPressed: (){
//               showDialog(context: context, builder: (context) => driInformation(dri.name, context));},
//             icon: const Icon(Icons.help)),
//       ]
//   );
// }

AlertDialog driInformation(String driName, BuildContext context) => AlertDialog(
      title: Text(replaceTextForForm(driName)),
      content: Text(driNotes[driName]!),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Return'))
      ],
    );

class DriIntro extends StatelessWidget {
  final String dietName;
  const DriIntro(this.dietName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              'Welcome to the DRI Configuration Page',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'A quick refresher on the terminology:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'DRI: Daily Recommended Intake (Always the number on the left)',
            style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'UL: Upper Tolerable Limit (Always the number on the right)',
            style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'These DRIs are calculated from the NSDA website based on the anthropomorphic data in the settings. Be careful regarding what you change and what you eat.',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'This App is not responsible for your health. Please consult a qualified dietitian before making any changes, and please double-check your anthropomorphic data before making any diets (as this is what the NSDA website uses to determine your DRIs).',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          Text(
            'The DRIs are diet-specific, so what you change here will only affect $dietName.',
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'The checkbox indicates you are tracking that nutrient; any nutrient with a tick will be shown in the comprehensive Nutrients, whereas those that are unchecked will be omitted.',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'If a field is empty, that means that nutrient doesn\'t have that field (i.e., an empty DRI means there is no daily recommended intake for that nutrient by default).',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'You can also leave things blank to remove their DRI or UL.',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'You can click the ? icon to see more information about any specific nutrient that has it.',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}


// Text driConfigIntro = Text('''
// Welcome to the DRI configuration page. A quick refresher on the terminology:
//
//   DRI: Daily Recommended Intake (Always the number on the left)
//   UL: Upper Tolerable Limit (Always the number on the right)
//
//
// These DRIs are calculated from the NSDA website based on the anthropomorphic data in the settings. Be careful regarding what you change and what you eat.
// This App is not responsible for your health please consult a qualified dietitian before making any changes, and please double check your anthropomorphic data before making any diets (as his is what the NSDA website uses to determine your DRIs).
//
// The DRIs are diet specific so what you change here will only affect (diet.name).
//
// The checkbox indicates you tracking that nutrient; any nutrient with a tick will be shown in the comprehensive Nutrients, whereas those that are unchecked will be omitted.
//
// If a field is empty that means that nutrient doesnt have that field, (IE an empty DRI means there is no daily recommended intake for that nutrient by default)
// You can also leave things blank to remove their DRI or UL.
//
// You can click the ? icon to see more information about any specific nutrient that has it.
//
// '''
//     .trim());