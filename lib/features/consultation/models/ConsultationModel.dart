class ConsultationModel {
  final String userName;
  final String userImage;
  final String consultationTitle;
  final String consultationSpecialization;
  final String consultationDescription;

  const ConsultationModel({
    this.userName="No User Name",
    this.userImage="Placeholder",
    this.consultationTitle="No Consultation Title",
    this.consultationSpecialization="No Consultation Specialization",
    this.consultationDescription="No Consultation Description",
  });
}
