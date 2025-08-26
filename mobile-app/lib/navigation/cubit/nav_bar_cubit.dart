import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mushroom_master/guide/view/encyclopedia_page.dart';
import 'package:mushroom_master/history/history_page.dart';
import 'package:mushroom_master/navigation/widgets/smooth_navigation.dart';
import 'package:mushroom_master/profile/about_page.dart';
import 'package:mushroom_master/scanner/camera_page.dart';

final List<Widget> pages = [
  const EncyclopediaPage(),
  const CameraPage(),
  const HistoryPage(),
  const AboutPage(),
];

class NavBarCubit extends Cubit<int> {
  NavBarCubit() : super(0);

  void updateIndex(BuildContext context, int index) {
    emit(index);
    smoothNavigation(context, _getPage(index));
  }

  Widget _getPage(int index) {
    return pages[index];
  }
}
