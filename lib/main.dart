import 'package:bob_mobile/add_player_page.dart';
import 'package:bob_mobile/sign_out_button.dart';
import 'package:bob_mobile/modelData/auth.dart';
import 'package:bob_mobile/battle_page.dart';
import 'package:bob_mobile/data_type/user.dart';
import 'package:bob_mobile/modelData/mfirestore.dart';
import 'package:bob_mobile/hero_room_page.dart';
import 'package:bob_mobile/modelData/battle_page_state_data.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/modelData/shop_purchase_data.dart';
import 'package:bob_mobile/select_role_page.dart';
import 'package:bob_mobile/shop_page.dart';
import 'package:bob_mobile/team_hall_page.dart';
import 'package:bob_mobile/widgets/loading_indicator_full_screen.dart';
import 'package:bob_mobile/widgets/loading_indicator_message.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'library_page.dart';
import 'dashboard_page.dart';
import 'login_page.dart';
import 'modelData/add_book_form_data.dart';
import 'modelData/personality_test_state_data.dart';
import 'modelData/team_formation_data.dart';
import 'personality_test_page.dart';
import 'data_type/question.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AddBookFormData>(
          create: (_) => AddBookFormData(),
        ),
        ChangeNotifierProvider<BattlePageStateData>(
          create: (_) => BattlePageStateData(),
        ),
        ChangeNotifierProvider<PersonalityTestStateData>(
            create: (_) => PersonalityTestStateData()),
        ChangeNotifierProvider<ShopPurchaseData>(
            create: (_) => ShopPurchaseData()),
        ChangeNotifierProvider<TeamFormationData>(
            create: (_) => TeamFormationData())
      ],
      child: Quanda(
        child: FireProvider(
          auth: Auth(),
          fireBase: MBobFireBase(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Battle of the books',
            theme: new ThemeData(
              secondaryHeaderColor: Colors.blueAccent,
              accentColor: Colors.blueAccent,
              primaryColor: Colors.deepOrange,
              scaffoldBackgroundColor: Colors.deepOrangeAccent[50],
            ),
            home: EntryPage(title: 'Battle of the Books'),
            routes: <String, WidgetBuilder>{
              '/main': (BuildContext context) =>
                  EntryPage(title: 'Please Login'),
              '/home': (BuildContext context) => HomePage(title: 'Home Page'),
              '/personality_test': (BuildContext context) =>
                  PersonalitySurveyPage(title: 'Tell your tale'),
              '/login': (BuildContext context) => LoginPage(),
              '/hero_room': (BuildContext context) => HeroRoomPage(),
              '/team_hall': (BuildContext context) => TeamHallPage(),
              '/fight': (BuildContext context) => BattlePage(),
              '/add_player_to_team': (BuildContext context) => AddPlayerPage(),
              '/add_read_book': (BuildContext context) => LibraryPage(),
              '/shop_page': (BuildContext context) => ShopPage(),
            },
          ),
        ),
      ),
    );
  }
}

class EntryPage extends StatefulWidget {
  EntryPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  _EntryPageState();
  String _user;

  @override
  Widget build(BuildContext context) {
    final Auth auth = FireProvider.of(context).auth;
    if (Quanda.of(context).myUser == null) {
      return StreamBuilder<FirebaseUser>(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.active) {
            print("connection state: Connection is active");
            String userid;
            String userEmail;
            if (snapshot.data != null) {
              userid = snapshot.data.uid;
              userEmail = snapshot.data.email;
              print('SNAPSHOT Connection id: $userid');
              final bool loggedIn = snapshot.hasData;
              return (loggedIn && snapshot.data != null)
                  ? HomePage(
                      email: userEmail,
                      uid: userid,
                      title: 'my Home Page',
                    )
                  : LoginPage();
            } else {
              print('Loading login page....');
              return LoginPage();
            }
          } else {
            return mLoadingIndicatorFullScreen(
                context, snapshot.connectionState);
          } //Condition to check when data comes back from the Auth//Condition to load when waiting for data to return
        },
      );
    } else {
      print('there is a user, going to dashboard....');
      return DashBoardPage();
    }
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.uid, this.email}) : super(key: key);
  //update the constructor to include the uid
  final String title;
  final String uid; //include this
  final String email;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Auth auth = FireProvider.of(context).auth;
    final MBobFireBase mBobFireBase = FireProvider.of(context).fireBase;
    print('Building Home page....');
    if (widget.uid != null) {
      print('This is the widget INFO: $widget.uid ');

      return StreamBuilder<QuerySnapshot>(
        stream: mBobFireBase.get_userprofile(widget.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print('SNAPSHOT Connection STARTED');
          return snapshot.hasError
              ? Container(
                  child: Text('Snapshot from user profile has errors'),
                )
              : (snapshot.connectionState == ConnectionState.active &&
                      snapshot.data != null &&
                      snapshot.hasData)
                  ? userPlayReadyVerification(snapshot)
                  : Scaffold(
                      body: LoadingIndicatorMessage(
                      message: 'Loading user data',
                    ));
        },
      );
    } else {
      print('Widget.uid is null');
      return Scaffold(
        appBar: AppBar(
          title: Text('The Home Page'),
          actions: <Widget>[SignOutButton()],
        ),
        body: Text('Welcome'),
      );
    }
  }

  bool UserIsIntro() {
    print('Checking is Intro....');
    bool intro;
    if (Quanda.of(context).myUser.personality['value_i'] != 0 ||
        Quanda.of(context).myUser.personality['value_e'] != 0) {
      if (Quanda.of(context).myUser.personality['value_i'] >
          Quanda.of(context).myUser.personality['value_e']) {
        intro = true;
      } else {
        intro = false;
      }
    } else {
      intro = false;
    }
    return intro;
  }

  bool UserIsExtro() {
    print('Checking is Extro....');
    bool isExtro;
    if (Quanda.of(context).myUser.personality['value_i'] != 0 ||
        Quanda.of(context).myUser.personality['value_e'] != 0) {
      if (Quanda.of(context).myUser.personality['value_i'] <
          Quanda.of(context).myUser.personality['value_e']) {
        isExtro = true;
      } else {
        isExtro = false;
      }
    } else {
      isExtro = false;
    }
    return isExtro;
  }

  bool user_has_personality() {
    print('Checking if user has personality....');
    if (UserIsExtro() || UserIsIntro()) {
      return true;
    } else {
      return false;
    }
  }

  Widget createUserProfile() {
    print('SNAPSHOT Connection Returned Empty');
    print('Generating user profile....');
    FireProvider.of(context)
        .fireBase
        .createUserProfile(widget.uid, widget.email, context);
    return Container(
      child: Text('created user Profile'),
    );
  }

  bool userHasRole() {
    print('Checking user has role....');
    if (Quanda.of(context).myUser.role == 0) {
      return false;
    } else {
      return true;
    }
  }

  Widget userProfileWorkflow(AsyncSnapshot<QuerySnapshot> userProfileSnapShot) {
    print('User Profile Workflow....');
    //User has user Profile
    int lenght = userProfileSnapShot.data.documents.length;
    print('SNAPSHOT Connection Returned $lenght');
    //Check if User has personality Test
    Quanda.of(context).myUser =
        User.fromJson(userProfileSnapShot.data.documents.first.data);

    //Check if User has personality Test
    if (user_has_personality()) {
      print("User Has personality");
    } else {
      return PersonalitySurveyPage(title: 'Personality Survey');
    }

    if (userHasRole()) {
      print('User Has role......');
    } else {
      return SelectRolePage();
    }
    if (userHasRole() && user_has_personality()) return DashBoardPage();
  }

  Widget userPlayReadyVerification(AsyncSnapshot<QuerySnapshot> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        print('SNAPSHOT Connection waiting');
        return LoadingIndicatorMessage(
          message: 'Checking user data...',
        );
        break;
      case ConnectionState.none:
        print('SNAPSHOT Connection NONE');
        return LoadingIndicatorMessage(
          message: 'No connection try again later..',
        );
        break;
      case ConnectionState.active:
        print('SNAPSHOT Connection Active');
        return snapshot.data.documents.isEmpty
            ? createUserProfile()
            : userProfileWorkflow(snapshot);
        break;
      case ConnectionState.done:
        print('SNAPSHOT Connection done');
        return LoadingIndicatorMessage(
          message: 'Finished..',
        );
        break;
      default:
        return new Container(width: 0.0, height: 0.0);
    }
  }

  Widget buildUserHasUID(MBobFireBase mBobFireBase) {
    print('buildUserHasUID....');
    return Scaffold(
        appBar: AppBar(
          title: Text('The Home Page'),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  try {
                    Auth auth = FireProvider.of(context).auth;
                    await auth.signOut();
                  } catch (e) {
                    print(e);
                  }
                },
                child: SignOutButton())
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: mBobFireBase.get_userprofile(widget.uid),
          builder:
              // ignore: missing_return
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print('SNAPSHOT Connection STARTED');
            return (snapshot.hasError)
                ? new Container(
                    child: Text('Error getting data from database'),
                  )
                : userPlayReadyVerification(snapshot);
          },
        ));
  }

  Widget buildUserHasNOId() {
    print('Building user has not id');

    return Scaffold(
      appBar: AppBar(
        title: Text('The Home Page'),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                try {
                  Auth auth = FireProvider.of(context).auth;
                  await auth.signOut();
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Sign outs'))
        ],
      ),
      body: Text('Welcome'),
    );
  }
}
