part of heatsense;

final MovesenseHRMonitor monitor = MovesenseHRMonitor('0C:8C:DC:1B:23:18');

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  bool light = true;

  static const TextStyle optionStyle = TextStyle(fontSize: 40);

  @override
  void initState() {
    super.initState();
    monitor.init();
  }

  final List<Widget> _widgetOptions = [
    Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.location_on_outlined,
                    size: 56,
                  ),
                  Text(
                    'Sweden',
                    style: optionStyle,
                  ),
                ]),
            const Text(
              '19°',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 64),
            ),
            const Text(
              'Feels like: 26°',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            const Text('No risk of heatstroke'),
            const SizedBox(
              height: 110,
            ),
            StreamBuilder<int>(
                stream: monitor.heartbeat,
                builder: (context, snapshot) {
                  var displayText = 'Heartrate: -- BPM';
                  if (snapshot.hasData) {
                    displayText = 'Heartrate: ${snapshot.data} BPM';
                  }
                  return Text(
                    displayText,
                    style: TextStyle(fontSize: 20),
                  );
                }),
            StreamBuilder<DeviceState>(
              stream: monitor.stateChange,
              builder: (context, snapshot) => Text(
                  'Device [${monitor.identifier}] - ${monitor.state.name}'),
            ),
            const SizedBox(
              height: 110,
            ),
            const Text(
              'Body Temperature: C°',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey,
        onPressed: () {},
        child: const Icon(Icons.bluetooth),
      ),
    ),
    const Route(),
    Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.person,
              size: 130,
            ),
            const Text(
              'Username',
              style: optionStyle,
            ),
            const SizedBox(
              height: 30,
            ),
            Switch(value: true, onChanged: null),
            Switch(value: true, onChanged: null),
            Switch(
              value: true,
              onChanged: null,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  if (monitor.isRunning) {
                    monitor.stop();
                  } else {
                    monitor.start();
                  }
                },
                child: const Text('Scan for devices')),
          ],
        ),
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

class Route extends StatelessWidget {
  const Route({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              title: Text('Event 1'),
              subtitle: Text('08-01-2024'),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              TextButton(
                child: const Text('Edit Event'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecondRoute()));
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  SecondRoute({super.key});
  var arrow = Icons.keyboard_arrow_right;

  void _onSymptomsTapped() {
    if (arrow == Icons.keyboard_arrow_down) {
      arrow = Icons.keyboard_arrow_right;
    } else {
      arrow = Icons.keyboard_arrow_down;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 15,
          ),
          Text(
            '12. October 2023',
            style: TextStyle(fontSize: 20),
          ),
          Text('08:31 AM', style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 50,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.favorite, size: 64),
            Text(
              '89 BPM',
              style: TextStyle(fontSize: 40),
            )
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.device_thermostat,
              size: 64,
            ),
            Text('40 C°', style: TextStyle(fontSize: 40))
          ]),
          SizedBox(
            height: 90,
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.text_snippet_outlined),
                    title: const Text('Symptoms'),
                    trailing: Icon(arrow),
                    onTap: _onSymptomsTapped,
                  ),
                ),
              ]),
        ]),
      ),
    );
  }
}
