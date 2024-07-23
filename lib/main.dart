import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nutrition_app/blocs/micro_blocs/saver.dart';
import 'package:nutrition_app/blocs/settings/settings_bloc.dart';
import 'package:nutrition_app/screens/index.dart';
import 'package:nutrition_app/screens/init.dart';
import 'blocs/index/index_bloc.dart';
import 'blocs/init/init_bloc.dart';
import 'blocs/init/settings/init_settings_bloc.dart';
import 'domain/nutrtion_app_domain.dart';
import 'utils.dart';

void main() async {
  await Hive.initFlutter();
  // debugInvertOversizedImages = true;
  runApp(MyApp(app: await loadApp()));
}

class MyApp extends StatelessWidget {
  final App? app;

  const MyApp({this.app, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(
          create: (context) {
            // runs async so need to call before
            final result = SaverBloc();
            RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
            Saver.init(result, rootIsolateToken);
            return result;
          },
          lazy: false,
        ),
        BlocProvider(create: (context) {
          final result = InitBloc();
          if (app != null) {
            result.add(ReloadApp(app: app));
          }
          return result;
        }),
        BlocProvider(create: (context) => InitSettingsBloc()),
        // BlocProvider(create: (context) => GlobalBloc())
      ],
      child: BlocBuilder<InitBloc, InitState>(
        builder: (context, state) {
          if (state is SuccessfulLoad) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (context) => SettingsBloc(state.app.settings)),
                BlocProvider(create: (context) => IndexBloc(state.app)),
              ],
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  return MaterialApp(
                    title: 'Nutrition App',
                    themeMode: settingsState.settings.darkMode
                        ? ThemeMode.dark
                        : ThemeMode.light,
                    theme: ThemeData(
                      primarySwatch: Colors.green,
                      // useMaterial3: true
                    ),
                    darkTheme: ThemeData(
                      brightness: Brightness.dark,
                      primarySwatch: Colors.green,
                      // useMaterial3: true
                    ),
                    home: const IndexPage(),
                    debugShowCheckedModeBanner: false,
                  );
                },
                buildWhen: (previousState, currentState) =>
                    currentState is SettingsStateDarkModeUpdate,
              ),
            );
          } else {
            return BlocBuilder<InitSettingsBloc, InitSettingsState>(
              builder: (context, state) {
                return MaterialApp(
                  title: 'Nutrition App',
                  themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
                  theme: ThemeData(
                    primarySwatch: Colors.green,
                  ),
                  darkTheme: ThemeData(
                      brightness: Brightness.dark, primarySwatch: Colors.green),
                  home: const InitPage(),
                  debugShowCheckedModeBanner: false,
                );
              },
            );
          }
        },
      ),
    );
  }
}
