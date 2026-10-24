import 'dart:async';

/// Emits a list with the latest value of every input stream whenever any of
/// them emits (after all have emitted once). Small, dependency-free
/// combineLatest for drift `watch()` streams.
Stream<List<T>> combineLatestList<T>(List<Stream<T>> streams) {
  if (streams.isEmpty) return Stream.value(const []);
  late StreamController<List<T>> ctrl;
  final values = List<T?>.filled(streams.length, null);
  final has = List<bool>.filled(streams.length, false);
  final subs = <StreamSubscription<T>>[];
  ctrl = StreamController<List<T>>(
    onListen: () {
      for (var i = 0; i < streams.length; i++) {
        subs.add(streams[i].listen((v) {
          values[i] = v;
          has[i] = true;
          if (has.every((h) => h)) ctrl.add(List<T>.from(values.cast<T>()));
        }, onError: ctrl.addError));
      }
    },
    onCancel: () async {
      for (final s in subs) {
        await s.cancel();
      }
    },
  );
  return ctrl.stream;
}

Stream<(A, B)> combine2<A, B>(Stream<A> a, Stream<B> b) =>
    combineLatestList<Object?>([a, b]).map((l) => (l[0] as A, l[1] as B));

Stream<(A, B, C)> combine3<A, B, C>(Stream<A> a, Stream<B> b, Stream<C> c) =>
    combineLatestList<Object?>([a, b, c]).map((l) => (l[0] as A, l[1] as B, l[2] as C));

Stream<(A, B, C, D)> combine4<A, B, C, D>(Stream<A> a, Stream<B> b, Stream<C> c, Stream<D> d) =>
    combineLatestList<Object?>([a, b, c, d]).map((l) => (l[0] as A, l[1] as B, l[2] as C, l[3] as D));
