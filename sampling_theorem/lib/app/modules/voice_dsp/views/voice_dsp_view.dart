import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/utils/custom_app_bar.dart';
import 'package:sampling_theorem/app/modules/voice_dsp/views/audio_spectrum_painter.dart';
import 'package:sampling_theorem/app/modules/voice_dsp/views/audio_waveform_painter.dart';
import '../controllers/voice_dsp_controller.dart';

class VoiceDspView extends GetView<VoiceDspController> {
  const VoiceDspView({super.key});
  // app/modules/voice_dsp/views/voice_dsp_view.dart

  @override
  Widget build(BuildContext context) {
    // final recorderService = VoiceRecorderService();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Voice DSP Processor',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Real-time Visualization Section
            _buildVisualizationSection(),

            /* SizedBox(
              height: 120,
              child: CustomPaint(
                painter: AudioWaveformPainter(
                  // Fixed class name
                  waveformData: controller.waveformData,
                  isRecording: controller.isRecording.value,
                ),
              ),
            ), */

            // Audio Controls Section
            _buildAudioControlsSection(),

            // Filters and Effects Section
            _buildFiltersSection(),

            // Audio Analysis Section
            _buildAnalysisSection(),

            // Action Buttons
            // _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizationSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Real-time Waveform
          Obx(() {
            return SizedBox(
              height: 120,
              child: CustomPaint(
                painter: AudioWaveformPainter(
                  waveformData: controller.waveformData,
                  isRecording: controller.isRecording.value,
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Real-time Spectrum
          Obx(() {
            return SizedBox(
              height: 120,
              child: CustomPaint(
                painter: AudioSpectrumPainter(
                  spectrumData: controller.spectrumData,
                  isActive: controller.isRecording.value ||
                      controller.isPlaying.value,
                ),
              ),
            );
          }),

          // Recording/Playback Status
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusIndicator(
                    'Recording',
                    controller.isRecording.value,
                    Colors.red,
                  ),
                  _buildStatusIndicator(
                    'Playing',
                    controller.isPlaying.value,
                    Colors.green,
                  ),
                  _buildStatusIndicator(
                    'Processing',
                    controller.isRecording.value,
                    Colors.blue,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, bool active, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? color : Colors.grey[300],
            boxShadow: active
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? color : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAudioControlsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status Message
          Obx(() {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.statusMessage.value,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// 🎙 RECORD
              Obx(() {
                if (controller.isInitializing.value) {
                  return ElevatedButton.icon(
                    onPressed: null,
                    icon: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    label: Text('Initializing...'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  );
                }

                return ElevatedButton.icon(
                  onPressed: controller.isRecording.value
                      ? controller.stopRecording
                      : controller.startRecording,
                  icon: Icon(
                    controller.isRecording.value ? Icons.stop : Icons.mic,
                  ),
                  label: Text(
                    controller.isRecording.value
                        ? 'Stop Recording'
                        : 'Start Recording',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.isRecording.value ? Colors.red : Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                );
              }),

              /// ▶ PLAY
              Obx(() {
                return ElevatedButton.icon(
                  onPressed: controller.isPlaying.value
                      ? controller.stopPlayback
                      : controller.playRecording,
                  icon: Icon(
                    controller.isPlaying.value ? Icons.stop : Icons.play_arrow,
                  ),
                  label: Text(
                    controller.isPlaying.value
                        ? 'Stop Playback'
                        : 'Play Recording',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.isPlaying.value ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 16),
          _buildParameterSlider(
            label: 'Sample Rate',
            value: controller.sampleRate.value.toDouble(),
            min: 8000,
            max: 48000,
            divisions: 8,
            unit: 'Hz',
            onChanged: (value) => controller.sampleRate.value = value.toInt(),
          ),
          _buildParameterSlider(
            label: 'FFT Size',
            value: controller.fftSize.value.toDouble(),
            min: 256,
            max: 4096,
            divisions: 8,
            unit: 'points',
            onChanged: (value) => controller.fftSize.value = value.toInt(),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audio Filters & Effects',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.deepPurple,
            ),
          ),

          const SizedBox(height: 16),

          // Filter Toggles
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterToggle(
                label: 'Low Pass',
                value: controller.applyLowPass.value,
                onChanged: (value) => controller.applyLowPass.value = value,
                color: Colors.blue,
              ),
              _buildFilterToggle(
                label: 'High Pass',
                value: controller.applyHighPass.value,
                onChanged: (value) => controller.applyHighPass.value = value,
                color: Colors.green,
              ),
              _buildFilterToggle(
                label: 'Echo',
                value: controller.applyEcho.value,
                onChanged: (value) => controller.applyEcho.value = value,
                color: Colors.orange,
              ),
              _buildFilterToggle(
                label: 'Reverb',
                value: controller.applyReverb.value,
                onChanged: (value) => controller.applyReverb.value = value,
                color: Colors.purple,
              ),
              _buildFilterToggle(
                label: 'Chorus',
                value: controller.applyChorus.value,
                onChanged: (value) => controller.applyChorus.value = value,
                color: Colors.red,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Filter Parameters
          Obx(() {
            if (controller.applyLowPass.value) {
              return _buildFilterParameterSlider(
                label: 'Low Pass Cutoff',
                value: controller.lowPassCutoff.value,
                min: 100,
                max: 5000,
                unit: 'Hz',
                onChanged: (value) => controller.lowPassCutoff.value = value,
              );
            }
            return const SizedBox();
          }),

          Obx(() {
            if (controller.applyHighPass.value) {
              return _buildFilterParameterSlider(
                label: 'High Pass Cutoff',
                value: controller.highPassCutoff.value,
                min: 50,
                max: 2000,
                unit: 'Hz',
                onChanged: (value) => controller.highPassCutoff.value = value,
              );
            }
            return const SizedBox();
          }),

          Obx(() {
            if (controller.applyEcho.value) {
              return Column(
                children: [
                  _buildFilterParameterSlider(
                    label: 'Echo Delay',
                    value: controller.echoDelay.value,
                    min: 0.1,
                    max: 1.0,
                    unit: 's',
                    onChanged: (value) => controller.echoDelay.value = value,
                  ),
                  _buildFilterParameterSlider(
                    label: 'Echo Decay',
                    value: controller.echoDecay.value,
                    min: 0.1,
                    max: 0.9,
                    unit: '',
                    onChanged: (value) => controller.echoDecay.value = value,
                  ),
                ],
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audio Analysis',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.deepPurple,
            ),
          ),

          const SizedBox(height: 16),

          // Audio Metrics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildMetricCard(
                'Volume',
                '${controller.currentVolume.value.toStringAsFixed(3)}',
                Icons.volume_up,
                Colors.blue,
              ),
              _buildMetricCard(
                'Pitch',
                '${controller.pitch.value.toStringAsFixed(1)} Hz',
                Icons.trending_up,
                Colors.green,
              ),
              _buildMetricCard(
                'RMS',
                controller.rmsValue.value.toStringAsFixed(4),
                Icons.show_chart,
                Colors.orange,
              ),
              _buildMetricCard(
                'Zero Crossings',
                controller.zeroCrossingRate.value.toStringAsFixed(4),
                Icons.compare_arrows,
                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Frequency Analysis
          Obx(() {
            if (controller.audioFFT.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Frequency Analysis',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    /*  SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: controller.getPeakFrequencies().map((peak) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              peak,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ), */
                  ],
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  /* Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: controller.exportAudioAnalysis,
            icon: const Icon(Icons.analytics),
            label: const Text('Export Analysis'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: controller.resetSettings,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Reset All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  } */

  Widget _buildParameterSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String unit,
    required Function(double) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${value.toInt()} $unit',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.deepPurple.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterToggle({
    required String label,
    required bool value,
    required Function(bool) onChanged,
    required Color color,
  }) {
    return FilterChip(
      label: Text(label),
      selected: value,
      onSelected: onChanged,
      backgroundColor: Colors.grey[200],
      selectedColor: color,
      labelStyle: TextStyle(
        color: value ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildFilterParameterSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Function(double) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                '${value.toStringAsFixed(2)} $unit',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.deepPurple.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

// Add this to your _buildAudioControlsSection
  Widget _buildPlaybackControls() {
    return Obx(() {
      if (controller.recordedFilePath.value.isEmpty) return SizedBox();

      return Column(
        children: [
          const SizedBox(height: 16),

          // Playback Progress
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(controller.playbackPosition.value),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      _formatDuration(controller.playbackDuration.value),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Slider(
                value: controller.playbackProgress.value,
                onChanged: (value) {
                  controller.seekPlayback(value);
                },
                min: 0,
                max: 1,
              ),
            ],
          ),

          // Playback Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: controller.stopPlayback,
                icon: Icon(Icons.stop),
                tooltip: 'Stop',
              ),
              IconButton(
                onPressed: controller.isPlaying.value
                    ? controller.pausePlayback
                    : controller.resumePlayback,
                icon: Icon(
                  controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                ),
                tooltip: controller.isPlaying.value ? 'Pause' : 'Play',
              ),
            ],
          ),
        ],
      );
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
