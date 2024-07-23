import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/blocs/ingredients_page/ingredients_page_bloc.dart';
import 'package:diet_planner/domain.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:diet_planner/screens/ingredients_page.dart';
import 'package:diet_planner/utils.dart';
import '../blocs/init/init_bloc.dart';

class BarcodeReadingPage extends StatelessWidget {
  const BarcodeReadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode Reader')),
      body: BarcodeReaderForFood(
        ingPgBloc: context.read<IngredientsPageBloc>(),
      ),
    );
  }
}

class BarcodeReaderForFood extends StatelessWidget {
  bool _isDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;
  final IngredientsPageBloc ingPgBloc;

  const BarcodeReaderForFood({Key? key, required this.ingPgBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ReaderWidget(
        onScan: (Code code) {
          // <editor-fold desc="If Valid">
          // print(code.text?.length);
          // print(_isDialogShowing(context));
          if (code.isValid &&
              !_isDialogShowing(context) &&
              code.text.toString().length == 12)
          // </editor-fold>
          {
            print('Current is valid');
            Ingredient.fromApi(context.read<InitBloc>().state.app!.settings,
                    int.parse(code.text!))
                .then((value) {
              showDialog(
                  context: context,
                  builder: (context) => BlocProvider.value(
                        value: ingPgBloc,
                        child: confirmIngredient(value, context, ingPgBloc),
                      ));
            }, onError: (err) {
              showErrorMessage(context, err.toString());
              Future.delayed(const Duration(seconds: 4));
            });
          }
        },
        onScanFailure: (code) {
          // print('failure $code');
          // onErrFunc
        },
        isMultiScan: false,
        scanDelay: const Duration(milliseconds: 500),
      );
}
