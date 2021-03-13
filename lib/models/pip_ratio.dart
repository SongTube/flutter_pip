class PipRatio {

  final int width;
  final int height;

  PipRatio({
    this.width = 16,
    this.height = 9
  });

  double get aspectRatio => width/height;

}