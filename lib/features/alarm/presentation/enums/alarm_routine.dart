enum AlarmRoutine {
  daily('يومي'),
  weekly('اسبوعي'),
  monthly('شهري');

  const AlarmRoutine(this.name);
  final String name;
}
