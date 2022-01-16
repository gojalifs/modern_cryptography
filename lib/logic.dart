import 'dart:io';
import 'dart:math';
import 'package:optimus_prime/optimus_prime.dart';
import 'package:cryptography/cryptography.dart';

class Logic {
  /// Stream Cipher
  String stream(String text, String key) {
    var string = text;
    var keys = key.codeUnits;
    var binstring = string.codeUnits
        .map((x) => x.toRadixString(2).padLeft(8, '0'))
        .join('');
    var newstring = string.codeUnits;
    List hasil = [];
    String result = '';

    print('satu ${binstring.split(' ')}');
    print(binstring);
    print(string.codeUnits);
    stdout.write('hasil xor ');
    for (int i = 0, j = 0; i < string.length; i++) {
      stdout.write('${newstring[i] ^ keys[j]} ');
      hasil.add(newstring[i] ^ keys[j]);
      result += String.fromCharCode(newstring[i] ^ keys[j]);
      j = (j + 1) % keys.length;
    }

    return result.codeUnits.map((e) => e.toRadixString(16)).join(' ');
  }

  /// ECB
  String ecb(String text, String keys, int blockLength, String type) {
    var string = text;
    var key = keys.codeUnits;
    var block = blockLength;
    String binstring = string.codeUnits
        .map((x) => x.toRadixString(2).padLeft(8, '0'))
        .join('');
    List binstringlist = binstring.split('');

    List<String> newHasil = [];
    List hasil = [];
    String result = '';

    if (type == 'cbc') {
      binstringlist.add(binstringlist.removeAt(0));
      binstring = binstringlist.join('');
    }

    for (var i = 1; i < binstring.length; i++) {
      if (binstring.length % block != 0) {
        binstring += '0';
      } else {
        break;
      }
    }

    /// make binary from string

    for (var i = 0; i < binstring.length; i += block) {
      if (i == binstring.length) {
        break;
      }
      hasil.add(binstring.substring(i, i + block));
    }

    if (type == 'ecb') {
      /// encrypt binary
      for (var i = 0, j = 0; i < hasil.length; i++) {
        int a = int.parse(hasil[i], radix: 2) ^ key[j];
        newHasil.add(a.toRadixString(2).padLeft(8, '0'));
        j = (j + 1) % key.length;
      }
    } else {
      int a = 0, b;

      for (var i = 0, j = 0; i < hasil.length; i++) {
        /// initialitation IV with first key
        if (i == 0) {
          a = (int.parse(hasil[i], radix: 2) ^ key[0]) ^ key[j];
          newHasil.add(a.toRadixString(2).padLeft(8, '0'));
          j = (j + 1) % key.length;

          continue;
        }
        b = (int.parse(hasil[i], radix: 2) ^ a) ^ key[j];
        newHasil.add(b.toRadixString(2).padLeft(8, '0'));
        j = (j + 1) % key.length;
      }
    }

    List newResult = [];
    String anu = newHasil.join();
    newResult = anu.split('');
    newResult.add(newResult.removeAt(0));
    List hasilnya = [];
    anu = newResult.join('');
    for (var i = 0; i < anu.length; i += block) {
      hasilnya.add(anu.substring(i, i + block));
    }
    for (var i = 0; i < hasilnya.length; i++) {
      result += String.fromCharCode(int.parse(hasilnya[i], radix: 2));
    }

    return result.codeUnits.map((e) => e.toRadixString(16)).join(' ');
  }

  /// CFB
  String cfb(String text, String keys, int blockLength, String type) {
    // Ci = Pi ^ MSBm(Ek(Xi))
    String result = '';
    String a = ecb(text, keys, blockLength, 'cbc');
    List z = a.split(' ').map((e) => e.toString().padLeft(2, '0')).toList();
    print(z);
    List<int> queue = [];
    for (var i = 0, j = 0; i < text.length; i++) {
      print(z[j]);
      print('object ${int.parse(z[j], radix: 16) ^ text.codeUnitAt(i)}');
      if (i == 0) {
        print('a');
        var x = ecb(String.fromCharCode(int.parse(z[j], radix: 16)), keys,
            blockLength, 'cbc');
        queue.add(int.parse(x, radix: 16) ^ text.codeUnitAt(i));
        continue;
      }
      print('queue for ${queue[j]} $i');
      // queue.add(queue[j] ^ text.codeUnitAt(i));
      if (type == 'cfb') {
        queue.add(int.parse(
                ecb(String.fromCharCode(queue[j]), keys, blockLength, 'cbc'),
                radix: 16) ^
            text.codeUnitAt(i));
      } else {
        queue.add(int.parse(
                ecb(String.fromCharCode(int.parse(z[j], radix: 16)), keys,
                    blockLength, 'cbc'),
                radix: 16) ^
            text.codeUnitAt(i));
      }
      j = (j + 1) % queue.length;
    }
    print('queue ${queue[0]}');
    var b;

    for (var i = 0; i < queue.length; i++) {
      result += queue[i].toRadixString(16);
    }
    print(result);
    return result;
  }

  /// Counter Mode CTR
  String ctr(String text, String key, int blockLength) {
    String result = '';
    var nonce = key[0];
    String blockEncrypt = ecb(text, key, blockLength, 'ecb');
    List encryptBlock = [];

    for (var i = 0; i < text.length; i++) {
      /// XOR the nonce and counter
      int xor = int.parse(nonce, radix: 16) ^ i;

      /// encrypt the header and key, i use ecb encryption for this
      String eb = ecb(xor.toRadixString(16), key, blockLength, 'ecb');

      String cipher =
          (int.parse(eb, radix: 16) ^ text.codeUnitAt(i)).toRadixString(16);

      result += cipher;
    }

    return result;
  }

  String rsa(String text, int p, int q) {
    String result = '';
    int n = p * q;
    int m = (p - 1) * (q - 1);
    int e = 0;
    int d = 0;
    List cipher = [];

    // if (a.coprimeWith(m) == false) {
    //   while (a.coprimeWith(m) == false) {
    //     var a = Random().nextInt(m);
    //     e = a;
    //   }
    // } else {
    //   e = a;
    // }
    /// find number that coprime with m
    for (e = 1; e < m; e++) {
      if (e.coprimeWith(m)) {
        break;
      }
    }

    /// find d number that e*d % m = 1
    for (d = 1; d < m; d++) {
      if ((e * d) % m == 1) {
        break;
      }
    }
    print('e $e d $d');
    print('kunci publik = (e, n) yaitu ($e, $n)');
    print('kunci privat = (d, n) yaitu ($d, $n)');

    /// encryption program
    for (var i = 0; i < text.length; i++) {
      // C = m^e mod n
      int z = pow(text.codeUnitAt(i), e) % n as int;
      print(z);
      result += z.toRadixString(16);
    }

    return result;
  }

  // String diffie(int g, int n) {
  //   String result = '';
  //   // int x = Random().nextInt(n) + 1;
  //   int x = 124;
  //   var y = Random().nextInt(n) + 1;
  //   // int X = g^^x % n
  //   int X = pow(g, x) % n as int;
  //   // Y = g^^y mod n
  //   int Y = pow(g, y).toInt() % n;
  //   // K = Y^^x mod n
  //   int key = pow(Y, x) % n as int;
  //   print('g $g n $n x $x X $X y $y Y $Y key $key');
  //   return key.toString();
  // }

  Future<String> diffie() async {
    final algorithm = Cryptography.instance.x25519();

    // Alice chooses her key pair
    final aliceKeyPair = await algorithm.newKeyPair();

    // Alice knows Bob's public key
    final bobKeyPair = await algorithm.newKeyPair();
    final bobPublicKey = await bobKeyPair.extractPublicKey();

    // Alice calculates the shared secret.
    final sharedSecret = await algorithm.sharedSecretKey(
      keyPair: aliceKeyPair,
      remotePublicKey: bobPublicKey,
    );
    final sharedSecretBytes = await aliceKeyPair.extractPrivateKeyBytes();
    print('Shared secret: ${sharedSecretBytes}');
    return sharedSecretBytes.join(' ');
  }

  // String elgamal(){}
}
