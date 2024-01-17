part of heatsense;

/// The homepage where current data can be viewed and the scan page can be accessed.
class HomePage extends StatefulWidget {
  final HomePageViewModel model;
  const HomePage({required this.model, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const TextStyle dataStyle = TextStyle(fontSize: 20);
  static const SizedBox spacer = SizedBox(
    width: 10,
  );

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
                      size: 60,
                    ),
                    Text(
                      'Sweden',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 50),
                    ),
                  ]),
              const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '19°',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 60),
                    ),
                    Text(
                      'Feels like: 26°',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                    ),
                  ]),
              const Row(
                children: [
                  spacer,
                  Divider(
                    color: Colors.black,
                  ),
                  spacer,
                ],
              ),
              Container(
                height: 0.5,
                width: 360,
                color: Colors.black,
              ),
              const Text(
                'No risk of heatstroke',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 0.5,
                width: 360,
                color: Colors.black,
              ),
              const SizedBox(
                height: 50,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(
                  Icons.favorite_border,
                  size: 60,
                  color: Colors.red,
                ),
                ListenableBuilder(
                  listenable: widget.model,
                  builder: (BuildContext context, child) => StreamBuilder<int>(
                      stream: widget.model.hr,
                      builder: (context, snapshot) {
                        var displayText = '     --   BPM';
                        if (snapshot.hasData) {
                          displayText = '     ${snapshot.data}   BPM';
                        }
                        return Text(
                          displayText,
                          style: dataStyle,
                        );
                      }),
                ),
              ]),
              const SizedBox(
                height: 50,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.thermostat, size: 60, color: Colors.black),
                ListenableBuilder(
                  listenable: widget.model,
                  builder: (BuildContext context, child) =>
                      StreamBuilder<double>(
                          stream: widget.model.temp,
                          builder: (context, snapshot) {
                            var displayText = '    --    C°';
                            if (snapshot.hasData) {
                              displayText = '   ${snapshot.data}    C°';
                            }
                            return Text(
                              displayText,
                              style: dataStyle,
                            );
                          }),
                ),
              ]),
              const SizedBox(
                height: 50,
              ),
              Column(children: [
                const Icon(
                  Icons.monitor_heart_rounded,
                  size: 60,
                  color: Colors.black,
                ),
                ListenableBuilder(
                    listenable: widget.model,
                    builder: (BuildContext context, child) =>
                        StreamBuilder<List<dynamic>>(
                            stream: widget.model.ecg,
                            builder: (context, snapshot) {
                              var displayText = ' -- ';
                              if (snapshot.hasData) {
                                displayText = '${snapshot.data}';
                              }
                              return Text(
                                displayText,
                                style: const TextStyle(fontSize: 10),
                              );
                            })),
              ]),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade300),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScanPage()));
                },
                child: const Text('Scan for devices'),
              ),
              const SizedBox(height: 10),
              ListenableBuilder(
                  listenable: widget.model,
                  builder: (BuildContext context, child) =>
                      StreamBuilder<DeviceState>(
                          stream: widget.model.stateChange,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var text = _getText(snapshot.data!);
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Status: ',
                                      style: TextStyle(fontSize: 20)),
                                  text,
                                ],
                              );
                            } else {
                              return const Text(
                                'Status: Not yet connected',
                                style: TextStyle(fontSize: 20),
                              );
                            }
                            //return Text('Device is currently: ${snapshot.data}',
                            //style: const TextStyle(fontSize: 10));
                          })),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.black,
          backgroundColor: Colors.teal.shade300,
          onPressed: () {
            if (widget.model.running) {
              widget.model.stop();
            } else {
              widget.model.start();
            }
          },
          child: const Icon(Icons.play_arrow)),
    );
  }

  Widget _getText(DeviceState state) {
    switch (state) {
      case DeviceState.connected:
        return const Text(
          'Connected',
          style: TextStyle(fontSize: 20, color: Colors.blue),
        );
      case DeviceState.connecting:
        return const Text(
          'Connecting...',
          style: TextStyle(fontSize: 20, color: Colors.orange),
        );
      case DeviceState.disconnected:
        return const Text(
          'Disconnected',
          style: TextStyle(fontSize: 20, color: Colors.red),
        );
      case DeviceState.error:
        return const Text(
          'Error',
          style: TextStyle(fontSize: 20, color: Colors.red),
        );
      default:
        return const Text(
          'Sampling',
          style: TextStyle(fontSize: 20, color: Colors.green),
        );
    }
  }
}
