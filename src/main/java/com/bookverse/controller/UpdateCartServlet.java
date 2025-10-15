package com.bookverse.controller;

import com.bookverse.dao.BookDAO;
import com.bookverse.dao.CartDAO;
import com.bookverse.model.Book;
import com.bookverse.model.Cart;
import com.bookverse.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/update-cart")
public class UpdateCartServlet extends HttpServlet {

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
            // Check login
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                out.print("{\"success\": false, \"message\": \"Vui lòng đăng nhập\"}");
                out.flush();
                return;
            }

            User user = (User) session.getAttribute("user");

            // Get parameters
            String cartIdStr = request.getParameter("cartId");
            String quantityStr = request.getParameter("quantity");

            // Validate parameters
            if (cartIdStr == null || cartIdStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Mã giỏ hàng không hợp lệ\"}");
                out.flush();
                return;
            }

            if (quantityStr == null || quantityStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Số lượng không hợp lệ\"}");
                out.flush();
                return;
            }

            int cartId;
            int quantity;

            try {
                cartId = Integer.parseInt(cartIdStr);
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

            // Get cart item to check book stock
            Cart cartItem = cartDAO.getCartById(cartId);
            if (cartItem == null) {
                out.print("{\"success\": false, \"message\": \"Không tìm thấy sản phẩm trong giỏ hàng\"}");
                out.flush();
                return;
            }

            // Verify cart belongs to current user
            if (cartItem.getUserId() != user.getUserId()) {
                out.print("{\"success\": false, \"message\": \"Không có quyền cập nhật giỏ hàng này\"}");
                out.flush();
                return;
            }

            // Check stock availability
            Book book = bookDAO.getBookById(cartItem.getBookId());
            if (book == null) {
                out.print("{\"success\": false, \"message\": \"Sách không tồn tại\"}");
                out.flush();
                return;
            }

            if (book.getStockQuantity() < quantity) {
                out.print("{\"success\": false, \"message\": \"Số lượng sách trong kho không đủ. Còn lại: " + book.getStockQuantity() + "\"}");
                out.flush();
                return;
            }

            // Update cart quantity
            boolean result = cartDAO.updateCartQuantity(cartId, quantity);

            if (result) {
                // Calculate new subtotal
                java.math.BigDecimal subtotal = book.getPrice().multiply(java.math.BigDecimal.valueOf(quantity));
                out.print("{\"success\": true, \"message\": \"Cập nhật số lượng thành công\", \"subtotal\": " + subtotal + "}");
            } else {
                out.print("{\"success\": false, \"message\": \"Không thể cập nhật số lượng\"}");
            }
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra: " + e.getMessage() + "\"}");
            out.flush();
        }
    }
}
