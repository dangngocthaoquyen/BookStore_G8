package com.bookverse.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Entity class cho bảng cart
 * Quản lý giỏ hàng của người dùng
 */
public class Cart {
    private int cartId;
    private int userId;
    private int bookId;
    private int quantity;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Thông tin book để hiển thị
    private String bookTitle;
    private String bookAuthor;
    private BigDecimal bookPrice;
    private String bookImageUrl;
    private int bookStockQuantity;

    // Constructors
    public Cart() {
    }

    public Cart(int userId, int bookId, int quantity) {
        this.userId = userId;
        this.bookId = bookId;
        this.quantity = quantity;
    }

    // Getters and Setters
    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getBookAuthor() {
        return bookAuthor;
    }

    public void setBookAuthor(String bookAuthor) {
        this.bookAuthor = bookAuthor;
    }

    public BigDecimal getBookPrice() {
        return bookPrice;
    }

    public void setBookPrice(BigDecimal bookPrice) {
        this.bookPrice = bookPrice;
    }

    public String getBookImageUrl() {
        return bookImageUrl;
    }

    public void setBookImageUrl(String bookImageUrl) {
        this.bookImageUrl = bookImageUrl;
    }

    public int getBookStockQuantity() {
        return bookStockQuantity;
    }

    public void setBookStockQuantity(int bookStockQuantity) {
        this.bookStockQuantity = bookStockQuantity;
    }

    // Utility methods
    /**
     * Tính tổng tiền cho item này trong giỏ hàng
     */
    public BigDecimal getSubtotal() {
        if (bookPrice == null) return BigDecimal.ZERO;
        return bookPrice.multiply(BigDecimal.valueOf(quantity));
    }

    /**
     * Format tổng tiền theo định dạng VNĐ
     */
    public String getFormattedSubtotal() {
        return String.format("%,.0f đ", getSubtotal());
    }

    /**
     * Kiểm tra số lượng có hợp lệ với tồn kho không
     */
    public boolean isQuantityValid() {
        return quantity > 0 && quantity <= bookStockQuantity;
    }

    @Override
    public String toString() {
        return "Cart{" +
                "cartId=" + cartId +
                ", userId=" + userId +
                ", bookId=" + bookId +
                ", quantity=" + quantity +
                ", bookTitle='" + bookTitle + '\'' +
                '}';
    }
}
