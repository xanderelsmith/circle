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
              child: const Icon(
                Icons.circle_outlined,
                color: Color(0xFF42D9FF),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Circle',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Better together. Stronger always.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(
              child: Icon(
                Icons.notifications_none,
                size: 28,
                color: Colors.white,
              ),
            ),
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
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF7B4DFF), Color(0xFF42D9FF)],
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=200&q=80',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Emmanuel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(
                            Icons.workspace_premium,
                            color: Color(0xFF7B4DFF),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Rookie',
                            style: TextStyle(
                              color: Color(0xFF7B4DFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const LinearProgressIndicator(
                                value: 0.62,
                                backgroundColor: Color(0xFF1B2339),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF7B4DFF),
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            '620 / 1,000 XP',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2339),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: const [
                          Text(
                            '#3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'in Flutter Builders',
                            style: TextStyle(color: Colors.grey, fontSize: 8),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Activity Heatmap
          Container(
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
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Activity Heatmap',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Days you showed up. Progress you can see.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
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
                          _buildHeatmapTab('7D', false),
                          _buildHeatmapTab('30D', true),
                          _buildHeatmapTab('90D', false),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Heatmap Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mon',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tue',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Wed',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Thu',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Fri',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sat',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sun',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
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
                        itemCount: 20 * 7,
                        itemBuilder: (context, index) {
                          // Randomize green shades for heatmap effect
                          final intensity = (index % 5) + (index % 3);
                          Color boxColor = const Color(0xFF1B2339);
                          if (intensity > 4)
                            boxColor = const Color(0xFF35D49A);
                          else if (intensity > 2)
                            boxColor = const Color(0xFF2EA076);
                          else if (intensity > 0)
                            boxColor = const Color(0xFF1B6B50);

                          return Container(
                            decoration: BoxDecoration(
                              color: boxColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'This month',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Low activity',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        const SizedBox(width: 8),
                        _buildLegendBox(const Color(0xFF1B2339)),
                        const SizedBox(width: 4),
                        _buildLegendBox(const Color(0xFF1B6B50)),
                        const SizedBox(width: 4),
                        _buildLegendBox(const Color(0xFF2EA076)),
                        const SizedBox(width: 4),
                        _buildLegendBox(const Color(0xFF35D49A)),
                        const SizedBox(width: 8),
                        const Text(
                          'High activity',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Your Habits
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.track_changes, color: Color(0xFF9B5CFF)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Your Habits',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Keep the streak alive',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const Row(
                children: [
                  Text(
                    'View all',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildHabitCard(
                  'Run 5km',
                  '12 day streak',
                  const Color(0xFF35D49A),
                  Icons.directions_run,
                  true,
                ),
                _buildHabitCard(
                  'Read 20 pages',
                  '8 day streak',
                  const Color(0xFF9B5CFF),
                  Icons.menu_book,
                  true,
                ),
                _buildHabitCard(
                  'Build Project',
                  '5 day streak',
                  const Color(0xFF42D9FF),
                  Icons.code,
                  false,
                ),
                _buildHabitCard(
                  'Meditate',
                  '3 day streak',
                  Colors.orange,
                  Icons.self_improvement,
                  false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Bottom Row (Total Progress & Next Rank)
          Row(
            children: [
              Expanded(
                flex: 5,
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
                        children: const [
                          Icon(
                            Icons.emoji_events,
                            color: Colors.orange,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Total Progress',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Circular progress
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: CircularProgressIndicator(
                                  value: 0.78,
                                  color: const Color(0xFF35D49A),
                                  backgroundColor: const Color(0xFF1B2339),
                                  strokeWidth: 6,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    '78%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'completion',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProgressStat(
                                  Icons.local_fire_department,
                                  Colors.orange,
                                  'Longest streak',
                                  '24 days',
                                ),
                                const SizedBox(height: 8),
                                _buildProgressStat(
                                  Icons.check,
                                  const Color(0xFF35D49A),
                                  'Habits completed',
                                  '47',
                                ),
                                const SizedBox(height: 8),
                                _buildProgressStat(
                                  Icons.bolt,
                                  const Color(0xFF42D9FF),
                                  'Total XP',
                                  '4,320',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13172E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Next Rank',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Champion',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Icon(
                        Icons.terrain,
                        color: Color(0xFF9B5CFF),
                        size: 40,
                      ), // Placeholder for mountain flag
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          value: 0.62,
                          backgroundColor: Color(0xFF1B2339),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF9B5CFF),
                          ),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '620 / 1,000 XP',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 12),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Keep going! You're closer than you think.",
                              style: TextStyle(color: Colors.grey, fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildHeatmapTab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF7B4DFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHabitCard(
    String title,
    String streak,
    Color color,
    IconData icon,
    bool done,
  ) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
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
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                radius: 18,
                child: Icon(icon, color: color, size: 20),
              ),
              Icon(
                done ? Icons.check_circle : Icons.radio_button_unchecked,
                color: done ? const Color(0xFF35D49A) : const Color(0xFF1B2339),
                size: 20,
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                streak,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(
    IconData icon,
    Color color,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
