import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                Text('Better together. Stronger always.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(child: Icon(Icons.notifications_none, size: 28)),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D162B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Color(0xFF7B4DFF), Color(0xFF42D9FF)]),
                  ),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=200&q=80'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Emmanuel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const Row(
                        children: [
                          Icon(Icons.workspace_premium, color: Color(0xFF7B4DFF), size: 16),
                          SizedBox(width: 4),
                          Text('Rookie', style: TextStyle(color: Color(0xFF7B4DFF), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const LinearProgressIndicator(
                                value: 0.62,
                                backgroundColor: Color(0xFF101A32),
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B4DFF)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('620 / 1,000 XP', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFF101A32), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: const [
                      Text('#3', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('in Flutter Builders', style: TextStyle(color: Colors.grey, fontSize: 8)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Activity Heatmap
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF0D162B), borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.orange),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Activity Heatmap', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('Days you showed up. Progress you can see.', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: const Color(0xFF101A32), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          _buildHeatmapTab('7D', false),
                          _buildHeatmapTab('30D', true),
                          _buildHeatmapTab('90D', false),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                // Placeholder for Heatmap grid
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF101A32),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('Heatmap Grid (Implementation pending)', style: TextStyle(color: Colors.grey))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Your Habits
          const Text('Your Habits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildHabitCard('Run 5km', '12 day streak', const Color(0xFF35D49A), Icons.directions_run),
                _buildHabitCard('Read 20 pages', '8 day streak', const Color(0xFF9B5CFF), Icons.book),
                _buildHabitCard('Build Project', '5 day streak', const Color(0xFF42D9FF), Icons.code),
                _buildHabitCard('Meditate', '3 day streak', Colors.orange, Icons.self_improvement),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Bottom Row (Total Progress & Next Rank)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF0D162B), borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      // Circular progress placeholder
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(width: 80, height: 80, child: CircularProgressIndicator(value: 0.78, color: const Color(0xFF35D49A), backgroundColor: const Color(0xFF101A32), strokeWidth: 8)),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('78%', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('completion', style: TextStyle(color: Colors.grey, fontSize: 8)),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF0D162B), borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Next Rank', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const Text('Champion', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(value: 0.62, backgroundColor: Color(0xFF101A32), valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B4DFF))),
                      ),
                      const SizedBox(height: 8),
                      const Text('620 / 1,000 XP', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildHeatmapTab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: active ? const Color(0xFF7B4DFF) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHabitCard(String title, String streak, Color color, IconData icon) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF0D162B), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.2), radius: 16, child: Icon(icon, color: color, size: 16)),
          const Spacer(),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: Colors.orange, size: 12),
              const SizedBox(width: 4),
              Text(streak, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }
}
