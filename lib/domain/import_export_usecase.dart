abstract class ImportExportUseCase {
  Future<String> exportDataToJson(bool exportCards, bool exportShopping);

  Future<void> importDataFromJson(String json);

  Future<String> exportDataToQrCode();

  Future<void> importDataFromQrCode(String qrData);
}
