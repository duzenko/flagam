// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "chapter1": MessageLookupByLibrary.simpleMessage(
            "War requires resources. It is logical to start with something simpler - for example, the nearest sawmill."),
        "epilogue": MessageLookupByLibrary.simpleMessage(
            "All enemies are defeated! All you can do is reap the fruits of a glorious victory and write your memoirs."),
        "peasant": MessageLookupByLibrary.simpleMessage("Peasant"),
        "prologue": MessageLookupByLibrary.simpleMessage(
            "The old emperor is dead and the civil war has already started. It\'s time for the old necromancer to once again roll the dice of fate!"),
        "ruins": MessageLookupByLibrary.simpleMessage("Ancient Ruins"),
        "ruinsDesc": MessageLookupByLibrary.simpleMessage(
            "In these ruins you hid from the cruel world, and now they will become the new capital of the world."),
        "sawmill": MessageLookupByLibrary.simpleMessage("Sawmill"),
        "sawmillDesc": MessageLookupByLibrary.simpleMessage(
            "The workers are hard at work, bringing your triumph closer."),
        "skeleton": MessageLookupByLibrary.simpleMessage("Skeleton")
      };
}
