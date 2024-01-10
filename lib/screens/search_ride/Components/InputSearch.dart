import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../size_config.dart';

class InputDepart extends StatefulWidget {
  const InputDepart({Key? key}) : super(key: key);

  @override
  State<InputDepart> createState() => _InputDepartState();
}

class _InputDepartState extends State<InputDepart> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _data = [];
  List<Map<String, String>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // TODO: Use the obtained position to sort placemarks by proximity
    // and populate the _data list with the sorted placemarks.

    setState(() {
      print(position);
      print(placemarks);
      _data = [
        {
          'name': 'Sesame University',
          'country': 'Technopole El Ghazela, Ariana El Soghra',
        },
        {
          'name': 'Esprit School Of Business',
          'country': 'Technopole El Ghazela, Ariana El Soghra',
        },
        ...placemarks.map((placemark) {
          return {
            'name': placemark.name.toString(),
            'country': placemark.locality.toString() +
                " " +
                placemark.subLocality.toString() +
                " " +
                placemark.subAdministrativeArea.toString(),
          };
        }).toList()
      ];
      _filteredData.addAll(_data);
    });
  }

  void _filterData(String query) {
    List<Map<String, String>> filteredList = [];
    filteredList.addAll(_data);
    if (query.isNotEmpty) {
      filteredList.retainWhere(
          (item) => item['name']!.toLowerCase().contains(query.toLowerCase()));
    }
    setState(() {
      _filteredData.clear();
      _filteredData.addAll(filteredList);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterData("");
  }

  void _onItemTap(String selectedItem) {
    setState(() {
      _searchController.text = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _searchController.text);
          },
        ),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Enter your starting point",
            prefixIcon: Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          onChanged: (query) => _filterData(query),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredData.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _filteredData[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 35.0, vertical: 5.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            child: ListTile(
              title: Text(
                item['name']!,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                item['country']!,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
              onTap: () => _onItemTap(item['name']!),
            ),
          );
        },
      ),
    );
  }
}
