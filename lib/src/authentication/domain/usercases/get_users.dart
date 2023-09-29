// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tdd_tutorial/core/usercase/usercase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';

import '../entities/user.dart';
import '../repositories/authentication_repository.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {
  final AuthenticationRepository _repository;
  const GetUsers(
    this._repository,
  );

  @override
  ResultFuture<List<User>> call() async => await _repository.getUsers();
}
