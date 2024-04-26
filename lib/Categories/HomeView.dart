import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
              'https://cdn.pixabay.com/photo/2018/08/03/12/18/wolf-3581809_640.jpg'),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.sort_outlined,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
              child: Image(
                image: NetworkImage(
                  'https://cdn.pixabay.com/photo/2017/01/31/13/45/checklist-2024181_640.png',
                ),
                height: 100,
              ),
            ),
            SizedBox(height: 3.0),
            Text(
              'What do you want to do today?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              'Tap + to add your tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.deepPurpleAccent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: 0,
          backgroundColor: Color(0x7A9E9E9E),
          items: [
            const BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 25,
              ),
            ),
            const BottomNavigationBarItem(
              label: 'Calendar',
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 25,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Add',
              icon: Container(
                decoration: BoxDecoration(
                  color: Color(0xD17C4DFF),
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: const EdgeInsets.all(16),
                child: const Icon(Icons.add, size: 38.0, color: Colors.grey),
              ),
            ),
            const BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 25,
              ),
            ),
            const BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
          onTap: (int index) {
            switch (index) {
              case 1:
                break;
              case 2:
                break;
              case 3:
                break;
              case 4:
                break;
              default:
                break;
            }
          }),
    );
  }
}
