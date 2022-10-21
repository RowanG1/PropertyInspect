class CheckInState {
  final bool loading;
  final bool content;
  final Exception? error;

  CheckInState({this.loading = false, this.content = false, this.error});
}