import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/mistral_ocr_model.dart';

class MistralOcrApi {
  final Dio _dio = Dio();
  late final String _mistralApiKey;

  MistralOcrApi() {
    _mistralApiKey = dotenv.env['MISTRAL_API_KEY'] ?? '';
    if (_mistralApiKey.isEmpty) {
      print('WARNING: MISTRAL_API_KEY is empty. Check your .env file.');
    }
  }

  Future<MistralOCRModel> processImage(String imagePath) async {
    try {
      // Convert image to base64
      File imageFile = File(imagePath);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Format base64 image with prefix to match Python implementation
      String formattedBase64 = "data:image/jpeg;base64,$base64Image";

      final response = await _dio.post(
        'https://api.mistral.ai/v1/ocr', // Corrected endpoint URL
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_mistralApiKey',
          },
        ),
        data: {
          'model': 'mistral-ocr-latest',
          'document': {
            'type': 'image_url',
            'image_url': formattedBase64,
          },
          'include_image_base64': 'True'
        },
      );

      if (response.statusCode == 200) {
        // Parse the response into our model
        return MistralOCRModel.fromJson(response.data);
      } else {
        throw Exception('Failed to process OCR: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('Authentication error: Your API key may be invalid or expired.');
        print('Status code: ${e.response?.statusCode}');
        print('Response: ${e.response?.data}');
      } else {
        print('Error calling Mistral OCR API: $e');
      }
      rethrow;
    } catch (e) {
      print('Unexpected error in Mistral OCR API: $e');
      rethrow;
    }
  }
}
