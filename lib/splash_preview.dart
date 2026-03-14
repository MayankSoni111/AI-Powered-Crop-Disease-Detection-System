import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splash Screen Preview',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreenPreview(),
    );
  }
}

class SplashScreenPreview extends StatefulWidget {
  const SplashScreenPreview({super.key});

  @override
  State<SplashScreenPreview> createState() => _SplashScreenPreviewState();
}

class _SplashScreenPreviewState extends State<SplashScreenPreview>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    
    // Start the fade-in animation
    _controller.forward();
    
    /* 
      As per the workflow: "initial start page that lasts for 1.5 sec (fade) is the uploaded photo..."
      In a real app, this is where we'd wait 1.5 - 2 seconds and navigate to the next screen.
      
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LanguageSelectionScreen()));
      });
    */
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        // The beautiful light green/white gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE2F3E7), // Light green tint at the top
              Colors.white,      // Fading to white
              Color(0xFFE2F3E7), // Light green tint at the bottom
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. The Avatar Graphic
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  // We simulate the provided character image with an icon and simple shapes
                  // In a real app with the asset, this would be Image.asset('assets/images/namaste.png')
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // The ground shadow
                      Positioned(
                        bottom: 40,
                        child: Container(
                          width: 120,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      // Representation of the character
                      const Icon(
                        Icons.person_pin, 
                        size: 140, 
                        color: Color(0xFF8D6E63) // Earth brown skin tone accent
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            
              // 2. Namaste Kisan Text
              const Text(
                'Namaste Kisan',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32), // Your requested Primary Green
                ),
              ),
              
              const SizedBox(height: 8),
              
              // 3. Orange Underline Accent
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFF57C00), // Requested orange accent
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(height: 60),
              
              // 4. Main App Title
              const Text(
                'Smart Crop Disease\nDetection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B2E35), // Very dark teal/navy for max contrast
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 5. Tagline
              const Text(
                'Smart Farming Powered by AI',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF43A047), // Slightly brighter green for tagline
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
