import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/drag_auto_scroller.dart';

// This widget is AI generated to provide auto-scrolling functionality during drag-and-drop operations.

/// A widget that provides drag state to its descendants.
///
/// This is used to communicate between draggable items and the
/// [DragAutoScroller] so that auto-scrolling only occurs when
/// an item is actually being dragged.
class DragStateProvider extends StatefulWidget {
  final Widget child;

  const DragStateProvider({super.key, required this.child});

  /// Returns the [DragStateProviderState] from the closest ancestor.
  static DragStateProviderState of(BuildContext context) {
    final state = context.findAncestorStateOfType<DragStateProviderState>();
    assert(state != null, 'No DragStateProvider found in context');
    return state!;
  }

  /// Returns the [DragStateProviderState] from the closest ancestor, or null if not found.
  static DragStateProviderState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<DragStateProviderState>();
  }

  @override
  State<DragStateProvider> createState() => DragStateProviderState();
}

class DragStateProviderState extends State<DragStateProvider> {
  var _isDragging = false;

  /// Whether a drag operation is currently in progress.
  bool get isDragging => _isDragging;

  /// Sets the drag state. Call with `true` when a drag starts,
  /// and `false` when it ends or is cancelled.
  void setDragging(bool value) {
    if (_isDragging != value) {
      setState(() {
        _isDragging = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
