import 'package:get/get.dart';

class MapSearchController extends GetxController {
  RxString searchValue = ''.obs;

  final List<String> suggestions = ['Afeganistan', 'Albania', 'Algeria', 'Australia', 'Brazil', 'German', 'Madagascar', 'Mozambique', 'Portugal', 'Zambia'];

  List cars = [
    {'id': 0, 'name': 'Select a Ride', 'price': 0.0},
    {'id': 1, 'name': 'UberGo', 'price': 230.0},
    {'id': 2, 'name': 'Go Sedan', 'price': 300.0},
    {'id': 3, 'name': 'UberXL', 'price': 500.0},
    {'id': 4, 'name': 'UberAuto', 'price': 140.0},
  ];

  RxInt selectedCarId = 0.obs;

}