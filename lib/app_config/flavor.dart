sealed class Flavor {
  static late final Flavor _current;

  static Flavor get current => _current;

  static void set({required bool isInstant}) =>
      _current = isInstant ? Instant() : Base();
}

final class Instant extends Flavor {}

final class Base extends Flavor {}
