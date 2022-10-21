// This class was necessary due to a seeming bug in the bindStream method of
// GetX for nullable types like String?
class Optional<T> {
  final T? value;

  Optional(this.value);
}