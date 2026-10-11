import 'package:diacritic/diacritic.dart';

final _digits = RegExp(r'\d+');

/// Orders album names the way a person reads them: without regard to case or
/// accents, and with runs of digits compared by value, so `Game 2` comes before
/// `Game 10`. Names that fold to the same key fall back to [String.compareTo],
/// so two different names never compare as equal.
int compareNames(String left, String right) {
  final a = _fold(left);
  final b = _fold(right);
  var i = 0;
  var j = 0;
  while (i < a.length && j < b.length) {
    final numberA = _digits.matchAsPrefix(a, i);
    final numberB = _digits.matchAsPrefix(b, j);
    if (numberA != null && numberB != null) {
      final result = BigInt.parse(numberA[0]!)
          .compareTo(BigInt.parse(numberB[0]!));
      if (result != 0) {
        return result;
      }
      i = numberA.end;
      j = numberB.end;
      continue;
    }
    final result = a.codeUnitAt(i).compareTo(b.codeUnitAt(j));
    if (result != 0) {
      return result;
    }
    i++;
    j++;
  }
  final result = (a.length - i).compareTo(b.length - j);
  return result != 0 ? result : left.compareTo(right);
}

/// [removeDiacritics] also drops the combining marks of a name read from an
/// HFS+ volume, which arrives decomposed.
String _fold(String name) => removeDiacritics(name).toLowerCase();
