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
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet quản lý đơn hàng (Admin)
 * URL: /admin/orders
 * - GET: Hiển thị danh sách orders với pagination, filter và search
 */
@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private static final int ORDERS_PER_PAGE = 15;

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

        try {
            // Lấy parameters
            String pageParam = request.getParameter("page");
            String statusFilter = request.getParameter("status");
            String keyword = request.getParameter("keyword");

            // Parse page number
            int currentPage = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // Calculate offset
            int offset = (currentPage - 1) * ORDERS_PER_PAGE;

            // Lấy danh sách orders
            List<Order> orders;
            int totalOrders;

            if (keyword != null && !keyword.trim().isEmpty()) {
                // Search by keyword
                orders = searchOrders(keyword.trim(), offset, ORDERS_PER_PAGE);
                totalOrders = countSearchOrders(keyword.trim());
            } else if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equals(statusFilter)) {
                // Filter by status
                orders = orderDAO.getOrdersByStatus(statusFilter, offset, ORDERS_PER_PAGE);
                totalOrders = orderDAO.countOrdersByStatus(statusFilter);
            } else {
                // Get all orders
                orders = orderDAO.getAllOrders(offset, ORDERS_PER_PAGE);
                totalOrders = orderDAO.countOrders();
            }

            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalOrders / ORDERS_PER_PAGE);

            // Get statistics for each status
            int pendingCount = orderDAO.countOrdersByStatus("pending");
            int confirmedCount = orderDAO.countOrdersByStatus("confirmed");
            int shippingCount = orderDAO.countOrdersByStatus("shipping");
            int completedCount = orderDAO.countOrdersByStatus("completed");
            int cancelledCount = orderDAO.countOrdersByStatus("cancelled");

            // Set attributes
            request.setAttribute("orders", orders);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "all");
            request.setAttribute("keyword", keyword != null ? keyword : "");

            // Statistics
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("confirmedCount", confirmedCount);
            request.setAttribute("shippingCount", shippingCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("cancelledCount", cancelledCount);
            request.setAttribute("allCount", totalOrders);

            // Forward đến JSP
            request.getRequestDispatcher("/views/admin/orders.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách đơn hàng: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/orders.jsp").forward(request, response);
        }
    }

    /**
     * Tìm kiếm orders theo order code hoặc customer name
     */
    private List<Order> searchOrders(String keyword, int offset, int limit) throws SQLException {
        // Simplified search - tìm theo order code
        // Trong thực tế nên có method search riêng trong OrderDAO
        List<Order> allOrders = orderDAO.getAllOrders(0, 1000); // Get more records for search
        List<Order> results = new ArrayList<>();

        String keywordLower = keyword.toLowerCase();

        for (Order order : allOrders) {
            if (order.getOrderCode().toLowerCase().contains(keywordLower) ||
                (order.getUserFullName() != null && order.getUserFullName().toLowerCase().contains(keywordLower)) ||
                (order.getShippingName() != null && order.getShippingName().toLowerCase().contains(keywordLower))) {
                results.add(order);
            }
        }

        // Apply pagination manually
        int fromIndex = Math.min(offset, results.size());
        int toIndex = Math.min(offset + limit, results.size());

        if (fromIndex < toIndex) {
            return results.subList(fromIndex, toIndex);
        }

        return new ArrayList<>();
    }

    /**
     * Đếm số orders theo keyword search
     */
    private int countSearchOrders(String keyword) throws SQLException {
        List<Order> allOrders = orderDAO.getAllOrders(0, 1000);
        int count = 0;

        String keywordLower = keyword.toLowerCase();

        for (Order order : allOrders) {
            if (order.getOrderCode().toLowerCase().contains(keywordLower) ||
                (order.getUserFullName() != null && order.getUserFullName().toLowerCase().contains(keywordLower)) ||
                (order.getShippingName() != null && order.getShippingName().toLowerCase().contains(keywordLower))) {
                count++;
            }
        }

        return count;
    }
}
