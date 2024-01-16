part of heatsense;

class EventPage extends StatefulWidget {
  final EventPageViewModel model;

  const EventPage({required this.model, super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              TestHSDetector().start();
            },
            child: Text('start'),
          ),
          /* Center(child: _buildDeviceList(widget.model.events)), */
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
      ),
    );
  }

/*   Widget _buildDeviceList(List<HSEvent> events) {
    return Expanded(
        child: ListView.builder(
            itemCount: 1/* TimerHSDetector().list.length */,
            itemBuilder: (BuildContext context, int index) =>
                _buildDeviceItem(context, index)));
  }

  Widget _buildDeviceItem(BuildContext context, int index) {
    return Card(
        clipBehavior: Clip.hardEdge,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Event ${TimerHSDetector().list[index].eventId}'),
                subtitle: Text('${TimerHSDetector().list[index].timestamp}'),
                //trailing: Text(devicecontrol.devices[index].connectionStatus.statusName),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(child: const Text('Edit Event'), onPressed: () {}),
                ],
              )
            ]));
  }*/
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
}
