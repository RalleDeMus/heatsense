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
  static const TextStyle streamStyle = TextStyle(fontSize: 20);
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
        child: SingleChildScrollView(
          //SingleChildScrollView if device screen is too small to display all information
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.location_on_outlined,
                        size: 40,
                      ),
                      Text(
                        'Sweden',
                        style: optionStyle,
                      ),
                    ]),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '19°',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 25),
                      ),
                      Text(
                        'Feels like: 26°',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 25),
                      ),
                    ]),
                Divider(
                  color: Colors.black,
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
                          style: streamStyle,
                        );
                      }),
                ),
                const SizedBox(
                  height: 70,
                ),
                ListenableBuilder(
                  listenable: widget.model,
                  builder: (BuildContext context, child) =>
                      StreamBuilder<String>(
                          stream: widget.model.temp,
                          builder: (context, snapshot) {
                            var displayText = 'Body Temperature: -- C°';
                            if (snapshot.hasData) {
                              displayText =
                                  'Body Temperature: ${snapshot.data} C°';
                            }
                            return Text(
                              displayText,
                              style: streamStyle,
                            );
                          }),
                ),
                const SizedBox(
                  height: 70,
                ),
                ListenableBuilder(
                    listenable: widget.model,
                    builder: (BuildContext context, child) =>
                        StreamBuilder<List<String>>(
                            stream: widget.model.ecg,
                            builder: (context, snapshot) {
                              var displayText = 'ECG Data: -- ';
                              if (snapshot.hasData) {
                                displayText = 'ECG Data: ${snapshot.data} ';
                              }
                              return Text(
                                displayText,
                                style: streamStyle,
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
                    child: ListenableBuilder(
                    listenable: widget.model,
                    builder: (BuildContext context, child) => StreamBuilder<DeviceState>(
                      stream: widget.model.state,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String buttonText = _getButtonText(snapshot.data!);
                          return Text(buttonText);
                        } else {
                          return Text('Connect to device');
                        }
                      }, 
                    )),),
                //child: const Text('find device')),
                const SizedBox(height: 20),
                StreamBuilder<DeviceState>(
                    stream: widget.model.state,
                    builder: (context, snapshot) {
                      return Text('Device is currently: ${snapshot.data}',
                          style: const TextStyle(fontSize: 10));
                    })
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          onPressed: () {
            widget.model.startECGHR();
          },
          child: StreamBuilder<DeviceState>(
            stream: widget.model.state,
            builder: (context, snapshot) => (widget.model.running)
                ? const Icon(Icons.stop)
                : const Icon(Icons.play_arrow),
          )),
    );
  }

  String _getButtonText(DeviceState state) {
    switch (state) {
      case DeviceState.connected:
        return "Connected";
      case DeviceState.connecting:
        return "Connecting...";
      case DeviceState.disconnected:
        return "Disconnected";
      case DeviceState.error:
        return "Error";
      default:
        return "Unknown";
    }
  }
}
