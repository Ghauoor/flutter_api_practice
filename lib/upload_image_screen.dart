import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool _showSpinner = false;

  void _pickImage() async {
    final pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  //Upload Image
  Future<void> uploadImage() async {
    setState(() {
      _showSpinner = true;
    });

    var stream = http.ByteStream(_image!.openRead());
    stream.cast();

    var length = await _image!.length();

    var uri = Uri.parse('https://fakestoreapi.com/products');

    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = 'Static String';

    var multiPart = http.MultipartFile('image', stream, length);

    request.files.add(multiPart);

    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        _showSpinner = false;
      });
      print('Image Uploaded');
    } else {
      setState(() {
        _showSpinner = false;
      });

      print('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: AppBar(title: const Text('Upload an Image')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _image == null
                      ? const Center(child: Text('Pick an Image'))
                      : Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                uploadImage();
              },
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
