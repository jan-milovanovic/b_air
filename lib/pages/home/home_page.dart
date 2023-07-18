import 'package:flutter/material.dart';
import 'package:pediatko/modals/show.dart';
import 'package:pediatko/pages/home/components/mascot_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.showData}) : super(key: key);

  final List<Show> showData;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width / 2;

    return Container(
      color: Colors.white,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(32.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 32.0,
          mainAxisSpacing: 32.0,
          mainAxisExtent: iconSize,
        ),
        itemCount: widget.showData.length,
        itemBuilder: (context, index) {
          return MascotButton(show: widget.showData[index]);
        },
      ),
    );
  }
}
