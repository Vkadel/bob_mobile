import 'package:bob_mobile/auth.dart';
import 'package:flutter/material.dart';

import 'mfirestore.dart';

class FireProvider extends InheritedWidget {
  final BaseAuth auth;
  final MBobFireBase fireBase;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  FireProvider({Key key, Widget child, this.auth, this.fireBase})
      : super(
          key: key,
          child: child,
        );

  static FireProvider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(FireProvider) as FireProvider);
}
