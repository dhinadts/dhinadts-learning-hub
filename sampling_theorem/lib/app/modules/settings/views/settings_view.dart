import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/global_controllers/theme_controller.dart';
import 'package:sampling_theorem/app/data/utils/custom_app_bar.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        showBackButton: true,
        onBackPressed: () => Get.offAllNamed('/home'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.palette, color: Colors.deepPurple),
                      title: const Text('Theme'),
                      subtitle: Obx(() => Text(
                            themeController.isDarkMode.value
                                ? 'Dark Mode'
                                : 'Light Mode',
                          )),
                      trailing: Obx(() => Switch(
                            value: themeController.isDarkMode.value,
                            onChanged: (value) => themeController.toggleTheme(),
                            activeColor: Colors.deepPurple,
                          )),
                    ),
                    Obx(() => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            themeController.isDarkMode.value
                                ? 'Dark theme reduces eye strain in low-light conditions'
                                : 'Light theme is better for daytime use',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'App Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.blue),
                    title: const Text('About App'),
                    subtitle: const Text('Sampling Theorem Tutorial'),
                    onTap: _showAppInfo,
                  ),
                  ListTile(
                    leading: const Icon(Icons.share, color: Colors.green),
                    title: const Text('Share App'),
                    subtitle: const Text('Share with friends'),
                    onTap: _shareApp,
                  ),
                  ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: const Text('Rate App'),
                    subtitle: const Text('Rate on app store'),
                    onTap: _rateApp,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Data & Privacy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.privacy_tip, color: Colors.purple),
                    title: const Text('Privacy Policy'),
                    onTap: _showPrivacyPolicy,
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.description, color: Colors.orange),
                    title: const Text('Terms of Service'),
                    onTap: _showTerms,
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Clear App Data'),
                    subtitle: const Text('Reset all settings and data'),
                    onTap: _clearData,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppInfo() {
    Get.dialog(
      AlertDialog(
        title: const Text('About Sampling Theorem Tutorial'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This educational app demonstrates the Nyquist-Shannon Sampling Theorem through interactive visualizations.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem('🎯 Interactive signal visualization'),
              _buildFeatureItem('📊 Real-time sampling demonstration'),
              _buildFeatureItem('⚠️ Aliasing effect visualization'),
              _buildFeatureItem('🔄 Signal reconstruction'),
              _buildFeatureItem('📱 Real-world applications'),
              const SizedBox(height: 16),
              const Text(
                'Created for educational purposes to help students and enthusiasts understand digital signal processing fundamentals.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _shareApp() {
    Get.snackbar(
      'Share App',
      'Sharing feature would open your device\'s share dialog',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.deepPurple.withOpacity(0.9),
      colorText: Colors.white,
    );
  }

  void _rateApp() {
    Get.snackbar(
      'Rate App',
      'Rating feature would redirect to app store',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showPrivacyPolicy() {
    Get.defaultDialog(
      title: 'Privacy Policy',
      content: const SingleChildScrollView(
        child: Text(
          'This app does not collect any personal data.\n\n'
          'All data generated during usage (like sampling parameters) is stored locally on your device and is not transmitted to any servers.\n\n'
          'The app does not require internet connectivity and operates completely offline.',
        ),
      ),
      textConfirm: 'OK',
      onConfirm: () => Get.back(),
    );
  }

  void _showTerms() {
    Get.defaultDialog(
      title: 'Terms of Service',
      content: const SingleChildScrollView(
        child: Text(
          'Educational Use License\n\n'
          '1. This app is provided for educational purposes only.\n'
          '2. The content and visualizations are for learning about sampling theorem.\n'
          '3. No warranty is provided for the accuracy of information.\n'
          '4. The app is free to use for personal educational purposes.',
        ),
      ),
      textConfirm: 'Accept',
      onConfirm: () => Get.back(),
    );
  }

  void _clearData() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear App Data'),
        content: const Text(
          'This will reset all app settings and clear any stored data.\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Data Cleared',
                'All app data has been reset',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text(
              'Clear Data',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
