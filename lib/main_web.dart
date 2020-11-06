// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:shipanther/app.dart';
import 'package:flutter/widgets.dart';
import 'package:key_value_store_web/key_value_store_web.dart';
import 'package:shipanther/blocs/tasks_interactor.dart';
import 'package:shipanther/tasks_repository_core/user_entity.dart';
import 'package:shipanther/tasks_repository_core/user_repository.dart';
import 'package:shipanther/tasks_repository_local_storage/reactive_repository.dart';
import 'package:shipanther/tasks_repository_local_storage/key_value_storage.dart';
import 'package:shipanther/tasks_repository_local_storage/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(BlocApp(
    tasksInteractor: TasksInteractor(
      ReactiveLocalStorageRepository(
        repository: LocalStorageRepository(
          localStorage: KeyValueStorage(
            'shipanther',
            WebKeyValueStore(window.localStorage),
          ),
        ),
      ),
    ),
    userRepository: AnonymousUserRepository(),
  ));
}

class AnonymousUserRepository implements UserRepository {
  @override
  Future<UserEntity> login() {
    return Future.value(UserEntity(id: 'anonymous'));
  }
}
