package com.bookverse.dao;

import com.bookverse.model.Order;
import com.bookverse.model.OrderItem;
import com.bookverse.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class cho bảng orders và order_items
 * Quản lý các thao tác CRUD với đơn hàng
 */
public class OrderDAO {

    /**
     * Tạo đơn hàng mới và các order items
     * Sử dụng transaction để đảm bảo tính toàn vẹn dữ liệu
     */
    public int createOrder(Order order, List<OrderItem> orderItems) throws SQLException {
        String orderSql = "INSERT INTO orders (user_id, order_code, total_amount, shipping_name, " +
                          "shipping_phone, shipping_address, payment_method, payment_status, " +
                          "order_status, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement orderStmt = null;
        int orderId = 0;

        try {
            conn = DatabaseConnection.getNewConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Insert order
            orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, order.getUserId());
            orderStmt.setString(2, order.getOrderCode());
            orderStmt.setBigDecimal(3, order.getTotalAmount());
            orderStmt.setString(4, order.getShippingName());
            orderStmt.setString(5, order.getShippingPhone());
            orderStmt.setString(6, order.getShippingAddress());
            orderStmt.setString(7, order.getPaymentMethod());
            orderStmt.setString(8, order.getPaymentStatus());
            orderStmt.setString(9, order.getOrderStatus());
            orderStmt.setString(10, order.getNotes());

            int affectedRows = orderStmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Tạo đơn hàng thất bại, không có dòng nào được insert.");
            }

            // Lấy orderId vừa tạo
            ResultSet generatedKeys = orderStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Tạo đơn hàng thất bại, không lấy được ID.");
            }

            // 2. Insert order items
            for (OrderItem item : orderItems) {
                item.setOrderId(orderId);
                createOrderItem(conn, item);
            }

            conn.commit(); // Commit transaction
            return orderId;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                    System.err.println("Transaction đã được rollback");
                } catch (SQLException ex) {
                    System.err.println("Lỗi khi rollback: " + ex.getMessage());
                }
            }
            throw e;
        } finally {
            if (orderStmt != null) {
                orderStmt.close();
            }
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    /**
     * Tạo order item (được gọi trong transaction)
     */
    private void createOrderItem(Connection conn, OrderItem item) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, book_id, book_title, book_price, quantity, subtotal) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, item.getOrderId());
            stmt.setInt(2, item.getBookId());
            stmt.setString(3, item.getBookTitle());
            stmt.setBigDecimal(4, item.getBookPrice());
            stmt.setInt(5, item.getQuantity());
            stmt.setBigDecimal(6, item.getSubtotal());

            stmt.executeUpdate();
        }
    }

    /**
     * Tạo order item riêng lẻ (public method)
     */
    public boolean createOrderItem(OrderItem item) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, book_id, book_title, book_price, quantity, subtotal) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, item.getOrderId());
            stmt.setInt(2, item.getBookId());
            stmt.setString(3, item.getBookTitle());
            stmt.setBigDecimal(4, item.getBookPrice());
            stmt.setInt(5, item.getQuantity());
            stmt.setBigDecimal(6, item.getSubtotal());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Lấy order theo ID
     * Join với users để lấy thông tin khách hàng
     */
    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT o.*, u.email as user_email, u.full_name as user_full_name " +
                     "FROM orders o " +
                     "INNER JOIN users u ON o.user_id = u.user_id " +
                     "WHERE o.order_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Lấy order items
                order.setOrderItems(getOrderItemsByOrderId(orderId));
                return order;
            }
        }

        return null;
    }

    /**
     * Lấy danh sách orders của một user
     */
    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        String sql = "SELECT o.*, u.email as user_email, u.full_name as user_full_name " +
                     "FROM orders o " +
                     "INNER JOIN users u ON o.user_id = u.user_id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.created_at DESC";

        List<Order> orders = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Có thể load order items nếu cần
                order.setOrderItems(getOrderItemsByOrderId(order.getOrderId()));
                orders.add(order);
            }
        }

        return orders;
    }

    /**
     * Lấy tất cả orders (có phân trang)
     * Join với users để lấy thông tin khách hàng
     */
    public List<Order> getAllOrders(int offset, int limit) throws SQLException {
        String sql = "SELECT o.*, u.email as user_email, u.full_name as user_full_name " +
                     "FROM orders o " +
                     "INNER JOIN users u ON o.user_id = u.user_id " +
                     "ORDER BY o.created_at DESC " +
                     "LIMIT ? OFFSET ?";

        List<Order> orders = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                orders.add(order);
            }
        }

        return orders;
    }

    /**
     * Lấy tất cả orders theo status (có phân trang)
     */
    public List<Order> getOrdersByStatus(String status, int offset, int limit) throws SQLException {
        String sql = "SELECT o.*, u.email as user_email, u.full_name as user_full_name " +
                     "FROM orders o " +
                     "INNER JOIN users u ON o.user_id = u.user_id " +
                     "WHERE o.order_status = ? " +
                     "ORDER BY o.created_at DESC " +
                     "LIMIT ? OFFSET ?";

        List<Order> orders = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                orders.add(order);
            }
        }

        return orders;
    }

    /**
     * Cập nhật trạng thái đơn hàng
     */
    public boolean updateOrderStatus(int orderId, String orderStatus) throws SQLException {
        String sql = "UPDATE orders SET order_status = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE order_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, orderStatus);
            stmt.setInt(2, orderId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật payment status
     */
    public boolean updatePaymentStatus(int orderId, String paymentStatus) throws SQLException {
        String sql = "UPDATE orders SET payment_status = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE order_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, paymentStatus);
            stmt.setInt(2, orderId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật payment status với transaction number (VNPay)
     */
    public boolean updatePaymentStatus(int orderId, String paymentStatus, String transactionNo) throws SQLException {
        String sql = "UPDATE orders SET payment_status = ?, notes = CONCAT(IFNULL(notes, ''), '\\nTransaction: ', ?), " +
                     "updated_at = CURRENT_TIMESTAMP WHERE order_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, paymentStatus);
            stmt.setString(2, transactionNo != null ? transactionNo : "N/A");
            stmt.setInt(3, orderId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật thông tin order
     */
    public boolean updateOrder(Order order) throws SQLException {
        String sql = "UPDATE orders SET shipping_name = ?, shipping_phone = ?, " +
                     "shipping_address = ?, payment_method = ?, payment_status = ?, " +
                     "order_status = ?, notes = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE order_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, order.getShippingName());
            stmt.setString(2, order.getShippingPhone());
            stmt.setString(3, order.getShippingAddress());
            stmt.setString(4, order.getPaymentMethod());
            stmt.setString(5, order.getPaymentStatus());
            stmt.setString(6, order.getOrderStatus());
            stmt.setString(7, order.getNotes());
            stmt.setInt(8, order.getOrderId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Đếm tổng số orders
     */
    public int countOrders() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM orders";

        try (Connection conn = DatabaseConnection.getNewConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        }

        return 0;
    }

    /**
     * Đếm số orders theo status
     */
    public int countOrdersByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM orders WHERE order_status = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }
        }

        return 0;
    }

    /**
     * Đếm số orders của user
     */
    public int countOrdersByUserId(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM orders WHERE user_id = ?";

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
     * Lấy order items theo orderId
     */
    public List<OrderItem> getOrderItemsByOrderId(int orderId) throws SQLException {
        String sql = "SELECT oi.*, b.author as book_author, b.image_url as book_image_url " +
                     "FROM order_items oi " +
                     "LEFT JOIN books b ON oi.book_id = b.book_id " +
                     "WHERE oi.order_id = ?";

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                orderItems.add(mapResultSetToOrderItem(rs));
            }
        }

        return orderItems;
    }

    /**
     * Tìm kiếm orders theo order code
     */
    public Order getOrderByOrderCode(String orderCode) throws SQLException {
        String sql = "SELECT o.*, u.email as user_email, u.full_name as user_full_name " +
                     "FROM orders o " +
                     "INNER JOIN users u ON o.user_id = u.user_id " +
                     "WHERE o.order_code = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, orderCode);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setOrderItems(getOrderItemsByOrderId(order.getOrderId()));
                return order;
            }
        }

        return null;
    }

    /**
     * Xóa order (cascade delete order items)
     */
    public boolean deleteOrder(int orderId) throws SQLException {
        Connection conn = null;

        try {
            conn = DatabaseConnection.getNewConnection();
            conn.setAutoCommit(false);

            // 1. Delete order items first
            String deleteItemsSql = "DELETE FROM order_items WHERE order_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteItemsSql)) {
                stmt.setInt(1, orderId);
                stmt.executeUpdate();
            }

            // 2. Delete order
            String deleteOrderSql = "DELETE FROM orders WHERE order_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteOrderSql)) {
                stmt.setInt(1, orderId);
                stmt.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    /**
     * Map ResultSet to Order object
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderCode(rs.getString("order_code"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setShippingName(rs.getString("shipping_name"));
        order.setShippingPhone(rs.getString("shipping_phone"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setNotes(rs.getString("notes"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));

        // User information
        order.setUserEmail(rs.getString("user_email"));
        order.setUserFullName(rs.getString("user_full_name"));

        return order;
    }

    /**
     * Map ResultSet to OrderItem object
     */
    private OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setOrderItemId(rs.getInt("order_item_id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setBookId(rs.getInt("book_id"));
        item.setBookTitle(rs.getString("book_title"));
        item.setBookPrice(rs.getBigDecimal("book_price"));
        item.setQuantity(rs.getInt("quantity"));
        item.setSubtotal(rs.getBigDecimal("subtotal"));
        item.setCreatedAt(rs.getTimestamp("created_at"));

        // Additional book information
        item.setBookAuthor(rs.getString("book_author"));
        item.setBookImageUrl(rs.getString("book_image_url"));

        return item;
    }
}
