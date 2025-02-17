void main() {
  runApp(const ElectricBillApp());
}

class ElectricBillApp extends StatelessWidget {
  const ElectricBillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const AddBillScreen(),
    );
  }
}

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;
  String extractedText = "No text detected yet.";

  Future<void> _showImagePicker(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose an Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery Picker'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Use Camera'),
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
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = imageBytes;
      });
      await _processImageForOCR(pickedFile);
    } else {
      debugPrint("No image selected");
    }
  }

  Future<void> _processImageForOCR(XFile imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      if (recognizedText.text.isEmpty) {
        setState(() {
          extractedText = "No text found in the image.";
        });
      } else {
        String correctedText = _correctText(recognizedText.text);
        setState(() {
          extractedText = correctedText;
        });
      }

      textRecognizer.close();
    } catch (e) {
      setState(() {
        extractedText = "Error processing image: $e";
      });
    }
  }

  String _correctText(String text) {
    List<String> words = text.split(" ");
    List<String> correctedWords = words.map((word) => SpellChecker.correct(word)).toList();
    return correctedWords.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bill with OCR')),
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
                const Text(
                  'No image selected',
                  style: TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showImagePicker(context),
                child: const Text('Upload Bill Image'),
              ),
              const SizedBox(height: 20),
              const Text(
                "Extracted Text:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  extractedText,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}