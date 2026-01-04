import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/drag_state_provider.dart';

// This widget is AI generated to provide auto-scrolling functionality during drag-and-drop operations.

/// Edge threshold in pixels - when pointer is within this distance from
/// the top or bottom edge, auto-scrolling begins.
const _edgeThreshold = 60.0;

/// Scroll speed in pixels per tick (every 16ms ≈ 60fps).
const _scrollSpeed = 16.0;

/// A widget that enables auto-scrolling when a draggable item is moved
/// near the top or bottom edge of the scrollable area.
///
/// Wrap this around a [SingleChildScrollView] or similar scrollable widget.
/// The [scrollController] must be attached to the scrollable widget.
class DragAutoScroller extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;

  const DragAutoScroller({
    super.key,
    required this.scrollController,
    required this.child,
  });

  @override
  State<DragAutoScroller> createState() => _DragAutoScrollerState();
}

class _DragAutoScrollerState extends State<DragAutoScroller> {
  Timer? _scrollTimer;
  double _scrollDirection = 0; // -1 = up, 1 = down, 0 = none

  @override
  void dispose() {
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _startScrolling(double direction) {
    if (_scrollDirection == direction) return;

    _scrollDirection = direction;
    _scrollTimer?.cancel();

    if (direction == 0) {
      _scrollTimer = null;
      return;
    }

    _scrollTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => _performScroll(),
    );
  }

  void _performScroll() {
    if (!widget.scrollController.hasClients) return;

    final currentOffset = widget.scrollController.offset;
    final maxOffset = widget.scrollController.position.maxScrollExtent;
    final minOffset = widget.scrollController.position.minScrollExtent;

    var newOffset = currentOffset + (_scrollSpeed * _scrollDirection);
    newOffset = newOffset.clamp(minOffset, maxOffset);

    if (newOffset != currentOffset) {
      widget.scrollController.jumpTo(newOffset);
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    // Only auto-scroll when an item is actually being dragged
    final dragState = DragStateProvider.maybeOf(context);
    if (dragState == null || !dragState.isDragging) {
      _startScrolling(0);
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(event.position);
    final height = renderBox.size.height;

    if (localPosition.dy < _edgeThreshold) {
      // Near top edge - scroll up
      _startScrolling(-1);
    } else if (localPosition.dy > height - _edgeThreshold) {
      // Near bottom edge - scroll down
      _startScrolling(1);
    } else {
      // Not near edge - stop scrolling
      _startScrolling(0);
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    _startScrolling(0);
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _startScrolling(0);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: widget.child,
    );
  }
}
