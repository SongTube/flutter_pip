
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pip/exceptions/pipRatioException.dart';

import '../models/pip_ratio.dart';

class FlutterPip {

  static const MethodChannel _channel =
      const MethodChannel('flutter_pip');

  static Future<int?> enterPictureInPictureMode({PipRatio? pipRatio}) async {
    PipRatio ratio = pipRatio != null ? pipRatio : PipRatio();
    if (ratio.aspectRatio < 0.418410 || ratio.aspectRatio > 2.390000)
      throw PipRatioException.extremeRatio();

    return await _channel.invokeMethod('enterPictureInPictureMode',
      {"width": ratio.width,"height": ratio.height}
    );
  }

  static Future<bool?> isInPictureInPictureMode() async {
    return await _channel.invokeMethod('isInPictureInPictureMode');
  }

  static Future<bool?> isPictureInPictureSupported() async {
    return await _channel.invokeMethod('isPictureInPictureSupported');
  }

}