import 'dart:math';

import 'package:bob_mobile/data_type/book_question.dart';
import 'package:bob_mobile/qanda.dart';
import 'package:bob_mobile/question_engine.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/rounded_edge_button.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class BattlePage extends StatefulWidget {
  //if this this true then the user will add points to his ledger
  //Otherwise it will be the team
  /* final bool personal;*/
  BattlePage({ObjectKey keyBattle}) : super(key: keyBattle);
  @override
  State<StatefulWidget> createState() {
    return new BattlePageState();
  }
}

class BattlePageState extends State<BattlePage> {
  QuestionEngine questionEngine = new QuestionEngine();

  @override
  void deactivate() {
    questionEngine = null;
    super.deactivate();
  }

  @override
  void dispose() {
    questionEngine = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: ColorLogicbyRole(context),
              forceElevated: true,
              pinned: true,
              expandedHeight: Constants.height_extended_bars,
              flexibleSpace: _buildBackgroundForAppBar(context),
            ),
            _buildQuestions(context, this.widget, questionEngine)
          ],
        ),
      ),
    );
  }
}

Widget _buildQuestions(
    BuildContext context, BattlePage widget, QuestionEngine questionEngine) {
  questionEngine.context = context;
  questionEngine.InitEngine();
  return SliverFillRemaining(
    child: StreamBuilder(
      stream: questionEngine.getStream(),
      builder: (context, bookQuestion) {
        if (bookQuestion.hasData) {
          BookQuestion question = bookQuestion.data;
          return Column(
            children: <Widget>[
              _buildBookReference(context, question, questionEngine),
              _buildQuestion(question, context),
              _buildRamdomOrderForAnswers(question, context),
            ],
          );
        } else {
          questionEngine.InitEngine();
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  );
}

Widget _buildBackgroundForAppBar(BuildContext context) {
  return Stack(
    alignment: Alignment.centerLeft,
    children: <Widget>[
      Image.asset('assets/monster_0.png'),
      Image.asset(
        Constants.myAvatars
            .elementAt(Quanda.of(context).myUser.role - 1)
            .asset_Large,
        height: Constants.height_extended_bars,
      ),
    ],
  );
}

Widget _buildBookReference(BuildContext context, BookQuestion question,
    QuestionEngine questionEngine) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(16.0),
      child: TextFormattedLabelTwo(
          'From the Book: ${questionEngine.bookQueried.name.replaceAll("\\", "")}',
          20,
          ColorLogicbyPersonality(context)),
    ),
  );
}

Widget _buildQuestion(BookQuestion question, BuildContext context) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(16.0),
      child: TextFormattedLabelTwo(
          question.question, 30, ColorLogicbyPersonality(context)),
    ),
  );
}

void functionFora(BuildContext context) {
  print('pressed incorrect a');
}

void functionForb(BuildContext context) {
  print('pressed incorrect b');
}

void functionForc(BuildContext context) {
  print('pressed incorrect c');
}

void functionForCorrect(BuildContext context) {
  print('pressed Correct');
}

Widget _buildRamdomOrderForAnswers(
    BookQuestion question, BuildContext context) {
  int mycase = new Random().nextInt(6);

  switch (mycase) {
    case 0:
      return Column(
        children: <Widget>[
          FormattedRoundedButton(
              question.correct_answer, functionForCorrect, context),
          FormattedRoundedButton(question.option_a, functionFora, context),
          FormattedRoundedButton(question.option_b, functionForb, context),
          FormattedRoundedButton(question.option_c, functionForc, context)
        ],
      );
    case 1:
      return Column(
        children: <Widget>[
          FormattedRoundedButton(question.option_a, functionFora, context),
          FormattedRoundedButton(
              question.correct_answer, functionForCorrect, context),
          FormattedRoundedButton(question.option_c, functionForc, context),
          FormattedRoundedButton(question.option_b, functionForb, context),
        ],
      );
    case 2:
      return Column(
        children: <Widget>[
          FormattedRoundedButton(question.option_a, functionFora, context),
          FormattedRoundedButton(question.option_b, functionForb, context),
          FormattedRoundedButton(question.option_c, functionForc, context),
          FormattedRoundedButton(
              question.correct_answer, functionForCorrect, context),
        ],
      );
    case 3:
      return Column(
        children: <Widget>[
          FormattedRoundedButton(question.option_b, functionForb, context),
          FormattedRoundedButton(question.option_a, functionFora, context),
          FormattedRoundedButton(
              question.correct_answer, functionForCorrect, context),
          FormattedRoundedButton(question.option_c, functionForc, context),
        ],
      );
    case 4:
      return Column(
        children: <Widget>[
          FormattedRoundedButton(question.option_b, functionForb, context),
          FormattedRoundedButton(
              question.correct_answer, functionForCorrect, context),
          FormattedRoundedButton(question.option_c, functionForc, context),
          FormattedRoundedButton(question.option_a, functionFora, context),
        ],
      );
    case 5:
      return Column(
        children: <Widget>[
          FormattedRoundedButton(question.option_c, functionForc, context),
          FormattedRoundedButton(question.option_b, functionForb, context),
          FormattedRoundedButton(
              question.correct_answer, functionForCorrect, context),
          FormattedRoundedButton(question.option_a, functionFora, context),
        ],
      );
    case 6:
      return Column(
        children: <Widget>[
          FormattedRoundedButton(question.option_c, functionForc, context),
          FormattedRoundedButton(
              question.correct_answer, functionForCorrect, context),
          FormattedRoundedButton(question.option_a, functionFora, context),
          FormattedRoundedButton(question.option_b, functionForb, context),
        ],
      );
    default:
      return Column(
        children: <Widget>[
          FormattedRoundedButton(question.option_c, functionForc, context),
          FormattedRoundedButton(question.option_a, functionFora, context),
          FormattedRoundedButton(
              question.correct_answer, functionForCorrect, context),
          FormattedRoundedButton(question.option_b, functionForb, context),
        ],
      );
  }
}
