package com.bookverse.controller;

import com.bookverse.dao.CartDAO;
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

@WebServlet("/remove-from-cart")
public class RemoveFromCartServlet extends HttpServlet {

    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        cartDAO = new CartDAO();
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

            // Get parameter
            String cartIdStr = request.getParameter("cartId");

            // Validate parameter
            if (cartIdStr == null || cartIdStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Mã giỏ hàng không hợp lệ\"}");
                out.flush();
                return;
            }

            int cartId;
            try {
                cartId = Integer.parseInt(cartIdStr);
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"Dữ liệu không đúng định dạng\"}");
                out.flush();
                return;
            }

            // Get cart item to verify ownership
            Cart cartItem = cartDAO.getCartById(cartId);
            if (cartItem == null) {
                out.print("{\"success\": false, \"message\": \"Không tìm thấy sản phẩm trong giỏ hàng\"}");
                out.flush();
                return;
            }

            // Verify cart belongs to current user
            if (cartItem.getUserId() != user.getUserId()) {
                out.print("{\"success\": false, \"message\": \"Không có quyền xóa sản phẩm này\"}");
                out.flush();
                return;
            }

            // Remove from cart
            boolean result = cartDAO.removeFromCart(cartId);

            if (result) {
                out.print("{\"success\": true, \"message\": \"Đã xóa sản phẩm khỏi giỏ hàng\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Không thể xóa sản phẩm khỏi giỏ hàng\"}");
            }
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra: " + e.getMessage() + "\"}");
            out.flush();
        }
    }
}
