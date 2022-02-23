# flutter_simple_calculator

Flutter widget that provides simple calculator. You can easily integrate a calculator to your apps.

[![pub package](https://img.shields.io/pub/v/flutter_simple_calculator.svg)](https://pub.dartlang.org/packages/flutter_simple_calculator)


### Default style

<img src="https://github.com/zuvola/flutter_simple_calculator/blob/master/example/screenshot_1.png?raw=true" width="320px"/>

### With custom styles

<img src="https://github.com/zuvola/flutter_simple_calculator/blob/master/example/screenshot_2.png?raw=true" width="320px"/>

````dart
SimpleCalculator(
  theme: const CalculatorThemeData(
    displayColor: Colors.black,
    displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
    /*...*/
  ),
)
````

### Localize

<img src="https://github.com/zuvola/flutter_simple_calculator/blob/master/example/screenshot_3.png?raw=true" width="320px"/>

````dart
SimpleCalculator(
  numberFormat: NumberFormat.decimalPattern("fa_IR")
    ..maximumFractionDigits = 6,
)
````


## Getting Started

To use this plugin, add `flutter_simple_calculator` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```yaml
dependencies:
 flutter_simple_calculator: 
```

Import the library in your file.

````dart
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
````

See the `example` directory for a complete sample app using SimpleCalculator.
Or use the SimpleCalculator like below.

````dart
SimpleCalculator(
  value: 123.45,
  hideExpression: true,
  onChanged: (key, value, expression) {
    /*...*/
  },
  theme: const CalculatorThemeData(
    displayColor: Colors.black,
    displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
  ),
)
````