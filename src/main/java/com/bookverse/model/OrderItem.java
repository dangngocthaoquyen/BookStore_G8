package com.bookverse.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Entity class cho bảng order_items
 * Quản lý chi tiết đơn hàng
 */
public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int bookId;
    private String bookTitle;
    private BigDecimal bookPrice;
    private int quantity;
    private BigDecimal subtotal;
    private Timestamp createdAt;

    // Thông tin thêm để hiển thị
    private String bookAuthor;
    private String bookImageUrl;

    // Constructors
    public OrderItem() {
    }

    public OrderItem(int orderId, int bookId, String bookTitle,
                     BigDecimal bookPrice, int quantity, BigDecimal subtotal) {
        this.orderId = orderId;
        this.bookId = bookId;
        this.bookTitle = bookTitle;
        this.bookPrice = bookPrice;
        this.quantity = quantity;
        this.subtotal = subtotal;
    }

    // Getters and Setters
    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public BigDecimal getBookPrice() {
        return bookPrice;
    }

    public void setBookPrice(BigDecimal bookPrice) {
        this.bookPrice = bookPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getBookAuthor() {
        return bookAuthor;
    }

    public void setBookAuthor(String bookAuthor) {
        this.bookAuthor = bookAuthor;
    }

    public String getBookImageUrl() {
        return bookImageUrl;
    }

    public void setBookImageUrl(String bookImageUrl) {
        this.bookImageUrl = bookImageUrl;
    }

    // Utility methods
    /**
     * Format giá sách theo định dạng VNĐ
     */
    public String getFormattedBookPrice() {
        if (bookPrice == null) return "0 đ";
        return String.format("%,.0f đ", bookPrice);
    }

    /**
     * Format tổng tiền theo định dạng VNĐ
     */
    public String getFormattedSubtotal() {
        if (subtotal == null) return "0 đ";
        return String.format("%,.0f đ", subtotal);
    }

    @Override
    public String toString() {
        return "OrderItem{" +
                "orderItemId=" + orderItemId +
                ", orderId=" + orderId +
                ", bookTitle='" + bookTitle + '\'' +
                ", quantity=" + quantity +
                ", subtotal=" + subtotal +
                '}';
    }
}
