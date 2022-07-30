import 'package:get_it/get_it.dart';
import 'package:krestakipapp/repository/user_repository.dart';
import 'package:krestakipapp/services/FirebaseAuthServices.dart';
import 'package:krestakipapp/services/firestore_db_service.dart';
import 'package:krestakipapp/services/messaging_services.dart';
import 'package:krestakipapp/services/sending_notification_service.dart';
import 'package:krestakipapp/services/storage_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => SendingNotificationService());
}
