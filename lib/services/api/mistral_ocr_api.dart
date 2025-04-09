import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/mistral_ocr_model.dart';

class MistralOcrApi {
  final Dio _dio = Dio();
  final String _mistralApiKey = dotenv.env['MISTRAL_API_KEY'] ?? '';

  Future<MistralOCRModel> processImage(String imagePath) async {
    try {
      // Convert image to base64
      File imageFile = File(imagePath);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Format base64 image with prefix to match Python implementation
      String formattedBase64 = "data:image/jpeg;base64,$base64Image";

      final response = await _dio.post(
        'https://api.mistral.ai/v1/ocr',
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
          "include_image_base64": true,
        },
      );

      if (response.statusCode == 200) {
        // Parse the response into our model
        return MistralOCRModel.fromJson(response.data);
      } else {
        throw Exception('Failed to process OCR: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calling Mistral OCR API: $e');
      rethrow;
    }
  }
}

/*
{
  "pages": [
    {
      "index": 1,
      "markdown": "# Sample Document\n\nThis is a sample document to demonstrate",
      "images": [
        {
          "id": "img-0.jpeg",
          "top_left_x": 292,
          "top_left_y": 217,
          "bottom_right_x": 1405,
          "bottom_right_y": 649,
          "image_base64": "..."
        }
      ],
      "dimensions": {
        "dpi": 300,
        "height": 1100,
        "width": 850
      }
    }
  ],
  "model": "sample-ocr-model",
  "usage_info": {
    "pages_processed": 1,
    "doc_size_bytes": 1024
  }
}

*/
