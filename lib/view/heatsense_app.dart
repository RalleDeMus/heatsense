part of heatsense;

class BottomNavigationBarHeatSense extends StatefulWidget {
  const BottomNavigationBarHeatSense({super.key});

  @override
  State<BottomNavigationBarHeatSense> createState() =>
      _BottomNavigationBarHeatSenseState();
}

class _BottomNavigationBarHeatSenseState
    extends State<BottomNavigationBarHeatSense> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _widgetOptions = [
    const HomePage(),
    const EventPage(),
    const ProfilePage(),
  ];

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
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}



/*
class ScanSecondRoute extends StatefulWidget {
  const ScanSecondRoute({super.key});
  @override
  State<ScanSecondRoute> createState() => _ScanSecondRouteState();
}

class _ScanSecondRouteState extends State<ScanSecondRoute> {
  Widget _buildDeviceItem(BuildContext context, int index) {
    return Card(
      child: ListTile(
        title: Text(monitor.devices[index].name!),
        subtitle: Text(monitor.devices[index].address!),
        onTap: () => {},
      ),
    );
  }

  
*/


