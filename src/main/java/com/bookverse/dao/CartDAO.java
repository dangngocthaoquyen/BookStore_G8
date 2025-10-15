package com.bookverse.dao;

import com.bookverse.model.Cart;
import com.bookverse.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class cho bảng cart
 * Quản lý các thao tác CRUD với giỏ hàng
 */
public class CartDAO {

    /**
     * Lấy tất cả items trong giỏ hàng của user
     * Join với books để lấy đầy đủ thông tin sách
     */
    public List<Cart> getCartByUserId(int userId) throws SQLException {
        String sql = "SELECT c.*, b.title, b.author, b.price, b.image_url, b.stock_quantity " +
                     "FROM cart c " +
                     "INNER JOIN books b ON c.book_id = b.book_id " +
                     "WHERE c.user_id = ? " +
                     "ORDER BY c.created_at DESC";

        List<Cart> cartItems = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                cartItems.add(mapResultSetToCart(rs));
            }
        }

        return cartItems;
    }

    /**
     * Thêm sách vào giỏ hàng
     * Nếu sách đã có trong giỏ thì cập nhật số lượng
     */
    public boolean addToCart(int userId, int bookId, int quantity) throws SQLException {
        // Kiểm tra xem sách đã có trong giỏ chưa
        String checkSql = "SELECT cart_id, quantity FROM cart WHERE user_id = ? AND book_id = ?";
        String insertSql = "INSERT INTO cart (user_id, book_id, quantity) VALUES (?, ?, ?)";
        String updateSql = "UPDATE cart SET quantity = quantity + ?, updated_at = CURRENT_TIMESTAMP WHERE cart_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection()) {
            // Check existing cart item
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, userId);
                checkStmt.setInt(2, bookId);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    // Item đã tồn tại, cập nhật số lượng
                    int cartId = rs.getInt("cart_id");
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, quantity);
                        updateStmt.setInt(2, cartId);
                        return updateStmt.executeUpdate() > 0;
                    }
                } else {
                    // Item chưa tồn tại, thêm mới
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setInt(1, userId);
                        insertStmt.setInt(2, bookId);
                        insertStmt.setInt(3, quantity);
                        return insertStmt.executeUpdate() > 0;
                    }
                }
            }
        }
    }

    /**
     * Cập nhật số lượng sách trong giỏ hàng
     */
    public boolean updateCartQuantity(int cartId, int quantity) throws SQLException {
        String sql = "UPDATE cart SET quantity = ?, updated_at = CURRENT_TIMESTAMP WHERE cart_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, cartId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật số lượng theo userId và bookId
     */
    public boolean updateCartQuantityByUserAndBook(int userId, int bookId, int quantity) throws SQLException {
        String sql = "UPDATE cart SET quantity = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE user_id = ? AND book_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, userId);
            stmt.setInt(3, bookId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Xóa một item khỏi giỏ hàng
     */
    public boolean removeFromCart(int cartId) throws SQLException {
        String sql = "DELETE FROM cart WHERE cart_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Xóa item theo userId và bookId
     */
    public boolean removeFromCartByUserAndBook(int userId, int bookId) throws SQLException {
        String sql = "DELETE FROM cart WHERE user_id = ? AND book_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Xóa toàn bộ giỏ hàng của user
     */
    public boolean clearCart(int userId) throws SQLException {
        String sql = "DELETE FROM cart WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Đếm số lượng items trong giỏ hàng của user
     */
    public int getCartItemCount(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM cart WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }
        }

        return 0;
    }

    /**
     * Đếm tổng số lượng sách trong giỏ (sum của quantity)
     */
    public int getTotalQuantity(int userId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantity), 0) as total FROM cart WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }
        }

        return 0;
    }

    /**
     * Kiểm tra sách có trong giỏ hàng không
     */
    public boolean isBookInCart(int userId, int bookId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM cart WHERE user_id = ? AND book_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        }

        return false;
    }

    /**
     * Lấy cart item cụ thể
     */
    public Cart getCartItem(int cartId) throws SQLException {
        String sql = "SELECT c.*, b.title, b.author, b.price, b.image_url, b.stock_quantity " +
                     "FROM cart c " +
                     "INNER JOIN books b ON c.book_id = b.book_id " +
                     "WHERE c.cart_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCart(rs);
            }
        }

        return null;
    }

    /**
     * Alias method for getCartItem - for backward compatibility
     */
    public Cart getCartById(int cartId) throws SQLException {
        return getCartItem(cartId);
    }

    /**
     * Lấy cart item theo userId và bookId
     */
    public Cart getCartItemByUserAndBook(int userId, int bookId) throws SQLException {
        String sql = "SELECT c.*, b.title, b.author, b.price, b.image_url, b.stock_quantity " +
                     "FROM cart c " +
                     "INNER JOIN books b ON c.book_id = b.book_id " +
                     "WHERE c.user_id = ? AND c.book_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCart(rs);
            }
        }

        return null;
    }

    /**
     * Map ResultSet to Cart object
     */
    private Cart mapResultSetToCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("cart_id"));
        cart.setUserId(rs.getInt("user_id"));
        cart.setBookId(rs.getInt("book_id"));
        cart.setQuantity(rs.getInt("quantity"));
        cart.setCreatedAt(rs.getTimestamp("created_at"));
        cart.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Book information
        cart.setBookTitle(rs.getString("title"));
        cart.setBookAuthor(rs.getString("author"));
        cart.setBookPrice(rs.getBigDecimal("price"));
        cart.setBookImageUrl(rs.getString("image_url"));
        cart.setBookStockQuantity(rs.getInt("stock_quantity"));

        return cart;
    }
}
