import 'package:flutter/material.dart';

AppBar buildAppBar(String title) {
  return AppBar(title: Text(title));
}

class constantMessage {
  static const noSchema = 'Failed to load schemes';
  static const noNavs = 'Failed to load navs';
  static const NoNavsData = 'No NAV data';
  static const NoFavs = 'No Favorites';
  static const NoSchemeFound = 'No Scheme found';
  static const loadSchema = 'Loading Schema';
}
