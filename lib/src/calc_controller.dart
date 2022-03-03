import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'calculator.dart';

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
  String? get display => _calc.displayString;

  /// Display value
  double? get value => _calc.displayValue;

  /// Expression
  String? get expression => _calc.expression;

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
