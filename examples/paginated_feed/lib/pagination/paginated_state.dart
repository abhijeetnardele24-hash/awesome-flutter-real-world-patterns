class PaginatedState<T> {
  const PaginatedState({
    required this.items,
    required this.isLoading,
    required this.hasMore,
    this.errorMessage,
  });

  const PaginatedState.initial()
      : items = const [],
        isLoading = false,
        hasMore = true,
        errorMessage = null;

  final List<T> items;
  final bool isLoading;
  final bool hasMore;
  final String? errorMessage;

  PaginatedState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? hasMore,
    String? errorMessage,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
