import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String fname;
  final String lname;
  final String phoneNumber;
  final String? photoUrl;
  final String address;
  final String about;
  final String role;
  final List assistants;

  const User(
      {required this.role,
      required this.assistants,
      required this.photoUrl,
      required this.uid,
      required this.about,
      required this.lname,
      required this.address,
      required this.phoneNumber,
      required this.fname});

  Map<String, dynamic> toJson() => {
        'address': address,
        'uid': uid,
        "about": about,
        "photoUrl": photoUrl,
        "assistants": assistants,
        'firstName': fname,
        'lastName': lname,
        'phoneNumber': phoneNumber,
        "role": role
      };
  static User fromSnap(DocumentSnapshot snap, String userid) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      about: snapshot['about'],
      assistants: snapshot['assistants'],
      address: snapshot['address'],
      fname: snapshot['firstName'],
      lname: snapshot['lastName'],
      phoneNumber: snapshot['phoneNumber'],
      role: snapshot['role'],
      uid: userid,
      photoUrl: snapshot['photoUrl'] == '' ? null : snapshot['photoUrl'],
    );
  }
}
