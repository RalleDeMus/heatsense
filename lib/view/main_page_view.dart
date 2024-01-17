part of heatsense;

/// The main page of the app, which contains the bottom navigationbar.
class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.model});
  final AppViewModel model;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [];

  _MainPageState();

  @override
  void initState() {
    super.initState();
    _widgetOptions.add(HomePage(model: widget.model.homeModel));
    _widgetOptions.add(EventPage(model: widget.model.eventList));
    _widgetOptions.add(const ProfilePage());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HeatSense'),
        backgroundColor: Colors.teal.shade300,
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal.shade300,
        onTap: _onItemTapped,
      ),
    );
  }
}
