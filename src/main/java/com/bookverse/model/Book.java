package com.bookverse.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Entity class cho bảng books
 * Quản lý thông tin sách
 */
public class Book {
    private int bookId;
    private String title;
    private String author;
    private int categoryId;
    private String categoryName; // Để hiển thị tên category
    private String description;
    private BigDecimal price;
    private int stockQuantity;
    private String imageUrl;
    private String isbn;
    private String publisher;
    private Integer publishYear;
    private String status; // 'available', 'out_of_stock', 'discontinued'
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public Book() {
    }

    public Book(String title, String author, int categoryId, String description,
                BigDecimal price, int stockQuantity, String imageUrl) {
        this.title = title;
        this.author = author;
        this.categoryId = categoryId;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
        this.status = "available";
    }

    // Getters and Setters
    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public Integer getPublishYear() {
        return publishYear;
    }

    public void setPublishYear(Integer publishYear) {
        this.publishYear = publishYear;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    // Utility methods
    public boolean isAvailable() {
        return "available".equals(this.status) && this.stockQuantity > 0;
    }

    public boolean isOutOfStock() {
        return this.stockQuantity <= 0;
    }

    /**
     * Format giá tiền theo định dạng VNĐ
     */
    public String getFormattedPrice() {
        if (price == null) return "0 đ";
        return String.format("%,.0f đ", price);
    }

    @Override
    public String toString() {
        return "Book{" +
                "bookId=" + bookId +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", price=" + price +
                ", stockQuantity=" + stockQuantity +
                ", status='" + status + '\'' +
                '}';
    }
}
