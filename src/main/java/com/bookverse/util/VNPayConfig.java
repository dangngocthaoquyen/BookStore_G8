package com.bookverse.util;

/**
 * VNPay Configuration
 * Chứa các thông số cấu hình cho VNPay payment gateway
 */
public class VNPayConfig {

    // VNPay Payment Gateway URL
    public static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";

    // VNPay Terminal/Merchant Code
    public static final String VNP_TMN_CODE = "B77INC60";

    // Secret key for HMAC SHA512
    public static final String VNP_HASH_SECRET = "NU3W61XPNAW4DDRSYM30E0G4GL97VG7M";

    // VNPay API URL (for query, refund, etc.)
    public static final String VNP_API_URL = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";

    // Return URL after payment (will be set in application)
    public static String VNP_RETURN_URL = "http://localhost:8080/BookVerse/vnpay-return";

    // VNPay API Version
    public static final String VNP_VERSION = "2.1.0";

    // VNPay Command
    public static final String VNP_COMMAND = "pay";

    // Currency Code (VND)
    public static final String VNP_CURRENCY_CODE = "VND";

    // Locale
    public static final String VNP_LOCALE = "vn";

    // Order Type
    public static final String VNP_ORDER_TYPE = "other";
}
