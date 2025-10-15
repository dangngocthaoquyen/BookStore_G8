package com.bookverse.controller;

import com.bookverse.dao.UserDAO;
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
 * Servlet quản lý người dùng (Admin)
 * URL: /admin/users
 */
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy parameters
            String keyword = request.getParameter("keyword");
            String roleFilter = request.getParameter("role");
            String statusFilter = request.getParameter("status");

            int page = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException e) {
                page = 1;
            }

            int pageSize = 10;
            int offset = (page - 1) * pageSize;

            List<User> users;
            int totalUsers;

            // Xử lý filter và search
            if (keyword != null && !keyword.trim().isEmpty()) {
                // Search
                users = userDAO.searchUsers(keyword.trim());
                totalUsers = users.size();

                // Manual pagination cho search results
                int fromIndex = Math.min(offset, users.size());
                int toIndex = Math.min(fromIndex + pageSize, users.size());
                users = users.subList(fromIndex, toIndex);

                request.setAttribute("keyword", keyword);
            } else if (roleFilter != null && !roleFilter.isEmpty()) {
                // Filter by role
                users = userDAO.getUsersByRole(roleFilter, offset, pageSize);
                totalUsers = userDAO.countUsersByRole(roleFilter);
                request.setAttribute("role", roleFilter);
            } else if (statusFilter != null && !statusFilter.isEmpty()) {
                // Filter by status
                users = userDAO.getUsersByStatus(statusFilter, offset, pageSize);
                // Count users by status
                totalUsers = 0;
                List<User> allUsers = userDAO.getUsersByStatus(statusFilter, 0, Integer.MAX_VALUE);
                totalUsers = allUsers.size();
                request.setAttribute("status", statusFilter);
            } else {
                // Get all users
                users = userDAO.getAllUsers(offset, pageSize);
                totalUsers = userDAO.countUsers();
            }

            // Tính pagination
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

            // Set attributes
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalUsers", totalUsers);

            // Forward to JSP
            request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách người dùng: " + e.getMessage());
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
                response.sendRedirect(request.getContextPath() + "/admin/users");
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

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID người dùng không hợp lệ");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
