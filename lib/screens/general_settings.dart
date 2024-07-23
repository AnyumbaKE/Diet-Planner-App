import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/blocs/settings/settings_bloc.dart';
import 'package:diet_planner/utils.dart';
import 'package:diet_planner/domain.dart';
import '../blocs/init/init_bloc.dart';

class GeneralSettingsPage extends StatelessWidget {
  late final TextEditingController cmCon;
  late final TextEditingController inchesCon;
  late final TextEditingController feetCon;
  late final TextEditingController weightCon;

  GeneralSettingsPage(Settings settings, {Key? key}) : super(key: key) {
    cmCon = TextEditingController(text: settings.anthroMetrics.cm.toString());
    inchesCon =
        TextEditingController(text: settings.anthroMetrics.inches.toString());
    feetCon =
        TextEditingController(text: settings.anthroMetrics.feet.toString());
    if (settings.measure == Measure.imperial) {
      weightCon =
          TextEditingController(text: settings.anthroMetrics.weight.toString());
    } else {
      weightCon =
          TextEditingController(text: settings.anthroMetrics.kg.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final App app = context.read<InitBloc>().state.app!;
    final settingsBloc = context.read<SettingsBloc>();
    // Wrap with bloc
    return Scaffold(
        appBar: AppBar(
          title: const Text('General Settings'),
          leading: IconButton(
            onPressed: () {
              saveSettings(app.settings);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        // resizeToAvoidBottomInset: false,
        body: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsMeasureChange) {
              if (state.measure == Measure.metric) {
                weightCon.text = state.settings.anthroMetrics.kg.toString();
                cmCon.text = state.settings.anthroMetrics.cm.toString();
              } else {
                weightCon.text = state.settings.anthroMetrics.weight.toString();
                feetCon.text = state.settings.anthroMetrics.feet.toString();
                inchesCon.text = state.settings.anthroMetrics.inches.toString();
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: PaddedColumn(
                edgeInsets: const EdgeInsets.all(8.0),
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          context
                              .read<SettingsBloc>()
                              .add(MeasureUpdate(Measure.imperial));
                        },
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Text('Imperial')),
                      ),
                      InkWell(
                        onTap: () {
                          context
                              .read<SettingsBloc>()
                              .add(MeasureUpdate(Measure.metric));
                        },
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Text('Metric')),
                      )
                    ],
                  ),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      if (state.settings.measure == Measure.metric) {
                        return Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                              child: Text('Height: '),
                            ),
                            Flexible(
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'centimeters',
                                  ),
                                  controller: cmCon,
                                  onChanged: (val) {
                                    context
                                        .read<SettingsBloc>()
                                        .add(CmUpdate(val));
                                  },
                                  // initialValue:
                                  // state.settings.anthroMetrics.cm.toString(),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ]),
                            )
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            const Text('Feet: '),
                            Flexible(
                              child: TextFormField(
                                  controller: feetCon,
                                  onChanged: (val) {
                                    context
                                        .read<SettingsBloc>()
                                        .add(FeetUpdate(val));
                                  },
                                  // initialValue: state.settings.anthroMetrics.feet
                                  //     .toString(),
                                  decoration: const InputDecoration(
                                    labelText: 'feet',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ]),
                            ),
                            const Text('Inches: '),
                            Flexible(
                              child: TextFormField(
                                  controller: inchesCon,
                                  // initialValue: state
                                  //     .settings.anthroMetrics.inches
                                  //     .toString(),
                                  onChanged: (val) {
                                    context
                                        .read<SettingsBloc>()
                                        .add(InchesUpdate(val));
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'in',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^1[01]|^\d'))
                                  ]),
                            )
                          ],
                        );
                      }
                    },
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                        child: Text('Weight: '),
                      ),
                      Flexible(
                        child: BlocBuilder<SettingsBloc, SettingsState>(
                          builder: (context, state) {
                            return TextFormField(
                                controller: weightCon,
                                // initialValue: state.settings.measure ==
                                //     Measure.imperial
                                //     ? state.settings.anthroMetrics.weight
                                //     .toString()
                                //     : state.settings.anthroMetrics.kg.toString(),
                                onChanged: (val) {
                                  if (state.settings.measure ==
                                      Measure.metric) {
                                    context
                                        .read<SettingsBloc>()
                                        .add(KgUpdate(val));
                                  } else {
                                    context
                                        .read<SettingsBloc>()
                                        .add(WeightUpdate(val));
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText:
                                      state.settings.measure == Measure.metric
                                          ? 'kilograms'
                                          : 'pounds',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ]);
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                        child: Text('Age: '),
                      ),
                      Flexible(child: BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                          return TextFormField(
                              onChanged: (val) {
                                context
                                    .read<SettingsBloc>()
                                    .add(AgeUpdate(val));
                              },
                              initialValue:
                                  state.settings.anthroMetrics.age.toString(),
                              decoration: const InputDecoration(
                                labelText: 'years',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ]);
                        },
                      )),
                    ],
                  ),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          const Text('Sex: '),
                          InkWell(
                            onTap: () {
                              context
                                  .read<SettingsBloc>()
                                  .add(SexUpdate(Sex.M));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              color: state.settings.anthroMetrics.sex == Sex.M
                                  ? Colors.green
                                  : null,
                              child: const Text('Male'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context
                                  .read<SettingsBloc>()
                                  .add(SexUpdate(Sex.F));
                            },
                            child: Container(
                                color: state.settings.anthroMetrics.sex == Sex.F
                                    ? Colors.green
                                    : null,
                                padding: const EdgeInsets.all(12),
                                child: const Text('Female')),
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    children: [
                      const Text('API Key: '),
                      Flexible(child: BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                          return TextFormField(
                            initialValue: state.settings.apikey.toString(),
                            onChanged: (val) {
                              context
                                  .read<SettingsBloc>()
                                  .add(ApiKeyUpdate(val));
                            },
                          );
                        },
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      const Text('API ID: '),
                      Flexible(child: BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                          return TextFormField(
                            initialValue: state.settings.appId.toString(),
                            onChanged: (val) {
                              context
                                  .read<SettingsBloc>()
                                  .add(AppIdUpdate(val));
                            },
                          );
                        },
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Dark mode: '),

                      /// Default = settings dark mode (which will be sys pref) onChange updates settings,
                      BlocConsumer<SettingsBloc, SettingsState>(
                        listener: (context, state) {
                          if (state is SettingsStateDarkModeUpdate) {
                            // context.read<InitBloc>().add(ReloadApp());
                          }
                        },
                        builder: (context, state) {
                          return Switch(
                              value: state.settings.darkMode,
                              onChanged: (bool val) {
                                context
                                    .read<SettingsBloc>()
                                    .add(DarkModeUpdate(val));
                              });
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                        child: Text('Estimated Activity Level: '),
                      ),
                      BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                          return DropdownButton<Activity>(
                              value: state.settings.anthroMetrics.activity,
                              onChanged: (Activity? act) {
                                if (act != null) {
                                  context
                                      .read<SettingsBloc>()
                                      .add(ActivityUpdate(act));
                                }
                              },
                              items: Activity.values
                                  .map<DropdownMenuItem<Activity>>(
                                      (Activity act) =>
                                          DropdownMenuItem<Activity>(
                                              value: act,
                                              child: Text(Activity.toStr(act))))
                                  .toList());
                        },
                      )
                    ],
                  ),
                  BlocListener<SettingsBloc, SettingsState>(
                    listener: (context, state) {
                      if (state is LocalBackUpSuccess) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('A back up of the app has been saved!'),
                          backgroundColor: Colors.green,
                        ));
                      }
                      if (state is LocalBackUpFailure) {
                        showErrorMessage(
                            context, 'Couldn\'t save backup :(\n${state.err}');
                      }
                    },
                    child: ElevatedButton(
                        onPressed: () async {
                          if (isMobile()) {
                            String? fname = await showDialog(
                                context: context,
                                builder: (context) => nameAThing(context,
                                    title: 'Back Up Name (w/o extension)'));
                            if (fname == null) {
                              return;
                            }
                            try {
                              saveAppBackupMobile(app: app, fileName: fname);
                              settingsBloc.add(BackupSuccess());
                            } on Exception catch (e) {
                              settingsBloc.add(BackupFailure(e.toString()));
                            }
                          }
                        },
                        child: const Text('Save Local Back Up')),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Factory Reset'),
                                    content: const PaddedColumn(
                                      mainAxisSize: MainAxisSize.min,
                                      edgeInsets: EdgeInsets.all(12),
                                      children: [
                                        Text(
                                            'Warning you are currently attempting to clear all'
                                            'data from the app!'),
                                        Text(
                                            'If you have no local back ups cancel this and save one. If you don\'t '
                                            'all data will be irrecoverably lost.'),
                                        Text(
                                            'Are you sure you wish to proceed?')
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel')),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  context
                                                      .read<InitBloc>()
                                                      .add(FactoryReset());
                                                },
                                                child: const Text(
                                                    'Delete All Data')),
                                          )
                                        ],
                                      )
                                    ],
                                  ));
                        },
                        child: const Text('Factory Reset App')),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
