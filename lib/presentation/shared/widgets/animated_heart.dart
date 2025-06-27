import 'package:flutter/material.dart';

class AnimatedHeart extends StatefulWidget {
  final bool isLiked;
  final VoidCallback? onTap;
  final double size;
  final Color likedColor;
  final Color unlikedColor;

  const AnimatedHeart({
    super.key,
    required this.isLiked,
    this.onTap,
    this.size = 24.0,
    this.likedColor = Colors.red,
    this.unlikedColor = Colors.grey,
  });

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation for the heart when liked/unliked
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Pulse animation for continuous heartbeat effect when liked
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isLiked) {
      _startPulseAnimation();
    }
  }

  @override
  void didUpdateWidget(AnimatedHeart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLiked != oldWidget.isLiked) {
      if (widget.isLiked) {
        _onLiked();
      } else {
        _onUnliked();
      }
    }
  }

  void _onLiked() {
    // Scale animation
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Start pulse animation
    _startPulseAnimation();
  }

  void _onUnliked() {
    // Scale animation for unlike
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Stop pulse animation
    _pulseController.stop();
    _pulseController.reset();
  }

  void _startPulseAnimation() {
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
          builder: (context, child) {
            double scale = _scaleAnimation.value;
            if (widget.isLiked) {
              scale *= _pulseAnimation.value;
            }

            return Transform.scale(
              scale: scale,
              child: Icon(
                widget.isLiked ? Icons.favorite : Icons.favorite_border,
                size: widget.size,
                color: widget.isLiked ? widget.likedColor : widget.unlikedColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
