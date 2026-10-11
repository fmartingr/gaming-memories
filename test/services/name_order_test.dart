import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_memories/services/name_order.dart';

void main() {
  test('sorts without regard to case or accents, and numbers by value', () {
    final names = [
      'tERRORbane',
      'Röki',
      'CONTROL',
      'Celeste',
      'Roki',
      'Game 10',
      'Game 2',
      'WHAT THE GOLF',
      'Warcraft',
      'shapez',
      'Bō: Path of the Teal Lotus',
    ]..sort(compareNames);

    expect(names, [
      'Bō: Path of the Teal Lotus',
      'Celeste',
      'CONTROL',
      'Game 2',
      'Game 10',
      'Roki',
      'Röki',
      'shapez',
      'tERRORbane',
      'Warcraft',
      'WHAT THE GOLF',
    ]);
  });

  test('compares digit runs by value whatever their leading zeros', () {
    final names = ['Game 10', 'Game 2', 'Game 02']..sort(compareNames);

    expect(names, ['Game 02', 'Game 2', 'Game 10']);
  });

  test('keeps a digit run longer than an int in order', () {
    final names = ['99999999999999999999', '100000000000000000000', '7']
      ..sort(compareNames);

    expect(names, ['7', '99999999999999999999', '100000000000000000000']);
  });

  test('puts a name before every name it is a prefix of', () {
    final names = ['Game 2', 'Game', '', 'Game 2 Remastered']
      ..sort(compareNames);

    expect(names, ['', 'Game', 'Game 2', 'Game 2 Remastered']);
  });

  test('folds a decomposed accent like a precomposed one', () {
    final names = ['Rokz', 'Ro\u0308ki', 'Roka']..sort(compareNames);

    expect(names, ['Roka', 'Ro\u0308ki', 'Rokz']);
  });

  test('never calls two different names equal', () {
    expect(compareNames('Roki', 'Röki'), lessThan(0));
    expect(compareNames('Röki', 'Roki'), greaterThan(0));
    expect(compareNames('roki', 'ROKI'), isNot(0));
    expect(compareNames('Roki', 'Roki'), 0);
  });
}
