// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../../domain/models/medi_user.dart';
//
// class UserDoc {
//   final String id;
//   final MediUser data;
//   const UserDoc({required this.id, required this.data});
// }
//
// Map<String, dynamic> _userToMap(MediUser u, {bool includeCreatedAt = false}) => {
//   'name': u.name,
//   'email': u.email,
//   'birthDate': u.birthDate,
//   'password': u.password,
//   if (includeCreatedAt) 'createdAt': FieldValue.serverTimestamp(),
//   'updatedAt': FieldValue.serverTimestamp(),
// };
//
// MediUser _userFromMap(Map<String, dynamic> map) => MediUser(
//   name: map['name'] as String? ?? '',
//   email: map['email'] as String? ?? '',
//   birthDate: map['birthDate'] as String? ?? '',
//   password: map['password'] as String? ?? '',
// );
