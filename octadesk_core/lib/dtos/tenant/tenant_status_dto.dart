class TenantStatusDTO {
  final int blockRemainingDays;
  final List<dynamic> features;
  final bool paymentIssue;
  final String paymentIssueReason;
  final bool paymentPending;
  final String? paymentPendingBarCode;
  final String? paymentPendingUrl;
  final String subDomain;
  final bool trialExpired;
  final int trialRemainingDays;
  final bool isBlocked;
  final String tenantId;

  TenantStatusDTO({
    required this.tenantId,
    required this.blockRemainingDays,
    required this.features,
    required this.paymentIssue,
    required this.paymentIssueReason,
    required this.paymentPending,
    this.paymentPendingBarCode,
    this.paymentPendingUrl,
    required this.subDomain,
    required this.trialExpired,
    required this.trialRemainingDays,
    required this.isBlocked,
  });

  factory TenantStatusDTO.fromMap(Map<String, dynamic> data) {
    return TenantStatusDTO(
      blockRemainingDays: data["blockRemainingDays"],
      features: List.from(data["features"]),
      paymentIssue: data["paymentIssue"],
      paymentIssueReason: data["paymentIssueReason"],
      paymentPending: data["paymentPending"],
      subDomain: data["subDomain"],
      trialExpired: data["trialExpired"],
      trialRemainingDays: data["trialRemainingDays"],
      isBlocked: data["isBlocked"],
      tenantId: data["tenantId"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "blockRemainingDays": blockRemainingDays,
      "features": features,
      "paymentIssue": paymentIssue,
      "paymentIssueReason": paymentIssueReason,
      "paymentPending": paymentPending,
      "subDomain": subDomain,
      "trialExpired": trialExpired,
      "trialRemainingDays": trialRemainingDays,
      "isBlocked": isBlocked,
      "tenantId": tenantId,
    };
  }
}
