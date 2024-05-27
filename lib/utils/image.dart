// Ref: https://stackoverflow.com/questions/46145472/how-to-convert-base64-string-into-image-with-flutter

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';


Image imageFromBase64String(String base64String, {bool cover=false}) {
  return Image.memory(base64Decode(base64String), fit: cover ? BoxFit.cover : BoxFit.fill);
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}