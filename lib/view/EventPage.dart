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
}
