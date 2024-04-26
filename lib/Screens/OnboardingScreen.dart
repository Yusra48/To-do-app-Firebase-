import 'package:application/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';

class OnBoardingContent {
  final String image;
  final String title;
  final String description;

  OnBoardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnBoardingScreen extends StatefulWidget {
  final List<OnBoardingContent> contents = [
    OnBoardingContent(
      description: 'You can manage your tasks on My Todo for free,',
      title: 'Manage Your Daily Tasks,',
      image: 'images/Onboarding1.jpg',
    ),
    OnBoardingContent(
      description:
          'In My Todo you can create your daily routine to study productively,',
      title: 'Create Daily Routine',
      image: 'images/Onboarding 2.png',
    ),
    OnBoardingContent(
      description:
          'You can organize your daily tasks by adding your tasks into separate categories',
      title: 'Organize Your Tasks',
      image: 'images/Onboarding3.png',
    ),
  ];

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.contents.length,
              onPageChanged: (int index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (context, index) {
                final content = widget.contents[index];
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(content.image),
                        height: 300.0,
                      ),
                      Text(
                        content.title,
                        style: const TextStyle(
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF)),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        content.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.contents.length,
              (index) => BuildDot(index, currentIndex),
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.all(25.0),
            width: double.infinity,
            color: Colors.deepPurpleAccent,
            child: GestureDetector(
              onTap: () {
                if (currentIndex == widget.contents.length - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn,
                  );
                }
              },
              child: Center(
                child: Text(
                  currentIndex == widget.contents.length - 1
                      ? 'Continue'
                      : 'Next',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildDot extends StatelessWidget {
  final int index;
  final int currentIndex;

  const BuildDot(this.index, this.currentIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: currentIndex == index ? Colors.deepPurpleAccent : Colors.grey,
      ),
    );
  }
}
