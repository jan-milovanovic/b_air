import 'package:flutter/material.dart';
import 'package:pediatko/audio_data.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({Key? key, required this.audioDataList}) : super(key: key);

  final List<AudioData> audioDataList;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Pediatko'),
          centerTitle: true,
          backgroundColor: Colors.grey.shade400,
        ),
        backgroundColor: const Color.fromARGB(234, 198, 204, 255),
        body: Column(
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                  image: NetworkImage(audioDataList[0].imageUrl),
                  width: width / 2),
            ),
            Text(
              audioDataList[0].showName,
              style: const TextStyle(fontSize: 20),
            ),
            Text(audioDataList[0].showDescription),
            const Spacer(
              flex: 1,
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 247, 249, 255),
                border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: SizedBox(
                height: height / 3,
                child: ListView.builder(
                    itemCount: audioDataList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          audioDataList[index].playAudio(context);
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(height: 50, width: 20),
                                const Icon(
                                  Icons.play_arrow_outlined,
                                  size: 40,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      audioDataList[index].title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            divideBetween(audioDataList.length, index),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ));
  }

  divideBetween(int listLength, int index) {
    return listLength > (index + 1)
        ? const Divider(
            color: Colors.black,
            indent: 20,
            endIndent: 20,
          )
        : const SizedBox(height: 5);
  }
}
