import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF101A32),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'For You',
                style: TextStyle(
                  color: Color(0xFFAAB4D0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B4DFF), Color(0xFF3D7BFF)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              alignment: Alignment.center,
              child: const Text(
                'My Circle',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
