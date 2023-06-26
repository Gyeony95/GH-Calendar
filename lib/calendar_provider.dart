import 'package:flutter/material.dart';
import 'package:gh_calendar/date_util.dart';

class CalendarProvider extends ChangeNotifier {
  final bool isPeriodSelect;
  final List<DateTime>? targetDate;
  final Function(List<DateTime>)? onChanged;

  DateTime curMonth = DateTime.now();
  List<DateTime> curSelect = [];
  List<DateTime> _tempSelect = [];
  final DateTime? activeMinDate;
  final DateTime? activeMaxDate;

  CalendarProvider({
    required this.isPeriodSelect,
    this.targetDate,
    this.onChanged,
    this.activeMinDate,
    this.activeMaxDate,
  });

  void changeCurMonth(int index) {
    curMonth = makeDateTimeByIndex(index);
    notifyListeners();
  }

  void clearSelected() {
    curSelect.clear();
    _tempSelect.clear();

    if (onChanged != null) {
      onChanged!(curSelect);
    }

    notifyListeners();
  }

  /// 날짜 선택 함수
  void changeCurSelect(DateTime select) {
    if (isPeriodSelect) {
      // 첫선택
      if (_tempSelect.isEmpty) {
        _tempSelect = [select];
      } else {
        // 이미 기간선택이 되어있는 경우
        if (_tempSelect.length >= 2) {
          _tempSelect = [select];
        } else {
          if (_tempSelect[0].isSameDate(select)) {
            _tempSelect = [];
          } else {
            DateTime startDate = _tempSelect[0];
            _tempSelect = [];
            // 처음 선택된 날짜와 비교
            var diffDay = select.difference(startDate).inDays;
            for (int i = 0; i <= diffDay.abs(); i++) {
              var periodDate = DateTime(
                startDate.year,
                startDate.month,
                diffDay.isNegative
                    ? startDate.day + diffDay + i
                    : startDate.day + diffDay - i,
              );
              _tempSelect.add(periodDate);
            }
          }
        }
      }
    } else {
      _tempSelect = [select];
    }
    // 날짜 정렬
    _tempSelect.sort((a, b) {
      return a.compareTo(b);
    });
    curSelect = _tempSelect;
    onChanged!(_tempSelect);
    notifyListeners();
  }

  bool isEnableDate(DateTime date) {
    if (activeMaxDate != null) {
      if (date.isAfter(activeMaxDate!)) {
        return false;
      }
    }
    if (activeMinDate != null) {
      if (date.isBefore(activeMinDate!)) {
        return false;
      }
    }
    return true;
  }

  DateTime makeDateTimeByIndex(int index) {
    var year = index ~/ 12;
    var month = index % 12 + 1;

    return DateTime(year, month);
  }
}
