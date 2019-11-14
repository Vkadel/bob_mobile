import 'package:bob_mobile/data_type/personality_questions.dart';
import 'package:bob_mobile/data_type/question.dart';
import 'package:flutter/cupertino.dart';

class PersonalityTestStateData with ChangeNotifier {
  int _progress = 0;
  bool _a_pressed = false;
  bool _b_pressed = false;
  bool _c_pressed = false;
  bool _d_pressed = false;
  bool is_calculating_personality = false;
  List<Question> _permanent = new List();

  //getters
  bool get a_pressed => _a_pressed;
  bool get b_pressed => _b_pressed;
  bool get c_pressed => _c_pressed;
  bool get d_pressed => _d_pressed;
  int get progress => _progress;
  List<Question> get permanent => _permanent;

  PersonalityTestStateData();

  //updaters
  void updateData(PersonalityTestStateData newData) {
    this._progress = newData.progress;
    this._a_pressed = newData._a_pressed;
    this._b_pressed = newData._b_pressed;
    this._c_pressed = newData._c_pressed;
    this._d_pressed = newData._d_pressed;
    this._permanent = newData._permanent;
    notifyListeners();
  }

  void updateProgress(int newProgress) {
    if (newProgress != _progress) {
      _progress = newProgress;
      notifyListeners();
    }
  }

  void updatea_pressed(bool newa_pressed) {
    print('will attempt to set pressed a to ${newa_pressed}');
    if (_a_pressed != newa_pressed) {
      print('set pressed a to ${newa_pressed}');
      _a_pressed = newa_pressed;
      notifyListeners();
    }
  }

  void updateb_pressed(bool newb_pressed) {
    if (_b_pressed != newb_pressed) {
      _b_pressed = newb_pressed;
      notifyListeners();
    }
  }

  void updatec_pressed(bool newc_pressed) {
    if (_c_pressed != newc_pressed) {
      _c_pressed = newc_pressed;
      notifyListeners();
    }
  }

  void updated_pressed(bool newd_pressed) {
    if (_d_pressed != newd_pressed) {
      _d_pressed = newd_pressed;
      notifyListeners();
    }
  }

  void updatepermanent(List<Question> newpermanent) {
    if (_permanent != newpermanent) {
      _permanent = newpermanent;
      notifyListeners();
    }
  }

  void updateisCalculating(bool newIscalculated) {
    if (is_calculating_personality != newIscalculated) {
      is_calculating_personality = newIscalculated;
      notifyListeners();
    }
  }
}
