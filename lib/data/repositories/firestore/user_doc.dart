import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/models/user.dart';

class UserDoc {
  final String id;
  final User data;
  const UserDoc({required this.id, required this.data});
}

Map<String, dynamic> _userToMap(User u, {bool includeCreatedAt = false}) => {
  'name': u.name,
  'email': u.email,
  'birthDate': u.birthDate,
  'password': u.password,
  if (includeCreatedAt) 'createdAt': FieldValue.serverTimestamp(),
  'updatedAt': FieldValue.serverTimestamp(),
};

User _userFromMap(Map<String, dynamic> map) => User(
  name: map['name'] as String? ?? '',
  email: map['email'] as String? ?? '',
  birthDate: map['birthDate'] as String? ?? '',
  password: map['password'] as String? ?? '',
);