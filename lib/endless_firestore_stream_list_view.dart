import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endless/endless_state_property.dart';
import 'package:endless_firestore/endless_firestore_stream_batch_delegate.dart';
import 'package:endless_firestore/endless_firestore_stream_builder.dart';
import 'package:endless_firestore/endless_firestore_stream_controller.dart';
import 'package:endless/stream/endless_stream_list_view.dart';
import 'package:endless/stream/endless_stream_list_view_data.dart';
import 'package:flutter/material.dart';

/// An infinite loading list view that displays documents loaded from the specified [Query] into a scrollable list. Subscribes to the documents
/// returned from the query with the [Query.snapshots] API using the [Query.limit] approach described [here](https://youtu.be/poqTHxtDXwU?t=470). Note that this
/// incurs a re-read of ***all** current documents when loading successive batches so be aware of the read pricing concerns there.
///
/// If live data updates are not required, consider using [EndlessPaginationListView] instead by executing your query in the [EndlessPaginationListView.loadMore] API.
class EndlessFirestoreStreamListView<T> extends StatelessWidget {
  /// The builder function for the list view items.
  final Widget Function(
    BuildContext context, {
    required QueryDocumentSnapshot<T> item,
    required int index,
    required int totalItems,
  }) itemBuilder;

  /// The stream controller used to perform actions on the list view such as loading more data
  /// or clearing the list.
  final EndlessFirestoreStreamController? controller;

  /// The scroll controller for the list view.
  final ScrollController? scrollController;

  /// The padding around the scroll view.
  final EdgeInsets? padding;

  /// The padding value in between each item in the list view.
  final double? itemPadding;

  /// The Firestore query to execute to populate the items in the scroll view. A [Query.limit]
  /// is applied to the query for each load based on the specified [EndlessFirestoreStreamBatchDelegate.batchSize].
  final Query<T> query;

  /// A function called after loading more data from Firestore. This function must finish before any new items
  /// are added to the list, allowing for any other data dependencies to be fetched before calling [itemBuilder].
  final Future<void> Function(List<QueryDocumentSnapshot<T>> items)? onLoad;

  /// The delegate that specifies the Firestore stream requirements for the list view such as the maximum
  /// number of batches to load and the batch size.
  final EndlessFirestoreStreamBatchDelegate batchDelegate;

  /// The fraction of the remaining quantity of content conceptually "below" the viewport in the scrollable
  /// relative to the maximum height of the scrollable region at which point [loadMore] should be called to
  /// load more data.
  final double? extentAfterFactor;

  /// The builder function for the list view header.
  final SliverPersistentHeader Function(BuildContext context)? headerBuilder;

  /// The state property for the list view header.
  final EndlessStateProperty? headerBuilderState;

  /// The builder function for the list view empty state.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// The state property for the list view empty state.
  final EndlessStateProperty? emptyBuilderState;

  /// The builder function for the list view load more action widget.
  final Widget Function(BuildContext context)? loadMoreBuilder;

  /// The state property for the list view load more action widget.
  final EndlessStateProperty? loadMoreBuilderState;

  /// The builder function for the list view footer.
  final Widget Function(BuildContext context)? footerBuilder;

  /// The state property for the list view footer.
  final EndlessStateProperty? footerBuilderState;

  /// The builder function for the list view loading state.
  final Widget Function(BuildContext context)? loadingBuilder;

  /// The state property for the list view loading state.
  final EndlessStateProperty? loadingBuilderState;

  /// A callback function that provides the current states of the endless scroll view whenever they change.
  final void Function(Set<EndlessState> states)? onStateChange;

  const EndlessFirestoreStreamListView({
    required this.itemBuilder,
    required this.query,
    required this.batchDelegate,
    this.extentAfterFactor,
    this.headerBuilder,
    this.headerBuilderState,
    this.emptyBuilder,
    this.emptyBuilderState,
    this.loadingBuilder,
    this.loadingBuilderState,
    this.loadMoreBuilder,
    this.loadMoreBuilderState,
    this.footerBuilder,
    this.footerBuilderState,
    this.controller,
    this.scrollController,
    this.padding,
    this.itemPadding,
    this.onLoad,
    this.onStateChange,
    key,
  }) : super(key: key);

  @override
  Widget build(context) {
    return EndlessFirestoreStreamBuilder.fromData<T>(
      EndlessFirestoreStreamData<T>(
        controller: controller,
        query: query,
        batchDelegate: batchDelegate,
        onLoad: onLoad,
        builder: ({
          required loadMore,
          required controller,
          required loadOnSubscribe,
          required stream,
        }) {
          return EndlessStreamListView.fromData<QueryDocumentSnapshot<T>>(
            EndlessStreamListViewData<QueryDocumentSnapshot<T>>(
              extentAfterFactor: extentAfterFactor,
              itemBuilder: itemBuilder,
              loadMore: loadMore,
              controller: controller,
              scrollController: scrollController,
              headerBuilder: headerBuilder,
              headerBuilderState: headerBuilderState,
              emptyBuilder: emptyBuilder,
              emptyBuilderState: emptyBuilderState,
              loadingBuilder: loadingBuilder,
              loadingBuilderState: loadingBuilderState,
              loadMoreBuilder: loadMoreBuilder,
              loadMoreBuilderState: loadMoreBuilderState,
              footerBuilder: footerBuilder,
              footerBuilderState: footerBuilderState,
              stream: stream,
              padding: padding,
              itemPadding: itemPadding,
              onStateChange: onStateChange,
              loadOnSubscribe: loadOnSubscribe,
            ),
          );
        },
      ),
    );
  }
}
