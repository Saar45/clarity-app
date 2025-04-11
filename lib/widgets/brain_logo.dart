import 'package:flutter/material.dart';

class BrainLogo extends StatefulWidget {
  final double size;
  final bool animate;

  const BrainLogo({
    Key? key,
    required this.size,
    this.animate = false,
  }) : super(key: key);

  @override
  _BrainLogoState createState() => _BrainLogoState();
}

class _BrainLogoState extends State<BrainLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.animate ? _pulseAnimation.value : 1.0,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Brain base
                Icon(
                  Icons.psychology,
                  size: widget.size * 0.7,
                  color: Theme.of(context).primaryColor,
                ),
                // Glowing effect
                Positioned(
                  right: widget.size * 0.25,
                  top: widget.size * 0.25,
                  child: Container(
                    width: widget.size * 0.15,
                    height: widget.size * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                          blurRadius: widget.size * 0.1,
                          spreadRadius: widget.size * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
