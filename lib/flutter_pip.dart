import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pip/platform_channel/channel.dart';

class PipWidget extends StatefulWidget {
  final Widget child;
  final Widget pictureInPictureChild;
  final Function()? onResume;
  final Function()? onSuspending;
  PipWidget({required this.child, required this.pictureInPictureChild, this.onResume, this.onSuspending});
  @override
  _PipWidgetState createState() => _PipWidgetState();
}

class _PipWidgetState extends State<PipWidget> with WidgetsBindingObserver {

  final _controller = StreamController<bool>();
  Duration _probeInterval = const Duration(milliseconds: 10);
  Timer? _timer;
  Stream<bool>? _stream;

  Stream<bool> get pipEnabled {
    _timer ??= Timer.periodic(
      _probeInterval,
      (_) async => _controller.add((await FlutterPip.isInPictureInPictureMode()) ?? false) ,
    );
    _stream ??= _controller.stream.asBroadcastStream();
    return _stream!.distinct();
  }

  late WidgetsBindingObserver observer;
  @override
  void initState() {
    observer = new LifecycleEventHandler(resumeCallBack: () async {
      if (widget.onResume != null) {
        widget.onResume!();
      }
      return;
    }, suspendingCallBack: () async {
      if (widget.onSuspending != null) {
        widget.onSuspending!();
      }
      return;
    });
    super.initState();
    WidgetsBinding.instance.addObserver(observer);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(observer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: pipEnabled,
      initialData: false,
      builder: (context, snapshot) => snapshot.data == true
          ? widget.pictureInPictureChild
          : widget.child,
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? suspendingCallBack;

  LifecycleEventHandler({this.resumeCallBack, this.suspendingCallBack});

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack!();
        }
        break;
    }
  }
}
