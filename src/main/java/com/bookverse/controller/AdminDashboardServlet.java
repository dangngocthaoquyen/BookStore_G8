package com.bookverse.controller;

import com.bookverse.dao.BookDAO;
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
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet quản lý trang Dashboard Admin
 * Hiển thị thống kê tổng quan hệ thống
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra quyền admin
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 1. Đếm tổng số sách
            int totalBooks = bookDAO.countBooks();
            request.setAttribute("totalBooks", totalBooks);

            // 2. Đếm tổng số đơn hàng
            int totalOrders = orderDAO.countOrders();
            request.setAttribute("totalOrders", totalOrders);

            // 3. Đếm số đơn hàng chờ xử lý (pending)
            int pendingOrders = orderDAO.countOrdersByStatus("pending");
            request.setAttribute("pendingOrders", pendingOrders);

            // 4. Đếm tổng số người dùng
            int totalUsers = userDAO.countUsers();
            request.setAttribute("totalUsers", totalUsers);

            // 5. Lấy 10 đơn hàng gần nhất
            List<Order> recentOrders = orderDAO.getAllOrders(0, 10);
            request.setAttribute("recentOrders", recentOrders);

            // 6. Tính tổng doanh thu từ các đơn hàng hoàn thành
            BigDecimal totalRevenue = calculateTotalRevenue();
            request.setAttribute("totalRevenue", totalRevenue);

            // Format doanh thu
            String formattedRevenue = String.format("%,.0f đ", totalRevenue);
            request.setAttribute("formattedRevenue", formattedRevenue);

            // Thiết lập page title
            request.setAttribute("pageTitle", "Dashboard - Quản trị");

            // Forward đến dashboard.jsp
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu dashboard: " + e.getMessage());
            request.getRequestDispatcher("/views/error/500.jsp").forward(request, response);
        }
    }

    /**
     * Tính tổng doanh thu từ các đơn hàng đã hoàn thành
     */
    private BigDecimal calculateTotalRevenue() throws SQLException {
        BigDecimal totalRevenue = BigDecimal.ZERO;

        // Lấy tất cả đơn hàng hoàn thành (không phân trang)
        List<Order> completedOrders = orderDAO.getOrdersByStatus("completed", 0, Integer.MAX_VALUE);

        // Tính tổng
        for (Order order : completedOrders) {
            if (order.getTotalAmount() != null) {
                totalRevenue = totalRevenue.add(order.getTotalAmount());
            }
        }

        return totalRevenue;
    }
}
