import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/provider.dart';
import 'package:flutter/cupertino.dart';

import 'constants.dart';

enum FormType { login, register, updatingName }

class EmailValidator {
  static String validate(String value) {
    return value.isEmpty ? "Email can't be empty" : null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    return value.isEmpty ? "Password can't be empty" : null;
  }
}

class NameValidator {
  BuildContext context;
  NameValidator(this.context);
  String validate(String value) {
    return value.isEmpty ? Constants.name_cannot_be_empty : null;
  }

  Future<bool> checkNameIsNotUsed(String value, BuildContext context) async {
    return FireProvider.of(context)
        .fireBase
        .checkIfNameExistAndCreateRanking(context, value);
  }
}
