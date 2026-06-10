import 'package:flutter/material.dart';
import 'package:jewellary_stock/screens/login_screen.dart';
import '../theme/theme.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expr = '';
  String result = '0';

  // Hidden Unlock Codes
  final List<String> secretCodes = ["2580.2580+2580", "786+786"];

  final List<String> keys = [
    'C',
    '±',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '⌫',
    '=',
  ];

  void _tap(String key) {
    setState(() {
      if (key == 'C') {
        expr = '';
        result = '0';
        return;
      }

      if (key == '⌫') {
        if (expr.isNotEmpty) {
          expr = expr.substring(0, expr.length - 1);
        }
        return;
      }

      if (key == '=') {
        // Hidden App Unlock
        if (secretCodes.contains(expr)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
          return;
        }

        result = _evaluate(expr);
        return;
      }

      if (key == '±') {
        if (expr.isNotEmpty) {
          if (expr.startsWith('-')) {
            expr = expr.substring(1);
          } else {
            expr = '-$expr';
          }
        }
        return;
      }

      expr += key;
    });
  }

  String _evaluate(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

      final tokens = <String>[];
      String current = '';

      for (int i = 0; i < expression.length; i++) {
        final char = expression[i];

        if ('+-*/'.contains(char)) {
          if (current.isNotEmpty) {
            tokens.add(current);
          }
          tokens.add(char);
          current = '';
        } else {
          current += char;
        }
      }

      if (current.isNotEmpty) {
        tokens.add(current);
      }

      if (tokens.isEmpty) return '0';

      double result = double.tryParse(tokens[0]) ?? 0;

      for (int i = 1; i < tokens.length; i += 2) {
        if (i + 1 >= tokens.length) break; // Guard against trailing operator
        final operator = tokens[i];
        final value = double.tryParse(tokens[i + 1]) ?? 0;

        switch (operator) {
          case '+':
            result += value;
            break;
          case '-':
            result -= value;
            break;
          case '*':
            result *= value;
            break;
          case '/':
            result = value == 0 ? 0 : result / value;
            break;
        }
      }

      if (result == result.toInt()) {
        return result.toInt().toString();
      }

      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  Widget buildKey(String text) {
    final bool isOperator = ['÷', '×', '-', '+', '='].contains(text);

    return Material(
      color: isOperator ? kGold : kCard,
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () => _tap(text),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isOperator ? Colors.black : kText,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay({required bool isLandscape}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isLandscape ? 12 : 24,
      ),
      alignment: Alignment.bottomRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            expr,
            maxLines: isLandscape ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: kMuted, fontSize: 22),
          ),
          SizedBox(height: isLandscape ? 6 : 12),
          Text(
            result,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: kText,
              fontSize: isLandscape ? 38 : 52,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Calculator',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          if (isLandscape) {
            return Row(
              children: [
                Expanded(flex: 5, child: _buildDisplay(isLandscape: true)),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: LayoutBuilder(
                      builder: (context, keyConstraints) {
                        const double spacing = 10;
                        final double wG = keyConstraints.maxWidth;
                        final double hG = keyConstraints.maxHeight;
                        final double wC = (wG - 3 * spacing) / 4;
                        final double hR = (hG - 4 * spacing) / 5;
                        double aspect = 1.2;
                        if (wC > 0 && hR > 0) {
                          aspect = wC / hR;
                        }
                        return GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          mainAxisSpacing: spacing,
                          crossAxisSpacing: spacing,
                          childAspectRatio: aspect,
                          children: keys.map(buildKey).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(child: _buildDisplay(isLandscape: false)),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: LayoutBuilder(
                    builder: (context, keyConstraints) {
                      final maxGridHeight = constraints.maxHeight * 0.6;
                      const double spacing = 10;
                      final double wG = keyConstraints.maxWidth;
                      double aspect = 1.2;
                      final double wC = (wG - 3 * spacing) / 4;
                      final double hR = wC / aspect;
                      final double gridHeight = 5 * hR + 4 * spacing;
                      if (gridHeight > maxGridHeight) {
                        final double allowedHR =
                            (maxGridHeight - 4 * spacing) / 5;
                        if (allowedHR > 0) {
                          aspect = wC / allowedHR;
                        }
                      }
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        childAspectRatio: aspect,
                        children: keys.map(buildKey).toList(),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
