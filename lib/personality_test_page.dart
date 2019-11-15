import 'package:bob_mobile/data_type/question.dart';
import 'package:bob_mobile/data_type/user.dart';
import 'package:bob_mobile/widgets/rounded_edge_button_survey.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_1.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'modelData/personality_test_state_data.dart';
import 'provider.dart';
import 'modelData/qanda.dart';

class PersonalitySurveyPage extends StatefulWidget {
  PersonalitySurveyPage({ObjectKey key, this.title, this.user})
      : super(key: key);
  //update the constructor to include the uid
  final String title;
  final User user;
  final formKey = GlobalKey<_PersonalitySurveyState>();

  //TODO: May want to tie progress to user just in case they disco

  @override
  State<StatefulWidget> createState() => _PersonalitySurveyState();
}

class _PersonalitySurveyState extends State<PersonalitySurveyPage> {
  List<Question> _list_of_questions;
  String _mytext = '';

  @override
  Widget build(BuildContext context) {
    //get questions
    return StreamBuilder(
      stream: FireProvider.of(context).fireBase.getQuestions(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          try {
            if (snapshot.data != null) {
              _list_of_questions = snapshot.data.documents
                  .toList()
                  .map((DocumentSnapshot doc) => Question.fromJson(doc.data))
                  .toList();
              /*   var question = _list_of_questions
                  .elementAt(Quanda.of(context).progress)
                  .option_a;*/

              return BuildSurveyQuestion(context);
            }
          } catch (e) {
            print(e);
            return Text('Sorry We are missing some nuts and bolts here');
          }
        } else {
          return Container(
            //Connection is not Active yet
            child: CircularProgressIndicator(),
          );
        }
        ;
      },
    );
  }

  Widget BuildSurveyQuestion(context) {
    return Consumer<PersonalityTestStateData>(
      builder: (context, personalityTestStateData, _) {
        return personalityTestStateData.is_calculating_personality
            ? _isCalculatingPersonality()
            : _buildScaffoldQuestion(personalityTestStateData);
      },
    );
  }

  Widget _buildScaffoldQuestion(
      PersonalityTestStateData personalityTestStateData) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: TextFormattedLabelTwo(
                _list_of_questions
                    .elementAt(personalityTestStateData.progress)
                    .question,
                35,
                Colors.deepOrange,
              ),
            ),
            MyRoundedButtonForSurvey(
              personalityTestStateData.a_pressed,
              _list_of_questions
                  .elementAt(personalityTestStateData.progress)
                  .option_a,
              personalityTestStateData,
              press_a,
            ),
            MyRoundedButtonForSurvey(
                personalityTestStateData.b_pressed,
                _list_of_questions
                    .elementAt(personalityTestStateData.progress)
                    .option_b,
                personalityTestStateData,
                press_b),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      child: Text('Previous'),
                      onPressed: () {
                        Go_prev(personalityTestStateData);
                      },
                    ),
                  ),
                  Text('$_mytext'),
                  FlatButton(
                    child: Text('Next'),
                    onPressed: () {
                      Go_next(personalityTestStateData);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _isCalculatingPersonality() {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Go_next(PersonalityTestStateData personalityTestStateData) {
    clearButs(personalityTestStateData);
    int showing = personalityTestStateData.progress;
    print('Trying to change state from: $showing');

    if (personalityTestStateData.progress ==
        Constants().number_of_questions_personality_test) {
      personalityTestStateData.updateProgress(0);
      //TODO: Make sure only one check if done and only happens when
      //When permanent is size 20. Then it pops back into the dashboard.
    } else {
      if (personalityTestStateData.progress ==
          Constants().number_of_questions_personality_test - 1) {
        //Calculate Personality
        calculate_intro_extro_perso(personalityTestStateData);
      }
      if (personalityTestStateData.progress <
          Constants().number_of_questions_personality_test - 1) {
        print('Trying to change state from: $showing');
        //Check if a selection has been done
        clearButs(personalityTestStateData);
        personalityTestStateData
            .updateProgress(personalityTestStateData.progress + 1);
      }
    }
    if (personalityTestStateData.progress <
        personalityTestStateData.permanent.length) {
      update_buttons_with_current_selections(personalityTestStateData);
    }
  }

  void Go_prev(PersonalityTestStateData personalityTestStateData) {
    clearButs(personalityTestStateData);
    if (personalityTestStateData.progress == 0) {
      //Will not allow users to go back from the first question
      //Todo: dissable in this case
      /*personalityTestStateData
          .updateProgress(Constants().number_of_questions_personality_test - 1);*/
    } else {
      if (personalityTestStateData.progress > 0) {
        print('Trying to change state');
        personalityTestStateData
            .updateProgress(personalityTestStateData.progress - 1);
        update_buttons_with_current_selections(personalityTestStateData);
        //Clean last Item
      }
    }
  }

  void press_a(PersonalityTestStateData personalityTestStateData) {
    print('setting state to A');
    Question question =
        _list_of_questions.elementAt(personalityTestStateData.progress);
    //this check is for the edgecase of the first item
    bool nonewerepressed = !(personalityTestStateData.a_pressed ||
        personalityTestStateData.b_pressed);
    if ((personalityTestStateData.progress == 0 && nonewerepressed) ||
        personalityTestStateData.permanent.length <=
            personalityTestStateData.progress) {
      //If the record does not exist add it
      personalityTestStateData.permanent
          .insert(personalityTestStateData.progress, question);
    } else {
      //If the record exist update it
      personalityTestStateData.permanent[personalityTestStateData.progress] =
          question;
      update_buttons_with_current_selections(personalityTestStateData);
    }
    personalityTestStateData
        .permanent[personalityTestStateData.progress].selection_b = 0;
    personalityTestStateData
        .permanent[personalityTestStateData.progress].selection_a = 1;
    //Update the dataModel
    personalityTestStateData.updateb_pressed(false);
    personalityTestStateData.updatea_pressed(true);
    printit(personalityTestStateData);
  }

  void press_b(PersonalityTestStateData personalityTestStateData) {
    print('setting state to B');

    Question question =
        _list_of_questions.elementAt(personalityTestStateData.progress);
    bool nonewerepressed = !(personalityTestStateData.a_pressed ||
        personalityTestStateData.b_pressed);
    if ((personalityTestStateData.progress == 0 && nonewerepressed) ||
        personalityTestStateData.permanent.length <=
            personalityTestStateData.progress) {
      personalityTestStateData.permanent
          .insert(personalityTestStateData.progress, question);
    } else {
      personalityTestStateData.permanent[personalityTestStateData.progress] =
          question;
      update_buttons_with_current_selections(personalityTestStateData);
    }
    personalityTestStateData
        .permanent[personalityTestStateData.progress].selection_b = 1;
    personalityTestStateData
        .permanent[personalityTestStateData.progress].selection_a = 0;
    personalityTestStateData.updateb_pressed(true);
    personalityTestStateData.updatea_pressed(false);
    printit(personalityTestStateData);
  }

  void printit(PersonalityTestStateData personalityTestStateData) {
    _mytext = personalityTestStateData.permanent
            .elementAt(personalityTestStateData.progress)
            .selection_a
            .toString() +
        personalityTestStateData.permanent
            .elementAt(personalityTestStateData.progress)
            .selection_b
            .toString();
  }

  void clearButs(PersonalityTestStateData personalityTestStateData) {
    personalityTestStateData.updatea_pressed(false);
    personalityTestStateData.updateb_pressed(false);
  }

  void update_buttons_with_current_selections(
      PersonalityTestStateData personalityTestStateData) {
    if (personalityTestStateData.permanent
            .elementAt(personalityTestStateData.progress)
            .selection_a ==
        1) {
      personalityTestStateData.updatea_pressed(true);
      personalityTestStateData.updateb_pressed(false);
    } else {
      personalityTestStateData.updatea_pressed(false);
      personalityTestStateData.updateb_pressed(true);
    }
  }

  void calculate_intro_extro_perso(
      PersonalityTestStateData personalityTestStateData) {
    personalityTestStateData.is_calculating_personality = true;
    //Calculate E and I;
    Set<int> checking_set_e_i = ({1, 5, 9, 13, 17});
    Set<int> checking_set_s_n = ({2, 6, 10, 14, 18});
    Set<int> checking_set_t_f = ({3, 7, 11, 15, 19});
    Set<int> checking_set_j_p = ({4, 8, 12, 16, 19});
    int i = 0;

    for (i = 0; i <= checking_set_e_i.length - 1; i++) {
      Quanda.of(context).myUser.personality['value_e'] =
          Quanda.of(context).myUser.personality['value_e'] +
              personalityTestStateData.permanent
                  .where((l) => l.id == checking_set_e_i.elementAt(i))
                  .first
                  .selection_a;
    }

    for (i = 0; i <= checking_set_e_i.length - 1; i++) {
      Quanda.of(context).myUser.personality['value_i'] =
          Quanda.of(context).myUser.personality['value_i'] +
              personalityTestStateData.permanent
                  .where((l) => l.id == checking_set_e_i.elementAt(i))
                  .first
                  .selection_b;
    }

    for (i = 0; i <= checking_set_s_n.length - 1; i++) {
      Quanda.of(context).myUser.personality['value_s'] =
          Quanda.of(context).myUser.personality['value_s'] +
              personalityTestStateData.permanent
                  .where((l) => l.id == checking_set_s_n.elementAt(i))
                  .first
                  .selection_a;
    }

    for (i = 0; i <= checking_set_s_n.length - 1; i++) {
      Quanda.of(context).myUser.personality['value_n'] =
          Quanda.of(context).myUser.personality['value_n'] +
              personalityTestStateData.permanent
                  .where((l) => l.id == checking_set_s_n.elementAt(i))
                  .first
                  .selection_b;
    }

    for (i = 0; i <= checking_set_t_f.length - 1; i++) {
      Quanda.of(context).myUser.personality['value_t'] =
          Quanda.of(context).myUser.personality['value_t'] +
              personalityTestStateData.permanent
                  .where((l) => l.id == checking_set_t_f.elementAt(i))
                  .first
                  .selection_a;
    }

    for (i = 0; i <= checking_set_t_f.length - 1; i++) {
      Quanda.of(context).myUser.personality['value_f'] =
          Quanda.of(context).myUser.personality['value_f'] +
              personalityTestStateData.permanent
                  .where((l) => l.id == checking_set_t_f.elementAt(i))
                  .first
                  .selection_b;
    }

    for (i = 0; i <= checking_set_j_p.length - 1; i++) {
      Quanda.of(context).myUser.personality['value_j'] =
          Quanda.of(context).myUser.personality['value_j'] +
              personalityTestStateData.permanent
                  .where((l) => l.id == checking_set_j_p.elementAt(i))
                  .first
                  .selection_a;
    }

    for (i = 0; i <= checking_set_j_p.length - 1; i++) {
      Quanda.of(context).myUser.personality['value_p'] =
          Quanda.of(context).myUser.personality['value_p'] +
              personalityTestStateData.permanent
                  .where((l) => l.id == checking_set_j_p.elementAt(i))
                  .first
                  .selection_b;
    }
    //TODO: Upload Personality to server
    int intro = Quanda.of(context).myUser.personality['value_i'];
    int extro = Quanda.of(context).myUser.personality['value_e'];
    int S = Quanda.of(context).myUser.personality['value_s'];
    int N = Quanda.of(context).myUser.personality['value_n'];
    int T = Quanda.of(context).myUser.personality['value_t'];
    int F = Quanda.of(context).myUser.personality['value_f'];
    int J = Quanda.of(context).myUser.personality['value_j'];
    int P = Quanda.of(context).myUser.personality['value_p'];

    print('Personality Values: E:$extro I:$intro S:'
        '$S N:$N T:$T F:$F J:$J P:$P');

    FireProvider.of(context).fireBase.setUpUserPersonality(
        FireProvider.of(context).auth.getLastUserLoged(),
        Quanda.of(context).myUser);
  }
}
