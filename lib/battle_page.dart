import 'package:bob_mobile/data_type/book_question.dart';
import 'package:bob_mobile/data_type/books_master.dart';
import 'package:bob_mobile/main.dart';
import 'package:bob_mobile/modelData/battle_page_state_data.dart';
import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/question_engine.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/generate_background_for_fight.dart';
import 'package:bob_mobile/widgets/generate_random_monster.dart';
import 'package:bob_mobile/widgets/rounded_edge_button.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

class BattlePage extends StatefulWidget {
  BattlePage({ObjectKey keyBattle}) : super(key: keyBattle);
  @override
  State<StatefulWidget> createState() {
    return new BattlePageState();
  }
}

class BattlePageState extends State<BattlePage> {
  QuestionEngine questionEngine;

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    questionEngine = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Provider.of<BattlePageStateData>(context, listen: false)
        .resetWithoutUpdate();
    questionEngine = new QuestionEngine();
  }

  @override
  Widget build(BuildContext context) {
    if (!questionEngine.engineIsRunning) {
      print('Starting Engine');
      questionEngine.InitEngine(context);
    }
    if (Provider.of<BattlePageStateData>(context).continue_fighting) {
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: _buildPage(context, questionEngine, this),
      );
    } else {
      print('I will want to POP');

      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
                child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(Constants.myAvatars
                      .elementAt(Quanda.of(context).myUser.role - 1)
                      .asset_Large),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormattedLabelTwo(
                        'The battle is over and you got ${Provider.of<BattlePageStateData>(context).total_points_if_correct} Points',
                        30),
                  ),
                  FormattedRoundedButton(
                      'Go to Hero Room ', _resetBattleGoBackToRoom, context),
                ],
              ),
            ))
          ],
        ),
      );
    }
  }

  Future<bool> _onBackPressed() {
    print('Do you want to end the battle');
    return showDialog<bool>(
      context: this.context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to leave the Battle?'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () => {Navigator.pop(context, false)},
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () => {_resetBattleGoBackToRoom(context)},
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _resetBattleGoBackToRoom(BuildContext context) {
    Provider.of<BattlePageStateData>(context, listen: false)
        .resetWithoutUpdate();
    Navigator.pop(context, true);
  }
}

Widget _buildPage(BuildContext context, QuestionEngine questionEngine,
    BattlePageState battlePageState) {
  return SafeArea(
    child: Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: null,
              backgroundColor: ColorLogicbyRole(context),
              forceElevated: true,
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: Constants.height_extended_bars,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                background: _buildBackgroundForAppBar(context),
              ),
            ),
            _buildQuestions(context, battlePageState.widget, questionEngine),
            _buildPossibleAnwers(
                context, battlePageState.widget, questionEngine),
            _buildBuff(context, battlePageState.widget, questionEngine),
            SliverFillRemaining(
              child: Container(),
            )
          ],
        ),
      ),
    ),
  );
}

Widget _buildBackgroundForAppBar(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: Stack(
      children: <Widget>[
        Image.asset(
            new GenerateBackGroundForFight(context).getRamdomBackground()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildheroSideFight(context),
            _buildMonsterSideOfFight(context),
          ],
        )
      ],
    ),
  );
}

Widget _buildheroSideFight(BuildContext context) {
  return Consumer<BattlePageStateData>(
    builder: (context, battlePageState, _) {
      return Row(
        children: <Widget>[
          //Life Column
          _buildLifeBar(context, battlePageState, battlePageState.hero_life),
          Image.asset(
            Constants.myAvatars
                .elementAt(Quanda.of(context).myUser.role - 1)
                .asset_Large,
            height: Constants.height_extended_bars,
          )
        ],
      );
    },
  );
}

Widget _buildMonsterSideOfFight(BuildContext context) {
  return Consumer<BattlePageStateData>(
    builder: (context, battlePageState, _) {
      return Row(
        children: <Widget>[
          //Life Column
          Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Monster Level: ${battlePageState.blows_required_to_kill_mob}'),
                ),
              ),
              Image.asset(new GenerateMonsterImageForFight(context)
                  .getRamdomMonsterImage()),
            ],
          ),

          _buildLifeBar(context, battlePageState, battlePageState.monster_life),
        ],
      );
    },
  );
}

Widget _buildLifeBar(
    BuildContext context, BattlePageStateData battlePageState, int life) {
  double heightOflife = (Constants.height_extended_bars) * (life) / 100;
  double heighofVoid = (Constants.height_extended_bars) * (1 - (life / 100));
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Container(
        height: heighofVoid,
        width: MediaQuery.of(context).size.width / 15,
        color: Constants.color_main,
      ),
      Container(
        height: heightOflife,
        width: MediaQuery.of(context).size.width / 15,
        color: ColorLogicbyRole(context),
      ),
    ],
  );
}

Widget _buildQuestions(
    BuildContext context, BattlePage widget, QuestionEngine questionEngine) {
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

Widget _buildPossibleAnwers(
    BuildContext context, BattlePage widget, QuestionEngine questionEngine) {
  return StreamBuilder(
    stream: questionEngine.getStream(),
    builder: (context, data) {
      if (data.hasData) {
        List<Widget> possibleAnswers = new List();
        BookQuestion question = data.data;
        possibleAnswers.add(FormattedRoundedButton(question.correct_answer,
            functionForCorrect, context, question.questionId));
        possibleAnswers.add(FormattedRoundedButton(
            question.option_a, functionFora, context, question.questionId));
        possibleAnswers.add(FormattedRoundedButton(
            question.option_b, functionForb, context, question.questionId));
        possibleAnswers.add(FormattedRoundedButton(
            question.option_c, functionForc, context, question.questionId));
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

void functionFora(BuildContext context, int questionId) {
  print('pressed incorrect a');
  _reportIncorrectQuestion(context, questionId);
}

void functionForb(BuildContext context, int questionId) {
  print('pressed incorrect b');
  _reportIncorrectQuestion(context, questionId);
}

void functionForc(BuildContext context, int questionId) {
  print('pressed incorrect c');
  _reportIncorrectQuestion(context, questionId);
}

void functionForCorrect(BuildContext context, int questionId) {
  print('pressed Correct');
  _reportRightAnswer(context, questionId);
}

void _reportIncorrectQuestion(BuildContext context, int questionId) async {
  Provider.of<BattlePageStateData>(context, listen: false).hitHero();
  FireProvider.of(context).fireBase.reportAnswer(context, questionId, false);
  //is User Alive
}

void _reportRightAnswer(BuildContext context, int questionId) async {
  print('The Question was answered correctly');
  Provider.of<BattlePageStateData>(context, listen: false).hitMob();
  Provider.of<BattlePageStateData>(context, listen: false).addPointHitForHero();
  await FireProvider.of(context)
      .fireBase
      .reportAnswer(context, questionId, true);
  Quanda.of(context).personal
      ? _sendPointToPersonal(context)
      : _sendPointToTeam();
}

void _sendPointToPersonal(BuildContext context) {
  if (Provider.of<BattlePageStateData>(context, listen: false)
      .battlePageData
      .continue_fighting) {
    print(
        'So far we got:${Provider.of<BattlePageStateData>(context, listen: false).total_points_if_correct}points');
  } else {
    int points = Provider.of<BattlePageStateData>(context, listen: false)
        .battlePageData
        .total_points_if_correct;
    FireProvider.of(context).fireBase.reportPointPersonal(context, points);
  }
}

void _sendPointToTeam() {}

int _calculateItemGains(BuildContext context) {
  int pointsToAdd = 0;
  try {
    Quanda.of(context)
        .myItems
        .where((item) =>
            item.inuse && item.endDate > Timestamp.now().millisecondsSinceEpoch)
        .forEach((item) => pointsToAdd = pointsToAdd + 1);
  } catch (e) {
    print(e);
  }
  return pointsToAdd;
}

int _calculateHeroAdditionsFromStats(
    BuildContext context, BookQuestion question, BooksMaster book) {
  int pointsToAdd = 0;

  //Loop to get Additions
  book.bookTypesArray.forEach((item) => Quanda.of(context)
      .myAvatarStats
      .additions
      .forEach((k, v) => {
            int.parse(k) == item
                ? pointsToAdd = pointsToAdd + 1
                : pointsToAdd = pointsToAdd
          }));

  return pointsToAdd;
}

int _calculateHeroSubstractionsFromStats(
    BuildContext context, BookQuestion question, BooksMaster book) {
  int pointsToAdd = 0;

  //Loop to get Additions
  book.bookTypesArray.forEach((item) => Quanda.of(context)
      .myAvatarStats
      .substractions
      .forEach((k, v) => {
            int.parse(k) == item
                ? pointsToAdd = pointsToAdd + 1
                : pointsToAdd = pointsToAdd
          }));

  return pointsToAdd;
}

Widget _buildBuff(
    BuildContext context, BattlePage widget, QuestionEngine engine) {
  return StreamBuilder(
    stream: engine.getStream(),
    builder: (context, event) {
      if (event.hasData && event.data != null) {
        BookQuestion question = event.data;
        return StreamBuilder(
            stream: FireProvider.of(context)
                .fireBase
                .getMasterBookInfo(question.id),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> bookSnapshot) {
              if (bookSnapshot.connectionState == ConnectionState.active &&
                  bookSnapshot.hasData &&
                  bookSnapshot.data != null) {
                BooksMaster book = BooksMaster.fromJson(bookSnapshot.data.data);
                return _listOfBuffs(context, question, book);
              } else {
                return returnEmpty();
              }
            });
      } else {
        return returnEmpty();
      }
    },
  );
}

Widget returnEmpty() {
  return SliverToBoxAdapter(
    child: Container(),
  );
}

Widget _listOfBuffs(
    BuildContext context, BookQuestion question, BooksMaster book) {
  int textDiv = 23;
  return Consumer<BattlePageStateData>(
    builder: (context, battlePageData, _) {
      battlePageData.updatecurrentAddForQuestion(
          _calculateHeroAdditionsFromStats(context, question, book));
      battlePageData.updatecurrentDeductionForQuestions(
          _calculateHeroSubstractionsFromStats(context, question, book));
      battlePageData.updatecurrentItemBuffs(_calculateItemGains(context));

      return SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormattedLabelTwo(
                '${Constants.active_battle_bonuses_label} '
                '${battlePageData.currentAddForQuestion - battlePageData.currentDeductionForQuestions + battlePageData.currentItemBuffs}',
                MediaQuery.of(context).size.width / 15,
                ColorLogicbyRole(context)),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormattedLabelTwo(
                '${Constants.hero_stat_buff_label}  ${battlePageData.currentAddForQuestion}',
                MediaQuery.of(context).size.width / textDiv,
                ColorLogicbyRole(context)),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormattedLabelTwo(
                '${Constants.hero_stat_debuff_label} ${battlePageData.currentDeductionForQuestions}',
                MediaQuery.of(context).size.width / textDiv,
                ColorLogicbyRole(context)),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormattedLabelTwo(
                '${Constants.hero_item_buff_label} ${battlePageData.currentItemBuffs}',
                MediaQuery.of(context).size.width / textDiv,
                ColorLogicbyRole(context)),
          ),
        ]),
      );
    },
  );
}

class mySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Text('this is my pinned header');
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 20;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
