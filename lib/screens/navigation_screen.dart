import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'history_screen.dart';
import 'recording_screen.dart';
import 'setting_screen.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/images/Navi/History.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            'assets/images/Navi/Add.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecordingScreen()),
            );
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            'assets/images/Navi/Setting.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            );
          },
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => DataListScreen()),
        //     );
        //   },
        //   child: Text('List'),
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => RecordingScreen()),
        //     );
        //   },
        //   child: Text('Recording'),
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => SettingScreen()),
        //     );
        //   },
        //   child: Text('Setting'),
        // ),
      ],
    );
  }
}
