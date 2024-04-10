import 'package:flutter/material.dart';

class BottomNavigationBarWrapper extends StatefulWidget {
  final int initialIndex;
  final void Function(int) onItemTapped;

  const BottomNavigationBarWrapper({
    super.key,
    required this.initialIndex,
    required this.onItemTapped,
  });

  @override
  _BottomNavigationBarWrapperState createState() => _BottomNavigationBarWrapperState();
}

class _BottomNavigationBarWrapperState extends State<BottomNavigationBarWrapper> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onItemTapped(index);
      },
      selectedFontSize: 14,
      fixedColor: Colors.black,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.black,),
          label: "Accueil",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, color: Colors.black,),
          label: "Rechercher",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, color: Colors.black,),
          label: "Poster",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, color: Colors.black,),
          label: "Profil",
        ),
      ],
    );
  }
}
