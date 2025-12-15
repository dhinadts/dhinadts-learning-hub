import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController animController;
  late Animation<double> fadeAnimation;
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  @override
  void onInit() {
    super.onInit();

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeOut,
    );

    animController.forward();
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }
}
