// lib/frontend/widgets/animated_button.dart
import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color color, pressedColor;
  final Duration duration;

  const AnimatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = Colors.black,
    this.pressedColor = Colors.grey,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _pressed = false;

  void _upd(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _upd(true);
      },
      onTapUp: (_) {
        _upd(false);
        widget.onPressed();
      },
      onTapCancel: () => _upd(false),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(_pressed ? 0.97 : 1.0),
        decoration: BoxDecoration(
          color: _pressed ? widget.pressedColor : widget.color,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
