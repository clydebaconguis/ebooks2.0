import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  String? _savedDomainName;
  String? _selectedProtocol = 'http'; // Default protocol is http

  @override
  void initState() {
    super.initState();
    _loadSavedDomainName();
  }

  Future<void> _loadSavedDomainName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedDomainName = prefs.getString('domainname') ?? '';
      _selectedProtocol = prefs.getString('protocol') ?? _selectedProtocol;
    });
  }

  Future<void> _saveDomainNameAndProtocol(
      String domainName, String protocol, String port) async {
    String combinedDomain = '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (port.isEmpty) {
      combinedDomain = Uri(
        scheme: protocol,
        host: domainName,
      ).toString();
    } else {
      combinedDomain = Uri(
        scheme: protocol,
        host: domainName,
        port: int.parse(port),
      ).toString();
    }

    await prefs.setString('domainname', combinedDomain);
    // await prefs.setString('protocol', protocol);
    // await prefs.setString('port', port);
    setState(() {
      _savedDomainName = combinedDomain;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Domain name saved successfully!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  "Settings",
                  style: GoogleFonts.prompt(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff500a34), Color(0xffcf167f)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Protocol:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: _selectedProtocol,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProtocol = newValue;
                  });
                },
                items: <String>['http', 'https']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter Domain Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _domainController,
                decoration: const InputDecoration(
                  hintText: 'e.g., example.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter Port Number:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _portController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'e.g., 8000',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  _domainController.text.isNotEmpty
                      ? await _saveDomainNameAndProtocol(
                          _domainController.text,
                          _selectedProtocol!,
                          _portController.text,
                        )
                      : ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fill all fields!')),
                        );
                },
                child: const Text('Save'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Saved Domain:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                _savedDomainName != null
                    ? '$_savedDomainName'
                    : 'Not yet saved.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
