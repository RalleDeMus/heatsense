part of heatsense;

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

@override
class _ScanPageState extends State<ScanPage> {
  MoveSenseDeviceController devicecontrol = MoveSenseDeviceController();

  @override
  void initState() {
    super.initState();
  }

  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan for Devices'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  devicecontrol.scan();
                  Timer(const Duration(seconds: 5), () {
                    reload();
                  });
                },
                child: Text('Start Scan')),
            _buildDeviceList(devicecontrol.devices),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceList(List<MovesenseHRMonitor> deviceList) {
    return Expanded(
        child: ListView.builder(
            itemCount: devicecontrol.devices.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildDeviceItem(context, index)));
  }

  Widget _buildDeviceItem(BuildContext context, int index) {
    return Card(
      child: ListTile(
        title: Text(devicecontrol.devices[index].name!),
        subtitle: Text(devicecontrol.devices[index].address!),
        //trailing: Text(devicecontrol.devices[index].connectionStatus.statusName),
        onTap: () => {
          devicecontrol.connect(devicecontrol.devices[index]),
          Navigator.pop(context, devicecontrol.devices[index].address),
        },
      ),
    );
  }
}
