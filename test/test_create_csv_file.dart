import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDirectory = await getApplicationDocumentsDirectory();
  //final downloadsDirectory = await getDownloadsDirectory();

  List<List<String>> dados = [
    ['Nome', 'Idade', 'Sexo'],
    ['João', '25', 'M'],
    ['Maria', '22', 'F'],
    ['José', '30', 'M'],
  ];

  String csv = const ListToCsvConverter().convert(dados);
  File f = File('${appDirectory.path}/filename.csv');
  f.writeAsString(csv);

  final result = await Share.shareXFiles(
      [XFile('${appDirectory.path}/filename.csv')],
      text: 'Teste CSV');

  if (result.status == ShareResultStatus.success) {
    print('Comparilhado com sucesso');
  }
}
