import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';
import 'package:intl/intl.dart' as intl;

import 'calculator.dart';

/// Signature for callbacks that report that the [SimpleCalculator] value has changed.
typedef CalcChanged = void Function(
    String key, double value, String expression);

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
  }) : super(key: key);

  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String _displayValue;
  String _expression = "";
  String _acLabel = "AC";
  BorderSide _borderSide;
  Calculator _calc;

  final List<String> _nums = new List(10);
  final _baseStyle = const TextStyle(
    fontSize: 26,
  );

  @override
  Widget build(BuildContext context) {
    _borderSide = Divider.createBorderSide(
      context,
      color: widget.theme?.borderColor ?? Theme.of(context).dividerColor,
      width: widget.theme?.borderWidth ?? 1.0,
    );
    return Column(children: <Widget>[
      Expanded(
        child: _getDisplay(),
      ),
      Expanded(
        child: _getButtons(),
        flex: 5,
      ),
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_calc != null) return;
    if (widget.numberFormat == null) {
      var myLocale = Localizations.localeOf(context);
      var nf = intl.NumberFormat.decimalPattern(myLocale.toLanguageTag())
        ..maximumFractionDigits = 6;
      _calc = Calculator.numberFormat(nf, widget.maximumDigits);
    } else {
      _calc =
          Calculator.numberFormat(widget.numberFormat, widget.maximumDigits);
    }
    for (var i = 0; i < 10; i++) {
      _nums[i] = _calc.numberFormat.format(i);
    }
    _calc.setValue(widget.value);
    _displayValue = _calc.displayString;
  }

  Widget _getButtons() {
    return GridButton(
      textStyle: _baseStyle,
      borderColor: _borderSide.color,
      textDirection: TextDirection.ltr,
      hideSurroundingBorder: widget.hideSurroundingBorder,
      borderWidth: widget.theme?.borderWidth,
      onPressed: (dynamic val) {
        var acLabel;
        switch (val) {
          case "→":
            _calc.removeDigit();
            break;
          case "±":
            _calc.toggleSign();
            break;
          case "+":
          case "-":
          case "×":
          case "÷":
            _calc.setOperator(val);
            break;
          case "=":
            _calc.operate();
            acLabel = "AC";
            break;
          case "AC":
            _calc.allClear();
            break;
          case "C":
            _calc.clear();
            acLabel = "AC";
            break;
          default:
            if (val == _calc.numberFormat.symbols.DECIMAL_SEP) {
              _calc.addPoint();
              acLabel = "C";
            }
            if (val == _calc.numberFormat.symbols.PERCENT) {
              _calc.setPercent();
            }
            if (_nums.contains(val)) {
              _calc.addDigit(_nums.indexOf(val));
            }
            acLabel = "C";
        }
        if (widget.onChanged != null) {
          widget.onChanged(val, _calc.displayValue, _calc.expression);
        }
        setState(() {
          _displayValue = _calc.displayString;
          _expression = _calc.expression;
          _acLabel = acLabel ?? _acLabel;
        });
      },
      items: _getItems(),
    );
  }

  Widget _getDisplay() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: widget.hideSurroundingBorder ? BorderSide.none : _borderSide,
          left: widget.hideSurroundingBorder ? BorderSide.none : _borderSide,
          right: widget.hideSurroundingBorder ? BorderSide.none : _borderSide,
          bottom: widget.hideSurroundingBorder ? _borderSide : BorderSide.none,
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
                  : widget.onTappedDisplay(_calc.displayValue, details),
              child: Container(
                color: widget.theme?.displayColor,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: AutoSizeText(
                      _displayValue,
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
                      _expression,
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

  List<List<GridButtonItem>> _getItems() {
    return [
      [_acLabel, "→", _calc.numberFormat.symbols.PERCENT, "÷"],
      [_nums[7], _nums[8], _nums[9], "×"],
      [_nums[4], _nums[5], _nums[6], "-"],
      [_nums[1], _nums[2], _nums[3], "+"],
      [_nums[0], _calc.numberFormat.symbols.DECIMAL_SEP, "±", "="],
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
        if (title == _calc.numberFormat.symbols.PERCENT ||
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
