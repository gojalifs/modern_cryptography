import 'dart:math';

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
  textFormattin() {
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
  final columnKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  TextEditingController additionalParam = TextEditingController();
  TextEditingController nController = TextEditingController();
  TextEditingController gController = TextEditingController();
  TextEditingController xController = TextEditingController();
  TextEditingController yController = TextEditingController();
  TextEditingController zController = TextEditingController();

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
                  widget.title == 'Diffie-Hellman' || widget.title == 'ElGamal'
                      ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02,
                                left: MediaQuery.of(context).size.height * 0.02,
                                right:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: const Text(
                                  'Ini adalah algoritma pertukaran kunci Diffie-Hellman.'
                                  'Kunci yang dihasilkan bisa digunakan untuk melakukan'
                                  ' enkripsi dengan algoritma lain.'),
                            ),
                            Row(
                              children: [
                                ///g number
                                Flexible(
                                  flex: 1,
                                  child: CustomInputField(
                                      controller: nController,
                                      widget: widget,
                                      formatter: textFormattin(),
                                      label: 'bilangan prima n'),
                                ),

                                /// n number
                                Flexible(
                                  flex: 1,
                                  child: CustomInputField(
                                      controller: gController,
                                      widget: widget,
                                      formatter: textFormattin(),
                                      label: 'g akar primitif dari n'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ///g number
                                Flexible(
                                  flex: 1,
                                  child: CustomInputField(
                                      controller: xController,
                                      widget: widget,
                                      formatter: textFormattin(),
                                      label: 'kunci privat pengirim'),
                                ),

                                /// n number
                                Flexible(
                                  flex: 1,
                                  child: CustomInputField(
                                      controller: zController,
                                      widget: widget,
                                      formatter: textFormattin(),
                                      label: 'kunci publik y penerima'),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),
                  widget.title == 'ElGamal'
                      ? ElevatedButton.icon(
                          onPressed: () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            // if (columnKey.currentState!.validate()) {
                            int a = pow(int.parse(gController.text),
                                    int.parse(xController.text)) %
                                int.parse(nController.text) as int;
                            setState(() {
                              zController.text = a.toString();
                            });
                            // }
                          },
                          icon: const Icon(Icons.search),
                          label: const Text('Cari Kunci Publik y anda'),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.amber,
                              textStyle: const TextStyle(
                                color: Colors.white,
                              )),
                        )
                      : const SizedBox(),
                  widget.title == 'Diffie-Hellman'
                      ? const SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: TextFormField(
                            maxLines: null,
                            controller: textController,
                            inputFormatters: textFormattin(),
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
                  widget.title == 'Diffie-Hellman' || widget.title == 'ElGamal'
                      ? const SizedBox()
                      : CustomInputField(
                          controller: keyController,
                          widget: widget,
                          formatter: textFormattin(),
                          label: widget.title == 'RSA' ? 'p' : 'Key'),
                  widget.title == 'Electronic Code Book (ECB)' ||
                          widget.title == 'Cipher Block Chaining (CBC)' ||
                          widget.title == 'Cipher Feedback' ||
                          widget.title == 'Output Feedback (OFB)' ||
                          widget.title == 'Counter Mode' ||
                          widget.title == 'RSA'
                      ? Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: TextFormField(
                            maxLines: null,
                            controller: additionalParam,
                            inputFormatters: textFormattin(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                hintText: widget.title == 'RSA'
                                    ? 'q'
                                    : 'Block Length'),
                          ),
                        )
                      : const SizedBox(),
                  widget.title == 'RSA'
                      ? Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  'This RSA Algorythm use same key both sender and receiver')),
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
                                      result = logic.stream(textController.text,
                                          keyController.text);
                                    });
                                  } else if (widget.title ==
                                      'Electronic Code Book (ECB)') {
                                    print('ecb');
                                    setState(() {
                                      result = logic.ecb(
                                          textController.text,
                                          keyController.text,
                                          int.parse(additionalParam.text),
                                          'ecb');
                                    });
                                  } else if (widget.title ==
                                      'Cipher Block Chaining (CBC)') {
                                    setState(() {
                                      result = logic.ecb(
                                          textController.text,
                                          keyController.text,
                                          int.parse(additionalParam.text),
                                          'cbc');
                                    });
                                  } else if (widget.title ==
                                      'Cipher Feedback') {
                                    setState(() {
                                      result = logic.cfb(
                                          textController.text,
                                          keyController.text,
                                          int.parse(additionalParam.text),
                                          'cfb');
                                    });
                                  } else if (widget.title ==
                                      'Output Feedback (OFB)') {
                                    setState(() {
                                      result = logic.cfb(
                                          textController.text,
                                          keyController.text,
                                          int.parse(additionalParam.text),
                                          'ofb');
                                    });
                                  } else if (widget.title == 'Counter Mode') {
                                    setState(() {
                                      result = logic.ctr(
                                          textController.text,
                                          keyController.text,
                                          int.parse(additionalParam.text));
                                    });
                                  } else if (widget.title == 'RSA') {
                                    setState(() {
                                      result = logic.rsa(
                                          textController.text,
                                          int.parse(keyController.text),
                                          int.parse(additionalParam.text));
                                    });
                                  } else if (widget.title == 'Diffie-Hellman') {
                                    setState(() {
                                      result = logic.diffieElgamal(
                                        textController.text,
                                        'diffie',
                                        int.parse(gController.text),
                                        int.parse(nController.text),
                                        int.parse(xController.text),
                                        zController.text,
                                        y: int.parse(yController.text),
                                      );
                                    });
                                  } else if (widget.title == 'ElGamal') {
                                    setState(() {
                                      result = logic.diffieElgamal(
                                        textController.text,
                                        'elgamal',
                                        int.parse(gController.text),
                                        int.parse(nController.text),
                                        int.parse(xController.text),
                                        zController.text,
                                      );
                                    });
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
                    child: ListTile(
                        title: Text(
                      widget.title == 'Diffie-Hellman'
                          ? 'OUTPUT (INT)'
                          : 'OUTPUT (HEX)',
                      style: const TextStyle(fontSize: 30),
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

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    Key? key,
    required this.controller,
    required this.widget,
    required this.formatter,
    required this.label,
  }) : super(key: key);

  final TextEditingController controller;
  final Screen widget;
  final List<TextInputFormatter>? formatter;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.02,
        left: MediaQuery.of(context).size.height * 0.02,
        right: MediaQuery.of(context).size.height * 0.02,
      ),
      child: TextFormField(
        maxLines: null,
        controller: controller,
        inputFormatters: formatter,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Required';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          label: Text(label),
          suffixIcon: label == 'g akar primitif dari n'
              ? IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              : null,
        ),
      ),
    );
  }
}
