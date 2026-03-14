import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../services/disease_api_service.dart';
import '../models/disease_result.dart';
import '../widgets/speak_button.dart';

class DiseaseScanScreen extends StatefulWidget {
  const DiseaseScanScreen({super.key});

  @override
  State<DiseaseScanScreen> createState() => _DiseaseScanScreenState();
}

class _DiseaseScanScreenState extends State<DiseaseScanScreen> {
  File? _imageFile;
  DiseaseResult? _result;
  bool _isLoading = false;
  final _picker = ImagePicker();
  final _apiService = DiseaseApiService();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _result = null;
        });
        await _analyzeImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageFile == null) return;
    setState(() => _isLoading = true);

    final result = await _apiService.detectDisease(_imageFile!);

    if (mounted) {
      setState(() {
        _result = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('scan_title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Instruction card
            if (_imageFile == null && !_isLoading && _result == null)
              _buildInstructionCard(),

            // Image preview
            if (_imageFile != null)
              _buildImagePreview(),

            // Loading indicator
            if (_isLoading)
              _buildLoadingCard(),

            // Result display
            if (_result != null && !_isLoading)
              _buildResultCard(),

            const SizedBox(height: 24),

            // Action buttons
            if (!_isLoading)
              _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC8E6C9), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_enhance,
              size: 64,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.tr('scan_instruction'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF33691E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: Color(0xFF2E7D32),
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.tr('scanning'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final result = _result!;
    final isHealthy = result.isHealthy;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isHealthy ? Colors.green : Colors.red).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isHealthy ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.bug_report,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isHealthy
                            ? context.tr('no_disease')
                            : result.diseaseName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${context.tr('confidence')}: ${result.confidencePercentage}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔊 Voice Over — Listen to full result
                SpeakButton(
                  text: '${result.diseaseName}. '
                      '${context.tr("confidence")}: ${result.confidencePercentage}. '
                      '${context.tr("treatment")}: ${result.treatment}. '
                      '${result.prevention.isNotEmpty ? "${context.tr("prevention")}: ${result.prevention}" : ""}',
                  label: '🔊 Listen to Result',
                  color: isHealthy ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                ),
                const SizedBox(height: 16),

                // Confidence bar
                _buildConfidenceBar(result.confidence),
                const SizedBox(height: 20),

                // Treatment
                _buildInfoSection(
                  icon: Icons.medical_services,
                  title: context.tr('treatment'),
                  content: result.treatment,
                  color: const Color(0xFF1565C0),
                  speakText: result.treatment,
                ),
                const SizedBox(height: 16),

                // Prevention
                if (result.prevention.isNotEmpty)
                  _buildInfoSection(
                    icon: Icons.shield,
                    title: context.tr('prevention'),
                    content: result.prevention,
                    color: const Color(0xFF2E7D32),
                    speakText: result.prevention,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBar(double confidence) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.tr('confidence')}: ${(confidence * 100).toStringAsFixed(1)}%',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: confidence,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(
              confidence > 0.7
                  ? const Color(0xFF4CAF50)
                  : confidence > 0.4
                      ? const Color(0xFFFFA726)
                      : const Color(0xFFE53935),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    String? speakText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (speakText != null)
                      SpeakButton.mini(text: speakText, color: color),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt, size: 24),
            label: Text(context.tr('take_photo'), style: const TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library, size: 24),
            label: Text(context.tr('from_gallery'), style: const TextStyle(fontSize: 18)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2E7D32),
              side: const BorderSide(color: Color(0xFF2E7D32), width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        if (_result != null) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => setState(() {
              _imageFile = null;
              _result = null;
            }),
            icon: const Icon(Icons.refresh),
            label: Text(context.tr('scan_again')),
          ),
        ],
      ],
    );
  }
}
