import 'package:get/get.dart';

class TransalationString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {

        'en_US': {
          'english': 'English',
          'tamil': 'தமிழ்',
          'langPrefs': 'Language Preferences',
        },

        'ta_IN': {
          'english': 'English',
          'tamil': 'தமிழ்',
          'langPrefs': 'மொழி விருப்பத்தேர்வுகள்',
        },

        //add more language here
      };
}