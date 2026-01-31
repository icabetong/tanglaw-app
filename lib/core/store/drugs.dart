import 'package:sembast/sembast.dart';

class DrugDataStoreLocalized {
  DrugDataStoreLocalized._();
  static final _storeEn = stringMapStoreFactory.store('drugs_en');
  static final _storeTl = stringMapStoreFactory.store('drugs_tl');
  static final _storeBs = stringMapStoreFactory.store('drugs_bs');
  static final _storeIg = stringMapStoreFactory.store('drugs_ig');

  static StoreRef<String, Map<String, Object?>> getLocalizedStore(
    String? locale,
  ) {
    switch (locale) {
      // Bisaya or Cebuano
      case 'bs':
        return _storeBs;
      // Ilocano
      case 'ig':
        return _storeIg;
      // Filipino or Tagalog
      case 'fil':
        return _storeTl;
      // default to English
      default:
        return _storeEn;
    }
  }
}
