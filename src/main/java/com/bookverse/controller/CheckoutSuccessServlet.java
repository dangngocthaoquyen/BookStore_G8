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

/**
 * Servlet hiển thị trang thành công sau khi đặt hàng
 * GET: Hiển thị thông tin đơn hàng vừa tạo
 */
@WebServlet("/checkout-success")
public class CheckoutSuccessServlet extends HttpServlet {

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

        // Lấy orderCode từ parameter
        String orderCode = request.getParameter("orderCode");

        // Validate orderCode
        if (orderCode == null || orderCode.trim().isEmpty()) {
            session.setAttribute("error", "Không tìm thấy mã đơn hàng!");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            // Lấy order từ OrderDAO.getOrderByOrderCode()
            Order order = orderDAO.getOrderByOrderCode(orderCode);

            // Kiểm tra order có tồn tại không
            if (order == null) {
                session.setAttribute("error", "Không tìm thấy đơn hàng!");
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            // Kiểm tra order thuộc về user hiện tại (security)
            if (order.getUserId() != user.getUserId()) {
                session.setAttribute("error", "Bạn không có quyền xem đơn hàng này!");
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            // Set attribute và forward đến checkout-success.jsp
            request.setAttribute("order", order);
            request.getRequestDispatcher("/views/user/checkout-success.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
