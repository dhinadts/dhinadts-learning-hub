import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/utils/custom_app_bar.dart';
import 'package:sampling_theorem/app/modules/tutorials/views/dasboard_card.dart';

import '../controllers/tutorials_controller.dart';

class TutorialsView extends GetView<TutorialsController> {
  const TutorialsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'DSP Laboratory',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.withOpacity(0.1),
                    Colors.blue.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.science,
                    size: 60,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Digital Signal Processing Lab',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Interactive visualizations for signal processing',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Features Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                DashboardCard(
                  icon: Icons.waves,
                  title: 'Signal Generator',
                  subtitle: 'Generate various signals',
                  color: Colors.blue,
                  route: '/signal-generator',
                ),
                DashboardCard(
                  icon: Icons.analytics,
                  title: 'FFT Analyzer',
                  subtitle: 'Frequency analysis',
                  color: Colors.green,
                  route: '/fft-analyzer',
                ),
                DashboardCard(
                  icon: Icons.mic,
                  title: 'Voice DSP',
                  subtitle: 'Audio processing',
                  color: Colors.orange,
                  route: '/voice-dsp',
                ),
                DashboardCard(
                  icon: Icons.psychology,
                  title: 'AI Insights',
                  subtitle: 'ML-based analysis',
                  color: Colors.purple,
                  route: '/ai-insights',
                ),
                DashboardCard(
                  icon: Icons.animation,
                  title: 'Animations',
                  subtitle: 'Visual demonstrations',
                  color: Colors.red,
                  route: '/animations',
                ),
                DashboardCard(
                  icon: Icons.school,
                  title: 'Tutorial',
                  subtitle: 'Learn DSP concepts',
                  color: Colors.teal,
                  route: '/tutorial',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
    
 /*   
    
    
    return Scaffold(
      appBar: CustomAppBar(title: "DSP Laboratory"),
      body: Stack(
        children: [
          _background(theme),
          SafeArea(
            child: FadeTransition(
              opacity: controller.fadeAnimation,
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: dashboardItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.92,
                ),
                itemBuilder: (_, index) {
                  return _dashboardTile(
                    dashboardItems[index],
                    isDark,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🌈 Theme-aware background
  Widget _background(ThemeData theme) {
    final colors = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary.withOpacity(0.9),
            colors.secondary.withOpacity(0.7),
            colors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  /// 🧊 Premium Glass Tile
  Widget _dashboardTile(DashboardItem item, bool isDark) {
    return GestureDetector(
      onTap: item.enabled
          ? () => Get.toNamed(item.route)
          : () => Get.snackbar(
                "Coming Soon",
                "This feature is under development",
                snackPosition: SnackPosition.BOTTOM,
              ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
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
          ),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.18)
                : Colors.black.withOpacity(0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.6 : 0.2),
              blurRadius: 20,
              offset: const Offset(4, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 46,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔒 Disabled overlay
            if (!item.enabled)
              Positioned(
                top: 12,
                right: 12,
                child: Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: Colors.orangeAccent,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final String route;
  final bool enabled;

  DashboardItem({
    required this.title,
    required this.icon,
    required this.route,
    this.enabled = true,
  });
}

final List<DashboardItem> dashboardItems = [
  DashboardItem(
    title: "Signal Generator",
    icon: Icons.graphic_eq,
    route: "/signal-generator",
  ),
  DashboardItem(
    title: "Sampling Theorem",
    icon: Icons.ssid_chart,
    route: "/sampling-theorem",
  ),
  DashboardItem(
    title: "FFT Visualizer",
    icon: Icons.multiline_chart,
    route: "/fft",
  ),
  DashboardItem(
    title: "Filters Lab",
    icon: Icons.filter_alt,
    route: "/filters",
  ),
  DashboardItem(
    title: "Voice DSP",
    icon: Icons.mic,
    route: "/voice-dsp",
  ),
  DashboardItem(
    title: "AI Insights",
    icon: Icons.psychology,
    route: "/ai-insights",
    enabled: false, // 🚧 future
  ),
];
*/