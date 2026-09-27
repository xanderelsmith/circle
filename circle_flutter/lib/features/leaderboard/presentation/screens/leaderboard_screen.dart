import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

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
                Text('Stronger together.', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
          // Top Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D162B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                        SizedBox(width: 4),
                        Text('Your Current Streak', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text('18', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Text('days', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B4DFF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.emoji_events, color: Color(0xFF7B4DFF), size: 12),
                          SizedBox(width: 4),
                          Text('Top 3 in your circle', style: TextStyle(color: Color(0xFF7B4DFF), fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
                // Right side Rank
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Your Rank', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const Text('#3', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('2,480 XP', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          value: 0.8,
                          backgroundColor: Color(0xFF101A32),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B4DFF)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Tab Bar
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF101A32),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF7B4DFF), Color(0xFF3D7BFF)]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Circle Leaderboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const Expanded(
                  child: Center(child: Text('Weekly', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                ),
                const Expanded(
                  child: Center(child: Text('Monthly', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Leaderboard List
          _buildLeaderboardTile(1, 'Sarah', 26, 3420, true, 2, const Color(0xFFFFC94A)),
          _buildLeaderboardTile(2, 'David', 21, 2980, true, 1, Colors.grey[400]!),
          _buildLeaderboardTile(3, 'Emmanuel', 18, 2480, null, 0, const Color(0xFFCD7F32), isMe: true),
          _buildLeaderboardTile(4, 'John', 12, 1920, true, 1, Colors.transparent),
          _buildLeaderboardTile(5, 'Chisom', 11, 1760, false, 1, Colors.transparent),
          _buildLeaderboardTile(6, 'Kelvin', 9, 1430, null, 0, Colors.transparent),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTile(int rank, String name, int streak, int xp, bool? trendingUp, int trendValue, Color rankColor, {bool isMe = false}) {
    final bool isTop3 = rank <= 3;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF3D7BFF).withOpacity(0.15) : const Color(0xFF0D162B),
        borderRadius: BorderRadius.circular(16),
        border: isTop3 || isMe ? Border.all(color: isMe ? const Color(0xFF3D7BFF) : rankColor, width: 1.5) : null,
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTop3 ? rankColor.withOpacity(0.2) : Colors.transparent,
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                color: isTop3 ? rankColor : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            padding: EdgeInsets.all(isTop3 ? 2 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isTop3 ? Border.all(color: rankColor, width: 2) : null,
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF42D9FF),
              child: Icon(Icons.person, color: Colors.white, size: 20), // Placeholder
            ),
          ),
          const SizedBox(width: 12),
          // Name and Streak
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    if (isMe) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF3D7BFF), borderRadius: BorderRadius.circular(8)),
                        child: const Text('You', style: TextStyle(color: Colors.white, fontSize: 10)),
                      )
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 12),
                    const SizedBox(width: 4),
                    Text('$streak day streak', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
          // XP and Trend
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${xp} XP', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              if (trendingUp != null)
                Row(
                  children: [
                    Icon(trendingUp ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: trendingUp ? Colors.green : Colors.red, size: 16),
                    Text('$trendValue', style: TextStyle(color: trendingUp ? Colors.green : Colors.red, fontSize: 12)),
                  ],
                )
              else
                const Text('—', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
