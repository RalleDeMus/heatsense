part of heatsense;

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 40);

  final List<Widget> _widgetOptions = [
    Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.location_pin),
            Text(
              'Sweden',
              style: optionStyle,
            ),
            Text('19° Feels like: 26°'),
            Text('No risk of heatstroke'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.black,
        onPressed: () {},
        child: const Icon(Icons.bluetooth),
      ),
    ),
    Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            title: Text('Event 1'),
            subtitle: Text('08-01-2024'),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            TextButton(
              child: const Text('Edit Event'),
              onPressed: () {/* ... */},
            ),
            const SizedBox(width: 4),
          ]),
        ],
      ),
    ),
    Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('Event 2'),
            subtitle: Text('08-01-2024'),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            TextButton(
              child: const Text('Edit Event'),
              onPressed: () {/* ... */},
            ),
            const SizedBox(width: 4),
          ]),
        ],
      ),
    )
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
