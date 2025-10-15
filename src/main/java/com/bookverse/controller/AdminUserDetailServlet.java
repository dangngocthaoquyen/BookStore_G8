package com.bookverse.controller;

import com.bookverse.dao.OrderDAO;
import com.bookverse.dao.UserDAO;
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
 * Servlet xem chi tiết người dùng (Admin)
 * URL: /admin/user
 */
@WebServlet("/admin/user")
public class AdminUserDetailServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userIdParam = request.getParameter("id");

        if (userIdParam == null || userIdParam.isEmpty()) {
            session.setAttribute("error", "Thiếu ID người dùng");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Lấy thông tin user
            User user = userDAO.getUserById(userId);

            if (user == null) {
                session.setAttribute("error", "Không tìm thấy người dùng");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // Lấy lịch sử đơn hàng của user
            List<Order> orders = orderDAO.getOrdersByUserId(userId);

            // Thống kê
            int totalOrders = orders.size();
            int pendingOrders = 0;
            int completedOrders = 0;

            for (Order order : orders) {
                if ("pending".equals(order.getOrderStatus())) {
                    pendingOrders++;
                } else if ("completed".equals(order.getOrderStatus())) {
                    completedOrders++;
                }
            }

            // Set attributes
            request.setAttribute("user", user);
            request.setAttribute("orders", orders);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("completedOrders", completedOrders);

            // Forward to JSP
            request.getRequestDispatcher("/views/admin/user-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID người dùng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải thông tin người dùng: " + e.getMessage());
            request.getRequestDispatcher("/views/error/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String userIdParam = request.getParameter("userId");

        if (action == null || userIdParam == null) {
            session.setAttribute("error", "Thiếu thông tin");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Không cho phép thao tác với chính mình
            if (userId == currentUser.getUserId()) {
                session.setAttribute("error", "Bạn không thể thay đổi trạng thái của chính mình!");
                response.sendRedirect(request.getContextPath() + "/admin/user?id=" + userId);
                return;
            }

            switch (action) {
                case "activate":
                    boolean activated = userDAO.updateUserStatus(userId, "active");
                    if (activated) {
                        session.setAttribute("success", "Đã kích hoạt người dùng thành công!");
                    } else {
                        session.setAttribute("error", "Không thể kích hoạt người dùng");
                    }
                    break;

                case "deactivate":
                    boolean deactivated = userDAO.updateUserStatus(userId, "inactive");
                    if (deactivated) {
                        session.setAttribute("success", "Đã vô hiệu hóa người dùng thành công!");
                    } else {
                        session.setAttribute("error", "Không thể vô hiệu hóa người dùng");
                    }
                    break;

                default:
                    session.setAttribute("error", "Hành động không hợp lệ");
            }

            response.sendRedirect(request.getContextPath() + "/admin/user?id=" + userId);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID người dùng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
