import 'package:firebase_auth/firebase_auth.dart';
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
  File? _resultImage;
  final picker = ImagePicker();
  bool _showResultButton = false;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> sendImageToAPI(File image) async {
    // Replace the URL with your API endpoint
    var url = Uri.parse('YOUR_API_ENDPOINT');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var decodedResponse = json.decode(utf8.decode(responseData));
        setState(() {
          _resultImage = File(decodedResponse['result_image_path']);
        });
      } else {
        print('Failed to upload image. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
            title: Text(
              'Lifecycle Stage Prediction',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            actions: [
              IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
            ],
            backgroundColor: Colors.orange[200],
          ),
          body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _image == null
                  ? Text('No image selected.')
                  : Container(
                      width: 350,
                      height: 400,
                      child: Image.file(_image! , fit: BoxFit.cover,),
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _image == null
                    ? null
                    : () {
                        sendImageToAPI(_image!);
                      },
                child: Text('Process Image'),
              ),
              SizedBox(height: 20),
              _resultImage == null
                  ? Container()
                  : Container(
                      width: 200,
                      height: 200,
                      child: Image.file(_resultImage!),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.photo_library),
        ),
      ),
    ),
    );
  }
}