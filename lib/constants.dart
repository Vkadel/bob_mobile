import 'package:bob_mobile/data_type/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static final String unit_points = 'Points';
  final int number_of_questions_personality_test = 20;
  final String select_your_role_page_title = "Select your Hero Type";
  final String user_dashboard_title = "Take actions to stop the dark";
  static final String go_to_hero_room_but_text = 'Hero Room';
  static final String go_to_team_hall_but_text = 'Team Hall';
  final String knight_1_story =
      "After the knights' order was destroyed, the grandmaster called all the acolytes back from their missions. Each of them was tasked with the same task protect the weak and fight off the dark.";
  final String mage_2_story =
      "Master warned during training that the dark was coming, and then the world became total darkness. The mage then goes off to understand how this dark started and to seek knowledge to bring back the light.";
  final String archer_3_story =
      "Archers struggle to survive in the forest.  Within their lands the darkness spread stealing away those that cannot defend themselves. Some are leaving their homes and looking for better hunt elsewhere. Others have no choice but to face the darkness head-on if they want to protect their land and keep the darkness at bay.";
  static List<Avatar> myAvatars;

/*  static Color icon_Colors = Colors.yellow[50];
  static Color color_main = Color.fromRGBO(255, 106, 36, 255);
  static Color color_secondary = Color.fromRGBO(143, 96, 255, 255);
  static Color color_intro = Color.fromRGBO(146, 34, 230, 255);
  static Color color_extro = Color.fromRGBO(255, 34, 68, 255);*/

  static Color icon_Colors = Colors.yellow[50];
  static Color color_main = Colors.deepOrange;
  static Color color_secondary = Colors.lightGreenAccent;
  static Color color_intro = Colors.deepPurple;
  static Color color_extro = Colors.redAccent[400];

  //Button Labels hero screen
  static final String i_want_to_be_knight = 'I want to be a Knight';
  static final String i_want_to_be_mage = 'I want to be a Mage';
  static final String i_want_to_be_archer = 'I want to be an Archer';
  static final String contract_knight = 'I want to be a Knight';
  static final String contract_mage = 'I want to be a Mage';
  static final String contract_archer = 'I want to be an Archer';

  static final int role_avatar_knight = 1;
  static final int role_avatar_mage = 2;
  static final int role_avatar_archer = 3;
  Constants() {
    myAvatars = <Avatar>[];
    myAvatars.add(
      new Avatar(
          knight_1_story,
          Colors.orange[600],
          'Knight',
          role_avatar_knight,
          'assets/knight.png',
          'assets/knight_icon.svg',
          contract_knight,
          'assets/knight_header_dashboard.png'),
    );
    myAvatars.add(
      new Avatar(
          mage_2_story,
          Colors.blue[600],
          'Mage',
          role_avatar_mage,
          'assets/mage.png',
          'assets/mage_icon.svg',
          contract_mage,
          'assets/mage_header_dashboard.png'),
    );
    myAvatars.add(
      new Avatar(
          archer_3_story,
          Colors.lightGreen[700],
          'Archer',
          role_avatar_archer,
          'assets/archer.png',
          'assets/archer_icon.svg',
          contract_archer,
          'assets/archer_header_dashboard.png'),
    );
  }
}
