package com.bookverse.controller;

import com.bookverse.dao.BookDAO;
import com.bookverse.dao.CartDAO;
import com.bookverse.model.Book;
import com.bookverse.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {

    private CartDAO cartDAO;
    private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        cartDAO = new CartDAO();
        bookDAO = new BookDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response content type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Check login - user must be in session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                out.print("{\"success\": false, \"message\": \"Vui lòng đăng nhập để thêm sách vào giỏ hàng\"}");
                out.flush();
                return;
            }

            User user = (User) session.getAttribute("user");

            // Get parameters
            String bookIdStr = request.getParameter("bookId");
            String quantityStr = request.getParameter("quantity");

            // Validate parameters
            if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Mã sách không hợp lệ\"}");
                out.flush();
                return;
            }

            if (quantityStr == null || quantityStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Số lượng không hợp lệ\"}");
                out.flush();
                return;
            }

            int bookId;
            int quantity;

            try {
                bookId = Integer.parseInt(bookIdStr);
                quantity = Integer.parseInt(quantityStr);
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"Dữ liệu không đúng định dạng\"}");
                out.flush();
                return;
            }

            // Validate quantity > 0
            if (quantity <= 0) {
                out.print("{\"success\": false, \"message\": \"Số lượng phải lớn hơn 0\"}");
                out.flush();
                return;
            }

            // Get book from database to check stock
            Book book = bookDAO.getBookById(bookId);
            if (book == null) {
                out.print("{\"success\": false, \"message\": \"Sách không tồn tại\"}");
                out.flush();
                return;
            }

            // Check stock availability
            if (book.getStockQuantity() < quantity) {
                out.print("{\"success\": false, \"message\": \"Số lượng sách trong kho không đủ. Còn lại: " + book.getStockQuantity() + "\"}");
                out.flush();
                return;
            }

            // Add or update cart
            boolean result = cartDAO.addToCart(user.getUserId(), bookId, quantity);

            if (result) {
                // Get updated cart count
                int cartCount = cartDAO.getCartItemCount(user.getUserId());
                out.print("{\"success\": true, \"message\": \"Đã thêm sách vào giỏ hàng thành công\", \"cartCount\": " + cartCount + "}");
            } else {
                out.print("{\"success\": false, \"message\": \"Không thể thêm sách vào giỏ hàng\"}");
            }
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra: " + e.getMessage() + "\"}");
            out.flush();
        }
    }
}
