import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PaymentController extends GetxController {

  List<String> listType = ["UPI", "Cash"];
  // It is mandatory initialize with one value from listType
  RxString selected = "UPI".obs;

  void setSelected(String value){
    selected.value = value;
  }

}