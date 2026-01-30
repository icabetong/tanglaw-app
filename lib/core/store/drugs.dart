import 'package:sembast/sembast.dart';

class DrugDataStoreLocalized {
  DrugDataStoreLocalized._();
  static final _storeEn = stringMapStoreFactory.store('drugs_en');
  static final _storeTl = stringMapStoreFactory.store('drugs_tl');

  static StoreRef<String, Map<String, Object?>> getLocalizedStore(
    String? locale,
  ) {
    switch (locale) {
      // Filipino or Tagalog
      case 'fil':
        return _storeTl;
      // default to English
      default:
        return _storeEn;
    }
  }
}
