import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recon_loc_caract_faces/detection_settings_page.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reconhecimento e Localização de Características Faciais',
      home: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Selecione imagem do celular'),
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  print(image.path);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog.fullscreen(
                      child: DetectionSettingsPage(imagePath: image.path),
                    ),
                  );
                }
              },
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
