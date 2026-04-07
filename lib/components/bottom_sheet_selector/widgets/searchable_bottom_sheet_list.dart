import 'package:flutter/material.dart';

/// A bottom sheet list widget with optional search filtering.
class SearchableBottomSheetList<T> extends StatefulWidget {
  final Future<List<T>> Function() itemsProvider;
  final Widget Function(T item) itemBuilder;
  final String? title;
  final String? searchHint;
  final bool Function(T item, String query)? searchFilter;

  const SearchableBottomSheetList({
    super.key,
    required this.itemsProvider,
    required this.itemBuilder,
    this.title,
    this.searchHint,
    this.searchFilter,
  });

  @override
  State<SearchableBottomSheetList<T>> createState() =>
      _SearchableBottomSheetListState<T>();
}

class _SearchableBottomSheetListState<T>
    extends State<SearchableBottomSheetList<T>> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  late final Future<List<T>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = widget.itemsProvider();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasSearch =>
      widget.searchHint != null && widget.searchFilter != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<T>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allItems = snapshot.data ?? [];
        final items = _searchQuery.isNotEmpty && widget.searchFilter != null
            ? allItems
                .where((item) => widget.searchFilter!(item, _searchQuery))
                .toList()
            : allItems;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null)
                    Text(
                      widget.title!,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (_hasSearch) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: widget.searchHint,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value.toLowerCase());
                      },
                    ),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    widget.itemBuilder(items[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}
