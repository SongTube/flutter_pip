# flutter_pip

Simple plugin to implement Picture in Picture support.

## Enter Picture in Picture mode:

```dart
int result = await FlutterPip.enterPictureInPictureMode();
```

If the result returns 0, the app has entered PiP mode successfully, if it return 1 then
most probably this indicates that the device does not support PiP mode.

## To check whether the app is on Picture in Picture mode:

```dart
bool result = await FlutterPip.isInPictureInPictureMode();
```

Simply returns a boolean indicating if the app is on PiP mode or not.

## PipWidget

This widget has two callbacks:

```dart
PipWidget(
    onResume: (bool pipMode) {
        ...
    },
    onSuspended: () {
        ...
    }
    child: ...
}
```

`onResume` is an Async callback that returns a boolean indicating if Picture in Picture
mode is enable/disabled, this is useful in case your app were in PiP mode and you want
to restore your Widget Tree UI.

`onSuspended` is just a simple callback that you can use to execute anything you want to
do when the application is thrown in the background.