// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../services/api/mistral_ocr_api.dart';
import 'package:EBRO/models/electicity_bill_model.dart';

class AddBillScreen extends StatefulWidget {
  AddBillScreen({super.key});

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;
  String extractedText = "no_text_detected".tr();
  bool _isProcessing = false;
  final MistralOcrApi _ocrApi = MistralOcrApi();
  ElecticityBillModel? result;

  Future<void> _showImagePicker(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('choose_option'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('gallery_picker'.tr()),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('use_camera'.tr()),
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
        SnackBar(content: Text("failed_to_pick_image".tr(args: ["$e"]))),
      );
    }
  }

  Future<void> _processImageForOCR(XFile imageFile) async {
    setState(() {
      _isProcessing = true;
    });

    result = await _ocrApi.get_structured_content(imageFile.path);

    setState(() {
      _isProcessing = false;
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_bill_with_ocr'.tr()),
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
                  'no_image_selected'.tr(),
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showImagePicker(context),
                child: Text('upload_bill_image'.tr()),
              ),
              SizedBox(height: 20),
              if (_isProcessing)
                CircularProgressIndicator()
              else if (result != null)
                Column(
                  children: [
                    Text(
                      "bill_information".tr(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow("due_date".tr(), result!.due_date),
                          _buildInfoRow("current_bill".tr(),
                              "Rs.${result!.current_bill.toStringAsFixed(2)}"),
                          _buildInfoRow("current_adjustment".tr(),
                              "Rs.${result!.current_adjustment.toStringAsFixed(2)}"),
                          SizedBox(height: 16),
                          Text(
                            "past_records".tr(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                border: TableBorder.all(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                columns: [
                                  DataColumn(label: Text('month'.tr())),
                                  DataColumn(label: Text('units'.tr())),
                                  DataColumn(label: Text('bill'.tr())),
                                  DataColumn(label: Text('adjustment'.tr())),
                                  DataColumn(label: Text('payment'.tr())),
                                ],
                                rows: result!.past_records.map((record) {
                                  return DataRow(cells: [
                                    DataCell(Text('${record.month}')),
                                    DataCell(Text('${record.units}')),
                                    DataCell(Text(
                                        'Rs.${record.bill.toStringAsFixed(2)}')),
                                    DataCell(Text(
                                        'Rs.${record.adjustment?.toStringAsFixed(2) ?? '0.00'}')),
                                    DataCell(Text(
                                        'Rs.${record.payment.toStringAsFixed(2)}')),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text(
                      "extracted_text".tr(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text('no_bill_info'.tr()),
                      ),
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
