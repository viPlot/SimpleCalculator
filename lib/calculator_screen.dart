import 'package:calculator_app/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number_1 = ""; //. 0-9
  String operand = ""; // + - / *
  String number_2 = ""; // . 0-9

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFf9f9f9),
        body: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(
                      right: 30, bottom: 20, left: 30),
                  child: Text(
                        "$number_1$operand$number_2".isEmpty
                            ? "0"
                            : "$number_1$operand$number_2",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                  ),
                ),
              ),
            //buttons
            Wrap(
              children: Btn.buttonValues
                  .map((value) =>
                  SizedBox(
                    width: screenSize.width / 4.5,
                    height: screenSize.width / 4.5,
                    child: buildButton(value),
                  ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shadowColor: Colors.black,
        elevation: 10,
        shape: const Border(
          left: BorderSide(
            color: Colors.black,
            width: 2.5,

          ),
          bottom: BorderSide(
            color: Colors.black,
            width: 2.5,

          ),
          right: BorderSide(
              color: Colors.black,
              width: 1.5
          ),
          top: BorderSide(
              color: Colors.black,
              width: 1.5
          ),
        ),
        /*const RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.black, 
                width: 1.3
            ),
        ),*/
        child: InkWell(
            onTap: () => onBtnTap(value),
            child: Center(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    fontSize: 26,
                  ),
                )
            )
        ),
      )
      ,
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }

//calculate the result
void calculate() {
  if (number_1.isEmpty || operand.isEmpty || number_2.isEmpty) {
    return;
  }
    double num_1 = double.parse(number_1);
    double num_2 = double.parse(number_2);

  var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num_1 + num_2;
        break;
      case Btn.subtract:
        result = num_1 - num_2;
        break;
      case Btn.multiply:
        result = num_1 * num_2;
        break;
      case Btn.divide:
        result = num_1 / num_2;
        break;
      default:
    }
    setState(() {

    number_1 = "$result";

      if (number_1.endsWith(".0")) {
        number_1 = number_1.substring(0, number_1.length - 2);
      }
      operand = "";
      number_2 = "";
    });
}

// converts output to %
void convertToPercentage() {
  if (number_1.isNotEmpty && operand.isNotEmpty && number_2.isNotEmpty) {
    calculate();
  }
  if (operand.isNotEmpty) {
    // cannot be converted
    return;
  }
  final number = double.parse(number_1);

  setState(() {
    number_1 = "${(number / 100)}";
    operand = "";
    number_2 = "";
  });
}

// clear all output
void clearAll() {
  setState(() {
    number_1 = "";
    operand = "";
    number_2 = "";
  });
}

// delete
void delete() {
  if (number_2.isNotEmpty) {
    //12323 => 1232
    number_2 = number_2.substring(0, number_2.length - 1);
  } else if (operand.isNotEmpty) {
    operand = "";
  } else if (number_1.isNotEmpty) {
    number_1 = number_1.substring(0, number_1.length - 1);
  }

  setState(() {});
}

// append value to the end
void appendValue(String value) {
  // number_1 operand number_2
  // if is operand and not .
  if (value != Btn.dot && int.tryParse(value) == null) {
    //operand pressed
    if (operand.isNotEmpty && number_2.isNotEmpty) {
      // to do calculate the equation before assigning new operand
      calculate();
    }
    operand = value;
  }
  // assign value to number_1 variable
  else if (number_1.isEmpty || operand.isEmpty) {
    // check if value is '.'
    if (value == Btn.dot && number_1.contains(Btn.dot)) return;
    if (value == Btn.dot &&
        (number_1.isEmpty || number_1 == Btn.n0 || number_1 == Btn.n00)) {
      value = "0.";
    }
    number_1 += value;
  }
  // assign value to number_2 variable
  else if (number_2.isEmpty || operand.isNotEmpty) {
    // check if value is '.'
    if (value == Btn.dot && number_2.contains(Btn.dot)) return;
    if (value == Btn.dot &&
        (number_1.isEmpty || number_2 == Btn.n0 || number_2 == Btn.n00)) {
      value = "0.";
    }
    number_2 += value;
  }

  setState(() {});
}}

Color getBtnColor(value) {
  return [
    Btn.clr,
    Btn.del,
    Btn.per,
    Btn.divide,
    Btn.multiply,
    Btn.subtract,
    Btn.add
  ].contains(value)
      ? const Color(0xFFfffdd7)
      : [Btn.calculate].contains(value)
      ? const Color(0xFFff7100)
      : const Color(0xFFe8e8e8);
}
