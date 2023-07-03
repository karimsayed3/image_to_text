import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text/utilits/utilits.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ImageToText(),
    );
  }
}

class ImageToText extends StatefulWidget {
  const ImageToText({Key? key}) : super(key: key);

  @override
  State<ImageToText> createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> {
  File? _pickedImage;
  String outputText = "";

  pickedImage(File file) {
    setState(() {
      _pickedImage = file;
    });

    InputImage inputImage = InputImage.fromFile(file);
    //code to recognize image
    processImageForConversion(inputImage);
  }

  processImageForConversion(inputImage) async {
    setState(() {
      outputText = "";
    });

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    for (TextBlock block in recognizedText.blocks) {
      setState(() {
        outputText += "${block.text}\n";
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image to Text",
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (outputText == "") {
      //       pickImage(ImageSource.gallery, pickedImage);
      //     } else {
      //       Clipboard.setData(ClipboardData(text: outputText));
      //     }
      //   },
      //   child:
      //       outputText == "" ? const Icon(Icons.image) : const Icon(Icons.copy),
      // ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_pickedImage == null)
                    Container(
                      height: 300,
                      color: Colors.black,
                      width: double.infinity,
                    )
                  else
                    Column(
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          child: Image.file(
                            _pickedImage!,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            // vertical: 10,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: SelectableText(
                              outputText,
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black38,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        pickImage(ImageSource.gallery, pickedImage);
                      },
                      child: Text(
                        _pickedImage == null ? 'Add Image' : 'Another Image',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: outputText));
                      },
                      child: const Text(
                        'Copy Text',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
