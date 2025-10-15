package com.bookverse.util;

import jakarta.servlet.http.HttpServletRequest;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * VNPay Utility Class
 * Xử lý các chức năng liên quan đến VNPay payment
 */
public class VNPayUtil {

    /**
     * Tạo URL thanh toán VNPay
     *
     * @param orderId     Mã đơn hàng
     * @param amount      Số tiền (VND)
     * @param orderInfo   Thông tin đơn hàng
     * @param ipAddress   IP address của người dùng
     * @return URL thanh toán VNPay
     */
    public static String createPaymentUrl(String orderId, long amount, String orderInfo, String ipAddress) {
        try {
            System.out.println("VNPayUtil.createPaymentUrl() started");

            // Tạo các tham số
            Map<String, String> vnpParams = new HashMap<>();

            vnpParams.put("vnp_Version", VNPayConfig.VNP_VERSION);
            vnpParams.put("vnp_Command", VNPayConfig.VNP_COMMAND);
            vnpParams.put("vnp_TmnCode", VNPayConfig.VNP_TMN_CODE);
            vnpParams.put("vnp_Amount", String.valueOf(amount * 100)); // VNPay yêu cầu amount * 100
            vnpParams.put("vnp_CurrCode", VNPayConfig.VNP_CURRENCY_CODE);
            vnpParams.put("vnp_TxnRef", orderId);
            vnpParams.put("vnp_OrderInfo", orderInfo);
            vnpParams.put("vnp_OrderType", VNPayConfig.VNP_ORDER_TYPE);
            vnpParams.put("vnp_Locale", VNPayConfig.VNP_LOCALE);
            vnpParams.put("vnp_ReturnUrl", VNPayConfig.VNP_RETURN_URL);
            vnpParams.put("vnp_IpAddr", ipAddress);

            System.out.println("VNPay params created successfully");

            // Tạo thời gian
            Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnpCreateDate = formatter.format(calendar.getTime());
            vnpParams.put("vnp_CreateDate", vnpCreateDate);

            // Thời gian hết hạn (15 phút)
            calendar.add(Calendar.MINUTE, 15);
            String vnpExpireDate = formatter.format(calendar.getTime());
            vnpParams.put("vnp_ExpireDate", vnpExpireDate);

            // Build query string và tạo secure hash
            List<String> fieldNames = new ArrayList<>(vnpParams.keySet());
            Collections.sort(fieldNames);

            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();

            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = vnpParams.get(fieldName);
                if (fieldValue != null && fieldValue.length() > 0) {
                    // Build hash data
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));

                    // Build query
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));

                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }

            String queryUrl = query.toString();
            String vnpSecureHash = hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnpSecureHash;

            String finalUrl = VNPayConfig.VNP_PAY_URL + "?" + queryUrl;
            System.out.println("VNPay URL generated successfully, length=" + finalUrl.length());

            return finalUrl;

        } catch (Exception e) {
            System.err.println("ERROR in VNPayUtil.createPaymentUrl(): " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Verify secure hash từ VNPay response
     *
     * @param request HttpServletRequest chứa VNPay response params
     * @return true nếu hash hợp lệ, false nếu không
     */
    public static boolean verifySecureHash(HttpServletRequest request) {
        try {
            Map<String, String> fields = new HashMap<>();
            for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements(); ) {
                String fieldName = params.nextElement();
                String fieldValue = request.getParameter(fieldName);
                if (fieldValue != null && fieldValue.length() > 0) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnpSecureHash = request.getParameter("vnp_SecureHash");
            fields.remove("vnp_SecureHashType");
            fields.remove("vnp_SecureHash");

            // Build hash data
            List<String> fieldNames = new ArrayList<>(fields.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = fields.get(fieldName);
                if (fieldValue != null && fieldValue.length() > 0) {
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        hashData.append('&');
                    }
                }
            }

            String signValue = hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());
            return signValue.equals(vnpSecureHash);

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * HMAC SHA512 hashing
     *
     * @param key  Secret key
     * @param data Data to hash
     * @return Hashed string
     */
    public static String hmacSHA512(String key, String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException();
            }
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] result = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            return "";
        }
    }

    /**
     * Lấy IP address từ request
     *
     * @param request HttpServletRequest
     * @return IP address
     */
    public static String getIpAddress(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty()) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }
}
