import 'package:mutual_fund_app/constant/storage_key.dart';
import 'package:get_storage/get_storage.dart';

class Storage {
  static final GetStorage box = GetStorage(); //single created

  static List? get readFavourites =>
      box.read(storageKeys.favKey); //getting fav list

  static set writeFavourites(List? value) =>
      box.write(storageKeys.favKey, value); //writing value if null

  static List? get readStorageKey => box.read(storageKeys.storageKey);

  static set writeStorageKey(List? value) =>
      box.write(storageKeys.storageKey, value);

  static Future<void> init() async {
    await GetStorage.init(); //initialize
  }
}
