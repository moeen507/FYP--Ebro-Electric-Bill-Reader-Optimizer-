import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_widget/widget/markdown.dart';
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
      } else {
        print("No image selected");
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

        print(extractedText);
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
                  child: Image.memory(
                    _imageData!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
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
                      child:
                          MarkdownWidget(shrinkWrap: true, data: extractedText),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
