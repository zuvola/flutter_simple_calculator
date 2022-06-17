import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'calculator.dart';

/// Controller for calculator.
class CalcController extends ChangeNotifier {
  final Calculator calc;
  String acLabel = 'AC';

  /// Create a [CalcController] with [maximumDigits] is 10 and maximumFractionDigits of [numberFormat] is 6.
  CalcController({maximumDigits = 10}) : calc = Calculator(maximumDigits: maximumDigits);

  /// Create a [Calculator].
  CalcController.numberFormat(intl.NumberFormat numberFormat, int maximumDigits) : calc = Calculator.numberFormat(numberFormat, maximumDigits);

  /// Display string
  String? get display => calc.displayString;

  /// Display value
  double? get value => calc.displayValue;

  /// Expression
  String? get expression => calc.expression;

  /// The [NumberFormat] used for display
  intl.NumberFormat get numberFormat => calc.numberFormat;

  /// Set the value.
  void setValue(double val) {
    calc.setValue(val);
    acLabel = 'C';
    notifyListeners();
  }

  /// Add digit to the display.
  void addDigit(int num) {
    calc.addDigit(num);
    acLabel = 'C';
    notifyListeners();
  }

  /// Add a decimal point.
  void addPoint() {
    calc.addPoint();
    acLabel = 'C';
    notifyListeners();
  }

  /// Clear all entries.
  void allClear() {
    calc.allClear();
    notifyListeners();
  }

  /// Clear value to zero.
  void clear() {
    calc.clear();
    acLabel = 'AC';
    notifyListeners();
  }

  /// Perform operations.
  void operate() {
    calc.operate();
    acLabel = 'AC';
    notifyListeners();
  }

  /// Remove the last digit.
  void removeDigit() {
    calc.removeDigit();
    notifyListeners();
  }

  /// Set the operation to addition.
  void setAdditionOp() {
    calc.setOperator('+');
    notifyListeners();
  }

  /// Set the operation to subtraction.
  void setSubtractionOp() {
    calc.setOperator('-');
    notifyListeners();
  }

  /// Set the operation to multiplication.
  void setMultiplicationOp() {
    calc.setOperator('×');
    notifyListeners();
  }

  /// Set the operation to division.
  void setDivisionOp() {
    calc.setOperator('÷');
    notifyListeners();
  }

  /// Set a percent sign.
  void setPercent() {
    calc.setPercent();
    acLabel = 'C';
    notifyListeners();
  }

  /// Toggle between a plus sign and a minus sign.
  void toggleSign() {
    calc.toggleSign();
    notifyListeners();
  }
}
