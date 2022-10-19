class CheckinState {
  final bool loading;
  final bool content;
  final Exception? error;

  CheckinState({this.loading = false, this.content = false, this.error});
}