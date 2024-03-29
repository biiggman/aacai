import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:aacademic/utils/tts.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({super.key, required this.cameras});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController cameraController;
  late CameraImage cameraImage;
  late List recognitionsList = [];
  bool predicting = false;

  //initializes camera on startup
  initCamera() {
    //sets resolution to max, then starts image stream and runs model on stream
    cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((value) {
      setState(() {
        cameraController.startImageStream((image) => {
              cameraImage = image,
              runModel(),
            });
      });
    });
  }

  //runs model
  runModel() async {
    if (predicting) return;
    predicting = true;

    try {
      recognitionsList = (await Tflite.detectObjectOnFrame(
        bytesList: cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 0,
        imageStd: 255,
        //number of each label that can be in 1 frame
        numResultsPerClass: 2,
        //%confidence
        threshold: 0.6,
      ))!;

      setState(() {
        //update the state with new recognitions list and stop predicting
        recognitionsList;
        predicting = false;
      });
    } catch (e) {
      //handle any exceptions and stop predicting
      print("Failed to run model: $e");
      predicting = false;
    }
  }

  //loads model from asset folder
  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/detect.tflite",
      labels: "assets/labelmap.txt",
    );
  }

  @override

  //disposes everything when camera is closed (hopefully crash is fixed)
  void dispose() {
    super.dispose();

    //turns off camera controller if currently running before stopping model
    //this was added to fix a crash that would happen after leaving the page
    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        cameraController.stopImageStream();
        cameraController.dispose();
      } catch (e) {
        print("Failed to dispose cameraController: $e");
      }
    }

    Tflite.close();
  }

  //loadModel and initCamera are ran whenever camera is turned on
  @override
  void initState() {
    super.initState();

    loadModel();
    initCamera();
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (recognitionsList == null) return [];

    double factorX = screen.width;
    double factorY = screen.height;

    Color colorPick = Colors.pink;

    return recognitionsList.map((result) {
      //maps over list and creates a position widget for each recognition
      return Positioned(
          //finds position of object and scales box based on screen size
          left: result["rect"]["x"] * factorX,
          top: result["rect"]["y"] * factorY,
          width: result["rect"]["w"] * factorX,
          height: result["rect"]["h"] * factorY,
          child: GestureDetector(
            onTap: () {
              //speaks name of object when tapping on box
              TextToSpeech.speak(result["detectedClass"]);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: Colors.pink, width: 2.0),
              ),
              child: Text(
                //displays object class and confidence level
                "${result['detectedClass']} ${(result['confidenceInClass'] * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  background: Paint()..color = colorPick,
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //will be populated with boxes later
    List<Widget> list = [];

    list.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height - 100,
        child: SizedBox(
          height: size.height - 100,
          child: (!cameraController.value.isInitialized)
              //if camera is not initialized (error) then will only pop up a black screen
              //if camera is initialized then will preview camera screen
              ? Container()
              : AspectRatio(
                  aspectRatio: cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                ),
        ),
      ),
    );

    //show boxes
    list.addAll(displayBoxesAroundRecognizedObjects(size));

    //back button and default UI stuff to make sure content fits screen
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 50),
          color: Colors.black,
          child: Stack(
            children: list,
          ),
        ),
      ),
    );
  }
}
