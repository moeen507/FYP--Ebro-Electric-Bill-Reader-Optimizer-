import 'dart:convert';
import 'dart:io';
import 'package:EBRO/models/electicity_bill_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MistralOcrApi {
  final Dio _dio = Dio();
  late final String _mistralApiKey;

  MistralOcrApi() {
    _mistralApiKey = dotenv.env['MISTRAL_API_KEY'] ?? '';
    if (_mistralApiKey.isEmpty) {
      print('WARNING: MISTRAL_API_KEY is empty. Check your .env file.');
    }
  }

  Future<String> get_content(String imagePath) async {
    try {
      // Convert image to base64
      File imageFile = File(imagePath);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Getting file extension
      String fileExtension = imagePath.split('.').last.toLowerCase();

      String formattedBase64 = "data:image/$fileExtension;base64,$base64Image";

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
          //'include_image_base64': 'True'
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        List<dynamic> pages = data['pages'];
        String content = "";
        for (var i = 0; i < pages.length; i++) {
          content += pages[i]['markdown'] + "\n\n";
        }
        return content;
      } else {
        throw Exception('Failed to process OCR: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
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

  Future<ElecticityBillModel> get_structured_repsonse(String content) async {
    try {
      final response =
          await _dio.post("https://api.mistral.ai/v1/chat/completions",
              options: Options(headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $_mistralApiKey",
              }),
              data: {
            "model": "ministral-8b-latest",
            "messages": [
              {
                "role": "system",
                "content":
                    "Extract all relevant electricity bill information from the provided content. Focus on due date, current bill amount, current adjustment, and past records including month, units consumed, bill amount, adjustment (if any), and payment. Parse the data accurately."
              },
              {"role": "user", "content": content}
            ],
            "response_format": {
              "type": "json_schema",
              "json_schema": {
                "schema": {
                  "title": "ElectricityBill",
                  "type": "object",
                  "properties": {
                    "due_date": {"type": "string", "title": "Due Date"},
                    "current_bill": {"type": "number", "title": "Current Bill"},
                    "current_adjustment": {
                      "type": "number",
                      "title": "Current Adjustment"
                    },
                    "past_records": {
                      "type": "array",
                      "title": "Past Records",
                      "items": {
                        "type": "object",
                        "properties": {
                          "month": {"type": "integer", "title": "Month"},
                          "units": {"type": "integer", "title": "Units"},
                          "bill": {"type": "number", "title": "Bill"},
                          "adjustment": {
                            "type": "number",
                            "title": "Adjustment"
                          },
                          "payment": {"type": "number", "title": "Payment"}
                        },
                        "required": ["month", "units", "bill", "payment"],
                        "additionalProperties": false
                      }
                    }
                  },
                  "required": [
                    "due_date",
                    "current_bill",
                    "current_adjustment",
                    "past_records"
                  ],
                  "additionalProperties": false
                },
                "name": "electricity_bill",
                "strict": true
              }
            },
            "max_tokens": 1024,
            "temperature": 0
          });
      final Map<String, dynamic> data = response.data;
      final List<dynamic> choices = data['choices'];
      final Map<String, dynamic> message = choices[0]['message'];
      final Map<String, dynamic> message_content =
          jsonDecode(message['content']);
      print("Content : $message_content");
      return ElecticityBillModel.fromJson(message_content);
    } catch (e) {
      print('Error in get_structured_response: $e');
      return ElecticityBillModel.fromJson({
        'due_date': '',
        'current_bill': 0.0,
        'current_adjustment': 0.0,
        'past_records': []
      });
    }
  }

  Future<ElecticityBillModel> get_structured_content(String file_path) async {
    final content = await get_content(file_path);
    return get_structured_repsonse(content);
  }
}
