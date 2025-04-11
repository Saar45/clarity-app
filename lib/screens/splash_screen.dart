import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final ThemeData theme;
  final Function onComplete;

  const SplashScreen({
    Key? key,
    required this.theme,
    required this.onComplete,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    
    _controller.forward();
    
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.onComplete()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: widget.theme.primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.psychology,
                        size: 100,
                        color: widget.theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Text(
                    'CLARITY POINT',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.theme.primaryColor,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Text(
                    'Organisez vos pensées',
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.theme.colorScheme.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 80),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.theme.colorScheme.secondary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
