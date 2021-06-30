import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double? _screenWidth;
  static double? _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;
  static double? aspectratio;

  static double? maxHeight;
  static double? maxWidth;
  static double? textMultiplier;
  static double? imageSizeMultiplier;
  static double? heightMultiplier;
  static double? widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;
    aspectratio = _screenHeight!/_screenWidth!;
    

    if (aspectratio! < 2) {
      print('ASPECT RATIO < 2');
      _blockWidth = _screenWidth! / 100;
      _blockHeight = 2.05 * _blockWidth;

      maxHeight = _screenHeight;
      maxWidth = _screenWidth;
      textMultiplier = _blockHeight;
      imageSizeMultiplier = _blockWidth;
      heightMultiplier = _blockHeight;
      widthMultiplier = _blockWidth;
    } else {
      _blockWidth = _screenWidth! / 100;
      _blockHeight = _screenHeight! / 100;

      maxHeight = _screenHeight;
      maxWidth = _screenWidth;
      textMultiplier = _blockHeight;
      imageSizeMultiplier = _blockWidth;
      heightMultiplier = _blockHeight;
      widthMultiplier = _blockWidth;
    }

    print('#######Responsive SizeConfig:');
    print('##ScreenWidth = $_screenWidth');
    print('##ScreenHeight = $_screenHeight');
    print('##BlockWidth = $_blockWidth');
    print('##BlockHeight = $_blockHeight');

    print('#####################');
    print('##textMultiplier = $_blockHeight');
    print('##imageSizeMultiplier = $_blockWidth');
    print('##heightMultiplier = $_blockHeight');
    print('##widthMultiplier = $_blockWidth');
  }
}
