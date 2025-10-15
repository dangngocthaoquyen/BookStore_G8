package com.bookverse.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class để quản lý kết nối database
 * Sử dụng Singleton pattern để tái sử dụng connection
 */
public class DatabaseConnection {

    // Thông tin kết nối database
    private static final String URL =
        "jdbc:mysql://bookstore-bookstore8.b.aivencloud.com:14800/defaultdb"
        + "?sslMode=REQUIRED&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USERNAME = "avnadmin";
    private static final String PASSWORD = "AVNS_NcWE-ey8WfJ0D_AjHfZ"; 

    // Connection instance
    private static Connection connection = null;

    // Private constructor để prevent instantiation
    private DatabaseConnection() {
    }

    /**
     * Lấy connection đến database
     * Sử dụng singleton pattern
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Nếu connection chưa tồn tại hoặc đã đóng, tạo connection mới
            if (connection == null || connection.isClosed()) {
                connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                System.out.println("✓ Kết nối database thành công!");
            }

            return connection;

        } catch (ClassNotFoundException e) {
            System.err.println("✗ Lỗi: Không tìm thấy MySQL JDBC Driver!");
            System.err.println("Hãy đảm bảo file mysql-connector-java.jar đã được thêm vào WEB-INF/lib/");
            throw new SQLException("MySQL JDBC Driver not found", e);

        } catch (SQLException e) {
            System.err.println("✗ Lỗi kết nối database: " + e.getMessage());
            System.err.println("Kiểm tra lại URL, username, password trong DatabaseConnection.java");
            throw e;
        }
    }

    /**
     * Tạo connection mới cho mỗi request (không dùng singleton)
     * Sử dụng cho multi-threading
     */
    public static Connection getNewConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
    }

    /**
     * Đóng connection
     */
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("✓ Đã đóng kết nối database");
            }
        } catch (SQLException e) {
            System.err.println("✗ Lỗi khi đóng connection: " + e.getMessage());
        }
    }

    /**
     * Đóng connection được truyền vào
     */
    public static void closeConnection(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            System.err.println("✗ Lỗi khi đóng connection: " + e.getMessage());
        }
    }

    /**
     * Test connection
     */
    public static boolean testConnection() {
        try {
            Connection conn = getConnection();
            boolean isValid = conn != null && !conn.isClosed();
            System.out.println(isValid ? "✓ Test connection: SUCCESS" : "✗ Test connection: FAILED");
            return isValid;
        } catch (SQLException e) {
            System.err.println("✗ Test connection FAILED: " + e.getMessage());
            return false;
        }
    }

    /**
     * Main method để test connection
     */
    public static void main(String[] args) {
        System.out.println("=== TEST DATABASE CONNECTION ===");
        testConnection();
    }
}
