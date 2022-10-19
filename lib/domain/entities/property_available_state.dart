class PropertyAvailableState {
  final bool loading;
  final bool content;
  final Exception? error;

  PropertyAvailableState({this.loading = false, this.content = false, this
      .error});
}