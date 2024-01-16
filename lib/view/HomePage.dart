part of heatsense;

//MovesenseHRMonitor monitor = MovesenseHRMonitor("");

class HomePage extends StatefulWidget {
  final HomePageViewModel model;
  const HomePage({required this.model, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const TextStyle optionStyle = TextStyle(fontSize: 40);

  //0C:8C:DC:3F:B2:CD

  /*  Future<void> _returnwithconnection(BuildContext context) async {
    final deviceAddress = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScanPage()));
    setState(() {});

    monitor = MovesenseHRMonitor(deviceAddress);
    monitor.connect(monitor);
    Timer(const Duration(seconds: 5), () {});

    //monitor.startTemp();
  } */

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
                height: 70,
              ),
              ListenableBuilder(
                listenable: widget.model,
                builder: (BuildContext context, child) => StreamBuilder<int>(
                    stream: widget.model.hr,
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
              ),
              const SizedBox(
                height: 70,
              ),
              ListenableBuilder(
                listenable: widget.model,
                builder: (BuildContext context, child) => StreamBuilder<String>(
                    stream: widget.model.temp,
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
              ),
              const SizedBox(
                height: 70,
              ),
              ListenableBuilder(
                  listenable: widget.model,
                  builder: (BuildContext context, child) =>
                      StreamBuilder<List<dynamic>>(
                          stream: widget.model.ecg,
                          builder: (context, snapshot) {
                            var displayText = 'ECG Data: -- ';
                            if (snapshot.hasData) {
                              displayText = 'ECG Data: ${snapshot.data} ';
                            }
                            return Text(
                              displayText,
                              style: TextStyle(fontSize: 20),
                            );
                          })),
              const SizedBox(
                height: 90,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ScanPage()));
                  },
                  child: const Text('Scan for devices')),
              const SizedBox(height: 10),
              StreamBuilder<DeviceState>(
                  stream: widget.model.stateChange,
                  builder: (context, snapshot) {
                    return Text('Device is currently: ${snapshot.data}',
                        style: const TextStyle(fontSize: 10));
                  })
            ]),
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          onPressed: () {
            if (widget.model.running) {
              widget.model.stop();
            } else {
              widget.model.start();
            }
          },
          child: StreamBuilder<DeviceState>(
            stream: widget.model.stateChange,
            builder: (context, snapshot) => (widget.model.running)
                ? const Icon(Icons.stop)
                : const Icon(Icons.play_arrow),
          )),
    );
  }
}
