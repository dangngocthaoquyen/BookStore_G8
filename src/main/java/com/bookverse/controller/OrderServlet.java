package com.bookverse.controller;

import com.bookverse.dao.OrderDAO;
import com.bookverse.model.Order;
import com.bookverse.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet hiển thị lịch sử đơn hàng của user
 * GET: Hiển thị danh sách orders
 */
@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy orders từ OrderDAO.getOrdersByUserId()
            List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());

            // Set attribute và forward đến orders.jsp
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/views/user/orders.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
