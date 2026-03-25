import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/custom_button.dart';
import 'auth/login_screen.dart'; // to be created

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Find Amazing Events',
      'description': 'Discover concerts, tech talks, food festivals and more near you.',
      'image': 'assets/images/onboard1.png',
      'icon': 'search'
    },
    {
      'title': 'Book Tickets Easily',
      'description': 'Choose your seats and pay securely in just a few taps.',
      'image': 'assets/images/onboard2.png',
      'icon': 'confirmation_number'
    },
    {
      'title': 'Scan & Enter',
      'description': 'Get a unique QR code for seamless check-in at the venue.',
      'image': 'assets/images/onboard3.png',
      'icon': 'qr_code_scanner'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => OnboardContent(
                  title: onboardingData[index]['title']!,
                  description: onboardingData[index]['description']!,
                  iconStr: onboardingData[index]['icon']!,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index, context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomButton(
                text: _currentPage == onboardingData.length - 1 ? 'Get Started' : 'Continue',
                onPressed: () {
                  if (_currentPage == onboardingData.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentPage == index ? 24 : 10,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentPage == index ? AppTheme.primaryColor : Colors.grey.withOpacity(0.5),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  final String title, description, iconStr;

  const OnboardContent({
    super.key,
    required this.title,
    required this.description,
    required this.iconStr,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (iconStr == 'search') {
      icon = Icons.search;
    } else if (iconStr == 'confirmation_number') icon = Icons.confirmation_number;
    else icon = Icons.qr_code_scanner;

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withOpacity(0.1),
            ),
            child: Icon(icon, size: 100, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 60),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
