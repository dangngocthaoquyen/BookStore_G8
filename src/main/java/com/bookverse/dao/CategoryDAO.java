package com.bookverse.dao;

import com.bookverse.model.Category;
import com.bookverse.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class cho bảng categories
 * Quản lý các thao tác CRUD với danh mục sách
 */
public class CategoryDAO {

    // Lấy category theo ID
    public Category getCategoryById(int categoryId) throws SQLException {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCategory(rs);
            }
        }
        return null;
    }

    // Lấy tất cả categories
    public List<Category> getAllCategories() throws SQLException {
        String sql = "SELECT * FROM categories ORDER BY category_name ASC";
        List<Category> categories = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        }
        return categories;
    }

    // Lấy các categories đang active
    public List<Category> getActiveCategories() throws SQLException {
        String sql = "SELECT * FROM categories WHERE status = 'active' ORDER BY category_name ASC";
        List<Category> categories = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        }
        return categories;
    }

    // Tạo category mới
    public boolean createCategory(Category category) throws SQLException {
        String sql = "INSERT INTO categories (category_name, description, status) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            stmt.setString(3, category.getStatus() != null ? category.getStatus() : "active");

            return stmt.executeUpdate() > 0;
        }
    }

    // Cập nhật category
    public boolean updateCategory(Category category) throws SQLException {
        String sql = "UPDATE categories SET category_name = ?, description = ?, status = ? WHERE category_id = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            stmt.setString(3, category.getStatus());
            stmt.setInt(4, category.getCategoryId());

            return stmt.executeUpdate() > 0;
        }
    }

    // Xóa category (chỉ nếu không có sách nào)
    public boolean deleteCategory(int categoryId) throws SQLException {
        // Kiểm tra xem có sách nào trong category này không
        String checkSql = "SELECT COUNT(*) as count FROM books WHERE category_id = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setInt(1, categoryId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next() && rs.getInt("count") > 0) {
                // Không xóa nếu có sách trong category
                return false;
            }

            // Xóa category nếu không có sách
            String deleteSql = "DELETE FROM categories WHERE category_id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, categoryId);
                return deleteStmt.executeUpdate() > 0;
            }
        }
    }

    // Đếm tổng số categories
    public int countCategories() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM categories";
        try (Connection conn = DatabaseConnection.getNewConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    // Đếm số sách trong category
    public int countBooksInCategory(int categoryId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM books WHERE category_id = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    // Kiểm tra tên category đã tồn tại chưa
    public boolean categoryNameExists(String categoryName) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM categories WHERE category_name = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, categoryName);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        }
        return false;
    }

    // Kiểm tra tên category đã tồn tại chưa (trừ category hiện tại khi update)
    public boolean categoryNameExists(String categoryName, int excludeCategoryId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM categories WHERE category_name = ? AND category_id != ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, categoryName);
            stmt.setInt(2, excludeCategoryId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        }
        return false;
    }

    // Map ResultSet to Category object
    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        category.setStatus(rs.getString("status"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setUpdatedAt(rs.getTimestamp("updated_at"));
        return category;
    }
}
