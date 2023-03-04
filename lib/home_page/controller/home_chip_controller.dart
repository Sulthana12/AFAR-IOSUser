import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/home_page/model/location_history.dart';
import 'package:get/get.dart';

//getx controller class for state management of chips

class HomeChipController extends GetxController {
  final _selectedRideOrExChip = 0.obs;
  get selectedRideOrExChip => _selectedRideOrExChip.value;
  set selectedRideOrExChip(index) => _selectedRideOrExChip.value = index;

  final _selectedNextChip = 0.obs;
  get selectedNextChip => _selectedNextChip.value;
  set selectedNextChip(index) => _selectedNextChip.value = index;

  RxBool expressSelected = false.obs;
  RxBool rideSelected = false.obs;

  RxBool dailySelected = false.obs;
  RxBool rentalSelected = false.obs;
  RxBool preBookSelected = false.obs;

  RxBool vehicleSelected = false.obs;

  RxBool autoSelected = false.obs;
  RxBool bikeSelected = false.obs;
  RxBool microSelected = false.obs;
  RxBool sedanSelected = false.obs;

  RxString datePicked = ''.obs;
  RxString timePicked = ''.obs;
  RxString dateTimePicked = ''.obs;

  RxString datePickedForApi = ''.obs;
  RxString timePickedForApi = ''.obs;
  RxString dateTimePickedForApi = ''.obs;

  RxBool rideConfirmed = false.obs;

}