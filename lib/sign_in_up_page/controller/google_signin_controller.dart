import 'package:afar_cabs_user/home_page/view/home_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  RxBool isLoading = false.obs;

  loginWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final authResult = await     _auth.signInWithCredential(credential);

      final User? user = authResult.user;
      // assert(!user.isAnonymous);
      assert(await user?.getIdToken() != null);
      final User? currentUser = _auth.currentUser;
      assert(user?.uid == currentUser?.uid);
      isLoading.value = false;
      Get.offAll(() => HomePage()); // navigate to your wanted page
      return;
    } catch (e) {
      Get.snackbar("Some error occurred", e.toString());
      print(e.toString());
      isLoading.value = false;
    }
  }

  Future<void> logoutGoogle() async {
    await googleSignIn.signOut();
    Get.back(); // navigate to your wanted page after logout.
  }

}