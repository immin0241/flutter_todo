import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

class TodoItems extends Table {
  IntColumn get idx => integer().autoIncrement()();
  TextColumn get content => text()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [TodoItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  Future<int> addTodo(TodoItemsCompanion entry) {
    return into(todoItems).insert(entry);
  }

  Future<List<TodoItem>> get allTodoItems => select(todoItems).get();

  Future delTodo(idx) async {
    final TodoItem? item = await (select(todoItems)
          ..where((row) => row.idx.equals(idx)))
        .getSingleOrNull();

    if (item != null) await delete(todoItems).delete(item);
  }

  Future flipTodoDoneStatus(int idx) async {
    final TodoItem? item = await (select(todoItems)
          ..where((row) => row.idx.equals(idx)))
        .getSingleOrNull();

    if (item != null) {
      final updated = item.copyWith(isDone: !item.isDone);

      await update(todoItems).replace(updated);
    }
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    final cachebase = (await getTemporaryDirectory()).path;

    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
