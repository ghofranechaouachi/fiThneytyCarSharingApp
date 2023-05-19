import 'package:flutter/material.dart';

import '../../../size_config.dart';

class SearchPosition extends StatefulWidget {
  const SearchPosition({Key? key}) : super(key: key);

  @override
  State<SearchPosition> createState() => _SearchPositionState();
}

class _SearchPositionState extends State<SearchPosition> {
  TextEditingController _searchController = TextEditingController();
  List<String> _data = [    "New York City",   "Los Angeles",   "San Francisco", "Seattle",    "Elderberry",    "Fig",    "Grapes",    "Honeydew",    "Jackfruit",    "Kiwi",    "Lemon",    "Mango",    "Nectarine",    "Orange",    "Papaya",    "Quince",    "Raspberry",    "Strawberry",    "Tangerine",    "Ugli Fruit",    "Watermelon",  ];
  List<String> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData.addAll(_data);
  }

  void _filterData(String query) {
    List<String> filteredList = [];
    filteredList.addAll(_data);
    if (query.isNotEmpty) {
      filteredList.retainWhere((item) => item.toLowerCase().contains(query.toLowerCase()));
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
                item,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                "Item $index",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
              onTap: ()=> _onItemTap(item),
            ),
          );
        },
      ),
    );
  }
}