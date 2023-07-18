import 'package:flutter/material.dart';
import 'dart:math';

import 'package:pediatko/pages/recording_player/components/hidden_thumb_component_shape.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final Color? color;

  const SeekBar(
      {Key? key,
      required this.duration,
      required this.position,
      required this.bufferedPosition,
      this.onChanged,
      this.onChangeEnd,
      this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            overlayShape: const RoundSliderOverlayShape(),
            activeTrackColor:
                widget.color?.withOpacity(0.3) ?? Colors.blue.shade100,
            inactiveTrackColor:
                widget.color?.withOpacity(0.1) ?? Colors.grey.shade200,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            activeTrackColor: widget.color,
            thumbColor: widget.color,
            overlayColor: widget.color?.withOpacity(0.3),
            activeTickMarkColor: widget.color,
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 18.0,
          bottom: 0.0,
          child: Row(
            children: [
              Text(
                  RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                          .firstMatch("${widget.position}")
                          ?.group(1) ??
                      '${widget.position}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(' / ', style: Theme.of(context).textTheme.bodySmall),
              Text(
                  RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                          .firstMatch("${widget.duration}")
                          ?.group(1) ??
                      '${widget.duration}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),

              /**
               * Text widget contains "remaining" duration
               * Remove the row + other texts if you'd like to use this instead
               * 
              Text(
                  RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                          .firstMatch("$_remaining")
                          ?.group(1) ??
                      '$_remaining',
                  style: Theme.of(context).textTheme.caption),
                */
            ],
          ),
        ),
      ],
    );
  }

  //Duration get _remaining => widget.duration - widget.position;
}
