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
 * Servlet quản lý chi tiết đơn hàng (Admin)
 * URL: /admin/order-detail
 * - GET: Hiển thị chi tiết order
 * - POST: Cập nhật order status và payment status
 */
@WebServlet("/admin/order-detail")
public class AdminOrderDetailServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Kiểm tra đăng nhập và quyền admin
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String orderIdStr = request.getParameter("id");

        // Validation
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID đơn hàng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            // Lấy thông tin order với items
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                session.setAttribute("errorMessage", "Không tìm thấy đơn hàng");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Set attributes
            request.setAttribute("order", order);

            // Forward đến JSP
            request.getRequestDispatcher("/views/admin/order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID đơn hàng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi khi tải thông tin đơn hàng: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Kiểm tra đăng nhập và quyền admin
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Lấy dữ liệu từ form
        String orderIdStr = request.getParameter("orderId");
        String orderStatus = request.getParameter("orderStatus");
        String paymentStatus = request.getParameter("paymentStatus");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            errors.append("ID đơn hàng không hợp lệ. ");
        }

        if (orderStatus == null || orderStatus.trim().isEmpty()) {
            errors.append("Trạng thái đơn hàng không được để trống. ");
        } else {
            // Validate orderStatus values
            if (!orderStatus.equals("pending") && !orderStatus.equals("confirmed") &&
                !orderStatus.equals("shipping") && !orderStatus.equals("completed") &&
                !orderStatus.equals("cancelled")) {
                errors.append("Trạng thái đơn hàng không hợp lệ. ");
            }
        }

        if (paymentStatus == null || paymentStatus.trim().isEmpty()) {
            errors.append("Trạng thái thanh toán không được để trống. ");
        } else {
            // Validate paymentStatus values
            if (!paymentStatus.equals("pending") && !paymentStatus.equals("paid") &&
                !paymentStatus.equals("failed")) {
                errors.append("Trạng thái thanh toán không hợp lệ. ");
            }
        }

        if (errors.length() > 0) {
            session.setAttribute("errorMessage", errors.toString().trim());
            response.sendRedirect(request.getContextPath() + "/admin/order-detail?id=" + orderIdStr);
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            // Kiểm tra order có tồn tại không
            Order existingOrder = orderDAO.getOrderById(orderId);
            if (existingOrder == null) {
                session.setAttribute("errorMessage", "Không tìm thấy đơn hàng");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Validation logic: Không cho phép chuyển từ completed/cancelled sang trạng thái khác
            String currentStatus = existingOrder.getOrderStatus();
            if ("completed".equals(currentStatus) && !"completed".equals(orderStatus)) {
                session.setAttribute("errorMessage", "Không thể thay đổi trạng thái đơn hàng đã hoàn thành");
                response.sendRedirect(request.getContextPath() + "/admin/order-detail?id=" + orderId);
                return;
            }

            if ("cancelled".equals(currentStatus) && !"cancelled".equals(orderStatus)) {
                session.setAttribute("errorMessage", "Không thể thay đổi trạng thái đơn hàng đã hủy");
                response.sendRedirect(request.getContextPath() + "/admin/order-detail?id=" + orderId);
                return;
            }

            // Update order status
            boolean orderStatusUpdated = orderDAO.updateOrderStatus(orderId, orderStatus);

            // Update payment status
            boolean paymentStatusUpdated = orderDAO.updatePaymentStatus(orderId, paymentStatus);

            if (orderStatusUpdated || paymentStatusUpdated) {
                session.setAttribute("successMessage", "Cập nhật trạng thái đơn hàng thành công");
            } else {
                session.setAttribute("errorMessage", "Không có thay đổi nào được thực hiện");
            }

            response.sendRedirect(request.getContextPath() + "/admin/order-detail?id=" + orderId);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID đơn hàng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi khi cập nhật đơn hàng: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/order-detail?id=" + orderIdStr);
        }
    }
}
