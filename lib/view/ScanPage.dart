part of heatsense;

class ScanPage extends StatefulWidget {
  /*  final ScanPageViewModel model; */
  const ScanPage({/* required this.model, */ super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

@override
class _ScanPageState extends State<ScanPage> {
  @override
  void initState() {
    super.initState();
    MoveSenseDeviceController().scan();
    Timer(const Duration(seconds: 5), () {
      reload();
    });
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
            /* ElevatedButton(
                onPressed: () {
                  MoveSenseDeviceController().scan();
                  Timer(const Duration(seconds: 5), () {
                    reload();
                  });
                },
                child:  Text('Start Scan')),*/
            _buildDeviceList(MoveSenseDeviceController().devices),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceList(List<MovesenseHRMonitor> deviceList) {
    return Expanded(
        child: ListView.builder(
            itemCount: MoveSenseDeviceController().devices.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildDeviceItem(context, index)));
  }

  Widget _buildDeviceItem(BuildContext context, int index) {
    return Card(
      child: ListTile(
        title: Text(MoveSenseDeviceController().devices[index].name!),
        subtitle: Text(MoveSenseDeviceController().devices[index].address!),
        //trailing: Text(devicecontrol.devices[index].connectionStatus.statusName),
        onTap: () {
          //MoveSenseDeviceController().setConnectedDeviceByIndex(index);
          MoveSenseDeviceController().setConnectedDeviceAndConnect(
              MoveSenseDeviceController().devices[index]);
          Navigator.pop(context);
        },
      ),
    );
  }
}
