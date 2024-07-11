import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class AnimatedProgressBar extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final List<Map<String, dynamic>>
      progressList; // {progress: 0.5, progressColor: Colors.blue, progressText: 'Progress', originalValue: 500000}
  final double height;
  final Map<String, dynamic> base; // {text: 'Base', value: 1000000}

  const AnimatedProgressBar({
    super.key,
    this.backgroundColor = Colors.grey,
    this.height = 17.0,
    required this.progressList,
    required this.base,
    required this.title,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  static BorderRadius borderRadius = BorderRadius.circular(10.0);

  late AnimationController _controller;
  late Animation<double> _animation;
  late List<Map<String, dynamic>> normalizedProgressList = widget.progressList;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
    normalizedProgressList = normalizeProgressList(widget.progressList);
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progressList != widget.progressList) {
      normalizedProgressList = normalizeProgressList(widget.progressList);
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> normalizeProgressList(
      List<Map<String, dynamic>> progressList) {
    double totalProgress = progressList.fold(0, (sum, item) {
      print("Item progress is: ${item['progress']}");
      return sum + item['progress'];
    });
    print("Total progress is: $totalProgress");

    if (totalProgress <= 1.0) {
      return progressList.map((item) {
        return {
          'progress': item['progress'].clamp(0.0, 1.0),
          'progressColor': item['progressColor']
        };
      }).toList();
    } else {
      return progressList.map((item) {
        double normalizedProgress = item['progress'] / totalProgress;
        return {
          'progress': normalizedProgress.clamp(0.0, 1.0),
          'progressColor': item['progressColor']
        };
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomAlignText(
        text: widget.title,
        style: textTheme.titleSmall,
        alignment: Alignment.center,
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
      const SizedBox(height: 7),
      ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: borderRadius,
            ),
            child: Stack(
              children: normalizedProgressList.asMap().entries.map((entry) {
                int index = entry.key;
                double progress = entry.value['progress'] * _animation.value;
                Color progressColor = entry.value['progressColor'];
                double cumulativeProgress = 0;

                for (int i = 0; i < index; i++) {
                  cumulativeProgress += normalizedProgressList[i]['progress'];
                }

                return Positioned(
                  left: cumulativeProgress * maxWidth,
                  child: Container(
                    width: progress * maxWidth,
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: borderRadius,
                    ),
                  ),
                );
              }).toList(),
            ),
          )),
      const SizedBox(height: 7),
      Wrap(
        spacing: 8.0, // Horizontal space between children
        runSpacing: 4.0, // Vertical space between lines
        alignment: WrapAlignment.spaceBetween,
        children: widget.progressList
            .map((progressValue) => _buildLegend(progressValue, textTheme))
            .toList(),
      ),
      const SizedBox(height: 7),
      const Divider(),
      Text(
        widget.base['text'] + ": " + formatAmountToVnd(widget.base['value']),
        style: textTheme.bodyMedium!
            .copyWith(fontFamily: 'Merriweather', fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 7),
      ...widget.progressList.map((progressValue) =>
          _buildExplanation(progressValue, widget.base, textTheme))
    ]);
  }

  Widget _buildLegend(Map<String, dynamic> progressValue, TextTheme textTheme) {
    return Row(
      children: [
        Icon(Icons.circle, color: progressValue['progressColor'], size: 16),
        const SizedBox(width: 4),
        Text(
          progressValue['progressText'],
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildExplanation(Map<String, dynamic> progressValue,
      Map<String, dynamic> base, TextTheme textTheme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(FontAwesomeIcons.fishFins,
                  color: progressValue['progressColor'], size: 16),
            ),
            const TextSpan(text: "   "), // Equivalent to SizedBox(width: 4)
            TextSpan(
              text: "${progressValue['progressText']} >< ${base['text']}",
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(FontAwesomeIcons.moneyBill,
                  color: progressValue['progressColor'].withOpacity(0.7),
                  size: 16),
            ),
            const TextSpan(text: "   "), // Equivalent to SizedBox(width: 4)
            TextSpan(
              text:
                  "${formatAmountToVnd(progressValue['originValue'])} >< ${formatAmountToVnd(base['value'])}",
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      const SizedBox(height: 5),
    ]);
  }
}
