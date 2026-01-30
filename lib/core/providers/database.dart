import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  final appDir = await getApplicationDocumentsDirectory();
  final path = join(appDir.path, 'drugs.db');

  return await databaseFactoryIo.openDatabase(path);
});
