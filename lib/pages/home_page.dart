import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   void signUserOut(){
//     FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context){
//     return  Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
//         ],
//       ),
//       body:  Center(child: Text('Logged'),),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  // Uint8List? _resultImage;
  //remove
  File? _resultImage;
  final picker = ImagePicker();
  bool _showResultButton = false;

  var stage1Count = 10;
  var stage2Count = 2;
  var stage3Count = 114;
  var stage4Count = 61;
  var totalCount = 142;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _resultImage = null; // Reset result image if a new image is uploaded
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> sendImageToAPI(File image) async {
    // Replace the URL with your API endpoint
    var url = Uri.parse('http://192.168.66.24:8000/image/');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var decodedResponse = json.decode(utf8.decode(responseData));
        var imageBytes = base64Decode(decodedResponse['image']);
        stage1Count = decodedResponse['stage 1'];
        stage2Count = decodedResponse['stage 2'];
        stage3Count = decodedResponse['stage 3'];
        stage4Count = decodedResponse['stage 4'];
        totalCount = decodedResponse['total'];
        print(stage2Count);
        setState(() {
          // _resultImage = imageBytes;
        });
      } else {
        print('Failed to upload image. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    // remove line
    setState(() {
      _resultImage = _image;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Lifecycle Stage Prediction',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            actions: [
              IconButton(
                onPressed: signUserOut,
                icon: const Icon(Icons.logout),
                color: Colors.white,
              )
            ],
            backgroundColor: Colors.orange[400],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _image == null
                    ? const Text(
                        'No image selected.',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w300),
                      )
                    : Container(
                        width: 350,
                        height: 400,
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      icon:
                          const Icon(Icons.photo_library, color: Colors.orange),
                      label: const Text(
                        'Select from Gallery',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        // textStyle: const TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.orange),
                      label: const Text(
                        'Take a Picture',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        // textStyle: const TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (_image != null)
                  ElevatedButton(
                    onPressed: () {
                      sendImageToAPI(_image!);
                    },
                    child: const Text(
                      'Process Image',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      // textStyle: const TextStyle(fontSize: 16, color: Colors.orange),
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                    ),
                  ),
                const SizedBox(height: 20),
                _resultImage == null
                    ? Container()
                    : Container(
                        width: 350,
                        height: 400,
                        // child: Image.memory(
                        child: Image.file(
                          _resultImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                // Display summary table after result image
                // if (_resultImage != null)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 350,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.orange[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Text(
                        'Summary',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 350,
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                            ),
                            children: [
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Stage 1 Count',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    stage1Count.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                            ),
                            children: [
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Stage 2 Count',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    stage2Count.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                            ),
                            children: [
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Stage 3 Count',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    stage3Count.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                            ),
                            children: [
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Stage 4 Count',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    stage4Count.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                            ),
                            children: [
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Total Count',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    totalCount.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
