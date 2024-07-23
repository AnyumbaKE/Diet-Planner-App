import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/blocs/ingredients_page/ingredients_page_bloc.dart';
import 'package:diet_planner/utils.dart';
import 'package:diet_planner/domain.dart';

class MealPage extends StatelessWidget {
  MealPage({Key? key}) : super(key: key);
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ingPgBloc = context.read<IngredientsPageBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        actions: [
          const Center(
              child: Text('Sub-Recipes',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic))),
          BlocConsumer<IngredientsPageBloc, IngredientsPageState>(
            listener: (context, state) {
              if (state is IngPageSuccessfulCreation) {
                searchController.text = '';
                if (state.backReference) {
                  Navigator.pop(context, state.ingredient);
                }
              }
            },
            builder: (context, state) {
              return Switch(
                  value: state.includeSubRecipes,
                  onChanged: (toggle) {
                    ingPgBloc.add(IngPageIncludeSubRecipes(toggle));
                  });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(5, 8, 5, 2.5),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    contentPadding: const EdgeInsets.all(20),
                    suffixIcon: const Icon(Icons.search)),
                onChanged: (val) {
                  ingPgBloc.add(UpdateSearchIng(val));
                },
              )),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: MCFactoryListViewStless(
                searchController,
                pgIsIng: false,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MealPopUpEnumHolder {
  const MealPopUpEnumHolder(Meal meal, PopUpOptions option);
}

// ListTile mealTile(Meal meal){
//   // print(meal.photo);
//   return ListTile(
//     title: Text(meal.name),
//     trailing: PopupMenuButton(
//       itemBuilder: (BuildContext context) => [
//       PopupMenuItem(value: MealPopUpEnumHolder(meal, PopUpOptions.edit),child: const Text('Edit'),),
//       PopupMenuItem(value: MealPopUpEnumHolder(meal, PopUpOptions.delete), child: const Text('Delete')),
//       PopupMenuItem(value: MealPopUpEnumHolder(meal, PopUpOptions.duplicate),child: const Text('Duplicate'),),
//       ],
//     ),
//     subtitle: Text(
//             'Serving:  '
//             "${meal.baseNutrient.nutrients.calories.value.round()}\u{1F525}  "
//             '${meal.baseNutrient.nutrients.carbohydrate.value.round()}\u{1F35E}  '
//             '${meal.baseNutrient.nutrients.protein.value.round()}\u{1F969}  '
//             // '${meal.baseNutrient.nutrients.unsaturatedFat.value.round()}\u{1FAD2}  '
//             '${meal.baseNutrient.nutrients.unsaturatedFat.value.round()}$olive  '
//             // '${meal.baseNutrient.nutrients.saturatedFat.value.round()}\u{1F9C8}',
//             '${meal.baseNutrient.nutrients.saturatedFat.value.round()}$butter'
//     ),
//     // subtitle: RichText(
//     //   text: TextSpan(
//     //     children:[
//     //       TextSpan(text: 'Serving:  '),
//     //       TextSpan(text: "${meal.baseNutrient.nutrients.calories.value.round()}\u{1F525}  "),
//     //       TextSpan(text: '\u{1F525}  ', style: TextStyle(fontFamily: 'EmojiOne')),
//     //       TextSpan(text: '${meal.baseNutrient.nutrients.carbohydrate.value.round()}\u{1F35E}  '),
//     //       TextSpan(text: '\u{1F35E}  ', style: TextStyle(fontFamily: 'EmojiOne')),
//     //       TextSpan(text: '${meal.baseNutrient.nutrients.protein.value.round()}\u{1F969}  '),
//     //       TextSpan(text: '\u{1F969}  ', style: TextStyle(fontFamily: 'EmojiOne')),
//     //       // '${meal.baseNutrient.nutrients.unsaturatedFat.value.round()}\u{1FAD2}  '
//     //       TextSpan(text: '${meal.baseNutrient.nutrients.unsaturatedFat.value.round()}$olive  '),
//     //       TextSpan(text: '$olive  ', style: GoogleFonts.notoColorEmoji()),
//     //       // '${meal.baseNutrient.nutrients.saturatedFat.value.round()}\u{1F9C8}',
//     //       TextSpan(text: '${meal.baseNutrient.nutrients.saturatedFat.value.round()}$butter'),
//     //       TextSpan(text: '$butter  ', style: GoogleFonts.notoColorEmoji()),
//     //     ]
//     //   )
//     // ),
//     leading: GetImage(meal.photo),
//     onTap: (){},
//   );
// }

class MealTile extends StatelessWidget {
  final Meal meal;

  const MealTile(this.meal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(meal.name),
      trailing: PopupMenuButton(
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: MealPopUpEnumHolder(meal, PopUpOptions.edit),
            child: const Text('Edit'),
          ),
          PopupMenuItem(
              value: MealPopUpEnumHolder(meal, PopUpOptions.delete),
              child: const Text('Delete')),
          PopupMenuItem(
            value: MealPopUpEnumHolder(meal, PopUpOptions.duplicate),
            child: const Text('Duplicate'),
          ),
        ],
      ),
      // subtitle: Text(
      //     'Serving:  '
      //         "${meal.baseNutrient.nutrients.calories.value.round()}\u{1F525}  "
      //         '${meal.baseNutrient.nutrients.carbohydrate.value.round()}\u{1F35E}  '
      //         '${meal.baseNutrient.nutrients.protein.value.round()}\u{1F969}  '
      //     // '${meal.baseNutrient.nutrients.unsaturatedFat.value.round()}\u{1FAD2}  '
      //         '${meal.baseNutrient.nutrients.unsaturatedFat.value.round()}$olive  '
      //     // '${meal.baseNutrient.nutrients.saturatedFat.value.round()}\u{1F9C8}',
      //         '${meal.baseNutrient.nutrients.saturatedFat.value.round()}$butter'
      // ),
      // subtitle: RichText(
      //   text: TextSpan(
      //     children:[
      //       TextSpan(text: 'Serving:  '),
      //       TextSpan(text: "${meal.baseNutrient.nutrients.calories.value.round()}\u{1F525}  "),
      //       TextSpan(text: '\u{1F525}  ', style: TextStyle(fontFamily: 'EmojiOne')),
      //       TextSpan(text: '${meal.baseNutrient.nutrients.carbohydrate.value.round()}\u{1F35E}  '),
      //       TextSpan(text: '\u{1F35E}  ', style: TextStyle(fontFamily: 'EmojiOne')),
      //       TextSpan(text: '${meal.baseNutrient.nutrients.protein.value.round()}\u{1F969}  '),
      //       TextSpan(text: '\u{1F969}  ', style: TextStyle(fontFamily: 'EmojiOne')),
      //       // '${meal.baseNutrient.nutrients.unsaturatedFat.value.round()}\u{1FAD2}  '
      //       TextSpan(text: '${meal.baseNutrient.nutrients.unsaturatedFat.value.round()}$olive  '),
      //       TextSpan(text: '$olive  ', style: GoogleFonts.notoColorEmoji()),
      //       // '${meal.baseNutrient.nutrients.saturatedFat.value.round()}\u{1F9C8}',
      //       TextSpan(text: '${meal.baseNutrient.nutrients.saturatedFat.value.round()}$butter'),
      //       TextSpan(text: '$butter  ', style: GoogleFonts.notoColorEmoji()),
      //     ]
      //   )
      // ),
      subtitle: NutrientText(nutrients: meal.baseNutrient.nutrients),
      leading: GetImage(meal.photo),
      onTap: () {},
    );
  }
}
