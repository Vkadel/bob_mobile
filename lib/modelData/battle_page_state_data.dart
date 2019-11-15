import 'package:flutter/cupertino.dart';

class BattlePageStateData with ChangeNotifier {
  bool _personal;
  bool _pressed_a;
  bool _pressed_b;
  bool _pressed_c;
  bool _pressed_d;
  bool _pressed_correct;
  int _currentAddForQuestion;
  int _currentDeductionForQuestions;
  int _currentItemBuffs;
  int _total_points_if_correct;

  //getters
  bool get personal => _personal;
  bool get pressed_a => _pressed_a;
  bool get pressed_b => _pressed_b;
  bool get pressed_c => _pressed_c;
  bool get pressed_d => _pressed_d;
  bool get pressed_correct => _pressed_correct;
  int get currentAddForQuestion => _currentAddForQuestion;
  int get currentDeductionForQuestions => _currentDeductionForQuestions;
  int get currentItemBuffs => _currentItemBuffs;
  int get total_points_if_correct => _total_points_if_correct;
  BattlePageStateData get battlePageData => this;

  BattlePageStateData();

  //Updaters

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

  void updatepersonal(bool newpersonal) {
    if (this._personal != newpersonal) {
      this._personal = newpersonal;
      notifyListeners();
    }
  }

  void updatepressed_a(bool newpressed_a) {
    if (this._pressed_a != newpressed_a) {
      this._pressed_a = pressed_a;
      notifyListeners();
    }
  }

  void updatepressed_b(bool newpressed_b) {
    if (this._pressed_b != newpressed_b) {
      this._pressed_b = pressed_b;
      notifyListeners();
    }
  }

  void updatepressed_c(bool newpressed_c) {
    if (this._pressed_c != newpressed_c) {
      this._pressed_c = pressed_c;
      notifyListeners();
    }
  }

  void updatepressed_d(bool newpressed_d) {
    if (this.pressed_d != newpressed_d) {
      this._pressed_d = pressed_d;
      notifyListeners();
    }
  }

  void updatepressed_correct(bool newpressed_correct) {
    if (this.pressed_correct != newpressed_correct) {
      this._pressed_correct = pressed_correct;
      notifyListeners();
    }
  }
}
