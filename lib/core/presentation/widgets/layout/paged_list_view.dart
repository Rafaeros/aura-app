import 'package:flutter/material.dart';

class PagedListView<T> extends StatefulWidget {
  final List<T> items;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget? emptyStateWidget;
  final EdgeInsetsGeometry? padding;

  const PagedListView({
    super.key,
    required this.items,
    required this.isLoading,
    required this.onRefresh,
    required this.onLoadMore,
    required this.itemBuilder,
    this.hasError = false,
    this.errorMessage,
    this.emptyStateWidget,
    this.padding,
  });

  @override
  State<PagedListView<T>> createState() => _PagedListViewState<T>();
}

class _PagedListViewState<T> extends State<PagedListView<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !widget.isLoading && 
        !widget.hasError) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && !widget.isLoading && !widget.hasError) {
      return widget.emptyStateWidget ?? 
             const Center(child: Text("Nenhum item encontrado"));
    }
    if (widget.items.isEmpty && widget.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.errorMessage ?? "Ocorreu um erro"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: widget.onRefresh,
              child: const Text("Tentar novamente"),
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: ListView.separated(
        controller: _scrollController,
        padding: widget.padding ?? const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.items.length + 1, 
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == widget.items.length) {
            return _buildBottomLoader();
          }

          final item = widget.items[index];
          return widget.itemBuilder(context, item);
        },
      ),
    );
  }

  Widget _buildBottomLoader() {
    if (widget.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return const SizedBox(height: 80); 
  }
}