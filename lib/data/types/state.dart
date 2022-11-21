class State<T> {
  final bool loading;
  final T? content;
  final Exception? error;

  State({this.loading = false, this.content, this.error});
}