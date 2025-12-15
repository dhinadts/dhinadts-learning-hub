import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/utils/custom_app_bar.dart';
import 'package:sampling_theorem/app/modules/sampling_theorem/views/applications_page.dart';
import 'package:sampling_theorem/app/modules/sampling_theorem/views/tutorial_page.dart';

import '../controllers/sampling_theorem_controller.dart';

class SamplingTheoremView extends GetView<SamplingTheoremController> {
  const SamplingTheoremView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: controller.scaffoldKey,
      // drawer: AppDrawer(),
      appBar: CustomAppBar(title: 'Sampling Theorem Tutorial'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/waveform.png', height: 150),
            const SizedBox(height: 30),
            const Text(
              'Nyquist-Shannon Sampling Theorem',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Learn how analog signals are converted to digital through sampling, aliasing, and reconstruction.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TutorialPage(),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Tutorial'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => _showTheory(context),
              icon: const Icon(Icons.menu_book),
              label: const Text('Theory Overview'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApplicationsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.apps),
              label: const Text('Real-World Applications'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTheory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sampling Theorem Theory',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTheoryPoint(
                'Nyquist Rate',
                'Sampling frequency must be at least twice the highest frequency component in the signal.',
              ),
              _buildTheoryPoint(
                'Aliasing',
                'When sampling rate is too low, higher frequencies appear as lower frequencies.',
              ),
              _buildTheoryPoint(
                'Reconstruction',
                'Original signal can be perfectly reconstructed if sampled above Nyquist rate.',
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTheoryPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(description),
        ],
      ),
    );
  }
}
