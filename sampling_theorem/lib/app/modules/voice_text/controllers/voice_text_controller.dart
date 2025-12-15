import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceTextController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final stt.SpeechToText speech = stt.SpeechToText();

  // Reactive values 👇
  var isListening = false.obs;
  var isInitialized = false.obs;
  var currentText = "".obs;

  var chatHistory = <String>[].obs;

  List<stt.LocaleName> availableLocales = [];
  var selectedLocaleId = "en_US".obs;

  List<DropdownMenuItem<String>> localeItems = [];

  late AnimationController waveController;

  @override
  void onInit() {
    super.onInit();
    initSpeech();
    debugLocales();

    waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void onClose() {
    waveController.dispose();
    speech.stop();
    super.onClose();
  }

  // ----------------------------------------------------------
  // PRINT ALL AVAILABLE LANGUAGES
  // ----------------------------------------------------------
  void debugLocales() async {
    var locales = await speech.locales();
    for (var l in locales) {
      print("${l.name} → ${l.localeId}");
    }
  }

  // ----------------------------------------------------------
  // INITIALIZE MICROPHONE
  // ----------------------------------------------------------
  // VoiceTextController - Updated initSpeech method
  void initSpeech() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == "done") stopListening();
      },
      onError: (e) => print("ERROR: $e"),
    );

    if (available) {
      availableLocales = await speech.locales();

      // Store available locales
      availableLocales = availableLocales;

      // Initialize locale items
      _updateLocaleItems();

      var systemLocale = await speech.systemLocale();
      selectedLocaleId.value = systemLocale?.localeId ?? "en_US";
    }

    isInitialized.value = available;
  }

  void _updateLocaleItems() {
    localeItems = availableLocales
        .map((loc) => DropdownMenuItem<String>(
              value: loc.localeId,
              child: Text(loc.name),
            ))
        .toList();

    // Add Tamil manually if missing
    if (!availableLocales.any((locale) => locale.localeId == "ta_IN")) {
      localeItems.add(const DropdownMenuItem<String>(
        value: "ta_IN",
        child: Text("Tamil (India)"),
      ));
    }

    // Add Hindi manually if missing
    if (!availableLocales.any((locale) => locale.localeId == "hi_IN")) {
      localeItems.add(const DropdownMenuItem<String>(
        value: "hi_IN",
        child: Text("Hindi (India)"),
      ));
    }
  }

  /* void initSpeech() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == "done") stopListening();
      },
      onError: (e) => print("ERROR: $e"),
    );

    if (available) {
      availableLocales = await speech.locales();

      localeItems = availableLocales
          .map((loc) => DropdownMenuItem(
                value: loc.localeId,
                child:
                    Text(loc.name, style: const TextStyle(color: Colors.white)),
              ))
          .toList();

      // Add Tamil manually if missing
      localeItems.add(const DropdownMenuItem(
        value: "ta_IN",
        child: Text("Tamil (India)", style: TextStyle(color: Colors.white)),
      ));

      var systemLocale = await speech.systemLocale();
      selectedLocaleId.value = systemLocale?.localeId ?? "en_US";
    }

    isInitialized.value = available;
  }
 */
  // ----------------------------------------------------------
  // START LISTENING
  // ----------------------------------------------------------
  void startListening() async {
    if (!isInitialized.value) return;

    await speech.listen(
      localeId: selectedLocaleId.value,
      onResult: (result) {
        currentText.value = result.recognizedWords;
      },
    );

    isListening.value = true;
    currentText.value = "";
  }

  // ----------------------------------------------------------
  // STOP LISTENING
  // ----------------------------------------------------------
  void stopListening() async {
    await speech.stop();

    if (currentText.value.trim().isNotEmpty) {
      String finalMsg = _convertToFormalMessage(currentText.value);
      chatHistory.add(finalMsg);
    }

    isListening.value = false;
  }

  // ----------------------------------------------------------
  // AUTO MESSAGE FORMATTER (English + Tamil)
  // ----------------------------------------------------------
  String _convertToFormalMessage(String text) {
    text = text.toLowerCase();

    if (text.contains("payment") || text.contains("due")) {
      return """
Dear Sir/Madam,

This is a gentle reminder regarding the pending payment. Kindly process it at the earliest.

Thank you.
""";
    }

    if (text.contains("meeting") || text.contains("schedule")) {
      return """
Dear Team,

We would like to schedule a meeting. Kindly share your available timings.

Regards.
""";
    }

    if (text.contains("கட்டணம்") || text.contains("பணம்")) {
      return """
அன்புள்ளவர்,

நீங்கள் செலுத்த வேண்டிய கட்டணம் நிலுவையில் உள்ளது. தயவுசெய்து விரைவில் செலுத்தவும்.

நன்றி.
""";
    }

    if (text.contains("சந்திப்பு") || text.contains("மீட்டிங்")) {
      return """
அன்புள்ள குழுவிற்கு,

சந்திப்பை ஏற்பாடு செய்ய விரும்புகிறோம். தயவுசெய்து உங்கள் கிடைக்கும் நேரத்தை பகிரவும்.

நன்றி.
""";
    }

    return text.capitalizeFirst!;
  }

  // ----------------------------------------------------------
  // SHARE LAST FORMATTED MESSAGE
  // ----------------------------------------------------------
  void shareMessage(String text) {
    Share.share(text);
  }
}
