import 'package:dashed_color_circle/dashed_color_circle.dart';
import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({Key? key}) : super(key: key);

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  late HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
  }

  int _getDashes(int count) {
    if (count == 0) {
      return 1;
    } else {
      return count;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Progress',
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(fontSize: 28),
            ),
            const SizedBox(
              width: 8,
            ),
            const Icon(
              Icons.timelapse,
              size: 28,
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          return Card(
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: black.withOpacity(.03)),
              height: 110,
              width: _mediaQuery.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _homeCubit.progressData.entries
                    .map((e) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  DashedColorCircle(
                                    dashes: _getDashes(e.value['total']!),
                                    size: 60.0,
                                    strokeWidth: 1.0,
                                    gapSize: 4,
                                    emptyColor: secondaryColor.withOpacity(.5),
                                    filledColor: Colors.green[800]!,
                                    fillCount: e.value['completed']! + 0.0,
                                    strokeCap: StrokeCap.round,
                                  ),
                                  FractionalTranslation(
                                    translation: const Offset(0.0, 0.4),
                                    child: Align(
                                      child: ClipOval(
                                        child: Container(
                                          height: 81,
                                          width: 81,
                                          child: Text(
                                            '${e.value['completed'].toString()} / ${e.value['total'].toString()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14),
                                          ),
                                          alignment:
                                              const FractionalOffset(0.5, 0.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              Utility().captialiseEachWord(e.key),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 12),
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
          );
        }),
      ],
    );
  }
}
