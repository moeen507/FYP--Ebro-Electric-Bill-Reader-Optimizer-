import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'dart:convert';
import '../models/mistral_ocr_model.dart';
import '../services/api/mistral_ocr_api.dart';

class AddBillScreen extends StatefulWidget {
  AddBillScreen({super.key});

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;
  String extractedText = "No text detected yet.";
  bool _isProcessing = false;
  final MistralOcrApi _ocrApi = MistralOcrApi();
  MistralOCRModel? _ocrResponse;

  Future<void> _showImagePicker(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose an Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery Picker'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Use Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _imageData = imageBytes;
        });
        await _processImageForOCR(pickedFile);
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  Future<void> _processImageForOCR(XFile imageFile) async {
    setState(() {
      _isProcessing = true;
      extractedText = "Processing image...";
      _ocrResponse = null;
    });

    try {
      // Use the API service to get structured response
      final result = await _ocrApi.processImage(imageFile.path);
      setState(() {
        _ocrResponse = result;

        extractedText = _ocrResponse!.toMarkdownString();
      });
    } catch (e) {
      print("Error during OCR process: $e");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bill with OCR'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageData != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        _imageData!,
                        height: 300,
                        width: MediaQuery.of(context).size.width * 0.85,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              else
                Text(
                  'No image selected',
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showImagePicker(context),
                child: Text('Upload Bill Image'),
              ),
              SizedBox(height: 20),
              if (_isProcessing)
                CircularProgressIndicator()
              else
                Column(
                  children: [
                    Text(
                      "Extracted Text:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildMarkdownWithImages(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkdownWithImages() {
    // If no OCR response yet, just show the basic text
    if (_ocrResponse == null) {
      return MarkdownWidget(shrinkWrap: true, data: extractedText);
    }

    // Regular expression to find base64 image patterns in markdown
    final RegExp imgRegExp =
        RegExp(r'!\[(.*?)\]\((data:image\/[^;]+;base64,[^)]+)\)');

    // Find all image matches in the markdown
    final matches = imgRegExp.allMatches(extractedText);

    if (matches.isEmpty) {
      // If no images, just return regular markdown
      return MarkdownWidget(shrinkWrap: true, data: extractedText);
    }

    // Build a list of widgets combining text and images
    List<Widget> contentWidgets = [];
    int lastEnd = 0;

    for (final match in matches) {
      // Add text before the image
      if (match.start > lastEnd) {
        final textBefore = extractedText.substring(lastEnd, match.start);
        contentWidgets.add(MarkdownWidget(shrinkWrap: true, data: textBefore));
      }

      // Extract image data
      final imageBase64 = match.group(2)!;

      // Add the image
      contentWidgets.add(_buildBase64Image(imageBase64));

      lastEnd = match.end;
    }

    // Add any remaining text after the last image
    if (lastEnd < extractedText.length) {
      final textAfter = extractedText.substring(lastEnd);
      contentWidgets.add(MarkdownWidget(shrinkWrap: true, data: textAfter));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentWidgets,
    );
  }

  Widget _buildBase64Image(String base64String) {
    try {
      // Extract just the base64 part without the data:image prefix
      final parts = base64String.split(',');
      if (parts.length < 2) {
        throw FormatException('Invalid base64 image format');
      }

      final base64Data = parts[1];
      final imageBytes = base64Decode(base64Data);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 400, // Limit max height to prevent overly large images
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.memory(
              imageBytes,
              fit: BoxFit.contain,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                print("Image error: $error");
                return Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.grey.shade200,
                  child: Text('Failed to load image: $error'),
                );
              },
            ),
          ),
        ),
      );
    } catch (e) {
      print("Base64 decoding error: $e");
      return Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.red.shade100,
        child: Text('Invalid image data: $e'),
      );
    }
  }
}
