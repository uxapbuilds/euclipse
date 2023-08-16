import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/models/assignmentsListData_Model.dart';
import 'package:euclipse/models/projectListData_Model.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/utility/utility.dart';
import 'package:euclipse/widgets/form_diags/assignment_form_dialog.dart';
import 'package:euclipse/widgets/form_diags/project_form_diaglog.dart';
import 'package:euclipse/widgets/see_more.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectsList extends StatefulWidget {
  const ProjectsList({this.type = SeeMoreType.PROJECTS, Key? key})
      : super(key: key);
  final SeeMoreType type;

  @override
  State<ProjectsList> createState() => _TaskListState();
}

class _TaskListState extends State<ProjectsList> {
  late HomeCubit _homeCubit;
  List<ProjecttListDataModel> _currentTasks = [];
  bool isAscPriority = false;
  bool isAscEndTime = false;
  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    loadCurrentTasks();
  }

  @override
  void didUpdateWidget(covariant ProjectsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadCurrentTasks();
  }

  void loadCurrentTasks() {
    _currentTasks = _homeCubit.projectsDataList;
  }

  void onNewTask() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ProjectFormDialog(
            preSelectedDate: DateTime.now(),
            lastIndex: _homeCubit.projecttLastIndex,
          );
        }).then(
      (_) {
        loadCurrentTasks();
        _homeCubit.updateProgressData();
      },
    );
  }

  void onDeleteTask(int i) {
    var id = _homeCubit.projectsDataList
        .indexWhere((element) => element.taskId == i);
    _homeCubit.removeProject(id);
    loadCurrentTasks();
    _homeCubit.updateProgressData();
  }

  void onComplete(int i) {
    /*
    TODO post sort complete action reverts the list back to original
    */
    var id = _homeCubit.projectsDataList
        .indexWhere((element) => element.taskId == i);
    _homeCubit.projectsDataList[id].isComplete =
        !_homeCubit.projectsDataList[id].isComplete;
    _homeCubit.updateProjectData(id);
    _homeCubit.updateProgressData();
  }

  bool onRemindTask(int i) {
    // var id =
    //     _homeCubit.assignmentsDataList.indexWhere((element) => element.taskId == i);
    return true;
  }

  Widget myTeamPopUp(BuildContext context, Map<int, String> teamMembers) {
    var _style = Theme.of(context)
        .textTheme
        .headline1!
        .copyWith(fontSize: 10, fontWeight: FontWeight.normal);
    return Row(
      children: [
        vMargin(
            height: MediaQuery.of(context).size.height * .11,
            color: black.withOpacity(.2)),
        const SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Team',
              style: _style.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 80,
              width: 110,
              child: teamMembers.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: teamMembers.entries
                              .map(
                                (e) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 4),
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.black.withOpacity(.03)),
                                  child: Text(
                                    e.value,
                                    style: _style,
                                  ),
                                ),
                              )
                              .toList()),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(.03)),
                      child: Center(
                        child: Text(
                          'Lone Wolf',
                          style: _style,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, snapshot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          contentActionBar(context,
              selectedIndex: _homeCubit.selectedTaskIndex,
              title: taskTypeString(widget.type),
              onAdd: () => onNewTask(),
              showSeeMore: false,
              trailling: Row(
                children: [
                  addButton(),
                  // sortPopUpMenu(context),
                ],
              )),
          const SizedBox(
            height: 8,
          ),
          _currentTasks.isEmpty
              ? Container(
                  margin: const EdgeInsets.only(
                      left: 0, right: 0, top: 8, bottom: 30),
                  child: emptyDataContainer(context,
                      hPadding: 0,
                      title: 'No ${taskTypeString(widget.type)} remaining.',
                      width: MediaQuery.of(context).size.width),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _currentTasks
                        .asMap()
                        .map(
                          (index, _taskData) => MapEntry(
                            index,
                            projectContentCard(
                              context,
                              _taskData,
                              teamPopUp:
                                  myTeamPopUp(context, _taskData.teamMembers),
                              onDelete: () => onDeleteTask((_taskData).taskId),
                              onComplete: () => onComplete((_taskData).taskId),
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ),
                )
        ],
      );
    });
  }
}
