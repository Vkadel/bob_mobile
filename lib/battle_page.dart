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
            _buildQuestions(context, this.widget, questionEngine),
            _buildPossibleAnwers(context, widget, questionEngine),
            SliverFillRemaining(
              child: Container(
                height: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildQuestions(
    BuildContext context, BattlePage widget, QuestionEngine questionEngine) {
  questionEngine.InitEngine(context);
  return StreamBuilder(
    stream: questionEngine.getStream(),
    builder: (context, bookQuestion) {
      if (bookQuestion.hasData &&
          !bookQuestion.hasError &&
          bookQuestion.connectionState == ConnectionState.active) {
        BookQuestion question = bookQuestion.data;
        return SliverList(
          delegate: SliverChildListDelegate([
            _buildBookReference(context, question, questionEngine),
            _buildQuestion(question, context),
          ]),
        );
      } else {
        return SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    },
  );
}

Widget _buildPossibleAnwers(
    BuildContext context, BattlePage widget, QuestionEngine questionEngine) {
  return StreamBuilder(
    stream: questionEngine.getStream(),
    builder: (context, data) {
      if (data.hasData) {
        List<Widget> possibleAnswers = new List();
        BookQuestion question = data.data;
        possibleAnswers.add(FormattedRoundedButton(
            question.correct_answer, functionForCorrect, context));
        possibleAnswers.add(
            FormattedRoundedButton(question.option_a, functionFora, context));
        possibleAnswers.add(
            FormattedRoundedButton(question.option_b, functionForb, context));
        possibleAnswers.add(
            FormattedRoundedButton(question.option_c, functionForc, context));
        // ignore: missing_return
        possibleAnswers.shuffle();
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return possibleAnswers.elementAt(index);
          }, childCount: possibleAnswers.length),
        );
      } else {
        return SliverToBoxAdapter(
          child: Container(),
        );
      }
    },
  );
}

Widget _buildRamdomOrderForAnswers(
    BookQuestion question, BuildContext context) {
  List<Widget> possibleAnswers = new List();

  possibleAnswers.add(FormattedRoundedButton(
      question.correct_answer, functionForCorrect, context));
  possibleAnswers
      .add(FormattedRoundedButton(question.option_a, functionFora, context));
  possibleAnswers
      .add(FormattedRoundedButton(question.option_b, functionForb, context));
  possibleAnswers
      .add(FormattedRoundedButton(question.option_c, functionForc, context));
  possibleAnswers.shuffle();
  return SliverList(
    delegate: SliverChildBuilderDelegate((context, index) {
      return possibleAnswers.elementAt(index);
    }, childCount: possibleAnswers.length),
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
