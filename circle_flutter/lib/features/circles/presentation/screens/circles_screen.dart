import 'package:flutter/material.dart';

class CirclesScreen extends StatelessWidget {
  const CirclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF3D7BFF), width: 3),
              ),
              child: const Icon(Icons.circle_outlined, color: Color(0xFF42D9FF)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Circle', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text('My Circles', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.add_circle, color: Color(0xFF7B4DFF)), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search your circles...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF101A32),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Tabs
          Row(
            children: [
              _buildTab('My Circles', '4', true),
              const SizedBox(width: 8),
              _buildTab('Invites', '2', false),
              const SizedBox(width: 8),
              _buildTab('Suggested', '3', false),
            ],
          ),
          const SizedBox(height: 24),
          
          // Circle Cards
          _buildCircleCard('Flutter Builders', 'Build. Ship. Grow. 🚀', const Color(0xFF7C4DFF), 12, 7, Icons.landscape),
          _buildCircleCard('Fitness Bros', 'Better men. Better habits. 💪', const Color(0xFF35D49A), 8, 8, Icons.fitness_center),
          _buildCircleCard('Study Squad', 'Discipline today, freedom tomorrow.', const Color(0xFF9B5CFF), 5, 5, Icons.book),
          _buildCircleCard('Build & Flow', 'Code • Create • Level Up', const Color(0xFF42D9FF), 3, 4, Icons.code),
          
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Your Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('View all >', style: TextStyle(fontSize: 14, color: Colors.blue[300])),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatsRow(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTab(String title, String count, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF3D7BFF) : const Color(0xFF101A32),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (active) const Icon(Icons.group, size: 16, color: Colors.white),
          if (active) const SizedBox(width: 4),
          Text(title, style: TextStyle(color: active ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(count, style: TextStyle(color: active ? Colors.white : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCircleCard(String name, String tagline, Color color, int streak, int members, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D162B),
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(tagline, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.group, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('$members members', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 8),
                    const Icon(Icons.circle, size: 8, color: Colors.green),
                    const SizedBox(width: 4),
                    const Text('Active today', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF101A32),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text('$streak day streak', style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D162B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.group, '4', 'Circles', const Color(0xFF7C4DFF)),
          _buildStatItem(Icons.local_fire_department, '32', 'Total Streak Days', Colors.orange),
          _buildStatItem(Icons.emoji_events, '1', 'Top 3 Ranks', Colors.yellow),
          _buildStatItem(Icons.star, '5', 'Achievements', Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}
