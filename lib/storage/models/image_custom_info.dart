import 'package:firebase_storage/firebase_storage.dart';

class ImageCustomInfo {
  String urlDownload;
  String name;
  String size;
  Reference ref;

  ImageCustomInfo({
    required this.urlDownload,
    required this.name,
    required this.size,
    required this.ref,
});




}