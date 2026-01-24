import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:aura/core/presentation/theme/app_colors.dart';

class AuraNativeAnimatedLogo extends StatefulWidget {
  final double size;
  final bool isAnimating;

  const AuraNativeAnimatedLogo({
    super.key,
    this.size = 300,
    this.isAnimating = true,
  });

  @override
  State<AuraNativeAnimatedLogo> createState() => _AuraNativeAnimatedLogoState();
}

class _AuraNativeAnimatedLogoState extends State<AuraNativeAnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AuraNativeAnimatedLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.isAnimating) ...[
            _buildPulsingArc(delay: 0.0),
            _buildPulsingArc(delay: 0.25),
            _buildPulsingArc(delay: 0.5),
            _buildPulsingArc(delay: 0.75),
          ] else ...[
            _buildStaticArc(scale: 0.7, opacity: 1.0),
            _buildStaticArc(scale: 0.9, opacity: 0.5),
            _buildStaticArc(scale: 1.1, opacity: 0.2),
          ],
          Container(
            padding: EdgeInsets.symmetric(horizontal: widget.size * 0.05),
            child: _buildCentralText(),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralText() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return AppColors.primaryGradient.createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Text(
        'AURA',
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: widget.size * 0.20,
          fontWeight: FontWeight.w900,
          letterSpacing: widget.size * 0.02,
          color: Colors.white,
          shadows: [
            Shadow(
              color: AppColors.primary.withValues(alpha: 0.6),
              blurRadius: 20,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticArc({required double scale, required double opacity}) {
    return Transform.scale(
      scale: scale,
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _GradientHalfMoonPainter(
          gradient: AppColors.primaryGradient,
          opacity: opacity,
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  Widget _buildPulsingArc({required double delay}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = ((_controller.value + delay) % 1.0);
        final double scale = Tween<double>(
          begin: 0.6,
          end: 1.4,
        ).transform(Curves.easeOutQuad.transform(progress));
        final double opacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).transform(Curves.easeInSine.transform(progress));

        if (opacity <= 0.01) return const SizedBox();

        return Transform.scale(
          scale: scale,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _GradientHalfMoonPainter(
              gradient: AppColors.primaryGradient,
              opacity: opacity,
              strokeWidth: 3.0,
            ),
          ),
        );
      },
    );
  }
}

class _GradientHalfMoonPainter extends CustomPainter {
  final LinearGradient gradient;
  final double opacity;
  final double strokeWidth;

  _GradientHalfMoonPainter({
    required this.gradient,
    required this.opacity,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide / 2) - strokeWidth;
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    final Gradient gradientWithOpacity = LinearGradient(
      begin: gradient.begin,
      end: gradient.end,
      colors: gradient.colors.map((c) => c.withValues(alpha: opacity)).toList(),
      stops: gradient.stops,
    );

    final Paint paint =
        Paint()
          ..shader = gradientWithOpacity.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final Paint glowPaint =
        Paint()
          ..shader = gradientWithOpacity.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth =
              strokeWidth +
              6 
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    const double gapAngle = 0.00;
    const double startAngleTop = math.pi + gapAngle;
    const double sweepAngle = math.pi - (2 * gapAngle);

    const double startAngleBottom = 0 + gapAngle;

    canvas.drawArc(arcRect, startAngleTop, sweepAngle, false, glowPaint);
    canvas.drawArc(arcRect, startAngleBottom, sweepAngle, false, glowPaint);
    canvas.drawArc(arcRect, startAngleTop, sweepAngle, false, paint);
    canvas.drawArc(arcRect, startAngleBottom, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientHalfMoonPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}
