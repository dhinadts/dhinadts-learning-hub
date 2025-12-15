import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/global_controllers/theme_controller.dart';
import 'package:sampling_theorem/app/data/utils/app_drawer.dart';
import 'package:sampling_theorem/app/data/utils/custom_app_bar.dart';
import 'package:sampling_theorem/app/modules/home/controllers/home_controller.dart';
import 'package:sampling_theorem/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      return Scaffold(
        key: controller.scaffoldKey,
        // extendBodyBehindAppBar: true,
        drawer: AppDrawer(),
        appBar: CustomAppBar(
          title: "AI Tutorial D.S.P",
          onMenuTap: controller.openDrawer,
          // backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            _buildGradientBackground(context, isDark),
            _buildDashboardContent(isDark),
          ],
        ),
      );
    });
  }

  /// -------------------------
  /// THEME AWARE BACKGROUND
  /// -------------------------
  Widget _buildGradientBackground(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: /* [
            colors.primary.withOpacity(0.85),
            colors.secondary.withOpacity(0.75),
            colors.surface.withOpacity(0.95),
          ], */
              isDark
                  ? const [
                      /* Color(0xFF0F0C29),
                  Color(0xFF302B63),
                  Color(0xFF24243E), */
                      Colors.black,
                      Colors.black45,
                      Colors.white38,
                      Colors.white70
                    ]
                  : const [
                      /* Color(0xFF4F46E5),
                  Color(0xFF9333EA), */
                      // Color(0xFFEC4899),
                      Colors.white70,
                      Colors.white38,
                      Colors.black45,

                      Colors.black
                    ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  /// -------------------------
  /// DASHBOARD GRID
  /// -------------------------
  Widget _buildDashboardContent(bool isDark) {
    return FadeTransition(
      opacity: controller.fadeAnimation,
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 0.92,
        ),
        itemCount: menuItems.length,
        itemBuilder: (_, index) {
          return _premiumTile(menuItems[index], isDark);
        },
      ),
    );
  }

  /// -------------------------
  /// PREMIUM TILE (THEME AWARE)
  /// -------------------------
  Widget _premiumTile(DashboardMenu item, bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed(item.route),
      child: Hero(
        tag: item.title,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),

            /// 🔹 Glass gradient with contrast
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Colors.white.withOpacity(0.10),
                      Colors.white.withOpacity(0.03),
                    ]
                  : [
                      Colors.black.withOpacity(0.08),
                      Colors.black.withOpacity(0.03),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            /// 🔹 Border visibility fix
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.18)
                  : Colors.black.withOpacity(0.15),
            ),

            /// 🔹 Shadow tuned per theme
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.6)
                    : Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(4, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🔹 Icon visibility fix
              Icon(
                item.icon,
                size: 48,
                color: isDark ? Colors.white : Colors.black87,
              ),
              const SizedBox(height: 14),

              /// 🔹 Text visibility fix
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*  Widget _premiumTile(DashboardMenu item, bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed(item.route),
      child: Hero(
        tag: item.title,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.02),
                    ]
                  : [
                      Colors.white.withOpacity(0.22),
                      Colors.white.withOpacity(0.06),
                    ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(isDark ? 0.15 : 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.5 : 0.25),
                blurRadius: 20,
                offset: const Offset(4, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 48, color: Colors.white),
              const SizedBox(height: 14),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
 */
}

/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/utils/app_drawer.dart';
import 'package:sampling_theorem/app/data/utils/custom_app_bar.dart';
import 'package:sampling_theorem/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: AppDrawer(),
      appBar: CustomAppBar(
        title: "AI Titorial D.S.P",
        onMenuTap: controller.openDrawer,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildGradientBackground(),
          _buildDashboardContent(),
        ],
      ),
    );
  }

  /// -------------------------
  /// PREMIUM BACKGROUND
  /// -------------------------
  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF9333EA),
            Color(0xFFEC4899),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  /// -------------------------
  /// PREMIUM GRID CONTENT
  /// -------------------------
  Widget _buildDashboardContent() {
    return FadeTransition(
      opacity: controller.fadeAnimation,
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 0.92,
        ),
        itemCount: menuItems.length,
        itemBuilder: (_, index) {
          final item = menuItems[index];
          return _premiumTile(item);
        },
      ),
    );
  }

  /// -------------------------
  ///  PREMIUM TILE
  /// -------------------------
  Widget _premiumTile(DashboardMenu item) {
    return GestureDetector(
      onTap: () => Get.toNamed(item.route),
      child: Hero(
        tag: item.title,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.20),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(4, 8),
              ),
            ],
            // backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: 1,
                duration: const Duration(milliseconds: 350),
                child: Icon(item.icon, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 14),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------------------
/// MENU ITEMS MODEL
/// -------------------------
class DashboardMenu {
  final IconData icon;
  final String title;
  final String route;

  DashboardMenu({required this.icon, required this.title, required this.route});
}

/// -------------------------
/// MENU ITEMS LIST
/// -------------------------
final List<DashboardMenu> menuItems = [
  DashboardMenu(
      icon: Icons.mic, title: "Voice to Text", route: Routes.voice_text),
  DashboardMenu(
      icon: Icons.ssid_chart,
      title: "Sampling Theorem",
      route: Routes.sampling_theorem),
  DashboardMenu(
      icon: Icons.settings, title: "Settings", route: Routes.settings),
  DashboardMenu(
      icon: Icons.menu_book, title: "Tutorials", route: Routes.tutorials),
];
 */

/// -------------------------
/// MENU ITEMS MODEL
/// -------------------------
class DashboardMenu {
  final IconData icon;
  final String title;
  final String route;

  DashboardMenu({required this.icon, required this.title, required this.route});
}

/// -------------------------
/// MENU ITEMS LIST
/// -------------------------
final List<DashboardMenu> menuItems = [
  DashboardMenu(
      icon: Icons.mic, title: "Voice to Text", route: Routes.voice_text),
  DashboardMenu(
      icon: Icons.ssid_chart,
      title: "Sampling Theorem",
      route: Routes.sampling_theorem),
  DashboardMenu(
      icon: Icons.settings, title: "Settings", route: Routes.settings),
  DashboardMenu(
      icon: Icons.menu_book, title: "Tutorials", route: Routes.tutorials),
];
