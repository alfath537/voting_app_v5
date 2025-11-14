import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/vote_service.dart';
import '../services/vote_stream.dart';

class ViewResultsPage extends StatelessWidget {
  const ViewResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const colors = [Colors.purple, Colors.deepPurple, Colors.indigo, Colors.orange, Colors.teal, Colors.pinkAccent];

    return Scaffold(
      appBar: AppBar(title: const Text('Voting Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Voting Results', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder<Map<String,int>>(
              future: VoteService.fetchVotes(),
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final total = snap.data!.values.fold<int>(0, (a,b) => a+b);
                return Text('Total votes: $total');
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<Map<String,int>>(
                stream: VoteStream.polling(interval: const Duration(seconds: 3)),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: CircularProgressIndicator());
                  final votesMap = snapshot.data!;
                  final movies = votesMap.keys.toList();
                  final votes = votesMap.values.toList();
                  final totalVotes = votes.isNotEmpty ? votes.reduce((a,b) => a+b) : 0;

                  // build bar chart
                  return Column(
                    children: [
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceEvenly,
                            maxY: (votes.isNotEmpty ? votes.reduce((a,b) => a>b ? a : b).toDouble() : 10) + 10,
                            barGroups: List.generate(movies.length, (i) {
                              return BarChartGroupData(
                                x: i,
                                barRods: [BarChartRodData(toY: votes[i].toDouble(), color: colors[i % colors.length], width: 28)],
                              );
                            }),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx >= 0 && idx < movies.length) return Text(movies[idx], style: const TextStyle(fontSize: 10));
                                return const Text('');
                              })),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(movies.length, (index) {
                          final percent = totalVotes > 0 ? (votes[index] / totalVotes) * 100 : 0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(width: 16, height: 16, color: colors[index % colors.length]),
                                const SizedBox(width: 8),
                                Expanded(child: Text('${movies[index]} - ${votes[index]} votes (${percent.toStringAsFixed(1)}%)')),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
