import 'package:bob_mobile/qanda.dart';
import 'package:bob_mobile/question_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class BattlePage extends StatefulWidget {
  //if this this true then the user will add points to his ledger
  //Otherwise it will be the team
  final bool personal;
  BattlePage({ObjectKey key, this.personal}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new BattlePageState();
  }
}

class BattlePageState extends State<BattlePage> {
  QuestionEngine questionEngine = new QuestionEngine();

  @override
  void deactivate() {
    this.questionEngine = null;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 150,
              forceElevated: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  child: Image.asset(Constants.myAvatars
                      .elementAt(Quanda.of(context).myUser.role - 1)
                      .asset_Large),
                ),
              ),
            ),
            _buildQuestions(context, this.widget, questionEngine),
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
  return SliverToBoxAdapter(
    child: Row(
      children: <Widget>[
        Text('Personal: ${widget.personal}'),
      ],
    ),
  );
}
