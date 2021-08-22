import 'dart:convert';
import 'dart:io';

import 'package:caption_generator/liveCamera.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  bool loading = true;
  late File image;
  String resultText = "fetching result...";
  final pickerImage = ImagePicker();


  Future<Map<String, dynamic>?> getResponse(File imageFile) async
  {
    final typeData = lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])!.split("/");

    final imgUploadRequest = http.MultipartRequest("POST", Uri.parse("http://max-image-caption-generator-abhay-desai0001-dev.apps.sandbox-m2.ll9k.p1.openshiftapps.com/model/predict"));

    final file = await http.MultipartFile.fromPath("image", imageFile.path, contentType: MediaType(typeData[0], typeData[1]));

    imgUploadRequest.fields["ext"] = typeData[1];
    imgUploadRequest.files.add(file);

    try
    {
      final responseUpload = await imgUploadRequest.send();
      final response = await http.Response.fromStream(responseUpload);
      final Map<String, dynamic> responseData = json.decode(response.body);
      parseResponse(responseData);
      return responseData;
    }
    catch(e)
    {
      print(e);
      return null;
    }
  }

  parseResponse(var response)
  {
    String result = "";
    var predictions = response["predictions"];

    for(var pred in predictions)
    {
      var caption = pred["caption"];
      var probability = pred["probability"];
      result = result + caption + "\n\n";
    }

    setState(() {
      resultText = result;
    });
  }

  pickImageFromGallery() async
  {
    var imageFile = await pickerImage.getImage(source: ImageSource.gallery);
    if(imageFile != null)
    {
      setState(() {
        image = File(imageFile.path);
        loading = false;
      });

      var res = getResponse(image);
    }
  }

  captureImageWithCamera() async
  {
    var imageFile = await pickerImage.getImage(source: ImageSource.camera);
    if(imageFile != null)
    {
      setState(() {
        image = File(imageFile.path);
        loading = false;
      });

      var res = getResponse(image);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/ml.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              Center(
                child: loading
                //if true - implement/display user interface for pick image or capture image or live image
                    ? Container(
                  padding: EdgeInsets.only(top: 140.0),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow:
                    [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [

                      SizedBox(height: 15.0,),

                      Container(
                        width: 250.0,
                        child: Image.asset("assets/cam.jpg"),
                      ),
                      SizedBox(height: 50.0,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          //live camera
                          SizedBox.fromSize(
                            size: Size(80, 80),
                            child: ClipOval(
                              child: Material(
                                color: Colors.yellow,
                                child: InkWell(
                                  splashColor: Colors.green,
                                  onTap: ()
                                  {
                                    print("clicked");
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraLive()));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_front, size: 40,),
                                      Text("Live Camera", style: TextStyle(fontSize: 10.0),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 4.0,),

                          //pick image from gallery
                          SizedBox.fromSize(
                            size: Size(80, 80),
                            child: ClipOval(
                              child: Material(
                                color: Colors.yellow,
                                child: InkWell(
                                  splashColor: Colors.green,
                                  onTap: ()
                                  {
                                    pickImageFromGallery();
                                    print("clicked");
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.photo, size: 40,),
                                      Text("Gallery", style: TextStyle(fontSize: 10.0),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 4.0,),

                          //capture image with camera
                          SizedBox.fromSize(
                            size: Size(80, 80),
                            child: ClipOval(
                              child: Material(
                                color: Colors.yellow,
                                child: InkWell(
                                  splashColor: Colors.green,
                                  onTap: ()
                                  {
                                    captureImageWithCamera();
                                    print("clicked");
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, size: 40,),
                                      Text("Camera", style: TextStyle(fontSize: 10.0),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(height: 20.0,),
                    ],
                  ),
                )

                //implement/display ui for showning results (captions according to image) by applying algo
                    : Container(
                  color: Colors.black54,
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        height: 200.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: IconButton(
                                onPressed: ()
                                {
                                  print("clicked");
                                  setState(() {
                                    resultText = "Fetching Result...";
                                    loading = true;
                                  });
                                },
                                icon: Icon(Icons.arrow_back_ios_outlined),
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 140,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(image, fit: BoxFit.fill,),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      Container(
                        child: Text(
                          "Caption Prediction is: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.pink, fontSize: 24.0),
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      Container(
                        child: Text(
                          resultText,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

