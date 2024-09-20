import 'dart:io';
import 'dart:ui';

//import 'package:camera/camera.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

// double translateX(
//   double x,
//   Size canvasSize,
//   Size imageSize,
//   InputImageRotation rotation,
//   //CameraLensDirection cameraLensDirection,
// ) {
//   switch (rotation) {
//     case InputImageRotation.rotation90deg:
//       return x *
//           canvasSize.width /
//           (Platform.isIOS ? imageSize.width : imageSize.height);
//     case InputImageRotation.rotation270deg:
//       return canvasSize.width -
//           x *
//               canvasSize.width /
//               (Platform.isIOS ? imageSize.width : imageSize.height);
//     case InputImageRotation.rotation0deg:
//     case InputImageRotation.rotation180deg:
//       // switch (cameraLensDirection) {
//       //   case CameraLensDirection.back:
//       //     return x * canvasSize.width / imageSize.width;
//       //   default:
//       return canvasSize.width - x * canvasSize.width / imageSize.width;
//     //}
//   }
// }

// double translateY(
//   double y,
//   Size canvasSize,
//   Size imageSize,
//   InputImageRotation rotation,
//   //CameraLensDirection cameraLensDirection,
// ) {
//   print(
//       'rotation: $rotation, y: $y, canvasSize: $canvasSize, imageSize: $imageSize');
//   switch (rotation) {
//     case InputImageRotation.rotation90deg:
//     case InputImageRotation.rotation270deg:
//       return y *
//           canvasSize.height /
//           (Platform.isIOS ? imageSize.height : imageSize.width);
//     case InputImageRotation.rotation0deg:
//     case InputImageRotation.rotation180deg:
//       return y * canvasSize.height / imageSize.height;
//   }
// }

double translateX(
  double x,
  Size canvasSize,
  Size imageSize,
  InputImageRotation rotation,
  //CameraLensDirection cameraLensDirection,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x *
          canvasSize.width /
          (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation270deg:
      return canvasSize.width -
          x *
              canvasSize.width /
              (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation0deg:
      return x *
          canvasSize.width /
          (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation180deg:
      // switch (cameraLensDirection) {
      //   case CameraLensDirection.back:
      //     return x * canvasSize.width / imageSize.width;
      //   default:
      return canvasSize.width - x * canvasSize.width / imageSize.width;
    //}
  }
}

double translateY(
  double y,
  Size canvasSize,
  Size imageSize,
  InputImageRotation rotation,
  //CameraLensDirection cameraLensDirection,
) {
  // print(
  //     'rotation: $rotation, y: $y, canvasSize: $canvasSize, imageSize: $imageSize');

  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y *
          canvasSize.height /
          (Platform.isIOS ? imageSize.height : imageSize.width);
    case InputImageRotation.rotation0deg:
      return y *
          canvasSize.height /
          //(Platform.isIOS ? imageSize.height : imageSize.width);
          imageSize.height;
    // pre-recorded video scenario
    //return y * imageSize.height / canvasSize.height;
    case InputImageRotation.rotation180deg:
      return y * canvasSize.height / imageSize.height;
  }
}

double translateXImage(
  double x,
  Size canvasSize,
  Size imageSize,
) {
  return x * canvasSize.width / imageSize.width;
}

double translateYImage(
  double y,
  Size canvasSize,
  Size imageSize,
) {
  return y * canvasSize.height / imageSize.height;
}
