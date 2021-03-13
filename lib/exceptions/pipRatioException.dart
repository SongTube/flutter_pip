class PipRatioException implements Exception {

  final String message;

  PipRatioException(this.message);

  PipRatioException.extremeRatio() : message =
    "Aspect ratio is too extreme (must be between 0,418410 and 2,390000)";

}