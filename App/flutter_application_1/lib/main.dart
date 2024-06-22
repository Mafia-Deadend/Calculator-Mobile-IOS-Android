// ignore_for_file: unused_field, prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use your custom font
        scaffoldBackgroundColor: Colors.black,
      ),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  String _input = '';
  String _operator = '';
  double _firstOperand = 0;
  double _secondOperand = 0;
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _clear();
      } else if (value == '⌫') {
        _backspace();
      } else if (value == '➕' ||
          value == '➖' ||
          value == '✖' ||
          value == '➗' ||
          value == '%') {
        _setOperator(value);
      } else if (value == '=') {
        _calculate();
      } else if (value == '+/-') {
        _toggleSign();
      } else {
        _inputDigit(value);
      }
    });
  }

  void _clear() {
    display = '0';
    _input = '';
    _operator = '';
    _firstOperand = 0;
    _secondOperand = 0;
    _shouldResetDisplay = false;
  }

  void _backspace() {
    if (_shouldResetDisplay) {
      return;
    }
    if (display.length > 1) {
      display = display.substring(0, display.length - 1);
    } else {
      display = '0';
    }
  }

  void _setOperator(String operator) {
    if (_operator.isNotEmpty) {
      _calculate();
    }
    _firstOperand = double.tryParse(display) ?? 0;
    _operator = operator;
    _shouldResetDisplay = true;
  }

  void _calculate() {
    _secondOperand = double.tryParse(display) ?? 0;
    double result = 0;
    switch (_operator) {
      case '➕':
        result = _firstOperand + _secondOperand;
        break;
      case '➖':
        result = _firstOperand - _secondOperand;
        break;
      case '✖':
        result = _firstOperand * _secondOperand;
        break;
      case '➗':
        result = _firstOperand / _secondOperand;
        break;
      case '%':
        result = _firstOperand % _secondOperand;
        break;
    }
    display = result.toString();
    _operator = '';
    _shouldResetDisplay = true;
  }

  void _inputDigit(String digit) {
    if (_shouldResetDisplay) {
      display = digit;
      _shouldResetDisplay = false;
    } else {
      display = display == '0' ? digit : display + digit;
    }
  }

  void _toggleSign() {
    if (display.startsWith('➖')) {
      display = display.substring(1);
    } else {
      display = '-' + display;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(32),
              child: Text(
                display,
                style: TextStyle(color: Colors.white, fontSize: 48),
              ),
            ),
          ),
          _buildButtonRow(['AC', '+/-', '%', '➗'], isFunctionRow: true),
          _buildButtonRow(['7', '8', '9', '✖']),
          _buildButtonRow(['4', '5', '6', '➖']),
          _buildButtonRow(['1', '2', '3', '➕']),
          _buildButtonRow(['0', '.', '='], isLastRow: true),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons,
      {bool isFunctionRow = false, bool isLastRow = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        return Expanded(
          flex: button == '0' && isLastRow ? 2 : 1,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ElevatedButton(
              onPressed: () => _onButtonPressed(button),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(24),
                backgroundColor: isFunctionRow
                    ? Colors.grey
                    : (button == '➗' ||
                            button == '✖' ||
                            button == '➖' ||
                            button == '➕' ||
                            button == '=')
                        ? Colors.orange
                        : const Color.fromARGB(221, 55, 54, 54),
                foregroundColor: Colors.white,
                shape: button == '0' && isLastRow
                    ? StadiumBorder()
                    : CircleBorder(),
              ),
              child: Text(
                button,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
