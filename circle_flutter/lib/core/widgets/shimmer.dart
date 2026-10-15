import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFF1B2339),
    this.highlightColor = const Color(0xFF2A334D),
    this.period = const Duration(milliseconds: 1200),
  });

  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration period;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat(reverse: true);
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
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((v) => v.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.baseColor = const Color(0xFF1B2339),
    this.highlightColor = const Color(0xFF2A334D),
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  const ShimmerCircle({
    super.key,
    required this.size,
    this.baseColor = const Color(0xFF1B2339),
    this.highlightColor = const Color(0xFF2A334D),
  });

  final double size;
  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: baseColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.spacing = 12,
    this.showAvatar = true,
    this.showSubtitle = true,
    this.showTrailing = false,
  });

  final int itemCount;
  final double itemHeight;
  final double spacing;
  final bool showAvatar;
  final bool showSubtitle;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == itemCount - 1 ? 0 : spacing,
          ),
          child: _ShimmerListItem(
            height: itemHeight,
            showAvatar: showAvatar,
            showSubtitle: showSubtitle,
            showTrailing: showTrailing,
          ),
        );
      }),
    );
  }
}

class _ShimmerListItem extends StatelessWidget {
  const _ShimmerListItem({
    required this.height,
    required this.showAvatar,
    required this.showSubtitle,
    required this.showTrailing,
  });

  final double height;
  final bool showAvatar;
  final bool showSubtitle;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            if (showAvatar) ...[
              const ShimmerCircle(size: 44),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 120, height: 14, borderRadius: 6),
                  if (showSubtitle) ...[
                    const SizedBox(height: 6),
                    ShimmerBox(width: 80, height: 12, borderRadius: 6),
                  ],
                ],
              ),
            ),
            if (showTrailing) ...[
              const SizedBox(width: 12),
              ShimmerBox(width: 40, height: 16, borderRadius: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 4,
    this.aspectRatio = 0.85,
    this.spacing = 12,
    this.runSpacing = 12,
    this.borderRadius = 16,
  });

  final int crossAxisCount;
  final int itemCount;
  final double aspectRatio;
  final double spacing;
  final double runSpacing;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => ShimmerBox(
        width: double.infinity,
        height: double.infinity,
        borderRadius: borderRadius,
      ),
    );
  }
}

class ShimmerProfileCard extends StatelessWidget {
  const ShimmerProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D162B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF1B2339), Color(0xFF2A334D)],
                ),
              ),
              child: const ShimmerCircle(size: 64),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 140, height: 20, borderRadius: 8),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ShimmerBox(width: 60, height: 14, borderRadius: 6),
                      const SizedBox(width: 8),
                      ShimmerBox(width: 50, height: 14, borderRadius: 6),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ShimmerBox(
                    width: double.infinity,
                    height: 6,
                    borderRadius: 4,
                  ),
                  const SizedBox(width: 12),
                  ShimmerBox(width: 80, height: 10, borderRadius: 4),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2339),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ShimmerBox(width: 30, height: 20, borderRadius: 4),
                  const SizedBox(height: 4),
                  ShimmerBox(width: 50, height: 8, borderRadius: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerHeatmap extends StatelessWidget {
  const ShimmerHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D162B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ShimmerBox(width: 24, height: 24, borderRadius: 6),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 120, height: 16, borderRadius: 6),
                        const SizedBox(height: 4),
                        ShimmerBox(width: 180, height: 11, borderRadius: 4),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2339),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ShimmerBox(width: 30, height: 16, borderRadius: 6),
                      const SizedBox(width: 4),
                      ShimmerBox(width: 30, height: 16, borderRadius: 6),
                      const SizedBox(width: 4),
                      ShimmerBox(width: 30, height: 16, borderRadius: 6),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    7,
                    (_) => ShimmerBox(width: 24, height: 10, borderRadius: 4),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 20,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                    itemCount: 140,
                    itemBuilder: (_, _) => ShimmerBox(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerHabitCards extends StatelessWidget {
  const ShimmerHabitCards({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (_, _) => Container(
          width: 130,
          margin: const EdgeInsets.only(right: 12),
          child: Shimmer(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0D162B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerCircle(size: 36),
                      ShimmerCircle(size: 20),
                    ],
                  ),
                  const Spacer(),
                  ShimmerBox(width: 80, height: 14, borderRadius: 6),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ShimmerBox(width: 12, height: 12, borderRadius: 6),
                      const SizedBox(width: 4),
                      ShimmerBox(width: 50, height: 11, borderRadius: 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerStatsRow extends StatelessWidget {
  const ShimmerStatsRow({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D162B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            itemCount,
            (_) => Column(
              children: [
                ShimmerCircle(size: 28),
                const SizedBox(height: 8),
                ShimmerBox(width: 40, height: 18, borderRadius: 4),
                const SizedBox(height: 4),
                ShimmerBox(width: 30, height: 10, borderRadius: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
