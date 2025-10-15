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
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        cartDAO = new CartDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get user from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            // Get cart items with book details (JOIN already in DAO)
            List<Cart> cartItems = cartDAO.getCartByUserId(user.getUserId());

            // Calculate total amount
            double totalAmount = 0.0;
            for (Cart item : cartItems) {
                if (item.getBookPrice() != null) {
                    totalAmount += item.getSubtotal().doubleValue();
                }
            }

            // Set attributes for JSP
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("pageTitle", "Giỏ hàng");

            // Forward to cart.jsp
            request.getRequestDispatcher("/views/user/cart.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải giỏ hàng: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
