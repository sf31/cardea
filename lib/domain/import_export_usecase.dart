abstract class ImportExportUseCase {
  Future<String> exportDataToJson();

  Future<void> importDataFromJson(String json);

  Future<String> exportDataToQrCode();

  Future<void> importDataFromQrCode(String qrData);
}
