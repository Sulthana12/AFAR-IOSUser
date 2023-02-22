import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String firstName;
  final String lastName;
  final String location;
  final String email;
  final String uid;
  final String photoUrl;
  final String pincode;

  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.email,
    required this.photoUrl,
    required this.pincode,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      firstName: snapshot["firstname"],
      lastName: snapshot["lastname"],
      uid: snapshot["uid"],
      location: snapshot["location"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      pincode: snapshot["pincode"],
    );
  }

  Map<String, dynamic> toJson() => {
    "firstname": firstName,
    "lastname": lastName,
    "uid": uid,
    "location": location,
    "email": email,
    "photoUrl": photoUrl,
    "pincode": pincode,
  };
}
