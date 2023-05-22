// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('login_details') != null ? true : false;
  }

  static Future<List<UserModel>?> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('login_details') != null) {
      final data =
          jsonDecode(prefs.getString('login_details')!) as List<dynamic>;

      final details = [
        UserModel(
          id: data.first['id'],
          idCard: data.first['idCard'],
          firstname: data.first['firstname'],
          lastname: data.first['lastname'],
          mobile: data.first['mobile'],
          email: data.first['email'],
          rank: data.first['rank'],
          affiliation: data.first['affiliation'],
          status: data.first['status'],
        )
      ];
      return details;
    } else {
      return null;
    }
  }

  static Future<void> setLoginDetails(UserModel? response) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'login_details', response != null ? jsonEncode(response) : '');
  }

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
