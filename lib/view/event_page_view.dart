part of heatsense;

/// The page where event history can be seen and accessed by the user.
// TODO - make eventpage update when an event is detected
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
      body: Center(
        child: Column(
          children: [
            ListenableBuilder(
              listenable: TimerHSDetector(),
              builder: (BuildContext context, Widget? child) =>
                  _buildDeviceList(TimerHSDetector().list.events),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade300,
        onPressed: () {
          TimerHSDetector().start();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDeviceList(List<HSEvent> events) {
    return Expanded(
        child: ListView.builder(
            itemCount: TimerHSDetector().list.events.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildDeviceItem(context, index)));
  }

  Widget _buildDeviceItem(BuildContext context, int index) {
    return Card(
      child: ListTile(
        title: Text('Event ${TimerHSDetector().list.events[index].eventId}'),
        subtitle: Text('${TimerHSDetector().list.events[index].timestamp}'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SecondRoute()));
        },
      ),
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
        backgroundColor: Colors.teal.shade300,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            height: 15,
          ),
          const Text(
            '12. October 2023',
            style: TextStyle(fontSize: 20),
          ),
          const Text('08:31 AM', style: TextStyle(fontSize: 20)),
          const SizedBox(
            height: 50,
          ),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.favorite,
              size: 64,
              color: Colors.red,
            ),
            Text(
              '89 BPM',
              style: TextStyle(fontSize: 40),
            )
          ]),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.device_thermostat,
              size: 64,
            ),
            Text('40 C°', style: TextStyle(fontSize: 40))
          ]),
          const SizedBox(
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
