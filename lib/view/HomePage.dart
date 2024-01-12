part of heatsense;

MovesenseHRMonitor monitor = MovesenseHRMonitor(""); //0C:8C:DC:3F:B2:CD

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const TextStyle optionStyle = TextStyle(fontSize: 40);

  //final MovesenseHRMonitor monitor = MovesenseHRMonitor(""); //0C:8C:DC:3F:B2:CD

  Future<void> _returnwithconnection(BuildContext context) async {
    final deviceAddress = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ScanPage()));
    setState(() {});

    monitor = MovesenseHRMonitor(deviceAddress);
    monitor.connect(monitor);
    Timer(const Duration(seconds: 5), () {});

    monitor.startTemp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ElevatedButton(
                onPressed: () {
                  _returnwithconnection(context);
                },
                child: const Text('Scan for devices')),
          ])),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          onPressed: () {
            if (monitor.isRunning) {
              monitor.stopHR();
            } else {
              monitor.startHR();
            }
          },
          child: StreamBuilder<DeviceState>(
            stream: monitor.stateChange,
            builder: (context, snapshot) => (monitor.isRunning)
                ? const Icon(Icons.stop)
                : const Icon(Icons.play_arrow),
          )),
    );
  }
}

/*class ScanRoute extends StatefulWidget{
  const ScanRoute({super.key});
  @override
  State<ScanRoute> createState() => _ScanRouteState();
}

class _ScanRouteState extends State<ScanRoute> {
  

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _returnwithconnection(context);
        },
        child: const Text('Scan for devices'));
  }

  Future<void> _returnwithconnection(BuildContext context) async {
    final deviceAddress = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ScanPage()));
  }
}*/
