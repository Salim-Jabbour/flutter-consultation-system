//TODO get the name from string resources.
enum AlarmRoutineType {
  acute('مدة محددة'),
  chronic('مزمن');

  const AlarmRoutineType(this.name);

  final String name;
}
