// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/routes/app_pages.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),

          // -----------------------
          // HOME
          // -----------------------
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.offAllNamed(Routes.home);
            },
          ),

          // -----------------------
          // SETTINGS
          // -----------------------
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Get.toNamed(Routes.settings);
            },
          ),

          // -----------------------
          // VOICE TO TEXT
          // -----------------------
          ListTile(
            leading: const Icon(Icons.mic),
            title: const Text('Voice to Text'),
            onTap: () {
              Get.toNamed(Routes.voice_text);
            },
          ),

          // -----------------------
          // SAMPLING THEOREM PAGE
          // -----------------------
          ListTile(
            leading: const Icon(Icons.ssid_chart),
            title: const Text('Sampling Theorem'),
            onTap: () {
              Get.toNamed(Routes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Tutorials'),
            onTap: () {
              Get.toNamed(Routes.home);
            },
          ),
        ],
      ),
    );
  }
}
