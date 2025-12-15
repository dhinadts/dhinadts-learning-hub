import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/global_controllers/theme_controller.dart';
import 'package:sampling_theorem/app/data/utils/custom_app_bar.dart';
import 'package:sampling_theorem/app/modules/voice_text/views/custom_dropdown.dart';
import '../controllers/voice_text_controller.dart';

class VoiceTextView extends GetView<VoiceTextController> {
  const VoiceTextView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: "Voice Assistant"),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Language Dropdown
            _buildFixedLanguageDropdown(theme),

            // Chat History
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.chatHistory.length,
                  reverse: false,
                  itemBuilder: (context, index) {
                    return _chatBubble(
                      controller.chatHistory[index],
                      theme,
                      index,
                    );
                  },
                );
              }),
            ),

            // Sound Wave
            Obx(() => controller.isListening.value
                ? _soundWave(theme)
                : const SizedBox()),

            const SizedBox(height: 16),

            // Mic Button
            Obx(() {
              bool listening = controller.isListening.value;
              return GestureDetector(
                onTap: listening
                    ? controller.stopListening
                    : controller.startListening,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: listening
                            ? theme.colorScheme.error.withOpacity(0.4)
                            : theme.colorScheme.primary.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                    gradient: LinearGradient(
                      colors: listening
                          ? [theme.colorScheme.error, Colors.redAccent]
                          : [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary
                            ],
                    ),
                  ),
                  child: Icon(
                    listening ? Icons.stop : Icons.mic,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Share Button
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (controller.chatHistory.isNotEmpty) {
                        controller.shareMessage(controller.chatHistory.last);
                      }
                    },
                    icon: Icon(
                      Icons.share,
                      size: 28,
                      color: theme.colorScheme.primary,
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

  // Fixed Language Dropdown
  /* Widget _buildFixedLanguageDropdown(ThemeData theme) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  dropdownColor: theme.colorScheme.surface,
                  value: controller.selectedLocaleId.value,
                  items: controller.localeItems,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedLocaleId.value = value;
                    }
                  },
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  // Force dropdown to open below
                  itemHeight: 56,
                  menuMaxHeight: constraints.maxHeight * 0.5,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  // Calculate available space and adjust
                  selectedItemBuilder: (context) {
                    return controller.localeItems.map((item) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _getLanguageName(item.value ?? 'en_US'),
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            );
          },
        ),
      );
    });
  }
 */
  Widget _buildFixedLanguageDropdown(ThemeData theme) {
    return CustomLanguageDropdown(
      theme: theme,
      controller: controller,
    );
  }

  String _getLanguageName(String localeId) {
    switch (localeId) {
      case 'en_US':
        return 'English';
      case 'ta_IN':
        return 'தமிழ் (Tamil)';
      case 'hi_IN':
        return 'हिंदी (Hindi)';
      case 'es_ES':
        return 'Spanish';
      case 'fr_FR':
        return 'French';
      case 'de_DE':
        return 'German';
      case 'ja_JP':
        return 'Japanese';
      case 'ko_KR':
        return 'Korean';
      default:
        final parts = localeId.split('_');
        if (parts.isNotEmpty) {
          return '${parts[0].toUpperCase()} Language';
        }
        return 'Unknown Language';
    }
  }

  // Updated Chat Bubble with index
  Widget _chatBubble(String text, ThemeData theme, int index) {
    bool isUser = index % 2 == 0; // Example logic
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primary.withOpacity(0.15)
              : theme.colorScheme.secondary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isUser
                ? theme.colorScheme.primary.withOpacity(0.3)
                : theme.colorScheme.secondary.withOpacity(0.3),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  // Sound Wave remains the same
  Widget _soundWave(ThemeData theme) {
    return SizedBox(
      height: 70,
      child: AnimatedBuilder(
        animation: controller.waveController,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(20, (i) {
              double height = 12 +
                  Random().nextInt(40) *
                      (0.5 + controller.waveController.value);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 4,
                height: height,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
