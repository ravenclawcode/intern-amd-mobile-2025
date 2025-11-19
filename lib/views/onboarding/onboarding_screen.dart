import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  Future finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboarding_done", true);
    Navigator.pushReplacementNamed(context, "/dashboard");
  }

  final List<Map<String, String>> pages = [
    {
      "image": "https://cdn-icons-png.flaticon.com/512/1170/1170576.png",
      "title": "Catat Keuanganmu",
      "desc":
          "Kelola pemasukan dan pengeluaran harian dengan mudah dan teratur.",
    },
    {
      "image": "https://cdn-icons-png.flaticon.com/512/2920/2920244.png",
      "title": "Pantau Kondisi Finansial",
      "desc": "Lihat ringkasan pemasukan, pengeluaran, dan selisih total.",
    },
    {
      "image": "https://cdn-icons-png.flaticon.com/512/891/891462.png",
      "title": "Simpan Data Secara Offline",
      "desc": "Seluruh transaksi disimpan aman di perangkatmu, tanpa internet.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: finishOnboarding,
                child: Text(
                  "Lewati",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) {
                  setState(() => _currentIndex = i);
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Image.network(pages[index]["image"]!, height: 230),
                      const SizedBox(height: 40),
                      Text(
                        pages[index]["title"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          pages[index]["desc"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == i ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == i
                        ? Color(0xff030213)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == pages.length - 1) {
                      finishOnboarding();
                    } else {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Color(0xff030213),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentIndex == pages.length - 1 ? "Mulai" : "Lanjut",
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
