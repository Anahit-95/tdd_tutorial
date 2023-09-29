import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();
  test('should be a subclass of [User] entity', () {
    // Arrange
    // Assert
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson);

  group('fromMap', () {
    test(
      'should return a [UserModel] with the right data',
      () {
        final result = UserModel.fromMap(tMap);
        expect(result, tModel);
      },
    );
  });

  group('fromJson', () {
    test(
      'should return a [UserModel] with the right data',
      () {
        final result = UserModel.fromJson(tJson);
        expect(result, tModel);
      },
    );
  });

  group('toMap', () {
    test('should return a [Map] with the right data', () {
      final result = tModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a [json] with the right data', () {
      final result = tModel.toJson();
      final tJson = jsonEncode({
        "id": "1",
        "createdAt": "_empty.createdAt",
        "name": "_empty.name",
        "avatar": "_empty.avatar"
      });
      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('should return a [UserMode] with different data', () {
      final result = tModel.copyWith(name: 'Paul');
      expect(result.name, equals('Paul'));
    });
  });
}
