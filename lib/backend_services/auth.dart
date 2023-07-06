import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        saveUserDetails(
            userId: user.uid,
            role: role,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            address: address);

        // Send OTP to the provided phone number
        sendOTP(phoneNumber);

        // Perform any other registration tasks you need
      }

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
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
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'address': address,
        'role': role,
      });
      res = "sucess";
    } catch (error) {
      res = "error has occured";
    }
    print(res);
    return res;

    // Set the data for the user document
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
}
