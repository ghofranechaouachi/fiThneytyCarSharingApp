import 'package:flutter/material.dart';


class filterInput extends StatefulWidget {
  final Map<String, dynamic> filterData;
   
  const filterInput({Key? key, required this.filterData}) : super(key: key);

  @override
  State<filterInput> createState() => _filterInputState();
}

class _filterInputState extends State<filterInput> {
  
  List<String> _filterOptions = [    'Option 1',    'Option 2',    'Option 3',    'Option 4',  ];
  String _selectedOption = '';

  List<String> _startingTimes = [    '9:00 AM',    '10:00 AM',    'This weekend',    'Next week',  ];
  String _selectedTime = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              widget.filterData['option'] =_selectedOption;
              widget.filterData['startTime'] = _selectedTime;
            });
            Navigator.pop(context,widget.filterData);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _filterOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.filter_list),
                    title: Text(_filterOptions[index]),
                    trailing: Radio(
                      value: _filterOptions[index],
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value.toString();
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 32.0),
              Text(
                'Starting time',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _startingTimes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_startingTimes[index]),
                    trailing: Radio(
                      value: _startingTimes[index],
                      groupValue: _selectedTime,
                      onChanged: (value) {
                        setState(() {
                          _selectedTime = value.toString();
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}