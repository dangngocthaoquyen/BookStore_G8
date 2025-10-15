package com.bookverse.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class để hash và verify password
 * Sử dụng SHA-256 với salt để bảo mật
 */
public class PasswordUtil {

    private static final String HASH_ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;

    /**
     * Hash password với salt
     * Format: salt:hashedPassword
     */
    public static String hashPassword(String password) {
        try {
            // Tạo salt ngẫu nhiên
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);

            // Hash password với salt
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());

            // Encode sang Base64
            String saltString = Base64.getEncoder().encodeToString(salt);
            String hashedString = Base64.getEncoder().encodeToString(hashedPassword);

            // Return format: salt:hashedPassword
            return saltString + ":" + hashedString;

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi hash password: " + e.getMessage(), e);
        }
    }

    /**
     * Verify password với hashed password
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        try {
            // Split salt và hash
            String[] parts = hashedPassword.split(":");
            if (parts.length != 2) {
                return false;
            }

            String saltString = parts[0];
            String hash = parts[1];

            // Decode salt
            byte[] salt = Base64.getDecoder().decode(saltString);

            // Hash password input với salt
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            md.update(salt);
            byte[] hashedInput = md.digest(password.getBytes());
            String hashedInputString = Base64.getEncoder().encodeToString(hashedInput);

            // So sánh
            return hash.equals(hashedInputString);

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi verify password: " + e.getMessage(), e);
        }
    }

    /**
     * Tạo password ngẫu nhiên
     */
    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();

        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }

        return password.toString();
    }

    /**
     * Kiểm tra độ mạnh của password
     */
    public static boolean isStrongPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }

        boolean hasUpperCase = false;
        boolean hasLowerCase = false;
        boolean hasDigit = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) hasUpperCase = true;
            if (Character.isLowerCase(c)) hasLowerCase = true;
            if (Character.isDigit(c)) hasDigit = true;
        }

        return hasUpperCase && hasLowerCase && hasDigit;
    }

    /**
     * Main method để test
     */
    public static void main(String[] args) {
        System.out.println("=== TEST PASSWORD UTIL ===\n");

        // Test hash và verify
        String password = "admin123";
        String hashed = hashPassword(password);
        System.out.println("Original password: " + password);
        System.out.println("Hashed password: " + hashed);
        System.out.println("Verify correct password: " + verifyPassword(password, hashed));
        System.out.println("Verify wrong password: " + verifyPassword("wrongpass", hashed));

        // Test password strength
        System.out.println("\n=== TEST PASSWORD STRENGTH ===");
        System.out.println("'admin123' is strong: " + isStrongPassword("admin123"));
        System.out.println("'Admin123' is strong: " + isStrongPassword("Admin123"));
        System.out.println("'weak' is strong: " + isStrongPassword("weak"));

        // Test generate random password
        System.out.println("\n=== TEST GENERATE RANDOM PASSWORD ===");
        System.out.println("Random password: " + generateRandomPassword(12));
    }
}
