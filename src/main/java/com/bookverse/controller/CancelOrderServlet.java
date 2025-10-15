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
 * Servlet xử lý hủy đơn hàng
 * GET: Redirect về trang danh sách đơn hàng (không cho phép truy cập trực tiếp)
 * POST: Hủy đơn hàng (chỉ cho phép hủy nếu status = pending)
 */
@WebServlet("/order/cancel")
public class CancelOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.setAttribute("error", "Không thể truy cập trang này trực tiếp!");
        response.sendRedirect(request.getContextPath() + "/orders");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy orderId từ parameter
        String orderIdStr = request.getParameter("orderId");

        // Validate orderId
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Mã đơn hàng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            // Lấy order từ database để kiểm tra
            Order order = orderDAO.getOrderById(orderId);

            // Kiểm tra order có tồn tại không
            if (order == null) {
                session.setAttribute("error", "Không tìm thấy đơn hàng!");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Kiểm tra order thuộc về user hiện tại (security)
            if (order.getUserId() != user.getUserId()) {
                session.setAttribute("error", "Bạn không có quyền hủy đơn hàng này!");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Chỉ cho phép hủy đơn hàng nếu status = pending
            if (!"pending".equals(order.getOrderStatus())) {
                session.setAttribute("error", "Không thể hủy đơn hàng này. Đơn hàng đã được xử lý!");
                response.sendRedirect(request.getContextPath() + "/order?id=" + orderId);
                return;
            }

            // Cập nhật status thành cancelled
            boolean result = orderDAO.updateOrderStatus(orderId, "cancelled");

            if (result) {
                session.setAttribute("success", "Hủy đơn hàng thành công!");
                response.sendRedirect(request.getContextPath() + "/orders");
            } else {
                session.setAttribute("error", "Không thể hủy đơn hàng. Vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/order?id=" + orderId);
            }

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
