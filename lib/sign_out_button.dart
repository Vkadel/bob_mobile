import 'package:flutter/material.dart';

import 'modelData/auth.dart';
import 'modelData/provider.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () async {
          try {
            Auth auth = FireProvider.of(context).auth;
            await auth.signOut();
          } catch (e) {
            print(e);
          }
        },
        child: Text('Sign outs'));
  }
}
