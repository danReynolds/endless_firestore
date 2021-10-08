# Endless Firestore

An extension of the [Endless](https://pub.dev/packages/endless) infinite scroll view library with support for Firestore streams.

## Basic List Example

```dart
import 'package:flutter/material.dart';
import 'package:endless_firestore/endless_firestore.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Endless Firestore stream list view')),
        body: EndlessFirestoreStreamListView<String>(
          // A Firestore stream takes a query to use for fetching items.
          query: FirebaseFirestore.instance.collection('users').where('name', isEqualTo: 'Tester'),
          // The batch delegate determines how many new items to fetch per batch and optionally the maximum number of batches to fetch.
          batchDelegate: EndlessFirestoreStreamBatchDelegate(
            batchSize: 5,
            maxBatches: 10,
          ),
          itemBuilder: (
            context, {
            required item,
            required index,
            required totalItems,
          }) {
            return Text(item);
          },
        ),
      ),
    );
  }
}
```

The `EndlessFirestoreStreamListView` displays documents loaded from the specified [Query](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/Query-class.html) into a scrollable list. The scroll view subscribes to the documents returned from the query with the [Query.snapshots](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/Query/snapshots.html) API using the [Query.limit](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/Query/limit.html) approach described [in this video](https://youtu.be/poqTHxtDXwU?t=470).

> Note that this approach incurs a re-read of **all** current documents when loading successive batches so be aware of the read pricing concerns there. This trade-off was made because of the advantages that come from limit-based batching as best described in the link above. 

## Basic Grid Example

```dart
import 'package:flutter/material.dart';
import 'package:endless_firestore/endless_firestore.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Endless Firestore stream grid view')),
        body: EndlessFirestoreStreamGridView<String>(
          batchDelegate: EndlessFirestoreStreamBatchDelegate(
            batchSize: 5,
            maxBatches: 10,
          ),
          query: FirebaseFirestore.instance.collection('users').where('name', isEqualTo: 'Tester'),
          // The only difference between the basic list and grid view is that a grid specifies its delegate such as how many items
          // to put in the cross axis.
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (
            context, {
            required item,
            required index,
            required totalItems,
          }) {
            return Text(item);
          },
        ),
      ),
    );
  }
}
```

## Advanced Example

To learn more about advanced use cases of Endless scroll views, check out the examples in the core [Endless library](https://pub.dev/packages/endless#advanced-example).