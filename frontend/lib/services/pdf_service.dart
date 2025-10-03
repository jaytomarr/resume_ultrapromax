import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // Web-only usage is gated by kIsWeb
import 'package:http/http.dart' as http;
import '../features/builder/models/resume_data.dart';

/// PDF service for backend API communication
class PDFService {
  // Backend API URL - update this for production deployment
  static const String _baseUrl = 'https://resume-backend-3ijy.onrender.com';

  /// Generate PDF from resume data
  /// Returns a URL usable to preview/download the PDF (Blob URL on web, data URL fallback otherwise)
  Future<String> generatePDF(ResumeData resumeData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/generate-resume'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(resumeData.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      final bytes = response.bodyBytes;

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        return url;
      }

      // Non-web fallback: return data URL
      final base64Pdf = base64Encode(bytes);
      return 'data:application/pdf;base64,$base64Pdf';
    } catch (e) {
      print('Error generating PDF: $e');
      rethrow;
    }
  }

  /// Check backend health
  Future<bool> checkBackendHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/health'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error checking backend health: $e');
      return false;
    }
  }
}
