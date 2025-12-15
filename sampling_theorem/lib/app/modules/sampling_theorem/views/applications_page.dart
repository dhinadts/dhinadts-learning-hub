// applications_screen.dart
import 'package:flutter/material.dart';
import 'package:sampling_theorem/app/data/utils/custom_app_bar.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Real-World Applications',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderSection(),
            const SizedBox(height: 20),
            _ApplicationCard(
              icon: Icons.audiotrack,
              title: 'Digital Audio & Music',
              color: Colors.blue,
              examples: [
                '🎵 Spotify/Apple Music (44.1kHz sampling)',
                '📞 Phone Calls (8kHz for speech)',
                '🎧 Bluetooth Audio (48kHz)',
                '🎤 Podcast Recording (96kHz for high quality)',
              ],
              explanation:
                  'Audio is sampled at different rates based on needs. '
                  'Music needs higher rates (44.1kHz) to capture full range '
                  'while phone calls use lower rates (8kHz) focusing on speech.',
              samplingRate: '44.1 kHz',
              nyquist: '22.05 kHz',
            ),
            const SizedBox(height: 16),
            _ApplicationCard(
              icon: Icons.videocam,
              title: 'Video & Streaming',
              color: Colors.red,
              examples: [
                '🎬 Netflix/YouTube (24-60 fps)',
                '📱 Slow Motion (240-960 fps)',
                '📹 Video Calls (30 fps)',
                '🎥 Cinema (24 fps temporal sampling)',
              ],
              explanation: 'Video uses temporal sampling (frames per second) '
                  'and spatial sampling (pixels). Higher fps prevents motion '
                  'aliasing (wagon wheel effect).',
              samplingRate: '60 fps',
              nyquist: '30 Hz motion',
            ),
            const SizedBox(height: 16),
            _ApplicationCard(
              icon: Icons.camera_alt,
              title: 'Digital Photography',
              color: Colors.green,
              examples: [
                '📸 Smartphone Cameras (12-108 MP)',
                '🛰 Satellite Imagery',
                '🏥 Medical Imaging (MRI/CT)',
                '🔬 Microscope Imaging',
              ],
              explanation: 'Camera sensors sample light intensity spatially. '
                  'More megapixels = higher spatial sampling. '
                  'Color filter arrays sample RGB separately.',
              samplingRate: '12-48 MP',
              nyquist: 'Spatial resolution limits',
            ),
            const SizedBox(height: 16),
            _ApplicationCard(
              icon: Icons.phone_android,
              title: 'Mobile Communications',
              color: Colors.orange,
              examples: [
                '📶 5G/4G Networks',
                '📡 Wi-Fi (OFDM)',
                '📶 Bluetooth',
                '🛰 GPS Navigation',
              ],
              explanation: 'Digital communication systems sample signals '
                  'for transmission. 5G uses massive MIMO with precise '
                  'timing to prevent interference.',
              samplingRate: 'Varies by standard',
              nyquist: 'Bandwidth dependent',
            ),
            const SizedBox(height: 16),
            _ApplicationCard(
              icon: Icons.monitor_heart,
              title: 'Medical Technology',
              color: Colors.purple,
              examples: [
                '❤️ ECG/EKG (250-500 Hz)',
                '🧠 EEG Brain Monitoring',
                '🩺 Digital Stethoscopes',
                '⌚ Fitness Trackers',
              ],
              explanation: 'Medical devices sample biological signals. '
                  'ECG samples heart electrical activity at 250-500Hz '
                  'to detect abnormalities like arrhythmias.',
              samplingRate: '250-500 Hz',
              nyquist: '125-250 Hz',
            ),
            const SizedBox(height: 16),
            _ApplicationCard(
              icon: Icons.directions_car,
              title: 'Automotive & ADAS',
              color: Colors.teal,
              examples: [
                '🚗 Radar/Lidar (object detection)',
                '📷 Camera Systems (Autopilot)',
                '🧭 GPS & Navigation',
                '⚡ EV Battery Management',
              ],
              explanation: 'Self-driving cars use multiple sampling systems: '
                  'Radar samples distance, cameras sample visual data, '
                  'and lidar samples 3D point clouds.',
              samplingRate: '10-100 Hz',
              nyquist: '5-50 Hz',
            ),
            const SizedBox(height: 16),
            _ApplicationCard(
              icon: Icons.smart_toy,
              title: 'IoT & Smart Devices',
              color: Colors.indigo,
              examples: [
                '🏠 Smart Home Assistants',
                '📹 Security Cameras',
                '🌡 Smart Thermostats',
                '💪 Fitness Wearables',
              ],
              explanation: 'IoT devices continuously sample sensor data: '
                  'Voice assistants sample audio, wearables sample '
                  'biometrics, and cameras sample video.',
              samplingRate: 'Varies by device',
              nyquist: 'Application specific',
            ),
            const SizedBox(height: 24),
            const _AliasingExamples(),
            const SizedBox(height: 16),
            const _CommonRatesTable(),
            const SizedBox(height: 30),
            const _ClosingNote(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        color: Colors.deepPurple[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Colors.deepPurple,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Everywhere You Look: Sampling in Action',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'The Nyquist-Shannon Sampling Theorem isn\'t just theory - '
                'it\'s the foundation of our digital world. '
                'Every digital device you use relies on proper sampling '
                'to convert analog signals to digital data.',
                style: TextStyle(fontSize: 15, color: Colors.black45),
              ),
            ],
          ),
        ));
  }
}

class _ApplicationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final List<String> examples;
  final String explanation;
  final String samplingRate;
  final String nyquist;

  const _ApplicationCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.examples,
    required this.explanation,
    required this.samplingRate,
    required this.nyquist,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Examples
            const Text(
              'Common Examples:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...examples.map((example) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(child: Text(example)),
                    ],
                  ),
                )),

            const SizedBox(height: 12),

            // Technical Details Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Technical Details:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          explanation,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Sampling Rate',
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          samplingRate,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nyquist: $nyquist',
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AliasingExamples extends StatelessWidget {
  const _AliasingExamples();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange[800]),
                const SizedBox(width: 8),
                Text(
                  'Aliasing in Real Life',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _AliasingExampleItem(
              title: '🎬 Wagon Wheel Effect',
              description: 'In movies, car wheels appear to spin backward '
                  'because frame rate < wheel rotation rate',
              fix: 'Increase frame rate or use motion blur',
            ),
            const SizedBox(height: 8),
            _AliasingExampleItem(
              title: '👔 Moiré Patterns',
              description: 'Strange patterns appear when photographing '
                  'fine fabrics or screens',
              fix: 'Anti-aliasing filters on camera sensors',
            ),
            const SizedBox(height: 8),
            _AliasingExampleItem(
              title: '🎵 Audio Artifacts',
              description: 'High-pitched "birdies" or metallic sounds '
                  'in cheap recordings',
              fix: 'Proper anti-aliasing filters before sampling',
            ),
            const SizedBox(height: 8),
            _AliasingExampleItem(
              title: '📱 Digital Artifacts',
              description: 'Pixelation in zoomed images or blocky video',
              fix: 'Higher sampling rates and better compression',
            ),
          ],
        ),
      ),
    );
  }
}

class _AliasingExampleItem extends StatelessWidget {
  final String title;
  final String description;
  final String fix;

  const _AliasingExampleItem({
    required this.title,
    required this.description,
    required this.fix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.black38),
          ),
          const SizedBox(height: 4),
          Text(
            'Fix: $fix',
            style: TextStyle(
              color: Colors.green[700],
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommonRatesTable extends StatelessWidget {
  const _CommonRatesTable();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Common Sampling Rates in Technology',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Different applications require different sampling rates:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Technology')),
                  DataColumn(label: Text('Sampling Rate')),
                  DataColumn(label: Text('Nyquist Limit')),
                  DataColumn(label: Text('Purpose')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Telephone')),
                    DataCell(Text('8 kHz')),
                    DataCell(Text('4 kHz')),
                    DataCell(Text('Voice communication')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('CD Audio')),
                    DataCell(Text('44.1 kHz')),
                    DataCell(Text('22.05 kHz')),
                    DataCell(Text('Music reproduction')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('DVD Audio')),
                    DataCell(Text('48 kHz')),
                    DataCell(Text('24 kHz')),
                    DataCell(Text('Movie soundtracks')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('HD Video')),
                    DataCell(Text('60 fps')),
                    DataCell(Text('30 Hz')),
                    DataCell(Text('Smooth motion')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('ECG Monitor')),
                    DataCell(Text('250-500 Hz')),
                    DataCell(Text('125-250 Hz')),
                    DataCell(Text('Heart monitoring')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('GPS')),
                    DataCell(Text('1-10 Hz')),
                    DataCell(Text('0.5-5 Hz')),
                    DataCell(Text('Position tracking')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Smartphone HR')),
                    DataCell(Text('100-250 Hz')),
                    DataCell(Text('50-125 Hz')),
                    DataCell(Text('Heart rate monitoring')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Wi-Fi 6')),
                    DataCell(Text('160 MHz')),
                    DataCell(Text('80 MHz')),
                    DataCell(Text('High-speed data')),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClosingNote extends StatelessWidget {
  const _ClosingNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple[50]!, Colors.blue[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: Colors.deepPurple, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'The Invisible Foundation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Every digital experience you have today - from crystal-clear '
            'video calls to precise GPS navigation, from your favorite '
            'streaming music to life-saving medical devices - relies on '
            'the simple but profound principle of the Sampling Theorem.',
            style: TextStyle(fontSize: 15, color: Colors.black, height: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'By ensuring we sample signals at least twice their highest '
            'frequency component, we can perfectly reconstruct the '
            'original analog information from digital data. This principle '
            'enables our entire digital world.',
            style: TextStyle(fontSize: 15, color: Colors.black, height: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Sampling Theorem: The bridge between analog and digital worlds',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
