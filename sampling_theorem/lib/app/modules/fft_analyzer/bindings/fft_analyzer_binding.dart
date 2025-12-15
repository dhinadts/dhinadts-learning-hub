import 'package:get/get.dart';

import '../controllers/fft_analyzer_controller.dart';

class FftAnalyzerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FFTAnalyzerController>(
      () => FFTAnalyzerController(),
    );
  }
}
