import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/init/init_bloc.dart';
import 'init_settings.dart';

const waiver = 'Waiver';

class InitPage extends StatelessWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<InitBloc, InitState>(
        listener: (context, state) {
          if (state is FailedLoad) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Failed to load back up from ${state.basename}')));
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    context.read<InitBloc>().add(LoadFileInitEvent());
                  },
                  child: const Text('Restore From Back-Up')),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => waiverDialog(context));
                  },
                  child: const Text('New'))
            ],
          ),
        ),
      ),
    );
  }
}

AlertDialog waiverDialog(BuildContext context) => AlertDialog(
        content: Column(
      children: [
        const Text(waiver),
        ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GeneralSettingsPageInit()));
              // Make New App
            },
            child: const Text('Continue'))
      ],
    ));
