import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Import geocoding package
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String _status = 'Safe'; // Tracks the safety status
  Color _buttonColor = Colors.green; // Button color when safe
  String _address = ''; // To store the full address
  String _coordinates = ''; // To store the coordinates
  final TextEditingController _noteController =
      TextEditingController(); // Controller for the TextField
  String _savedNote = ''; // To store the saved note

  @override
  void initState() {
    super.initState();
    _loadSavedNote(); // Load the saved note when the app starts
  }

  // Load saved note from Shared Preferences
  void _loadSavedNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedNote =
          prefs.getString('note') ?? ''; // Load the note or set to empty
      _noteController.text = _savedNote; // Set the controller's text
    });
  }

  // Save note to Shared Preferences
  void _saveNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('note', _noteController.text); // Save the note
    setState(() {
      _savedNote = _noteController.text; // Update the saved note
    });
  }

  // Panic Button Handler
  void _triggerPanicButton() async {
    // Check location permission before accessing the device's location
    var permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      // Using LocationSettings to get the position
      var position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter:
              10, // Minimum distance (in meters) before location updates
        ),
      );

      // Reverse geocoding to get the full address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Get the first Placemark and extract the address details
      Placemark placemark = placemarks.first;
      String fullAddress =
          '${placemark.street}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';

      // Update the status to include location and address
      setState(() {
        _status = 'Emergency Mode'; // Update status to Emergency Mode
        _coordinates =
            'Coordinates: ${position.latitude}, ${position.longitude}'; // Save coordinates
        _address = fullAddress; // Save the full address
        _buttonColor = Colors.red; // Change button color to red
      });
    } else {
      // Handle permission denied (optional)
      setState(() {
        _status = 'Location Permission Denied';
        _address = ''; // Clear address if permission is denied
        _coordinates = ''; // Clear coordinates if permission is denied
        _buttonColor = Colors.grey; // Change button color to grey
      });
    }
  }

  // Reset Status to Safe
  void _resetStatus() {
    setState(() {
      _status = 'Safe';
      _address = ''; // Clear address when resetting
      _coordinates = ''; // Clear coordinates when resetting
      _buttonColor = Colors.green;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black87, // Dark background for a high-contrast look
      appBar: AppBar(
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Spread out the children
          children: [
            Flexible(
              child: Text(
                'Women’s Security App',
                style: TextStyle(
                  fontSize: 18,
                ),
                overflow:
                    TextOverflow.ellipsis, // Ensure the text doesn't overflow
              ),
            ),
            Image.asset(
              'assets/helmet.png',
              height: 50,
              // width: 40, // Optional, adjust width if needed
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // TextField for notes
                Visibility(
                  visible: _status !=
                      'Emergency Mode', // Hide when in Emergency Mode
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            hintText: 'Your name (optional)',
                            hintStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white12,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: _saveNote, // Save note when pressed
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Safety status display
                Center(
                  child: Text(
                    'Current Status:\n $_status',
                    textAlign:
                        TextAlign.center, // Ensures multi-line text is centered
                    style: TextStyle(
                      color: _status == 'Safe' ? Colors.green : Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Panic button
                GestureDetector(
                  onTap: _triggerPanicButton,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: _buttonColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(),
                          spreadRadius: 5,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Panic\nButton',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Optional Status Indicator
                AnimatedSwitcher(
                  duration: Duration(seconds: 1),
                  child: _status == 'Safe'
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 80,
                        )
                      : Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 80,
                        ),
                ),
                SizedBox(height: 10),

                // Additional instructions or actions
                Text(
                  _status == 'Safe'
                      ? 'Stay safe, always be aware!'
                      : 'Help is on the way!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                // Display the full address and coordinates in the same section
                if (_address.isNotEmpty && _coordinates.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        Text(
                          'Address:\n$_address',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _coordinates, // Display coordinates here
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Show Reset Button when the status is Emergency Mode
                Visibility(
                  visible: _status == 'Emergency Mode',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: _resetStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Button color
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        'Reset to Safe',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
