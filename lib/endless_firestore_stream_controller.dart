/// The delegate that specifies the Firestore query requirements such as the [batchSize]
/// and maximum number of batches to load.
class EndlessFirestoreStreamController<T> {
  /// Clears the items from the scroll view.
  late void Function({bool lazy}) clear;

  /// Reloads the content of the scroll view, lazily clearing its current data and calling [loadMore].
  late void Function() reload;

  // Loads an additional batch of items.
  late void Function() loadMore;
}
