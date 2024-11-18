import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs_rashhuli/views/modules/categories_view.dart';
import 'package:bs_rashhuli/views/modules/favourite_view.dart';
import 'package:bs_rashhuli/views/modules/home_view.dart';
import 'package:bs_rashhuli/views/modules/settings_view.dart';

class BottomNaviCubit extends Cubit<int> {
  BottomNaviCubit() : super(0);

  List<Widget> screensList = const [
    HomeView(),
    CategoriesView(),
    FavouriteView(),
    SettingsView(),
  ];
  List<String> titlesList = const [
    'الرئيسية',
    'التصنيفات',
    'المفضلة',
    'الإعدادات',
  ];

  int currentIndex = 0;
  changeSelectedIndex(int newIndex) {
    currentIndex = newIndex;
    emit(newIndex);
  }
}
