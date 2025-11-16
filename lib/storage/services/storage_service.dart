import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app_medi/storage/models/image_custom_info.dart';

class StorageService {
  String pathService = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future<String> upload({required File file, required String fileName}) async {
    await _firebaseStorage.ref("$pathService/$fileName.png").putFile(file);

    String url =  await _firebaseStorage
        .ref("$pathService/$fileName.png")
        .getDownloadURL();
    await _firebaseAuth.currentUser!.updatePhotoURL(url);
    return url;
  }

  Future<String> getDownloadUrlByFileName({required String fileName}) async {
    return await _firebaseStorage
        .ref("$pathService/$fileName.png")
        .getDownloadURL();
  }

  Future<List<ImageCustomInfo>> listAllFiles() async {
    ListResult result = await _firebaseStorage.ref(pathService).listAll();
    List<Reference> listReference = result.items;
    List<ImageCustomInfo> listFiles = [];
    for (var reference in listReference) {
      String urlDownload = await reference.getDownloadURL();
      String name = reference.name;
      FullMetadata metadados = await reference.getMetadata();
      int? size = metadados.size;
      String sizeString = "Sem informações de tamanho";
      if (size != null) {
        sizeString = "${size / 1000} kb";
      }
      listFiles.add(
        ImageCustomInfo(
          urlDownload: urlDownload,
          name: name,
          size: sizeString,
          ref: reference,
        ),
      );
    }
    return listFiles;
  }

  Future<void> deleteByReference({required ImageCustomInfo imageInfo}) async {
    if(_firebaseAuth.currentUser!.photoURL != null){
      if(_firebaseAuth.currentUser!.photoURL! == imageInfo.urlDownload){
        await _firebaseAuth.currentUser!.updatePhotoURL(null);
      }
    }
   return await imageInfo.ref.delete();
  }
}
