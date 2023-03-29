import 'package:flutter/material.dart';
import 'package:pediatko/modals/show.dart';
import 'package:pediatko/pages/playlist_page.dart';

class MascotButton extends StatelessWidget {
  const MascotButton({Key? key, required this.show}) : super(key: key);

  final Show show;

  pageRouteAnimation(
    BuildContext context,
    Show show,
    dynamic key,
  ) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset? position = box?.localToGlobal(Offset.zero);
    double x = 0.0;
    double y = 0.0;

    Size size = MediaQuery.of(context).size;
    double iconSize = MediaQuery.of(context).size.width / 2 - 48.0;

    /// half of icon size
    /// this will be used to center position alignment
    final double halvedIconSize = iconSize * 0.5;

    /// normalize min max from -1 to 1
    /// position starts at top left corner, add size to center
    if (position != null) {
      x = ((position.dx + halvedIconSize) / size.width * 2) - 1;
      y = ((position.dy + halvedIconSize) / size.height * 2) - 1;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return PlaylistPage(show: show);
        },
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation =
              CurvedAnimation(parent: animation, curve: Curves.easeOutExpo);
          return ScaleTransition(
            alignment: Alignment(x, y),
            scale: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: show.bgColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: IconButton(
              key: globalKey,
              padding: const EdgeInsets.all(15),
              icon: Image.network(show.iconUrl),
              onPressed: () => pageRouteAnimation(context, show, globalKey),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          show.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
