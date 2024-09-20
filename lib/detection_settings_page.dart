import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:recon_loc_caract_faces/face_detector_painter.dart';

class DetectionSettingsPage extends StatefulWidget {
  final String imagePath;

  const DetectionSettingsPage({
    super.key,
    required this.imagePath,
  });

  @override
  State<DetectionSettingsPage> createState() => _DetectionSettingsPageState();
}

class _DetectionSettingsPageState extends State<DetectionSettingsPage> {
  String? _appDirectoryPath;
  List<Face> _faces = [];
  double _minFaceSize = 0.1;
  bool _enableClassification = true;
  bool _enableContours = true;
  bool _enableLandmarks = true;
  FaceDetectorMode _performanceMode = FaceDetectorMode.accurate;
  Size? _imageSize;
  Size? _adjustedImageSize;
  double _imageSizeRatio = 1.0;
  img.Image? _rawImage;
  int? _detectionDuration;

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  asyncInit() async {
    _appDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    // Read and decode an image from file.
    _rawImage = img.decodeImage(File(widget.imagePath).readAsBytesSync());

    _imageSize =
        Size(_rawImage!.width.toDouble(), _rawImage!.height.toDouble());
    _adjustedImageSize ??= _imageSize;
    setState(() {});
  }

  detectFacialFeatures() async {
    // Implement facial features detection here.
    final _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification:
            _enableClassification, // Need to run additional classification for eyes open
        enableContours: _enableContours, // Defaults to false
        enableLandmarks: _enableLandmarks,
        minFaceSize:
            _minFaceSize, // Defaults to 0.1 (increase size turn it faster?)
        performanceMode: _performanceMode, // Defaults to fast
      ),
    );

    // Resize the image, maintaining the aspect ratio.
    if (_imageSize != _adjustedImageSize) {
      _rawImage = img.copyResize(
        _rawImage!,
        width: _adjustedImageSize!.width.toInt(),
        height: _adjustedImageSize!.height.toInt(),
      );
    }
    //Image thumbnail = copyResize(image, 120);

    final outputFilePath = '$_appDirectoryPath/output.png';
    // Save the thumbnail as a PNG.
    File(outputFilePath).writeAsBytesSync(img.encodePng(_rawImage!));

    //final inputImage = InputImage.fromFilePath(widget.imagePath);
    final inputImage = InputImage.fromFilePath(outputFilePath);
    final begin = DateTime.now();
    _faces = await _faceDetector.processImage(inputImage);
    _detectionDuration = DateTime.now().difference(begin).inMilliseconds;
    print('Face detection duration: $_detectionDuration ms');

    print('faces.length: ${_faces.length}');
    setState(() {});
  }

  List<Widget> renderFaces() {
    final List<Widget> widgets = [];
    //final List<FaceDetectorPainter> painters = [];
    //final List<CustomPaint> customPaints = [];

    widgets.add(Text('Faces detectadas: ${_faces.length}'));
    widgets.add(Text('Tempo de detecção: ${_detectionDuration}ms'));
    widgets.add(Divider());
    final outputFilePath = '$_appDirectoryPath/output.png';
    img.Image? image = img.decodeImage(File(outputFilePath).readAsBytesSync());

    for (final face in _faces) {
      final faceImage = img.copyCrop(
        image!,
        x: face.boundingBox.topLeft.dx.toInt(),
        y: face.boundingBox.topLeft.dy.toInt(),
        width: face.boundingBox.width.toInt(),
        height: face.boundingBox.height.toInt(),
      );
      List<int>? faceImageEncoded = img.encodePng(faceImage);
      final faceWidget = Image.memory(
        Uint8List.fromList(faceImageEncoded.toList()),
        width: double.infinity,
        fit: BoxFit.fitWidth,
      );
      print('Face: ${face.boundingBox.size}');
      print(
          'Face first countoir length: ${face.contours[FaceContourType.face]?.points.length}');
      print('_adjustedImageSize: $_adjustedImageSize');
      print(MediaQuery.of(context).size.width);
      final imageHeight = MediaQuery.of(context).size.width *
          face.boundingBox.height /
          face.boundingBox.width;

      widgets.add(
        Column(
          children: <Widget>[
            Text('Face: ${face.boundingBox}'),
            Stack(children: [
              faceWidget,
              //if (customPaint != null)
              Positioned(
                left: 0,
                top: 0,
                // TODO: Improve this...
                width: MediaQuery.of(context).size.width,
                height: imageHeight,
                child: CustomPaint(
                  painter: FaceDetectorPainter(
                    face,
                    face.boundingBox.size,
                    InputImageRotation.rotation0deg,
                  ),
                ),
              ),
            ]),
            //faceWidget,
            Text('HeadEulerAngleY: ${face.headEulerAngleY}'),
            Text('HeadEulerAngleZ: ${face.headEulerAngleZ}'),
            Text('LeftEyeOpenProbability: ${face.leftEyeOpenProbability}'),
            Text('RightEyeOpenProbability: ${face.rightEyeOpenProbability}'),
            Text('SmilingProbability: ${face.smilingProbability}'),
            Divider()
          ],
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Configurações de Detecção'),
        ),
        body: ListView(
          children: <Widget>[
            // Image preview
            FractionallySizedBox(
              widthFactor: 0.5,
              child: Image.file(File(widget.imagePath)),
            ),
            Text('Tamanho da Imagem: $_imageSize'),
            Row(
              children: [
                Text('Ajuste do tamanho: '),
                Slider(
                  value: _imageSizeRatio,
                  max: 1.0,
                  min: 0.1,
                  divisions: 9,
                  label: _imageSizeRatio.toStringAsFixed(1),
                  onChanged: (double value) {
                    setState(() {
                      _faces.clear();
                      _imageSizeRatio = value;
                      if (_imageSize != null) {
                        _adjustedImageSize = Size(
                            _imageSize!.width * _imageSizeRatio,
                            _imageSize!.height * _imageSizeRatio);
                      }
                    });
                  },
                ),
              ],
            ),
            Text('Tamanho da Imagem Ajustado: $_adjustedImageSize'),
            // Slider to configure the minimum face size
            Row(
              children: [
                const Text('Tamanho Mínimo da Face: '),
                Slider(
                  value: _minFaceSize,
                  max: 1.0,
                  min: 0.1,
                  divisions: 9,
                  label: _minFaceSize.toStringAsFixed(1),
                  onChanged: (double value) {
                    setState(() {
                      _faces.clear();
                      _minFaceSize = value;
                    });
                  },
                ),
              ],
            ),
            // Checkboxes to enable/disable classification, contours, and landmarks
            Row(
              children: [
                const Text('Enable Classification: '),
                Checkbox(
                  value: _enableClassification,
                  onChanged: (bool? value) {
                    setState(() {
                      _enableClassification = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Enable Contours: '),
                Checkbox(
                  value: _enableContours,
                  onChanged: (bool? value) {
                    setState(() {
                      _enableContours = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Enable Landmarks: '),
                Checkbox(
                  value: _enableLandmarks,
                  onChanged: (bool? value) {
                    setState(() {
                      _enableLandmarks = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Fast mode: '),
                Checkbox(
                  value: _performanceMode == FaceDetectorMode.fast,
                  onChanged: (bool? value) {
                    setState(() {
                      _performanceMode = value!
                          ? FaceDetectorMode.fast
                          : FaceDetectorMode.accurate;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                detectFacialFeatures();
              },
              child: const Text('Detectar Características Faciais'),
            ),
            if (_faces.isNotEmpty)
              //Text('Faces detectadas: ${_faces.length}'),
              Column(
                children: renderFaces(),
              ),
          ],
        ),
      ),
    );
  }
}
