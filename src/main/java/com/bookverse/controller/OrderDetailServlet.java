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
 * Servlet hiển thị chi tiết đơn hàng
 * GET: Hiển thị thông tin chi tiết order
 */
@WebServlet("/order")
public class OrderDetailServlet extends HttpServlet {

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

        // Lấy orderId từ parameter
        String orderIdParam = request.getParameter("id");

        // Validate orderId
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            session.setAttribute("error", "Không tìm thấy mã đơn hàng!");
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);

            // Get order từ OrderDAO.getOrderById() (có JOIN user, có order items)
            Order order = orderDAO.getOrderById(orderId);

            // Kiểm tra order có tồn tại không
            if (order == null) {
                session.setAttribute("error", "Không tìm thấy đơn hàng!");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Check order thuộc về user hiện tại (security)
            if (order.getUserId() != user.getUserId()) {
                session.setAttribute("error", "Bạn không có quyền xem đơn hàng này!");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Set attribute và forward đến order-detail.jsp
            request.setAttribute("order", order);
            request.getRequestDispatcher("/views/user/order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Mã đơn hàng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/orders");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }
}
