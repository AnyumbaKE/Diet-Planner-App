import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/domain.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppingListBloc(Diet diet) : super(ShoppingListState.init(diet)) {
    on<ShoppingListEvent>((event, emit) {});
    on<ReIndexItem>((event, emit) {
      final movedItem = state.shoppingList[event.oldListIndex].value
          .removeAt(event.oldItemIndex);
      state.shoppingList[event.newListIndex].value
          .insert(event.newItemIndex, movedItem);
      emit(ShoppingListState.onMovement(
          state.diet, state.shoppingList, state.selected));
    });
    on<ReIndexList>((event, emit) {
      // final copy = List<MapEntry<String, List<MealComponent>>>.from(state.shoppingList);
      final movedList = state.shoppingList.removeAt(event.oldListIndex);
      state.shoppingList.insert(event.newListIndex, movedList);
      emit(ShoppingListState.onMovement(
          state.diet, state.shoppingList, state.selected));
    });
    on<ReorderWithinList>((event, emit) {
      final movedItem =
          state.shoppingList[event.listIndex].value.removeAt(event.oldIndex);
      state.shoppingList[event.listIndex].value
          .insert(event.newIndex, movedItem);
      emit(ShoppingListState.onMovement(
          state.diet, state.shoppingList, state.selected));
    });
    on<SelectItem>((event, emit) {
      if (state.selected.contains(event.item)) {
        state.selected.remove(event.item);
      } else {
        state.selected.add(event.item);
      }
      emit(state.copyWith());
    });
    on<ClearSelectedItems>((event, emit) {
      emit(state.copyWith(selected_: <MealComponent>[]));
    });
    on<SendSelectedItems>((event, emit) {
      state.moveItemsInSelected(event.target);
      emit(state.copyWith(selected_: <MealComponent>[]));
    });
  }
}

// @immutable
class ShoppingListEvent {}

class ReIndexItem extends ShoppingListEvent {
  final int oldItemIndex;
  final int oldListIndex;
  final int newItemIndex;
  final int newListIndex;

  ReIndexItem({
    required this.oldItemIndex,
    required this.oldListIndex,
    required this.newItemIndex,
    required this.newListIndex,
  });
}

class ReorderWithinList extends ShoppingListEvent {
  final int listIndex;
  final int oldIndex;
  final int newIndex;
  ReorderWithinList({
    required this.listIndex,
    required this.oldIndex,
    required this.newIndex,
  });
}

class ReIndexList extends ShoppingListEvent {
  final int oldListIndex;
  final int newListIndex;

  ReIndexList(this.oldListIndex, this.newListIndex);
}

class SelectItem extends ShoppingListEvent {
  MealComponent item;

  SelectItem(this.item);
}

class SendSelectedItems extends ShoppingListEvent {
  String target;
  SendSelectedItems(this.target);
}

class ClearSelectedItems extends ShoppingListEvent {}

// @immutable
class ShoppingListState {
  final Diet diet;
  List<MapEntry<String, List<MealComponent>>> shoppingList;
  final List<MealComponent> selected;

  Iterable<String> get categories => diet.shoppingList.keys;
  // 'Good': initShoppingList(),
  // 'Running Low': [],
  // 'Out of Stock': [],
  // 'On the Way': []

  ShoppingListState(this.diet,
      {required this.shoppingList, required this.selected});

  factory ShoppingListState.init(Diet diet) {
    diet.updateShoppingList();
    final shoppingList = diet.shoppingList.entries.toList();
    return ShoppingListState(diet,
        shoppingList: shoppingList, selected: <MealComponent>[]);
  }

  ShoppingListState.onMovement(this.diet, this.shoppingList, this.selected) {
    diet.shoppingList =
        Map<String, List<MealComponent>>.fromEntries(shoppingList);
    // print(diet.shoppingList.keys.toList());
  }

  ShoppingListState copyWith({
    Diet? diet_,
    List<MapEntry<String, List<MealComponent>>>? shoppingList_,
    List<MealComponent>? selected_,
  }) {
    return ShoppingListState(diet_ ?? diet,
        shoppingList: shoppingList_ ?? List.from(shoppingList),
        selected: selected_ ?? List.from(selected));
  }

  void moveItemsInSelected(String target) {
    for (MapEntry<String, List<MealComponent>> entry
        in diet.shoppingList.entries) {
      diet.shoppingList[entry.key] = entry.value
          .where((element) => !(selected.contains(element)))
          .toList();
    }
    diet.shoppingList[target] = [...diet.shoppingList[target]!, ...selected];
    shoppingList = diet.shoppingList.entries.toList();
  }
}

// class ShoppingListInitial extends ShoppingListState {}