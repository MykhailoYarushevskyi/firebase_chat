import 'package:firebase_chat/frameworks/sources/web/firebase/massages_firestore_service_impl.dart';
import 'package:get_it/get_it.dart';

import 'package:firebase_chat/interface_adapters/repositories/messages_repository_impl.dart';
import 'package:firebase_chat/interface_adapters/repositories/soources_abstr/web/firebase/massages_firestore_service.dart';
import 'package:firebase_chat/domain/use_cases/adapters_abstr/repositories/messages_repository.dart';
import 'package:firebase_chat/domain/use_cases/messages_use_cases/messages_use_case.dart';

final getIt = GetIt.instance;

void setUp() {

  // started register block for Messages
  getIt.registerSingleton<MessagesFirestoreService>(
      MessagesFirestoreServiceImpl());

  getIt.registerLazySingleton<MessagesRepository>(() {
    return MessagesRepositoryImpl(GetIt.I.get<MessagesFirestoreService>());
  });

  getIt.registerLazySingleton<MessagesUseCase>(() {
    final messagesRepository = GetIt.I.get<MessagesRepository>();
    return MessagesUseCase(messagesRepository);
  });

  // getIt.registerFactory<MessagesUseCase>(() {
  //   final messagesRepository =
  //       GetIt.I.get<MessagesRepositoryImpl>();
  //   return MessagesUseCase(messagesRepository);
  // });

  // finished register block for Messages
}
