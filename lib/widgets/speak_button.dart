import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/tts_service.dart';

/// Reusable "Speak" button — reads out text using text-to-speech.
///
/// Shows a speaker icon. Tap to listen, tap again to stop.
/// Automatically uses the user's selected language.
///
/// Usage:
///   SpeakButton(text: 'Your crop has Leaf Blight disease')
///   SpeakButton(text: treatment, label: 'Listen to treatment')
///   SpeakButton.mini(text: alertDescription)  // smaller version
class SpeakButton extends StatefulWidget {
  final String text;
  final String? label;
  final bool mini;
  final Color? color;

  const SpeakButton({
    super.key,
    required this.text,
    this.label,
    this.mini = false,
    this.color,
  });

  /// Compact version for inline use (e.g., next to alert cards).
  const SpeakButton.mini({
    super.key,
    required this.text,
    this.color,
  })  : label = null,
        mini = true;

  @override
  State<SpeakButton> createState() => _SpeakButtonState();
}

class _SpeakButtonState extends State<SpeakButton>
    with SingleTickerProviderStateMixin {
  static final TtsService _tts = TtsService();
  bool _isSpeaking = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _toggleSpeak() async {
    if (_isSpeaking) {
      await _tts.stop();
      _pulseController.stop();
      setState(() => _isSpeaking = false);
    } else {
      final lang = Provider.of<LanguageProvider>(context, listen: false).languageCode;
      await _tts.initialize(lang);
      setState(() => _isSpeaking = true);
      _pulseController.repeat(reverse: true);

      await _tts.speak(widget.text);

      // When speech finishes
      if (mounted) {
        _pulseController.stop();
        setState(() => _isSpeaking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? const Color(0xFF2E7D32);

    // Mini version — just an icon button
    if (widget.mini) {
      return AnimatedBuilder(
        animation: _pulseController,
        builder: (_, child) {
          return IconButton(
            onPressed: _toggleSpeak,
            icon: Icon(
              _isSpeaking ? Icons.stop_circle : Icons.volume_up,
              color: _isSpeaking
                  ? Colors.red
                  : color.withOpacity(0.6 + (_pulseController.value * 0.4)),
              size: 24,
            ),
            tooltip: _isSpeaking ? 'Stop' : 'Listen',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          );
        },
      );
    }

    // Full version — button with label
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, child) {
        return Material(
          color: _isSpeaking
              ? Colors.red.withOpacity(0.1)
              : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _toggleSpeak,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isSpeaking ? Icons.stop_circle : Icons.volume_up,
                    color: _isSpeaking ? Colors.red : color,
                    size: 22,
                  ),
                  if (widget.label != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      _isSpeaking ? '■ Stop' : widget.label!,
                      style: TextStyle(
                        color: _isSpeaking ? Colors.red : color,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A voice input button — tap and speak to enter text.
///
/// Usage:
///   VoiceInputButton(
///     controller: _cropNameController,
///     languageCode: 'hi',
///   )
class VoiceInputButton extends StatefulWidget {
  final TextEditingController controller;
  final String? languageCode;
  final Color? color;

  const VoiceInputButton({
    super.key,
    required this.controller,
    this.languageCode,
    this.color,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? const Color(0xFF2E7D32);

    return IconButton(
      onPressed: () {
        // Voice input will use the STT service
        setState(() => _isListening = !_isListening);
        if (_isListening) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('🎤 Listening... speak now'),
              backgroundColor: color,
              duration: const Duration(seconds: 2),
            ),
          );
          // In full implementation, integrate SttService here
        }
      },
      icon: Icon(
        _isListening ? Icons.mic : Icons.mic_none,
        color: _isListening ? Colors.red : color,
        size: 24,
      ),
      tooltip: 'Voice input',
    );
  }
}
