import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:let_com/backend_services/storage.dart';
import 'package:let_com/constants.dart';
import '../model/User.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in anonymously
  Future<User?> signInAnon() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      User? user = credential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot, currentUser.uid);
  }

  // Register with email, password, first name, last name, phone number, and address. Send OTP to the entered phone number
  Future<User?> registerWithEmailAndPassword(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String role,
      required String phoneNumber,
      required String address}) async {
    try {
      // 1. Create user with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;

      if (user != null) {
        // Save user details (firstName, lastName, phoneNumber, address) to Firestore
       await  saveUserDetails(
            userId: user.uid,
            role: role,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            address: address);

        // Send OTP to the provided phone number
        // sendOTP(phoneNumber);

        // Perform any other registration tasks you need
      }

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // fetch single user
  Future<Map> FetchUser({required String UserId}) async {
    var userdata = {};
    try {
      var usersnap = await _firestore.collection('users').doc(UserId).get();
      userdata = usersnap.data()!;
    } catch (err) {}
    return userdata;
  }

  // Save user details to Firestore
  Future<String> saveUserDetails(
      {required String userId,
      required String firstName,
      required String lastName,
      required String role,
      required String phoneNumber,
      required String address}) async {
    // Create a reference to the users collection in Firestore
    String res = "none";
    try {
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');

      // Create a document for the user using their userId
      DocumentReference userDocRef = usersRef.doc(userId);
      await userDocRef.set({
        'firstName': firstName,
        "uid": userId,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'address': address,
        'role': role,
        'photoUrl': '',
        'assistants': [],
        'about':
            role == 'impaired' ? abouts[Random().nextInt(abouts.length)] : ''
      });
      res = "sucess";
    } catch (error) {
      res = "error has occured";
    }
    print(res);
    return res;

    // Set the data for the user document
  }

  Future<String> setProfileImage(
      {required String uid,
      required String name,
      required Uint8List file}) async {
    String res = '';
    try {
      String Url = await StorageMethods().uploadImage(name, file, false);

      await _firestore.collection("users").doc(uid).update({"photoUrl": Url});
      res = 'success';
    } catch (e) {
      res = 'fail';
    }
    print(res);
    return res;
  }

  // Send OTP to the provided email address
  Future<void> sendOTP(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('OTP sent successfully to $email');
    } catch (e) {
      print('Failed to send OTP: $e');
    }
  }

  // Verify the OTP entered by the user
  Future<UserCredential?> verifyOTP(String email, String otp) async {
    try {
      UserCredential credential = await _auth.signInWithEmailLink(
        email: email,
        emailLink: 'https://www.example.com/?otp=$otp',
      );
      print('OTP verified successfully for $email');
      return credential;
    } catch (e) {
      print('Failed to verify OTP: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }

  Future<String> appointAssistance(
      String uid,
      String auid,
      model.User assistants,
      model.User impaire,
      String date,
      String time,
      String desc) async {
    String res = '';
    try {
      await _firestore.collection("users").doc(uid).update({
        "assistants": FieldValue.arrayUnion([auid])
      });
      String cid = auid + uid;
      await _firestore.collection("request").doc(cid).set({
        ...assistants.toJson(),
        "impairedId": uid,
        "photoUrl": assistants.photoUrl == null ? "" : assistants.photoUrl,
        "impairedaddress": impaire.address,
        "impairedFname": impaire.fname,
        "impairedlname": impaire.lname,
        "impairedPhoto": impaire.photoUrl == null ? "" : impaire.photoUrl,
        "accepted": false,
        'declined': false,
        "scheduledDate": date,
        "Time": time,
        "desc": desc
      });
      res = 'success';
    } catch (e) {
      print('Failed: $e');
    }
    print(res);
    return res;
  }

  Future<String> declineRequest(
    String uid,
    String pid,
  ) async {
    String res = '';
    try {
      await _firestore.collection("users").doc(pid).update({
        "assistants": FieldValue.arrayRemove([uid])
      });
      String cid = uid + pid;
      await _firestore
          .collection("request")
          .doc(cid)
          .update({"declined": true});
      res = 'success';
    } catch (e) {
      print('Failed: $e');
    }
    print(res);
    return res;
  }

  Future<String> acceptRequest(
    String uid,
    String pid,
  ) async {
    String res = '';
    try {
      String cid = uid + pid;
      await _firestore
          .collection("request")
          .doc(cid)
          .update({"declined": false, "accepted": true});
      res = 'success';
    } catch (e) {
      print('Failed: $e');
    }
    print(res);
    return res;
  }
}
