import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_medi/storage/models/image_custom_info.dart';
import 'package:flutter_app_medi/storage/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  String? urlPhoto;
  List<ImageCustomInfo> listFiles = [];

  @override
  void initState() {
    super.initState();
    reload();
  }

  final StorageService _storageService = StorageService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Foto de Perfil'),
        actions: [
          IconButton(onPressed: uploadImage, icon: Icon(Icons.upload)),
          IconButton(onPressed: reload, icon: Icon(Icons.refresh)),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(32),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            (urlPhoto != null)
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(64),
                  child: Image.network(
                    urlPhoto!,
                    height: 128,
                    width: 128,
                    fit: BoxFit.cover,
                  ),
                )
                : CircleAvatar(radius: 64, child: Icon(Icons.person)),
            Padding(padding: const EdgeInsets.all(16.0), child: Divider()),
            Text(
              'Histórico de imagens',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(listFiles.length, (index) {
                    ImageCustomInfo imageInfo = listFiles[index];
                    return ListTile(
                      onTap: () {
                        selectedImage(imageInfo);
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          imageInfo.urlDownload,
                          height: 64,
                          width: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(imageInfo.name, style: TextStyle(fontSize: 12)),
                      subtitle: Text(
                        imageInfo.size,
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          deleteImage(imageInfo);
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadImage() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(
          source: ImageSource.gallery,
          maxHeight: 2000,
          maxWidth: 2000,
          imageQuality: 50,
        )
        .then((XFile? image) {
          if (image != null) {
            _storageService
                .upload(
                  file: File(image.path),
                  fileName: DateTime.now().toString(),
                )
                .then((String urlDownload) {
                  setState(() {
                    urlPhoto = urlDownload;
                    reload();
                  });
                });
            showSnackBar(context: context, mensagem: "upload realizado com sucesso", isErro: false);
          } else {
            showSnackBar(
              context: context,
              mensagem: 'Nenhuma imagem selecionada',
            );
          }
        });
  }

  reload() {
    setState(() {
      urlPhoto = _firebaseAuth.currentUser!.photoURL;
    });
    _storageService.listAllFiles().then((List<ImageCustomInfo> listFilesInfo) {
      setState(() {
        listFiles = listFilesInfo;
      });
    });
  }

  selectedImage(ImageCustomInfo imageInfo) {
    _firebaseAuth.currentUser!.updatePhotoURL(imageInfo.urlDownload);
    setState(() {
      urlPhoto = imageInfo.urlDownload;
    });
  }

  deleteImage(ImageCustomInfo imageInfo) {
    _storageService.deleteByReference(imageInfo: imageInfo).then((value) {
      if (urlPhoto == imageInfo.urlDownload) {
        urlPhoto = null;
      }
      reload();
    });
  }
}

showSnackBar({
  required BuildContext context,
  required String mensagem,
  bool isErro = true,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(mensagem),
    backgroundColor: (isErro) ? Colors.red : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
