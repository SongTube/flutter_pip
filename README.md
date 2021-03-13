# flutter_pip

Simple plugin to implement Picture in Picture support for Android only.

## Android Setup

You need to declare that your app supports Picture in Picture mode by adding
to your AndroidManifest.xml the following line:

```xml
<activity
    ...
    android:supportsPictureInPicture="true"
    ...>
</activity>
```

## Enter Picture in Picture mode:

```dart
int result = await FlutterPip.enterPictureInPictureMode();
```

If the result returns 0, the app has entered PiP mode successfully, if it return 1 then
most probably this indicates that the device does not support PiP mode.

This function supports an optional parameter of type `PipRatio`, for example:

```dart
int result = await FlutterPip.enterPictureInPictureMode(
    PipRatio(
        width: ...
        height: ...
    )
);
```

Default values for `pipRatio` are `width: 16` and `height: 9`. You also need to take in
consideration that PiP mode only supports a value range from 0.418410 to 2.390000 for Aspect Ratio,
going anything bellow the minimum or above the maximum will throw a `PipRatioException` exception.

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