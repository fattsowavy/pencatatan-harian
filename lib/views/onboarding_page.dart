import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data untuk setiap slide onboarding
  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'lib/assets/images/onboarding1.png',
      'title': 'Catat Pengeluaran dengan Mudah',
      'description': 'Tambahkan pengeluaran harian Anda dalam hitungan detik.'
    },
    {
      'image': 'lib/assets/images/onboarding2.png',
      'title': 'Pantau Keuangan Anda',
      'description': 'Lihat ringkasan pengeluaran per kategori dengan jelas.'
    },
    {
      'image': 'lib/assets/images/onboarding3.png',
      'title': 'Atur Target dan Peringatan',
      'description': 'Tetapkan target bulanan dan dapatkan peringatan otomatis.'
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Image.asset(
                        _onboardingData[index]['image']!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Text(
                          _onboardingData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _onboardingData[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                            height:
                                90), // Tambah ruang untuk menghindari tumpang tindih dengan titik
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Indikator titik (dots)
          Positioned(
            bottom: 10, // Kurangi jarak dari bawah, lebih dekat ke tombol
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          // Tombol "Mulai Sekarang" hanya di slide terakhir
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Visibility(
              visible: _currentPage == _onboardingData.length - 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: _navigateToLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Mulai Sekarang'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
