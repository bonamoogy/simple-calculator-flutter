import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ipt1 = new TextEditingController(),
      _ipt2 = new TextEditingController(),
      _ipt3 = new TextEditingController();

  List<MControl> _controllers = [];
  List<String> _operators = ['+', '-', 'x', '/'];
  String _result = '';

  @override
  void initState() {
    _controllers = [
      MControl(controller: _ipt1, isActive: true),
      MControl(controller: _ipt2, isActive: true),
      MControl(controller: _ipt3, isActive: true),
    ];
    super.initState();
  }

  void _onPressed(String op) {
    final isActivate = _controllers.where((el) => el.isActive).toList();
    if (isActivate.length > 1) {
      int res = 0;
      final getValues = isActivate.map((e) {
        if (e.controller.text.isNotEmpty)
          return int.parse(e.controller.text);
        else
          return 0;
      }).toList();
      res = getValues[0];
      for (int i = 0; i < getValues.length - 1; i++) {
        switch (op) {
          case '+':
            res += getValues[i + 1];
            break;
          case '-':
            res -= getValues[i + 1];
            break;
          case 'x':
            res *= getValues[i + 1];
            break;
          case '/':
            res = (res / getValues[i + 1]).round();
            break;
        }
      }
      _result = res.toString();
      setState(() {});
      return;
    }

    // show err
    _showError();
  }

  void _showError() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Mininum active input is more than two'),
            titleTextStyle: TextStyle(
              color: Colors.blueGrey,
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calculator'),
        elevation: .0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: _controllers.map((el) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              enabled: el.isActive,
                              keyboardType: TextInputType.number,
                              controller: el.controller,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 5.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Checkbox(
                            value: el.isActive,
                            onChanged: (val) {
                              setState(() {
                                el.isActive = val;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.blue,
                  height: 4,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _operators.map((op) {
                    return Container(
                      margin: const EdgeInsets.only(
                        right: 10,
                      ),
                      child: FloatingActionButton(
                        elevation: .0,
                        onPressed: () => _onPressed(op),
                        child: Text(
                          op,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.blue,
                  height: 4,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Result :',
                      style: _styleResult,
                    ),
                    Spacer(),
                    Text(
                      _result,
                      style: _styleResult,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle get _styleResult => TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      );
}

class MControl {
  final TextEditingController controller;
  bool isActive;

  MControl({
    @required this.controller,
    @required this.isActive,
  });
}
