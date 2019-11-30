import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../helpers/constants.dart';

/// A class to keep the battle information
///
///
/// [question_answered] will ensure the interface is not updated until the .
///
///
///
class BattlePageStateData with ChangeNotifier {
  bool _question_answered = false;
  bool _continue_fighting = true;
  bool _personal;
  bool _pressed_a;
  bool _pressed_b;
  bool _pressed_c;
  bool _pressed_d;
  bool _pressed_correct;
  int _currentAddForQuestion = 0;
  int _currentDeductionForQuestions = 0;
  int _currentItemBuffs = 0;
  int _total_points_if_correct = 0;
  int _monster_life = 100;
  int _hero_life = 100;
  int _blows_required_to_kill_mob = new Random().nextInt(5) + 1;

  //getters
  bool get question_answered => _question_answered;
  bool get personal => _personal;
  bool get pressed_a => _pressed_a;
  bool get pressed_b => _pressed_b;
  bool get pressed_c => _pressed_c;
  bool get pressed_d => _pressed_d;
  bool get pressed_correct => _pressed_correct;
  bool get continue_fighting => _continue_fighting;
  int get currentAddForQuestion => _currentAddForQuestion;
  int get currentDeductionForQuestions => _currentDeductionForQuestions;
  int get currentItemBuffs => _currentItemBuffs;
  int get total_points_if_correct => _total_points_if_correct;
  int get monster_life => _monster_life;
  int get hero_life => _hero_life;
  int get blows_required_to_kill_mob => _blows_required_to_kill_mob;
  BattlePageStateData get battlePageData => this;

  BattlePageStateData();

  //Updaters
  void updatecontinue_fighting(bool newcontinue_fighting) {
    if (this.continue_fighting != newcontinue_fighting) {
      this._continue_fighting = newcontinue_fighting;
      notifyListeners();
    }
  }

  void updatetotal_points_if_correct(int newtotal_points_if_correct) {
    if (this._total_points_if_correct != newtotal_points_if_correct) {
      this._total_points_if_correct = newtotal_points_if_correct;
      notifyListeners();
    }
  }

  void updatecurrentItemBuffs(int newcurrentItemBuffs) {
    if (this._currentItemBuffs != newcurrentItemBuffs) {
      this._currentItemBuffs = newcurrentItemBuffs;
      notifyListeners();
    }
  }

  void updatecurrentDeductionForQuestions(int newcurrentDeductionForQuestions) {
    if (this._currentDeductionForQuestions != newcurrentDeductionForQuestions) {
      this._currentDeductionForQuestions = newcurrentDeductionForQuestions;
      notifyListeners();
    }
  }

  void updatecurrentAddForQuestion(int newcurrentAddForQuestion) {
    if (this._currentAddForQuestion != newcurrentAddForQuestion) {
      this._currentAddForQuestion = newcurrentAddForQuestion;
      notifyListeners();
    }
  }

  void updatehero_life(int newhero_life) {
    if (this._hero_life != newhero_life) {
      this._hero_life = newhero_life;
      notifyListeners();
    }
  }

  void updatemonster_life(int newmonster_life) {
    if (this._monster_life != newmonster_life) {
      this._monster_life = newmonster_life;
      notifyListeners();
    }
  }

  void updatepersonal(bool newpersonal) {
    if (this._personal != newpersonal) {
      this._personal = newpersonal;
      notifyListeners();
    }
  }

  void updatepressed_a(bool newpressed_a) {
    if (this._pressed_a != newpressed_a) {
      this._pressed_a = pressed_a;
      _question_answered = true;
      notifyListeners();
    }
  }

  void updatepressed_b(bool newpressed_b) {
    if (this._pressed_b != newpressed_b) {
      this._pressed_b = pressed_b;
      _question_answered = true;
      notifyListeners();
    }
  }

  void updatepressed_c(bool newpressed_c) {
    if (this._pressed_c != newpressed_c) {
      this._pressed_c = pressed_c;
      _question_answered = true;
      notifyListeners();
    }
  }

  void updatepressed_d(bool newpressed_d) {
    if (this.pressed_d != newpressed_d) {
      this._pressed_d = newpressed_d;
      _question_answered = true;
      notifyListeners();
    }
  }

  void updatepressed_correct(bool newpressed_correct) {
    if (this.pressed_correct != newpressed_correct) {
      this._pressed_correct = newpressed_correct;
      notifyListeners();
      _question_answered = true;
    }
  }

  addPointHitForHero() {
    int buffPoints = this._currentAddForQuestion +
        this.currentItemBuffs -
        this._currentDeductionForQuestions;
    int newPoints;
    buffPoints >= 0 ? buffPoints = buffPoints : buffPoints = 0;
    int myConstant = Constants.point_perQuestion;
    this.updatetotal_points_if_correct(
        _total_points_if_correct + buffPoints + myConstant);
  }

  hitMob() {
    print(
        'going to hit the mob with multiplier of: ${_blows_required_to_kill_mob}');

    _blows_required_to_kill_mob =
        new Random().nextInt(Constants.blows_ceiling_to_kill_mob);

    double ammountToLifeToTake = (100 / _blows_required_to_kill_mob);
    monster_life - ammountToLifeToTake.round() <= 0
        ? finishBattle()
        : this.updatemonster_life(_monster_life - ammountToLifeToTake.round());
  }

  void hitHero() {
    double ammountToLifeToTake = (100 / _blows_required_to_kill_mob);
    hero_life - ammountToLifeToTake.round() <= 0
        ? finishBattle()
        : this.updatehero_life(hero_life - ammountToLifeToTake.round());
  }

  void finishBattle() {
    _continue_fighting = false;
    notifyListeners();
  }

  void resetWithoutUpdate() {
    _continue_fighting = true;
    _personal;
    _pressed_a = false;
    _pressed_b = false;
    _pressed_c = false;
    _pressed_d = false;
    _pressed_correct = false;
    _currentAddForQuestion = 0;
    _currentDeductionForQuestions = 0;
    _currentItemBuffs = 0;
    _total_points_if_correct = 0;
    _monster_life = 100;
    _hero_life = 100;
    _blows_required_to_kill_mob = new Random().nextInt(5) + 1;
  }
}
