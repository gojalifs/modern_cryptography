import 'dart:io';

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
    print('ab $binstringlist');

    List<String> newHasil = [];
    List hasil = [];

    if (type == 'cbc') {
      binstringlist.add(binstringlist.removeAt(0));
      binstring = binstringlist.join('');
    }

    print('hasil $binstringlist');
    String result = '';

    for (var i = 1; i < binstring.length; i++) {
      if (binstring.length % block != 0) {
        binstring += '0';
      } else {
        break;
      }
    }

    /// make binary from string
    print('new biner ${binstring}');
    for (var i = 0; i < binstring.length; i += block) {
      if (i == binstring.length) {
        break;
      }
      hasil.add(binstring.substring(i, i + block));
    }

    print('plain biner ${hasil}');
    if (type == 'ecb') {
      /// encrypt binary
      for (var i = 0, j = 0; i < hasil.length; i++) {
        int a = int.parse(hasil[i], radix: 2) ^ key[j];
        newHasil.add(a.toRadixString(2).padLeft(8, '0'));
        j = (j + 1) % key.length;
      }

      for (var i = 0; i < newHasil.length; i++) {
        // result += String.fromCharCode(newHasil[i]);
        // newHasil[i].toRadixString(2).padLeft(8, '0');
      }
    }
    print('new result ${newHasil.join('')}');
    List newResult = [];
    String anu = newHasil.join();
    newResult = anu.split('');
    newResult.add(newResult.removeAt(0));
    print('anu ${int.parse(anu, radix: 2)}');
    // newResult = result.codeUnits
    //     .map((e) => e.toRadixString(2).padLeft(8, '0'))
    //     .toList();
    print('newR $newResult');
    List hasilnya = [];
    anu = newResult.join('');
    for (var i = 0; i < anu.length; i += block) {
      hasilnya.add(anu.substring(i, i + block));
    }
    for (var i = 0; i < hasilnya.length; i++) {
      result += String.fromCharCode(int.parse(hasilnya[i], radix: 2));
    }

    // String hasilEncrypt = hasilnya.m

    print('newres ${hasilnya}');

    return result.codeUnits.map((e) => e.toRadixString(16)).join(' ');
  }
}
