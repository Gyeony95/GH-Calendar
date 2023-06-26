import 'package:flutter/material.dart';
import 'package:gh_calendar/date_util.dart';
import 'package:gh_calendar/tap_well.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'calendar_provider.dart';
import 'colors.dart';
import 'selectable.dart';

class CustomCalendar extends StatefulWidget {
  final bool isPeriodSelect;
  final int startWeekday;
  final List<DateTime>? targetDate;
  final Function(List<DateTime>)? onChanged;
  final DateTime? activeMinDate;
  final DateTime? activeMaxDate;
  Color touchableDateTextColor = Colors.black;
  Color unTouchableDateTextColor = Colors.grey;
  Color selectedDateTextColor = Colors.white;
  Color highlightColor = Colors.blueAccent;
  Color highlightPeriodColor = Colors.lightBlue;


  CustomCalendar({
    Key? key,
    this.isPeriodSelect = false,
    this.startWeekday = DateTime.sunday,
    this.targetDate,
    this.onChanged,
    this.activeMaxDate,
    this.activeMinDate,
    this.touchableDateTextColor = Colors.black,
    this.unTouchableDateTextColor = Colors.grey,
    this.selectedDateTextColor = Colors.white,
    this.highlightColor = Colors.blueAccent,
    this.highlightPeriodColor = Colors.lightBlue,
  }) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late PageController _pageController;

  @override
  void initState() {
    var now = DateTime.now();
    _pageController = PageController(
      initialPage: now.year * 12 + now.month - 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarProvider(
          isPeriodSelect: widget.isPeriodSelect,
          targetDate: widget.targetDate,
          onChanged: widget.onChanged,
          activeMaxDate: widget.activeMaxDate,
          activeMinDate: widget.activeMinDate),
      builder: (context, child) {
        return _CustomCalendarInternal(
          pageController: _pageController,
          isPeriodSelect: widget.isPeriodSelect,
          startWeekday: widget.startWeekday,
          targetDate: widget.targetDate,
          onChanged: widget.onChanged,
          activeMaxDate: widget.activeMaxDate,
          activeMinDate: widget.activeMinDate,
          touchableDateTextColor: widget.touchableDateTextColor,
          unTouchableDateTextColor: widget.unTouchableDateTextColor,
          selectedDateTextColor: widget.selectedDateTextColor,
          highlightColor: widget.highlightColor,
          highlightPeriodColor: widget.highlightPeriodColor,
        );
      },
    );
  }
}

class _CustomCalendarInternal extends StatelessWidget {
  final PageController pageController;

  final bool isPeriodSelect;
  final int startWeekday;
  final List<DateTime>? targetDate;
  final Function(List<DateTime>)? onChanged;
  final DateTime? activeMinDate;
  final DateTime? activeMaxDate;
  Color touchableDateTextColor = Colors.black;
  Color unTouchableDateTextColor = Colors.grey;
  Color selectedDateTextColor = Colors.white;
  Color highlightColor = Colors.blueAccent;
  Color highlightPeriodColor = Colors.lightBlue;


  final _elements = <SelectableElement>{};

  _CustomCalendarInternal({
    Key? key,
    required this.pageController,
    required this.isPeriodSelect,
    required this.startWeekday,
    this.targetDate,
    this.onChanged,
    this.activeMinDate,
    this.activeMaxDate,
    this.touchableDateTextColor = Colors.black,
    this.unTouchableDateTextColor = Colors.grey,
    this.selectedDateTextColor = Colors.white,
    this.highlightColor = Colors.blueAccent,
    this.highlightPeriodColor = Colors.lightBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(
      context,
      listen: false,
    );

    return Column(
      children: [
        Selector<CalendarProvider, DateTime>(
          selector: (context, provider) => provider.curMonth,
          builder: (context, value, child) {
            return monthWidget(context, value);
          },
        ),
        const SizedBox(height: 4),
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemBuilder: (context, index) {
              var curMonth = calendarProvider.makeDateTimeByIndex(index);

              return dayWidget(curMonth);
            },
            onPageChanged: (index) {
              calendarProvider.changeCurMonth(index);
            },
          ),
        ),
      ],
    );
  }

  Widget monthWidget(BuildContext context, DateTime curMonth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TapWell(
          onTap: () => pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
            child: Icon(
              Icons.chevron_left_sharp,
              color: cE3E3E3,
            ),
          ),
        ),
        Text(
          DateFormat.yMMM().format(curMonth),
          style: TextStyle(
            color: cE3E3E3,
            fontSize: 13,
          ),
        ),
        TapWell(
          onTap: () => pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          ),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 14, 0),
            child: Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> weekWidget(DateTime curMonth, int startDay) {
    return List.generate(
      DateTime.daysPerWeek,
      (index) {
        var dateWeek = curMonth.add(Duration(days: index - startDay));

        return Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              DateFormat.E().format(dateWeek),
              style: TextStyle(
                color: c888888,
                fontSize: 11,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget dayWidget(DateTime curMonth) {
    int startDay = 0;

    for (int i = 0; i < 7; i++) {
      var findWeekday = DateTime(
        curMonth.year,
        curMonth.month,
        curMonth.day - i,
      );

      if (findWeekday.weekday == startWeekday) {
        startDay = i;
        break;
      }
    }
    // var startDay = curMonth.weekday - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        return _calendarGrid(
          weeksWidget: weekWidget(curMonth, startDay),
          daysWidget: List.generate(
            DateTime(curMonth.year, curMonth.month + 1, 0).day + startDay,
            (index) {
              if (index < startDay) return const SizedBox();

              var curDay = DateTime(
                curMonth.year,
                curMonth.month,
                index - startDay + 1,
              );

              return _makeDay(context, index, curDay);
            },
          ),
        );
      },
    );
  }

  Widget _calendarGrid({
    required List<Widget> weeksWidget,
    required List<Widget> daysWidget,
  }) {
    var widgets = List.generate(
      (daysWidget.length - 1) ~/ 7 + 1,
      (y) {
        return Expanded(
          child: Row(
            children: List.generate(7, (x) {
              var index = y * 7 + x;

              if (daysWidget.length <= index) return const Spacer();

              return Expanded(
                child: daysWidget[index],
              );
            }),
          ),
        );
      },
    );

    return Column(
      children: [
        Expanded(
          child: Row(
            children: weeksWidget,
          ),
        ),
        ...widgets
      ],
    );
  }

  Widget _makeDay(BuildContext context, int index, DateTime curDay) {
    var isEnabled = Provider.of<CalendarProvider>(context).isEnableDate(
      curDay,
    );

    return IgnorePointer(
      ignoring: !isEnabled,
      child: Selectable(
        dateTime: curDay,
        onMountElement: _elements.add,
        onUnmountElement: _elements.remove,
        child: TapWell(
          onTap: () {
            Provider.of<CalendarProvider>(
              context,
              listen: false,
            ).changeCurSelect(curDay);
          },
          child: Selector<CalendarProvider, List<DateTime>>(
            selector: (context, provider) => provider.curSelect,
            builder: (context, curSelect, child) {
              var selected =
                  curSelect.indexWhere((date) => date.isSameDate(curDay)) != -1;

              return Stack(
                children: [
                  _selectDayWidget(selected, curSelect, curDay),
                  if (DateTime.now().isSameDate(curDay)) const SizedBox(),
                  isEnabled
                      ? _normalDayWidget(curDay, selected)
                      : _disabledDayWidget(curDay),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _selectDayWidget(
      bool selected, List<DateTime> curSelect, DateTime curDay) {
    if (!selected) return const SizedBox();
    // 여러개 선택된 상태인지
    bool isPeriodSelected = curSelect.length >= 2;
    var index = curSelect.indexWhere((date) => date.isSameDate(curDay));
    // 첫번째 날짜와 마지막 날짜를 기준으로 ui가 다름
    bool isMainDate = (index == 0) || (index == curSelect.length - 1);
    if (isPeriodSelected == false) {
      return Container(
        alignment: Alignment.center,
        child: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            color: highlightColor,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const SizedBox(),
        ),
      );
    }
    if (isMainDate == true) {
      bool isFirst = index == 0;

      return Container(
        alignment: Alignment.center,
        padding:
            EdgeInsets.only(left: isFirst ? 10 : 0, right: isFirst ? 0 : 10),
        child: Container(
          height: 24,
          width: double.infinity,
          decoration: BoxDecoration(
            color: highlightPeriodColor,
            borderRadius: BorderRadius.horizontal(
              left: isFirst ? const Radius.circular(2) : Radius.zero,
              right: isFirst ? Radius.zero : const Radius.circular(2),
            ),
          ),
          transform: Matrix4(
            1.005,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
          ),
          // 위젯 기간 선택시 사이를 매꿔주기 위해 매트릭스 사용
          padding:
              EdgeInsets.only(left: isFirst ? 0 : 10, right: isFirst ? 10 : 1),
          child: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: highlightColor,
              borderRadius: BorderRadius.circular(2),
            ),
            child: const SizedBox(),
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Container(
          height: 24,
          width: double.infinity,
          transform: Matrix4(
            1.005,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
          ),
          // 위젯 기간 선택시 사이를 매꿔주기 위해 매트릭스 사용
          color: highlightPeriodColor,
          child: const SizedBox(),
        ),
      );
    }
  }

  Widget _normalDayWidget(DateTime curDay, bool selected) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '${curDay.day}',
        style: TextStyle(
          color: selected ? selectedDateTextColor : touchableDateTextColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _disabledDayWidget(DateTime curDay) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '${curDay.day}',
        style: TextStyle(
          fontSize: 15,
          color: unTouchableDateTextColor,
        ),
      ),
    );
  }
}
