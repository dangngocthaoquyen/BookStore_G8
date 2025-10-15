package com.bookverse.dao;

import com.bookverse.model.Book;
import com.bookverse.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class cho bảng books
 * Quản lý các thao tác CRUD với sách
 */
public class BookDAO {

    // Lấy book theo ID (có join với categories)
    public Book getBookById(int bookId) throws SQLException {
        String sql = "SELECT b.*, c.category_name " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.category_id " +
                     "WHERE b.book_id = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
        }
        return null;
    }

    // Lấy tất cả books với phân trang (có join với categories)
    public List<Book> getAllBooks(int offset, int limit) throws SQLException {
        String sql = "SELECT b.*, c.category_name " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.category_id " +
                     "ORDER BY b.created_at DESC " +
                     "LIMIT ? OFFSET ?";
        List<Book> books = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    // Lấy books theo category
    public List<Book> getBooksByCategory(int categoryId, int offset, int limit) throws SQLException {
        String sql = "SELECT b.*, c.category_name " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.category_id " +
                     "WHERE b.category_id = ? " +
                     "ORDER BY b.created_at DESC " +
                     "LIMIT ? OFFSET ?";
        List<Book> books = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, categoryId);
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    // Tìm kiếm books theo tên, tác giả
    public List<Book> searchBooks(String keyword, int offset, int limit) throws SQLException {
        String sql = "SELECT b.*, c.category_name " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.category_id " +
                     "WHERE b.title LIKE ? OR b.author LIKE ? OR b.isbn LIKE ? " +
                     "ORDER BY b.created_at DESC " +
                     "LIMIT ? OFFSET ?";
        List<Book> books = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setInt(4, limit);
            stmt.setInt(5, offset);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    // Tạo book mới
    public boolean createBook(Book book) throws SQLException {
        String sql = "INSERT INTO books (title, author, category_id, description, price, " +
                     "stock_quantity, image_url, isbn, publisher, publish_year, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setInt(3, book.getCategoryId());
            stmt.setString(4, book.getDescription());
            stmt.setBigDecimal(5, book.getPrice());
            stmt.setInt(6, book.getStockQuantity());
            stmt.setString(7, book.getImageUrl());
            stmt.setString(8, book.getIsbn());
            stmt.setString(9, book.getPublisher());

            if (book.getPublishYear() != null) {
                stmt.setInt(10, book.getPublishYear());
            } else {
                stmt.setNull(10, Types.INTEGER);
            }

            stmt.setString(11, book.getStatus() != null ? book.getStatus() : "available");

            return stmt.executeUpdate() > 0;
        }
    }

    // Cập nhật book
    public boolean updateBook(Book book) throws SQLException {
        String sql = "UPDATE books SET title = ?, author = ?, category_id = ?, description = ?, " +
                     "price = ?, stock_quantity = ?, image_url = ?, isbn = ?, publisher = ?, " +
                     "publish_year = ?, status = ? WHERE book_id = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setInt(3, book.getCategoryId());
            stmt.setString(4, book.getDescription());
            stmt.setBigDecimal(5, book.getPrice());
            stmt.setInt(6, book.getStockQuantity());
            stmt.setString(7, book.getImageUrl());
            stmt.setString(8, book.getIsbn());
            stmt.setString(9, book.getPublisher());

            if (book.getPublishYear() != null) {
                stmt.setInt(10, book.getPublishYear());
            } else {
                stmt.setNull(10, Types.INTEGER);
            }

            stmt.setString(11, book.getStatus());
            stmt.setInt(12, book.getBookId());

            return stmt.executeUpdate() > 0;
        }
    }

    // Xóa book
    public boolean deleteBook(int bookId) throws SQLException {
        String sql = "DELETE FROM books WHERE book_id = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Cập nhật số lượng tồn kho
    public boolean updateStock(int bookId, int newQuantity) throws SQLException {
        String sql = "UPDATE books SET stock_quantity = ? WHERE book_id = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, newQuantity);
            stmt.setInt(2, bookId);

            return stmt.executeUpdate() > 0;
        }
    }

    // Giảm số lượng tồn kho (khi bán)
    public boolean decreaseStock(int bookId, int quantity) throws SQLException {
        String sql = "UPDATE books SET stock_quantity = stock_quantity - ? WHERE book_id = ? AND stock_quantity >= ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, bookId);
            stmt.setInt(3, quantity);

            return stmt.executeUpdate() > 0;
        }
    }

    // Tăng số lượng tồn kho (khi nhập thêm hoặc hủy đơn)
    public boolean increaseStock(int bookId, int quantity) throws SQLException {
        String sql = "UPDATE books SET stock_quantity = stock_quantity + ? WHERE book_id = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, bookId);

            return stmt.executeUpdate() > 0;
        }
    }

    // Đếm tổng số books
    public int countBooks() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM books";
        try (Connection conn = DatabaseConnection.getNewConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    // Đếm số books theo category
    public int countBooksByCategory(int categoryId) throws SQLException {
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

    // Đếm số books theo keyword tìm kiếm
    public int countSearchResults(String keyword) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM books WHERE title LIKE ? OR author LIKE ? OR isbn LIKE ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    // Kiểm tra ISBN đã tồn tại chưa
    public boolean isbnExists(String isbn) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM books WHERE isbn = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, isbn);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        }
        return false;
    }

    // Kiểm tra ISBN đã tồn tại chưa (trừ book hiện tại khi update)
    public boolean isbnExists(String isbn, int excludeBookId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM books WHERE isbn = ? AND book_id != ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, isbn);
            stmt.setInt(2, excludeBookId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        }
        return false;
    }

    // Lấy sách mới nhất (hiển thị trang chủ)
    public List<Book> getLatestBooks(int limit) throws SQLException {
        String sql = "SELECT b.*, c.category_name " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.category_id " +
                     "WHERE b.status = 'available' " +
                     "ORDER BY b.created_at DESC " +
                     "LIMIT ?";
        List<Book> books = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    // Lấy sách bán chạy (có thể mở rộng sau với order_items)
    public List<Book> getBestSellingBooks(int limit) throws SQLException {
        String sql = "SELECT b.*, c.category_name, COALESCE(SUM(oi.quantity), 0) as total_sold " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.category_id " +
                     "LEFT JOIN order_items oi ON b.book_id = oi.book_id " +
                     "WHERE b.status = 'available' " +
                     "GROUP BY b.book_id " +
                     "ORDER BY total_sold DESC " +
                     "LIMIT ?";
        List<Book> books = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    // Map ResultSet to Book object
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("book_id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setCategoryId(rs.getInt("category_id"));
        book.setCategoryName(rs.getString("category_name"));
        book.setDescription(rs.getString("description"));
        book.setPrice(rs.getBigDecimal("price"));
        book.setStockQuantity(rs.getInt("stock_quantity"));
        book.setImageUrl(rs.getString("image_url"));
        book.setIsbn(rs.getString("isbn"));
        book.setPublisher(rs.getString("publisher"));

        // Xử lý publish_year có thể null
        int publishYear = rs.getInt("publish_year");
        if (!rs.wasNull()) {
            book.setPublishYear(publishYear);
        }

        book.setStatus(rs.getString("status"));
        book.setCreatedAt(rs.getTimestamp("created_at"));
        book.setUpdatedAt(rs.getTimestamp("updated_at"));
        return book;
    }
}
