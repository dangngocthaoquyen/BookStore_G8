package com.bookverse.util;

import java.util.regex.Pattern;

/**
 * Utility class để validation input
 * Đảm bảo dữ liệu đầu vào hợp lệ và an toàn
 */
public class ValidationUtil {

    // Regex patterns
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    private static final Pattern PHONE_PATTERN = Pattern.compile(
            "^(0|\\+84)(\\s|\\.)?((3[2-9])|(5[689])|(7[06-9])|(8[1-689])|(9[0-46-9]))(\\d)(\\s|\\.)?(\\d{3})(\\s|\\.)?(\\d{3})$"
    );

    private static final Pattern ISBN_PATTERN = Pattern.compile(
            "^(?:ISBN(?:-1[03])?:? )?(?=[0-9X]{10}$|(?=(?:[0-9]+[- ]){3})[- 0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[- ]){4})[- 0-9]{17}$)(?:97[89][- ]?)?[0-9]{1,5}[- ]?[0-9]+[- ]?[0-9]+[- ]?[0-9X]$"
    );

    /**
     * Kiểm tra string có rỗng hoặc null không
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Kiểm tra string không rỗng
     */
    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }

    /**
     * Validate email
     */
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) return false;
        return EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Validate số điện thoại Việt Nam
     */
    public static boolean isValidPhone(String phone) {
        if (isEmpty(phone)) return false;
        // Remove spaces and dots
        String cleanPhone = phone.replaceAll("[\\s.-]", "");
        return PHONE_PATTERN.matcher(cleanPhone).matches();
    }

    /**
     * Validate password
     * Yêu cầu: ít nhất 6 ký tự
     */
    public static boolean isValidPassword(String password) {
        return isNotEmpty(password) && password.length() >= 6;
    }

    /**
     * Validate ISBN
     */
    public static boolean isValidISBN(String isbn) {
        if (isEmpty(isbn)) return false;
        return ISBN_PATTERN.matcher(isbn).matches();
    }

    /**
     * Validate số nguyên dương
     */
    public static boolean isPositiveInteger(String str) {
        if (isEmpty(str)) return false;
        try {
            int num = Integer.parseInt(str);
            return num > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Validate số thực dương
     */
    public static boolean isPositiveDecimal(String str) {
        if (isEmpty(str)) return false;
        try {
            double num = Double.parseDouble(str);
            return num > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Validate độ dài string
     */
    public static boolean isValidLength(String str, int minLength, int maxLength) {
        if (isEmpty(str)) return false;
        int length = str.trim().length();
        return length >= minLength && length <= maxLength;
    }

    /**
     * Sanitize input để tránh XSS
     */
    public static String sanitizeInput(String input) {
        if (isEmpty(input)) return "";

        return input
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;")
                .replace("/", "&#x2F;");
    }

    /**
     * Validate full name
     * Yêu cầu: chỉ chứa chữ cái, khoảng trắng, dấu tiếng Việt
     */
    public static boolean isValidFullName(String fullName) {
        if (isEmpty(fullName)) return false;

        // Cho phép chữ cái, khoảng trắng, dấu tiếng Việt
        String vietnamesePattern = "^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵýỷỹ\\s]+$";
        return fullName.matches(vietnamesePattern) && isValidLength(fullName, 2, 100);
    }

    /**
     * Validate order code format
     * Format: OD + timestamp
     */
    public static boolean isValidOrderCode(String orderCode) {
        if (isEmpty(orderCode)) return false;
        return orderCode.matches("^OD\\d{13,}$");
    }

    /**
     * Validate URL
     */
    public static boolean isValidUrl(String url) {
        if (isEmpty(url)) return false;
        try {
            new java.net.URL(url);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Validate year
     */
    public static boolean isValidYear(int year) {
        int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
        return year >= 1000 && year <= currentYear;
    }

    /**
     * Main method để test
     */
    public static void main(String[] args) {
        System.out.println("=== TEST VALIDATION UTIL ===\n");

        // Test email
        System.out.println("Email validation:");
        System.out.println("test@example.com: " + isValidEmail("test@example.com"));
        System.out.println("invalid-email: " + isValidEmail("invalid-email"));

        // Test phone
        System.out.println("\nPhone validation:");
        System.out.println("0901234567: " + isValidPhone("0901234567"));
        System.out.println("123456: " + isValidPhone("123456"));

        // Test password
        System.out.println("\nPassword validation:");
        System.out.println("admin123: " + isValidPassword("admin123"));
        System.out.println("123: " + isValidPassword("123"));

        // Test full name
        System.out.println("\nFull name validation:");
        System.out.println("Nguyễn Văn A: " + isValidFullName("Nguyễn Văn A"));
        System.out.println("Test123: " + isValidFullName("Test123"));

        // Test sanitize
        System.out.println("\nSanitize input:");
        System.out.println("Input: <script>alert('XSS')</script>");
        System.out.println("Output: " + sanitizeInput("<script>alert('XSS')</script>"));
    }
}
