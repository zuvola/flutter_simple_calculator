import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';
import 'package:intl/intl.dart' as intl;

import 'calculator.dart';

/// Signature for callbacks that report that the [SimpleCalculator] value has changed.
typedef CalcChanged = void Function(
    String key, double value, String expression);

/// Controller for calculator.
class CalcController extends ChangeNotifier {
  final Calculator _calc;
  String _acLabel = 'AC';

  /// Create a [CalcController] with [maximumDigits] is 10 and maximumFractionDigits of [numberFormat] is 6.
  CalcController({maximumDigits = 10})
      : _calc = Calculator(maximumDigits: maximumDigits);

  /// Create a [Calculator].
  CalcController.numberFormat(intl.NumberFormat numberFormat, int maximumDigits)
      : _calc = Calculator.numberFormat(numberFormat, maximumDigits);

  /// Display string
  String get display => _calc.displayString;

  /// Display value
  double get value => _calc.displayValue;

  /// Expression
  String get expression => _calc.expression;

  /// Label for the "AC" button, "AC" or "C".
  String get acLabel => _acLabel;

  /// The [NumberFormat] used for display
  intl.NumberFormat get numberFormat => _calc.numberFormat;

  /// Set the value.
  void setValue(double val) {
    _calc.setValue(val);
    _acLabel = 'C';
    notifyListeners();
  }

  /// Add digit to the display.
  void addDigit(int num) {
    _calc.addDigit(num);
    _acLabel = 'C';
    notifyListeners();
  }

  /// Add a decimal point.
  void addPoint() {
    _calc.addPoint();
    _acLabel = 'C';
    notifyListeners();
  }

  /// Clear all entries.
  void allClear() {
    _calc.allClear();
    notifyListeners();
  }

  /// Clear value to zero.
  void clear() {
    _calc.clear();
    _acLabel = 'AC';
    notifyListeners();
  }

  /// Perform operations.
  void operate() {
    _calc.operate();
    _acLabel = 'AC';
    notifyListeners();
  }

  /// Remove the last digit.
  void removeDigit() {
    _calc.removeDigit();
    notifyListeners();
  }

  /// Set the operation to addition.
  void setAdditionOp() {
    _calc.setOperator('+');
    notifyListeners();
  }

  /// Set the operation to subtraction.
  void setSubtractionOp() {
    _calc.setOperator('-');
    notifyListeners();
  }

  /// Set the operation to multiplication.
  void setMultiplicationOp() {
    _calc.setOperator('×');
    notifyListeners();
  }

  /// Set the operation to division.
  void setDivisionOp() {
    _calc.setOperator('÷');
    notifyListeners();
  }

  /// Set a percent sign.
  void setPercent() {
    _calc.setPercent();
    _acLabel = 'C';
    notifyListeners();
  }

  /// Toggle between a plus sign and a minus sign.
  void toggleSign() {
    _calc.toggleSign();
    notifyListeners();
  }
}

/// Holds the color and typography values for the [SimpleCalculator].
class CalculatorThemeData {
  /// The color to use when painting the line.
  final Color borderColor;

  /// Width of the divider border, which is usually 1.0.
  final double borderWidth;

  /// The color of the display panel background.
  final Color displayColor;

  /// The background color of the expression area.
  final Color expressionColor;

  /// The background color of operator buttons.
  final Color operatorColor;

  /// The background color of command buttons.
  final Color commandColor;

  /// The background color of number buttons.
  final Color numColor;

  /// The text style to use for the display panel.
  final TextStyle displayStyle;

  /// The text style to use for the expression area.
  final TextStyle expressionStyle;

  /// The text style to use for operator buttons.
  final TextStyle operatorStyle;

  /// The text style to use for command buttons.
  final TextStyle commandStyle;

  /// The text style to use for number buttons.
  final TextStyle numStyle;

  const CalculatorThemeData(
      {this.displayColor,
      this.borderWidth = 1.0,
      this.expressionColor,
      this.borderColor,
      this.operatorColor,
      this.commandColor,
      this.numColor,
      this.displayStyle,
      this.expressionStyle,
      this.operatorStyle,
      this.commandStyle,
      this.numStyle});
}

/// SimpleCalculator
///
/// {@tool sample}
///
/// This example shows a simple [SimpleCalculator].
///
/// ```dart
/// SimpleCalculator(
///   value: 123.45,
///   hideExpression: true,
///   onChanged: (key, value, expression) {
///     /*...*/
///   },
///   theme: const CalculatorThemeData(
///     displayColor: Colors.black,
///     displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
///   ),
/// )
/// ```
/// {@end-tool}
///
class SimpleCalculator extends StatefulWidget {
  /// Visual properties for this widget.
  final CalculatorThemeData theme;

  /// Whether to show surrounding borders.
  final bool hideSurroundingBorder;

  /// Whether to show expression area.
  final bool hideExpression;

  /// The value currently displayed on this calculator.
  final double value;

  /// Called when the button is tapped or the value is changed.
  final CalcChanged onChanged;

  /// Called when the display area is tapped.
  final Function(double, TapDownDetails) onTappedDisplay;

  /// The [NumberFormat] used for display
  final intl.NumberFormat numberFormat;

  /// Maximum number of digits on display.
  final int maximumDigits;

  /// Controller for calculator.
  final CalcController controller;

  const SimpleCalculator({
    Key key,
    this.theme,
    this.hideExpression = false,
    this.value = 0,
    this.onChanged,
    this.onTappedDisplay,
    this.numberFormat,
    this.maximumDigits = 10,
    this.hideSurroundingBorder = false,
    this.controller,
  }) : super(key: key);

  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  CalcController _controller;
  String _acLabel;

  final List<String> _nums = List(10);
  final _baseStyle = const TextStyle(
    fontSize: 26,
  );

  void _initController() {
    if (widget.controller == null) {
      if (widget.numberFormat == null) {
        var myLocale = Localizations.localeOf(context);
        var nf = intl.NumberFormat.decimalPattern(myLocale.toLanguageTag())
          ..maximumFractionDigits = 6;
        _controller = CalcController.numberFormat(nf, widget.maximumDigits);
      } else {
        _controller = CalcController.numberFormat(
            widget.numberFormat, widget.maximumDigits);
      }
    } else {
      _controller = widget.controller;
    }
    _controller.addListener(_didChangeCalcValue);
  }

  @override
  void didChangeDependencies() {
    _initController();
    for (var i = 0; i < 10; i++) {
      _nums[i] = _controller.numberFormat.format(i);
    }
    _controller.allClear();
    _controller.setValue(widget.value);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SimpleCalculator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_didChangeCalcValue);
      _initController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: _CalcDisplay(
          hideSurroundingBorder: widget.hideSurroundingBorder,
          hideExpression: widget.hideExpression,
          onTappedDisplay: widget.onTappedDisplay,
          theme: widget.theme,
          controller: _controller,
        ),
      ),
      Expanded(
        child: _getButtons(),
        flex: 5,
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.removeListener(_didChangeCalcValue);
    super.dispose();
  }

  void _didChangeCalcValue() {
    if (_acLabel == _controller.acLabel) return;
    setState(() {
      _acLabel = _controller.acLabel;
    });
  }

  Widget _getButtons() {
    return GridButton(
      textStyle: _baseStyle,
      borderColor: widget.theme?.borderColor ?? Theme.of(context).dividerColor,
      textDirection: TextDirection.ltr,
      hideSurroundingBorder: widget.hideSurroundingBorder,
      borderWidth: widget.theme?.borderWidth,
      onPressed: (dynamic val) {
        switch (val) {
          case "→":
            _controller.removeDigit();
            break;
          case "±":
            _controller.toggleSign();
            break;
          case "+":
            _controller.setAdditionOp();
            break;
          case "-":
            _controller.setSubtractionOp();
            break;
          case "×":
            _controller.setMultiplicationOp();
            break;
          case "÷":
            _controller.setDivisionOp();
            break;
          case "=":
            _controller.operate();
            break;
          case "AC":
            _controller.allClear();
            break;
          case "C":
            _controller.clear();
            break;
          default:
            if (val == _controller.numberFormat.symbols.DECIMAL_SEP) {
              _controller.addPoint();
            }
            if (val == _controller.numberFormat.symbols.PERCENT) {
              _controller.setPercent();
            }
            if (_nums.contains(val)) {
              _controller.addDigit(_nums.indexOf(val));
            }
        }
        if (widget.onChanged != null) {
          widget.onChanged(val, _controller.value, _controller.expression);
        }
      },
      items: _getItems(),
    );
  }

  List<List<GridButtonItem>> _getItems() {
    return [
      [_acLabel, "→", _controller.numberFormat.symbols.PERCENT, "÷"],
      [_nums[7], _nums[8], _nums[9], "×"],
      [_nums[4], _nums[5], _nums[6], "-"],
      [_nums[1], _nums[2], _nums[3], "+"],
      [_nums[0], _controller.numberFormat.symbols.DECIMAL_SEP, "±", "="],
    ].map((items) {
      return items.map((title) {
        Color color =
            widget.theme?.numColor ?? Theme.of(context).scaffoldBackgroundColor;
        TextStyle style = widget.theme?.numStyle;
        if (title == "=" ||
            title == "+" ||
            title == "-" ||
            title == "×" ||
            title == "÷") {
          color = widget.theme?.operatorColor ?? Theme.of(context).primaryColor;
          style = widget.theme?.operatorStyle ??
              _baseStyle.copyWith(
                  color: Theme.of(context).primaryTextTheme.headline6.color);
        }
        if (title == _controller.numberFormat.symbols.PERCENT ||
            title == "→" ||
            title == "C" ||
            title == "AC") {
          color = widget.theme?.commandColor ?? Theme.of(context).splashColor;
          style = widget.theme?.commandStyle;
        }
        return GridButtonItem(
          title: title,
          color: color,
          textStyle: style,
        );
      }).toList();
    }).toList();
  }
}

class _CalcDisplay extends StatefulWidget {
  /// Whether to show surrounding borders.
  final bool hideSurroundingBorder;

  /// Whether to show expression area.
  final bool hideExpression;

  /// Visual properties for this widget.
  final CalculatorThemeData theme;

  /// Controller for calculator.
  final CalcController controller;

  /// Called when the display area is tapped.
  final Function(double, TapDownDetails) onTappedDisplay;

  const _CalcDisplay({
    Key key,
    this.hideSurroundingBorder,
    this.hideExpression,
    this.onTappedDisplay,
    this.theme,
    this.controller,
  }) : super(key: key);

  @override
  _CalcDisplayState createState() => _CalcDisplayState();
}

class _CalcDisplayState extends State<_CalcDisplay> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeCalcValue);
  }

  @override
  void didUpdateWidget(_CalcDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_didChangeCalcValue);
      widget.controller.addListener(_didChangeCalcValue);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeCalcValue);
    super.dispose();
  }

  void _didChangeCalcValue() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final borderSide = Divider.createBorderSide(
      context,
      color: widget.theme?.borderColor ?? Theme.of(context).dividerColor,
      width: widget.theme?.borderWidth ?? 1.0,
    );
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: widget.hideSurroundingBorder ? BorderSide.none : borderSide,
          left: widget.hideSurroundingBorder ? BorderSide.none : borderSide,
          right: widget.hideSurroundingBorder ? BorderSide.none : borderSide,
          bottom: widget.hideSurroundingBorder ? borderSide : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) => widget.onTappedDisplay == null
                  ? null
                  : widget.onTappedDisplay(widget.controller.value, details),
              child: Container(
                color: widget.theme?.displayColor,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: AutoSizeText(
                      widget.controller.display,
                      style: widget.theme?.displayStyle ??
                          const TextStyle(fontSize: 50),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !widget.hideExpression,
            child: Expanded(
              child: Container(
                color: widget.theme?.expressionColor,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      widget.controller.expression,
                      style: widget.theme?.expressionStyle ??
                          const TextStyle(color: Colors.grey),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
