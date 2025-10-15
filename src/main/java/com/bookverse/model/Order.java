package com.bookverse.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

/**
 * Entity class cho bảng orders
 * Quản lý đơn hàng
 */
public class Order {
    private int orderId;
    private int userId;
    private String orderCode;
    private BigDecimal totalAmount;
    private String shippingName;
    private String shippingPhone;
    private String shippingAddress;
    private String paymentMethod; // 'cod', 'bank_transfer', 'credit_card'
    private String paymentStatus; // 'pending', 'paid', 'failed'
    private String orderStatus; // 'pending', 'confirmed', 'shipping', 'completed', 'cancelled'
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Thông tin user để hiển thị
    private String userEmail;
    private String userFullName;

    // Danh sách items trong đơn hàng
    private List<OrderItem> orderItems;

    // Constructors
    public Order() {
    }

    public Order(int userId, String orderCode, BigDecimal totalAmount,
                 String shippingName, String shippingPhone, String shippingAddress) {
        this.userId = userId;
        this.orderCode = orderCode;
        this.totalAmount = totalAmount;
        this.shippingName = shippingName;
        this.shippingPhone = shippingPhone;
        this.shippingAddress = shippingAddress;
        this.paymentMethod = "cod";
        this.paymentStatus = "pending";
        this.orderStatus = "pending";
    }

    // Getters and Setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getShippingName() {
        return shippingName;
    }

    public void setShippingName(String shippingName) {
        this.shippingName = shippingName;
    }

    public String getShippingPhone() {
        return shippingPhone;
    }

    public void setShippingPhone(String shippingPhone) {
        this.shippingPhone = shippingPhone;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    // Utility methods
    /**
     * Format tổng tiền theo định dạng VNĐ
     */
    public String getFormattedTotalAmount() {
        if (totalAmount == null) return "0 đ";
        return String.format("%,.0f đ", totalAmount);
    }

    /**
     * Lấy tên hiển thị cho payment method
     */
    public String getPaymentMethodDisplay() {
        switch (paymentMethod) {
            case "cod":
                return "Thanh toán khi nhận hàng";
            case "bank_transfer":
                return "Chuyển khoản ngân hàng";
            case "credit_card":
                return "Thẻ tín dụng";
            default:
                return paymentMethod;
        }
    }

    /**
     * Lấy tên hiển thị cho order status
     */
    public String getOrderStatusDisplay() {
        switch (orderStatus) {
            case "pending":
                return "Chờ xác nhận";
            case "confirmed":
                return "Đã xác nhận";
            case "shipping":
                return "Đang giao hàng";
            case "completed":
                return "Hoàn thành";
            case "cancelled":
                return "Đã hủy";
            default:
                return orderStatus;
        }
    }

    /**
     * Lấy class CSS cho badge status
     */
    public String getOrderStatusClass() {
        switch (orderStatus) {
            case "pending":
                return "bg-yellow-100 text-yellow-600";
            case "confirmed":
                return "bg-blue-100 text-blue-600";
            case "shipping":
                return "bg-blue-100 text-blue-600";
            case "completed":
                return "bg-green-100 text-green-600";
            case "cancelled":
                return "bg-red-100 text-red-600";
            default:
                return "bg-gray-100 text-gray-600";
        }
    }

    public boolean isPending() {
        return "pending".equals(orderStatus);
    }

    public boolean isCompleted() {
        return "completed".equals(orderStatus);
    }

    public boolean isCancelled() {
        return "cancelled".equals(orderStatus);
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", orderCode='" + orderCode + '\'' +
                ", totalAmount=" + totalAmount +
                ", orderStatus='" + orderStatus + '\'' +
                '}';
    }
}
