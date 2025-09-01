import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B1B1B),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9B5DE5), Color(0xFF6A4C93)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Row(
            children: [
              Icon(Icons.menu, color: Colors.white),
              const SizedBox(width: 12),
              const Text('Magnus', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              const Spacer(),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset('assets/anya.png', width: 32, height: 32), // Replace with your asset
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Card
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9B5DE5), Color(0xFF6A4C93)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Anya Forger', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                        SizedBox(height: 8),
                        Text('"Oh, Poor Me! I\'m So Lonely \'Cuz I\'ve Got No Momma!"', style: TextStyle(fontSize: 16, color: Colors.black87)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Emoji Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF7C4DFF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('What is in your mind today?', style: TextStyle(fontSize: 18, color: Colors.black)),
                        SizedBox(height: 12),
                        
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Weekly Graphs
                  const Text('Weekly Graphs', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Stack(
                      children: [
                        // Bar Chart (dummy data)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildBar(60),
                              _buildBar(40),
                              _buildBar(70),
                              _buildBar(50),
                              _buildBar(90),
                              _buildBar(80),
                              _buildBar(55),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 18,
      height: height,
      decoration: BoxDecoration(
        color: Color(0xFFB56576),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}