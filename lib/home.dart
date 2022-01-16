import 'package:flutter/material.dart';
import 'screen.dart';

final ciphers = [
  'Stream Cipher',
  'Electronic Code Book (ECB)',
  'Cipher Block Chaining (CBC)',
  'Cipher Feedback',
  'Output Feedback (OFB)',
  'Counter Mode',
  'RSA',
  'Diffie-Hellman',
  'ElGamal',
  'Knapsack',
  'MD5'
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('CIPHERS ALGORYTHM',
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: ciphers.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.015,
                  left: MediaQuery.of(context).size.height * 0.015,
                  right: MediaQuery.of(context).size.height * 0.015,
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Screen(title: ciphers[index])));
                  },
                  leading: const Icon(Icons.lock, color: Colors.black),
                  title: Text(ciphers[index]),
                ),
              );
            }));
  }
}
