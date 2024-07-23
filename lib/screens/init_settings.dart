import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/init/init_bloc.dart';
import '../blocs/init/settings/init_settings_bloc.dart';
import 'package:diet_planner/utils.dart';
import 'package:diet_planner/domain.dart';
import 'package:flutter/services.dart';

class GeneralSettingsPageInit extends StatelessWidget {
  const GeneralSettingsPageInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap with bloc
    return Scaffold(
        appBar: AppBar(title: const Text('General Settings')),
        // resizeToAvoidBottomInset: false,
        body: BlocListener<InitSettingsBloc, InitSettingsState>(
          listener: (context, state) {
            if (state is InitSettingsSuccessfulLoad) {
              context.read<InitBloc>().add(CreatedNewSettings(state.settings));
            }
          },
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: PaddedColumn(
                  edgeInsets: const EdgeInsets.all(8.0),
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          launchUrl(Uri.parse(
                              'https://developer.nutritionix.com/signup'));
                        },
                        child: const Text('Nutrionix Sign Up')),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            context
                                .read<InitSettingsBloc>()
                                .add(MeasureUpdate(Measure.imperial));
                          },
                          child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Text('Imperial')),
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read<InitSettingsBloc>()
                                .add(MeasureUpdate(Measure.metric));
                          },
                          child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Text('Metric')),
                        )
                      ],
                    ),
                    BlocBuilder<InitSettingsBloc, InitSettingsState>(
                      builder: (context, state) {
                        if (state.measure == Measure.metric) {
                          return Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                child: Text('Height: '),
                              ),
                              Flexible(
                                child: BlocBuilder<InitSettingsBloc,
                                    InitSettingsState>(
                                  builder: (context, state) {
                                    return TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'centimeters',
                                          errorText: state.errorCm
                                              ? 'Required field Height'
                                              : null),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (val) {
                                        context
                                            .read<InitSettingsBloc>()
                                            .add(CmUpdate(val));
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                    child: Text('Feet: '),
                                  ),
                                  Flexible(
                                    child: BlocBuilder<InitSettingsBloc,
                                        InitSettingsState>(
                                      builder: (context, state) {
                                        return TextFormField(
                                            decoration: InputDecoration(
                                                labelText: 'feet',
                                                errorText: state.errorFeet
                                                    ? 'Required field Feet'
                                                    : null),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onChanged: (val) {
                                              context
                                                  .read<InitSettingsBloc>()
                                                  .add(FeetUpdate(val));
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                    child: Text('Inches: '),
                                  ),
                                  Flexible(
                                    child: BlocBuilder<InitSettingsBloc,
                                        InitSettingsState>(
                                      builder: (context, state) {
                                        return TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'in',
                                              errorText: state.errorInches
                                                  ? 'Required field Inches'
                                                  : null),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (val) {
                                            context
                                                .read<InitSettingsBloc>()
                                                .add(InchesUpdate(val));
                                          },
                                        );
                                      },
                                    ),
                                  )
                                ],
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
                          child:
                              BlocBuilder<InitSettingsBloc, InitSettingsState>(
                            builder: (context, state) {
                              return TextFormField(
                                  onChanged: (val) {
                                    context
                                        .read<InitSettingsBloc>()
                                        .add(WeightUpdate(val));

                                    context
                                        .read<InitSettingsBloc>()
                                        .add(KgUpdate(val));
                                  },
                                  decoration: InputDecoration(
                                    errorText:
                                        state.errorWeight || state.errorKg
                                            ? 'Required field weight'
                                            : null,
                                    labelText: state.measure == Measure.metric
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
                        Flexible(
                          child:
                              BlocBuilder<InitSettingsBloc, InitSettingsState>(
                            builder: (context, state) {
                              return TextFormField(
                                  onChanged: (val) {
                                    context
                                        .read<InitSettingsBloc>()
                                        .add(AgeUpdate(val));
                                  },
                                  decoration: InputDecoration(
                                    errorText: state.errorAge
                                        ? 'Required field age'
                                        : null,
                                    labelText: 'years',
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
                    BlocBuilder<InitSettingsBloc, InitSettingsState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            const Text('Sex: '),
                            InkWell(
                              onTap: () {
                                context
                                    .read<InitSettingsBloc>()
                                    .add(SexUpdate(Sex.M));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                color: state.sex == Sex.M ? Colors.green : null,
                                child: const Text('Male'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<InitSettingsBloc>()
                                    .add(SexUpdate(Sex.F));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(12),
                                  color:
                                      state.sex == Sex.F ? Colors.green : null,
                                  child: const Text('Female')),
                            ),
                          ],
                        );
                      },
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                          child: Text('API Key: '),
                        ),
                        Flexible(child:
                            BlocBuilder<InitSettingsBloc, InitSettingsState>(
                          builder: (context, state) {
                            return TextFormField(
                              decoration: InputDecoration(
                                  errorText: state.errorApiKey
                                      ? 'Required field API key'
                                      : null),
                              onChanged: (val) {
                                context
                                    .read<InitSettingsBloc>()
                                    .add(ApiKeyUpdate(val));
                              },
                            );
                          },
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                          child: Text('API ID: '),
                        ),
                        Flexible(child:
                            BlocBuilder<InitSettingsBloc, InitSettingsState>(
                          builder: (context, state) {
                            return TextFormField(
                              decoration: InputDecoration(
                                  errorText: state.errorAppId
                                      ? 'Required field API ID'
                                      : null),
                              onChanged: (val) {
                                context
                                    .read<InitSettingsBloc>()
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
                        BlocBuilder<InitSettingsBloc, InitSettingsState>(
                          builder: (context, state) {
                            return Switch(
                                value: state.darkMode,
                                onChanged: (val) {
                                  context
                                      .read<InitSettingsBloc>()
                                      .add(DarkModeUpdate(val));
                                });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                          child: Text('Estimated Activity Level: '),
                        ),
                        BlocBuilder<InitSettingsBloc, InitSettingsState>(
                          builder: (context, state) {
                            return DropdownButton<Activity>(
                                value: state.activity,
                                onChanged: (Activity? act) {
                                  if (act != null) {
                                    context
                                        .read<InitSettingsBloc>()
                                        .add(ActivityUpdate(act));
                                  }
                                },
                                items: Activity.values
                                    .map<DropdownMenuItem<Activity>>(
                                        (Activity act) =>
                                            DropdownMenuItem<Activity>(
                                                value: act,
                                                child:
                                                    Text(Activity.toStr(act))))
                                    .toList());
                          },
                        )
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          context
                              .read<InitSettingsBloc>()
                              .add(SubmitInitSettings());
                        },
                        child: const Text('Submit'))
                  ],
                ),
              )),
        ));
  }
}
