import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'logic.dart';

class Screen extends StatefulWidget {
  final title;

  const Screen({Key? key, this.title}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  inputFormattin() {
    if (widget.title == 'CAESAR CIPHER' || widget.title == 'VIGENERE CIPHER') {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
      ];
    }
  }

  keyFormattin() {
    if (widget.title == 'CAESAR CIPHER' ||
        widget.title == "RAIL FENCE CIPHER") {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
      ];
    } else if (widget.title == 'VIGENERE CIPHER' ||
        widget.title == 'KEYWORD CIPHER') {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
      ];
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController inputController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  TextEditingController additionalParam = TextEditingController();

  Logic logic = Logic();
  String result = '';

  int maxChar = -1;
  String all = '';
  List decryptedList = [];
  bool checked = false;
  bool fullVigenere = false;
  bool encryption = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.height * 0.02,
                      right: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: TextFormField(
                      maxLines: null,
                      controller: inputController,
                      inputFormatters: inputFormattin(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          hintText: 'Text'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.height * 0.02,
                      right: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: TextFormField(
                      maxLines: null,
                      controller: keyController,
                      inputFormatters: inputFormattin(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          hintText: 'Key'),
                    ),
                  ),
                  widget.title == 'Electronic Code Book (ECB)' ||
                          widget.title == 'Cipher Block Chaining (CBC)'
                      ? Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: TextFormField(
                            maxLines: null,
                            controller: additionalParam,
                            inputFormatters: inputFormattin(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                hintText: 'Block Length'),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                FocusManager.instance.primaryFocus!.unfocus();
                                if (formKey.currentState!.validate()) {
                                  /// Stream Cipher Function
                                  if (widget.title == 'Stream Cipher') {
                                    setState(() {
                                      result = logic.stream(
                                          inputController.text,
                                          keyController.text);
                                    });
                                  } else if (widget.title ==
                                      'Electronic Code Book (ECB)') {
                                    print('ecb');
                                    setState(() {
                                      result = logic.ecb(
                                          inputController.text,
                                          keyController.text,
                                          int.parse(additionalParam.text),
                                          'ecb');
                                    });
                                  } else if (widget.title ==
                                      'Cipher Block Chaining (CBC)') {
                                    setState(() {
                                      result = logic.ecb(
                                          inputController.text,
                                          keyController.text,
                                          int.parse(additionalParam.text),
                                          'cbc');
                                    });
                                  } else {
                                    print('null');
                                  }
                                }
                              },
                              icon: const Icon(Icons.lock_outline),
                              label: const Text('ENCRYPT'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                FocusManager.instance.primaryFocus!.unfocus();
                                if (formKey.currentState!.validate()) {
                                  /// todo encrypt
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.lock_open_rounded),
                              label: const Text('DECRYPT'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: const ListTile(
                        title: Text(
                      'OUTPUT (HEX)',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.height * 0.02,
                      right: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        constraints: const BoxConstraints.expand(
                          width: 500,
                          height: 100,
                        ),
                        child: result == ''
                            ? const SelectableText('Output Will Shown Here')
                            : SelectableText(result)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
