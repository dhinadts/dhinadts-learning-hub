import 'package:get/get.dart';

import '../modules/fft_analyzer/bindings/fft_analyzer_binding.dart';
import '../modules/fft_analyzer/views/fft_analyzer_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/sampling_theorem/bindings/sampling_theorem_binding.dart';
import '../modules/sampling_theorem/views/sampling_theorem_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/signal_generator/bindings/signal_generator_binding.dart';
import '../modules/signal_generator/views/signal_generator_view.dart';
import '../modules/tutorials/bindings/tutorials_binding.dart';
import '../modules/tutorials/views/tutorials_view.dart';
import '../modules/voice_dsp/bindings/voice_dsp_binding.dart';
import '../modules/voice_dsp/views/voice_dsp_view.dart';
import '../modules/voice_text/bindings/voice_text_binding.dart';
import '../modules/voice_text/views/voice_text_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;
  // static const settings = Routes.settings;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.voice_text,
      // name: _Paths.home,
      page: () => const VoiceTextView(),
      binding: VoiceTextBinding(),
    ),
    GetPage(
      name: _Paths.sampling_theorem,
      page: () => const SamplingTheoremView(),
      binding: SamplingTheoremBinding(),
    ),
    GetPage(
      name: _Paths.tutorials,
      page: () => const TutorialsView(),
      binding: TutorialsBinding(),
    ),
    GetPage(
      name: _Paths.SIGNAL_GENERATOR,
      page: () => SignalGeneratorView(),
      binding: SignalGeneratorBinding(),
    ),
    GetPage(
      name: _Paths.FFT_ANALYZER,
      page: () => const FFTAnalyzerView(),
      binding: FftAnalyzerBinding(),
    ),
    GetPage(
      name: _Paths.VOICE_DSP,
      page: () => const VoiceDspView(),
      binding: VoiceDspBinding(),
    ),
  ];
}
