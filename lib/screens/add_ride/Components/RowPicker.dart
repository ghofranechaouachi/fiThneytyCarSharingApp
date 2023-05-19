import 'package:flutter/material.dart';

class RowPicker extends StatefulWidget {
  final String title;
  final int defaultValue;
  final Function(int) onChangeValue;

  const RowPicker(
      {required this.title,
      required this.onChangeValue,
      this.defaultValue = 2,
      Key? key})
      : assert(defaultValue >= 0),
        super(key: key);

  @override
  State<RowPicker> createState() => _RowPickerState();
}

class _RowPickerState extends State<RowPicker> {
  late int _count;
  @override
  void initState() {
    super.initState();
    _count = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
        const Spacer(),
        Text(_count.toString()),
        const SizedBox(
          width: 15,
        ),
        Row(
          children: [
            OutlinedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(10, 10)),
                ),
                onPressed: () {
                  setState(() {
                    _count += 1;
                  });
                  widget.onChangeValue(_count);
                },
                child: const Text(
                  "+",
                  style: TextStyle(fontSize: 22, color: Colors.orangeAccent),
                )),
            OutlinedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(15, 15)),
                ),
                onPressed: () {
                  if (_count > 0) {
                    setState(() {
                      _count -= 1;
                    });
                    widget.onChangeValue(_count);
                  }
                },
                child: const Text(
                  "-",
                  style: TextStyle(
                    fontSize: 22,
                     color: Colors.orangeAccent
                     )
                    ),
                )
          ],
        )
      ],
    );
  }
}