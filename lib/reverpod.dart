import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// We have list of items, deleting one item results
/// in all delete icons reloading as you can see if you
/// run the program, how can we prevent this in a way that
/// only the deleted item reloads and the rest do not
///

/// Copy the content of this file and past it into main file

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListOfItemsPage(),
    );
  }
}

/// [Item] - Model

class Item {
  final String title;
  final bool deleted;
  final bool isLoading;
  const Item({required this.title, this.deleted = false, this.isLoading = false});

  Item copyWith({bool? deleted, bool? isLoading}) {
    return Item(title: title, deleted: deleted ?? this.deleted, isLoading: isLoading ?? this.isLoading);
  }
}

/// [items] - Our Data
final items = List.generate(20, (index) => Item(title: 'item no ${index + 1}'));

/// [itemsProvider] - Items Provider
///

final itemsProvider = FutureProvider.autoDispose((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  return items;
});

/// [deleteItemNotifierProvider] - Notifier for delete request
///
final deleteItemNotifierProvider = AsyncNotifierProvider.autoDispose(DeleteItemProviderNotifier.new);

class DeleteItemProviderNotifier extends AutoDisposeAsyncNotifier {
  @override
  FutureOr build() {
    return null;
  }

  void delete(int param) async {
    state = const AsyncLoading();
    items[param] = items[param].copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 2));
    items[param] = items[param].copyWith(deleted: true, isLoading: false);
    state = const AsyncData(null);
    ref.invalidate(itemsProvider);
  }
}

/// [ListOfItemsPage] - UI

class ListOfItemsPage extends ConsumerWidget {
  const ListOfItemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Items ')),
      body: items.when(
        data: (data) => Consumer(
          builder: (context, ref, child) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                ref.watch(deleteItemNotifierProvider);
                return ItemWidget(item: data[index]);
              },
            );
          },
        ),
        error: (_, __) => Center(child: Text(_.toString())),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

class ItemWidget extends ConsumerWidget {
  const ItemWidget({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (item.deleted) {
      return const SizedBox.shrink();
    }
    return ListTile(
      title: Text(item.title),
      trailing: item.isLoading
          ? const CircularProgressIndicator.adaptive()
          : IconButton(
              onPressed: () {
                final index = items.indexWhere((i) => item.title == i.title);
                ref.read(deleteItemNotifierProvider.notifier).delete(index);
              },
              icon: const Icon(
                Icons.remove,
                color: Colors.red,
              ),
            ),
    );
  }
}
