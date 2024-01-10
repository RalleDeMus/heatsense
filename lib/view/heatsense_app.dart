part of heatsense;

final MovesenseHRMonitor monitor = MovesenseHRMonitor('0C:8C:DC:3F:B2:CD');

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
                height: 90,
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
              const SizedBox(
                height: 90,
              ),
              StreamBuilder<String>(
                  stream: monitor.temperature,
                  builder: (context, snapshot) {
                    var displayText = 'Body Temperature: -- C°';
                    if (snapshot.hasData) {
                      displayText = 'Body Temperature: ${snapshot.data} C°';
                    }
                    return Text(
                      displayText,
                      style: TextStyle(fontSize: 20),
                    );
                  }),
              SizedBox(
                height: 100,
              ),
              ScanRoute(),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          onPressed: () {
            if (monitor.isRunning) {
              monitor.stopHR();
              monitor.stopTemp();
            } else {
              monitor.startHR();
              monitor.startTemp();
            }
          },
          child: StreamBuilder<DeviceState>(
            stream: monitor.stateChange,
            builder: (context, snapshot) => (monitor.isRunning)
                ? const Icon(Icons.stop)
                : const Icon(Icons.play_arrow),
          )),
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
            StreamBuilder<DeviceState>(
              stream: monitor.stateChange,
              builder: (context, snapshot) => Text(
                  'Device [${monitor.identifier}] - ${monitor.state.name}'),
            ),
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

class ScanRoute extends StatelessWidget {
  const ScanRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScanSecondRoute()));
        },
        child: const Text('Scan for devices'));
  }
}

class ScanSecondRoute extends StatefulWidget {
  const ScanSecondRoute({super.key});
  @override
  State<ScanSecondRoute> createState() => _ScanSecondRouteState();
}

class _ScanSecondRouteState extends State<ScanSecondRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan for Devices'),
      ),
      body: Text('Hello'),
    );
  }
}

class Route extends StatelessWidget {
  const Route({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Card(
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
      ]),
    );
  }
}

class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key});
  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  var arrow = Icons.keyboard_arrow_right;

  void _onSymptomsTapped() {
    setState(() {
      if (arrow == Icons.keyboard_arrow_down) {
        arrow = Icons.keyboard_arrow_right;
      } else {
        arrow = Icons.keyboard_arrow_down;
      }
    });
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

  /*Widget _buildDeviceItem(BuildContext context, int index) {
    return Card(
      child: ListTile(
        title: Text(model.deviceList[index].name!),
        subtitle: Text(model.deviceList[index].address!),
        trailing: Text(model.deviceList[index].connectionStatus.statusName),
        onTap: () => model.connectToDevice(model.deviceList[index]),
      ),
    );
  }

  Widget _buildDeviceList(List<Device> deviceList) {
    return new Expanded(
        child: new ListView.builder(
            itemCount: model.deviceList.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildDeviceItem(context, index)));
  }
  */
}
