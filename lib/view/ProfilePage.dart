part of heatsense;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const TextStyle optionStyle = TextStyle(fontSize: 40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            /*StreamBuilder<DeviceState>(
              stream: monitor.stateChange,
              builder: (context, snapshot) => Text(
                  'Device [${monitor.identifier}] - ${monitor.state.name}'),
            ),*/
          ],
        ),
      ),
    );
  }
}
