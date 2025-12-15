import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/global_controllers/theme_controller.dart';

import '../../routes/app_pages.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final double? elevation;
  final Color? backgroundColor;
  final VoidCallback? onMenuTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.elevation,
    this.backgroundColor,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return AppBar(
      backgroundColor: backgroundColor ?? themeController.primaryColor,
      foregroundColor: Colors.white,
      elevation: elevation ?? 4,
      leading: _buildLeading(),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: _buildActions(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
    );
  }

  /// Leading button logic (simple & reliable)
  Widget? _buildLeading() {
    if (onMenuTap != null) {
      return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: onMenuTap,
      );
    }

    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Get.back(),
      );
    }

    return null;
  }

  List<Widget>? _buildActions() {
    final List<Widget> allActions = [];

    if (actions != null) {
      allActions.addAll(actions!);
    }

    allActions.add(
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => Get.toNamed(Routes.settings),
        tooltip: 'Settings',
      ),
    );

    return allActions;
  }
}
