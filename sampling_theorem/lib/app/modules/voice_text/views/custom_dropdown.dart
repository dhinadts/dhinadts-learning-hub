import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/modules/voice_text/controllers/voice_text_controller.dart';

class CustomLanguageDropdown extends StatefulWidget {
  final ThemeData theme;
  final VoiceTextController controller;

  const CustomLanguageDropdown({
    super.key,
    required this.theme,
    required this.controller,
  });

  @override
  State<CustomLanguageDropdown> createState() => _CustomLanguageDropdownState();
}

class _CustomLanguageDropdownState extends State<CustomLanguageDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isExpanded = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _removeOverlay();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    setState(() => _isExpanded = !_isExpanded);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 8, // Position below the dropdown
        width: size.width,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 250, // Fixed height
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.theme.colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Scrollbar(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.controller.localeItems.length,
                itemBuilder: (context, index) {
                  final item = widget.controller.localeItems[index];
                  return ListTile(
                    title: Text(
                      _getLanguageName(item.value ?? 'en_US'),
                      style: TextStyle(
                        color: widget.theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      widget.controller.selectedLocaleId.value = item.value!;
                      _toggleDropdown();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getLanguageName(String localeId) {
    // Same function as before
    switch (localeId) {
      case 'en_US':
        return 'English';
      case 'ta_IN':
        return 'தமிழ் (Tamil)';
      case 'hi_IN':
        return 'हिंदी (Hindi)';
      default:
        return localeId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.theme.colorScheme.primary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  color: widget.theme.colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    return Text(
                      _getLanguageName(
                          widget.controller.selectedLocaleId.value),
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: widget.theme.colorScheme.primary,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
