import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// List: List to combine elements of
/// Keyizer: Function to get key from an element of the list.
///
/// Valueizer: Function to get map's value from an element of a list relative
/// its key from keyizer.
///
/// Combinator: Function to combine derived values of two list elements whose
/// keyizer function returned the same key.
///
/// Example use case
/// ```dart
/// class Wallet{
///   owner string;
///   value int;
///   Wallet(this.owner, this.string)
/// }
///
/// List<Wallet> wallets = [
///   Wallet('A', 1),
///   Wallet('A', 1),
///   Wallet('A', 1),
///   Wallet('B', 1),
///   Wallet('B', 1),
///   Wallet('B', 1)
///   ];
///
/// // Generics wont show in code example but are (in order): Wallet, String, int
///
/// combineListValuesToMap<Wallet, String, int>(
///   wallets,
///   (Wallet elemToKey) => elemToKey.owner,
///   (Wallet elemToValue) => elemToValue.value,
///   (int existingSameKeyValue, int newSameKeyValue) => existingSameKeyValue + newSameKeyValue
/// )
/// // The above Returns {'A': 3, 'B': 3}
/// ```
Map<T1, T2> combineListValuesToMap<E, T1, T2>(
    List<E> list,
    T1 Function(E elemToKey) keyizer,
    T2 Function(E elemToValue) valueizer,
    T2 Function(T2 existingSameKeyValue, T2 newSameKeyValue) combinator) {
  Map<T1, T2> result = {};
  for (E entry in list) {
    T1 key = keyizer(entry);
    T2 value = valueizer(entry);
    if (result[key] == null) {
      result[key] = value;
    } else {
      result[key] = combinator(result[key] as T2, value);
    }
  }
  return result;
}

Iterable<T> flatten<T>(Iterable<dynamic> iterable) sync* {
  for (final element in iterable) {
    if (element is Iterable<dynamic>) {
      yield* flatten<T>(element);
    } else {
      yield element as T;
    }
  }
}

bool isMobile() => Platform.isAndroid || Platform.isIOS;

/// In Dart Maps are ordered so you can re-order them.
/// Accepts negative indices (pythonic)
/// Returns a shallow copy of the list (not done in place)
Map<K, V> reorderMap<K, V>(Map<K, V> map, int oldIndex, int newIndex,
    {bool safe = false}) {
  if (oldIndex == newIndex) {
    return map;
  }
  if (oldIndex > map.length) {
    throw RangeError(
        'Old Index $oldIndex is out of range (Map length = ${map.length})');
  }

  while (oldIndex < 0) {
    oldIndex += map.length;
  }
  while (newIndex < 0) {
    oldIndex += map.length;
  }
  List<MapEntry<K, V>> entries = map.entries.toList();
  MapEntry<K, V> item = entries[oldIndex];
  entries.removeAt(oldIndex);
  // print('len ${entries.length} new $newIndex old $oldIndex');
  if (newIndex > entries.length) {
    if (safe) {
      throw RangeError(
          'New Index $newIndex is out of range (Map length = ${map.length})');
    }
    entries.add(item);
  } else {
    entries.insert(newIndex, item);
  }
  return Map<K, V>.fromEntries(entries);
}

class ImperialHeight {
  int feet;
  int inches;

  ImperialHeight({
    required this.feet,
    required this.inches,
  });
  factory ImperialHeight.fromInches(int inches) =>
      ImperialHeight(feet: inches ~/ 12, inches: inches % 12);
}

int cm2in(num cm) => (0.393701 * cm).round();
int in2cm(num inches) => (2.54 * inches).round();
int kg2lb(num kg) => (2.20462 * kg).round();
int lb2kg(num lb) => (0.453592 * lb).round();

num? fixDecimal(String string) {
  string =
      string.endsWith('.') ? string.substring(0, string.length - 1) : string;
  if (string.isEmpty) {
    return null;
  }
  return num.parse(string);
}

bool isAmerican() =>
    Platform.localeName == 'en_US' || Platform.localeName == 'es_US';

extension ColumnPadding on Column {
  Column pad(EdgeInsetsGeometry padding) {
    return Column(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children:
          children.map((e) => Padding(padding: padding, child: e)).toList(),
    );
  }
}

class PaddedColumn extends StatelessWidget {
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextBaseline? textBaseline;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;
  final List<Widget> children;
  final EdgeInsets edgeInsets;
  const PaddedColumn(
      {Key? key,
      this.mainAxisAlignment,
      this.mainAxisSize,
      this.crossAxisAlignment,
      this.textBaseline,
      this.textDirection,
      this.verticalDirection,
      required this.children,
      required this.edgeInsets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: VerticalDirection.down,
      children:
          children.map((e) => Padding(padding: edgeInsets, child: e)).toList(),
    );
  }
}

List<Padding> padWidgets(List<Widget> widgets, EdgeInsetsGeometry padding) =>
    widgets.map((e) => Padding(padding: padding, child: e)).toList();

extension RowPadding on Row {
  Row pad(EdgeInsetsGeometry padding) => Row(
        key: key,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textBaseline: textBaseline,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        children:
            children.map((e) => Padding(padding: padding, child: e)).toList(),
      );
}

// Image getImage(Uri? uri, {double? width, double? height}){
//   if (uri == null){
//     return Image.asset('cache/images/null.png', width: width, height: height,);
//   }
//   try{
//     if (uri.scheme == 'file'){
//       return Image.file(File(uri.path), width: width, height: height,);
//       }
//     else{
//       return Image.network(uri.toString(), width: width, height: height,);
//       }
//   }
//   catch (e){
//     // Maybe add snackbar or alt image for no internet
//     return Image.asset('cache/images/null.png', width: width, height: height,);
//   }
// }

// class GetImage extends StatefulWidget {
//   final Uri? uri;
//   final double? width;
//   final double? height;
//   final bool cache;
//   const GetImage(this.uri, {Key? key, this.width, this.height, this.cache = true}) : super(key: key);
//
//   @override
//   State<GetImage> createState() => _GetImageState();
// }
//
// class _GetImageState extends State<GetImage> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.uri == null){
//       return Image.asset('cache/images/null.png',
//         width: widget.width,
//         height: widget.height,);
//     }
//     try{
//       if (widget.uri!.scheme == 'file'){
//         return ExtendedImage.file(
//           File(widget.uri!.path),
//           width: widget.width, //?? 75,
//           height: widget.height ?? 120,
//         );
//       }
//       else{
//         return ExtendedImage.network(
//           widget.uri.toString(),
//           width: widget.width, // ?? 75,
//           height: widget.height ?? 120,
//           cache: widget.cache,
//           retries: 6,
//
//         );
//       }
//     }
//     catch (e){
//       // Maybe add snackbar or alt image for no internet
//       return Image.asset('cache/images/null.png',
//         width: widget.width,
//         height: widget.height,);
//     }
//   }
//   }

class GetImage extends StatelessWidget {
  final Uri? uri;
  final double width;
  final double height;
  final bool cache;
  final int? cW;
  final int? cH;

  const GetImage(this.uri,
      {Key? key,
      this.width = 100,
      this.height = 100,
      this.cache = true,
      this.cH,
      this.cW})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (uri == null) {
      return Image.asset(
        'cache/images/null.png',
        width: width,
        height: height,
      );
    }
    try {
      if (uri!.scheme == 'file') {
        return ExtendedImage.file(
          File(uri!.path),
          width: width,
          height: height,
          cacheWidth: cW ?? width.round() * 4,
          cacheHeight: cH ?? height.round() * 4,
        );
      } else {
        return ExtendedImage.network(
          uri.toString(),
          width: width,
          height: height,
          cacheHeight: cH ?? height.round() * 4,
          cacheWidth: cW ?? width.round() * 4,
          // cache: cache,
          // retries: 6,
        );
      }
    } catch (e) {
      // Maybe add snackbar or alt image for no internet
      return Image.asset(
        'cache/images/null.png',
        width: width,
        height: height,
      );
    }
  }
}

@immutable
class KeyHolder<T1, T2, T3, T4, T5, T6> {
  final T1 value1;
  final T2 value2;
  final T3? value3;
  final T4? value4;
  final T5? value5;
  final T6? value6;

  const KeyHolder({
    required this.value1,
    required this.value2,
    this.value3,
    this.value4,
    this.value5,
    this.value6,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyHolder &&
          runtimeType == other.runtimeType &&
          value1 == other.value1 &&
          value2 == other.value2 &&
          value3 == other.value3 &&
          value4 == other.value4 &&
          value5 == other.value5 &&
          value6 == other.value6;

  @override
  int get hashCode =>
      value1.hashCode ^
      value2.hashCode ^
      value3.hashCode ^
      value4.hashCode ^
      value5.hashCode ^
      value6.hashCode;

  ValueKey<KeyHolder<T1, T2, T3, T4, T5, T6>> key() => ValueKey(this);
}

List<T> sorter<T>(List<T> list, Function(T)? key) {
  key ??= (T obj) => obj;
  final copy = List.from(list);
  copy.sort((a, b) => key!(a).compareTo(key(b)));
  return List<T>.from(copy);
}

final emoji = EmojiParser();
final olive = emoji.get('olive').code;
final butter = emoji.get('butter').code;

AlertDialog deleteConfirmation(
    {required void Function(BuildContext context) onSubmit,
    required BuildContext context,
    String? obj}) {
  obj ??= 'this';
  return AlertDialog(
    content: Text('Are you sure you would like to delete $obj?'),
    actions: [
      Row(
        children: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('cancel')),
          const Spacer(),
          TextButton(
              onPressed: () {
                onSubmit(context);
                Navigator.pop(context);
              },
              child: const Text('submit'))
        ],
      ),
    ],
  );
}

void dialog(BuildContext context, AlertDialog alertDialog) {
  showDialog(context: context, builder: (context) => alertDialog);
}

Future<Uri> saveImage(String imagePath) async {
  final dir = await getApplicationDocumentsDirectory();
  final name = basename(imagePath);
  final img = File(join(dir.path, name));
  final result = await File(imagePath).copy(img.path);
  return Uri.file(result.path, windows: Platform.isWindows);
}

String duplicateNamer(iterWithName, thingToName) {
  if (iterWithName is! Iterable<String>) {
    iterWithName = iterWithName.map((e) => e.name);
  }
  if (thingToName is! String) {
    thingToName = thingToName.name;
  }
  // var x = 'a'.s;
  if (RegExp(r'\(\d+\)$').hasMatch(thingToName)) {
    final upto = RegExp(r' \(\d+\)$').firstMatch(thingToName)!.start;
    thingToName = thingToName.substring(0, upto);
  }
  final regex = RegExp('^' + thingToName + r' \((\d+)\)$');
  int highestInt = 1;
  for (String name in iterWithName) {
    Match? match = regex.firstMatch(name);
    if (match != null) {
      int newNum = int.parse(match.group(1)!);
      if (newNum > highestInt) {
        highestInt = newNum;
      }
    }
  }
  return '$thingToName (${highestInt + 1})';
}

List<T> sortByOtherList<T>(
    List<T> objectList, List orderList, Object Function(T) key) {
  List<T> copy = List.from(objectList);
  copy.sort((a, b) {
    int indexA = orderList.indexOf(key(a));
    int indexB = orderList.indexOf(key(b));
    return indexA.compareTo(indexB);
  });
  return copy;
}

extension ListReIndex<T> on List<T> {
  List<T> reIndex(int old, int new_, {bool safe = true, bool inPlace = false}) {
    while (old < 0) {
      old += length;
    }
    while (new_ < 0) {
      new_ += length;
    }
    final item = this[old];
    final toModfiy = inPlace ? this : List<T>.from(this);
    toModfiy.removeAt(old);
    if (safe && new_ >= length) {
      toModfiy.add(item);
      return toModfiy;
    }
    toModfiy.insert(new_, item);
    return toModfiy;
  }
}
