import 'dart:math';

//import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'coordinates_translator.dart';

/// Painter for single images with face detection. This painter is customized
/// to draw facial features on the image offsetting the points to the face
/// bounding box.
class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
    this.face,
    this.imageSize,
    this.rotation,
    //this.cameraLensDirection,
  );

  final Face face;
  final Size imageSize;
  final InputImageRotation rotation;
  //final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    print('FaceDetectorPainter.paint size: $size imageSize: $imageSize');
    final Paint paint1 = Paint()
      //..style = PaintingStyle.stroke
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = Colors.red;
    final Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = Colors.green;

    final left = translateX(
      face.boundingBox.left,
      size,
      imageSize,
      rotation,
      //cameraLensDirection,
    );
    final top = translateY(
      face.boundingBox.top,
      size,
      imageSize,
      rotation,
      //cameraLensDirection,
    );
    final right = translateX(
      face.boundingBox.right,
      size,
      imageSize,
      rotation,
      //cameraLensDirection,
    );
    final bottom = translateY(
      face.boundingBox.bottom,
      size,
      imageSize,
      rotation,
      //cameraLensDirection,
    );

    print('Face bounding box: $left, $top, $right, $bottom');
    // canvas.drawRect(
    //   Rect.fromLTRB(left, top, right, bottom),
    //   paint1,
    // );

    void paintContour(FaceContourType type) {
      final contour = face.contours[type];
      print('Face contour: $type');
      if (contour?.points != null) {
        print('Face contour points: ${contour!.points.length}'
            ' point[0]: ${contour.points[0].x}, ${contour.points[0].y}');
        for (final Point point in contour!.points) {
          final offSettedX = point.x - face.boundingBox.left;
          final offSettedY = point.y - face.boundingBox.top;
          // print('Face landmark: ${point.x}, ${point.y}'
          //     ' offsetted: $offSettedX, $offSettedY');
          final translatedX = translateX(
            //landmark.position.x.toDouble(),
            offSettedX.toDouble(),
            size,
            imageSize,
            rotation,
            //cameraLensDirection,
          );
          final translatedY = translateY(
            //landmark.position.y.toDouble(),
            offSettedY.toDouble(),
            size,
            imageSize,
            rotation,
            //cameraLensDirection,
          );
          canvas.drawCircle(Offset(translatedX, translatedY), 2, paint1);
        }
      }
    }

    void paintLandmark(FaceLandmarkType type) {
      final landmark = face.landmarks[type];
      if (landmark?.position != null) {
        final offSettedX = landmark!.position.x - face.boundingBox.left;
        final offSettedY = landmark.position.y - face.boundingBox.top;
        // print('Face landmark: ${landmark.position.x}, ${landmark.position.y}'
        //     ' offsetted: $offSettedX, $offSettedY');
        final translatedX = translateX(
          //landmark.position.x.toDouble(),
          offSettedX.toDouble(),
          size,
          imageSize,
          rotation,
          //cameraLensDirection,
        );
        final translatedY = translateY(
          //landmark.position.y.toDouble(),
          offSettedY.toDouble(),
          size,
          imageSize,
          rotation,
          //cameraLensDirection,
        );
        //print('Face landmark translated: $translatedX, $translatedY');
        canvas.drawCircle(Offset(translatedX, translatedY), 4, paint2);
      }
    }

    for (final type in FaceContourType.values) {
      paintContour(type);
    }

    for (final type in FaceLandmarkType.values) {
      paintLandmark(type);
    }
    //}
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.face != face;
  }
}
