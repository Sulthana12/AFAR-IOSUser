import 'dart:typed_data';

import 'package:afar_cabs_user/components/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:afar_cabs_user/sign_in_up_page/model/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // signup user
  Future<String> signUpUser({
    required String firstname,
    required String lastname,
    required String location,
    required String email,
    required String password,
    required Uint8List? file,
    required String pincode,
  }) async {
    String res = "Some error occurred";
    try {
      if (firstname.isNotEmpty ||
          lastname.isNotEmpty ||
          location.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          pincode.isNotEmpty) {
        // register user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(credential.user!.uid);

        String photoUrl = file != null
            ? await StorageMethods().uploadImageToStorage('profilePics', file)
            : "";

        model.User user = model.User(
            firstName: firstname,
            lastName: lastname,
            uid: credential.user!.uid,
            location: location,
            email: email,
            photoUrl: photoUrl,
            pincode: pincode);

        // add user to our database
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());
        res = "success";

        //Get.find<UserController>().user = user;
        //Get.back();
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  // login user
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "An error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  // sign out user
  Future<void> signOut() async {
    // Get.find<UserController>().clear();
    await _auth.signOut();
  }
}
