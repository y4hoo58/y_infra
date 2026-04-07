/// Represents a Firebase Analytics user property as a key-value pair.
abstract class UserProperty {
  final String key;
  final String value;

  const UserProperty(this.key, this.value);
}
