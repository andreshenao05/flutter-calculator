import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _append(String value) {
    setState(() {
      _expression += value;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '';
    });
  }

  void _evaluate() {
    try {
      final parsed = Expression.parse(
        _expression.replaceAll('×', '*').replaceAll('÷', '/'),
      );
      final evaluator = const ExpressionEvaluator();
      final context = <String, dynamic>{};
      final value = evaluator.eval(parsed, context);
      setState(() {
        _result = value.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget buildButton(String label, {Color? color, VoidCallback? onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.indigo.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          onPressed: onPressed,
          child: Text(label),
        ),
      ),
    );
  }

  Widget buildButtonRow(List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Calculator'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_expression, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(_result, style: Theme.of(context).textTheme.headlineLarge),
              const Divider(height: 32, thickness: 1),
              buildButtonRow([
                buildButton('7', onPressed: () => _append('7')),
                buildButton('8', onPressed: () => _append('8')),
                buildButton('9', onPressed: () => _append('9')),
                buildButton('÷', color: Colors.orange, onPressed: () => _append('÷')),
              ]),
              buildButtonRow([
                buildButton('4', onPressed: () => _append('4')),
                buildButton('5', onPressed: () => _append('5')),
                buildButton('6', onPressed: () => _append('6')),
                buildButton('×', color: Colors.orange, onPressed: () => _append('×')),
              ]),
              buildButtonRow([
                buildButton('1', onPressed: () => _append('1')),
                buildButton('2', onPressed: () => _append('2')),
                buildButton('3', onPressed: () => _append('3')),
                buildButton('-', color: Colors.orange, onPressed: () => _append('-')),
              ]),
              buildButtonRow([
                buildButton('0', onPressed: () => _append('0')),
                buildButton('.', onPressed: () => _append('.')),
                buildButton('C', color: Colors.red, onPressed: _clear),
                buildButton('+', color: Colors.orange, onPressed: () => _append('+')),
              ]),
              const SizedBox(height: 12),
              Row(
                children: [
                  buildButton('=', color: Colors.green, onPressed: _evaluate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
