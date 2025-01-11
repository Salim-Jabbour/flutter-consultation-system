//TODO localisation
enum AlarmWeekDay {
  monday(1, "monday"),
  tuesday(2, "tuesday"),
  wednesday(3, "wednesday"),
  thursday(4, "thursday"),
  friday(5, "friday"),
  saturday(6, "saturday"),
  sunday(7, "sunday");

  const AlarmWeekDay(
      this.number, this.name); //hy al Ids r7 2t3aml m3ha b class al helper

  final int number;
  final String name;
}
