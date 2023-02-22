import 'package:get/get.dart';

//getx controller class for state management of chips

class ChipController extends GetxController {
  final _selectedChip = 0.obs;
  get selectedChip => _selectedChip.value;
  set selectedChip(index) => _selectedChip.value = index;
}