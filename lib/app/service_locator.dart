// ignore_for_file: directives_ordering

import 'package:firebase_chat/interface_adapters/repositories/soources_abstr/firebase/massages_firestore_service_abstr.dart';
import 'package:get_it/get_it.dart';

import 'package:firebase_chat/domain/use_cases/adapters_abstr/repositories/messages_repository.dart';
import 'package:firebase_chat/domain/use_cases/messages_use_cases/messages_use_case.dart';
import 'package:firebase_chat/frameworks/sources/web/firebase/massages_firestore_service_impl.dart';
import 'package:firebase_chat/interface_adapters/repositories/messages_repository_impl.dart';

final getIt = GetIt.instance;

void setUp() {

  // started register block for Messages
  getIt.registerSingleton<MessagesFirestoreServiceAbstr>(
      MessagesFirestoreService());

  getIt.registerLazySingleton<MessagesRepositoryAbstr>(() {
    final messagesFirestoreService = GetIt.I.get<MessagesFirestoreServiceAbstr>();
    return MessagesRepository(messagesFirestoreService);
  });

  getIt.registerLazySingleton<MessagesUseCase>(() {
    final messagesRepository = GetIt.I.get<MessagesRepositoryAbstr>();
    return MessagesUseCase(messagesRepository);
  });

  // getIt.registerFactory<MessagesUseCase>(() {
  //   final messagesRepository =
  //       GetIt.I.get<MessagesRepository>();
  //   return MessagesUseCase(messagesRepository);
  // });

  // finished register block for Messages
}
