part of heatsense;

class BottomNavigationBarHeatSense extends StatefulWidget {
  const BottomNavigationBarHeatSense({super.key, required this.model});
  final AppViewModel model;

  @override
  State<BottomNavigationBarHeatSense> createState() =>
      _BottomNavigationBarHeatSenseState();
}

class _BottomNavigationBarHeatSenseState
    extends State<BottomNavigationBarHeatSense> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [];

  _BottomNavigationBarHeatSenseState();

  @override
  void initState() {
    super.initState();
    _widgetOptions.add(HomePage(model: widget.model.homeModel));
    _widgetOptions.add(EventPage(model: widget.model.eventList));
    _widgetOptions.add(ProfilePage());
  }

/*   final List<Widget> _widgetOptions = [
    const HomePage(),
    EventPage(model: widget.model.eventList),
    const ProfilePage(),
  ]; */

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


