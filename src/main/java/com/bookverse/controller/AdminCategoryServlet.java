package com.bookverse.controller;

import com.bookverse.dao.CategoryDAO;
import com.bookverse.model.Category;
import com.bookverse.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet quản lý danh mục sách (Admin)
 * URL: /admin/categories
 * - GET: Hiển thị danh sách categories với số lượng sách
 * - POST: Xóa category (kiểm tra constraint trước)
 */
@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
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
            // Lấy tất cả categories
            List<Category> categories = categoryDAO.getAllCategories();

            // Tạo map để lưu số lượng sách trong mỗi category
            Map<Integer, Integer> bookCounts = new HashMap<>();
            for (Category category : categories) {
                int count = categoryDAO.countBooksInCategory(category.getCategoryId());
                bookCounts.put(category.getCategoryId(), count);
            }

            // Set attributes
            request.setAttribute("categories", categories);
            request.setAttribute("bookCounts", bookCounts);
            request.setAttribute("totalCategories", categories.size());

            // Forward đến JSP
            request.getRequestDispatcher("/views/admin/categories.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách danh mục: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/categories.jsp").forward(request, response);
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

        // Lấy action từ form
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            handleDelete(request, response, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }

    /**
     * Xử lý xóa category
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {

        String categoryIdStr = request.getParameter("categoryId");

        // Validation
        if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID danh mục không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdStr);

            // Kiểm tra số lượng sách trong category
            int bookCount = categoryDAO.countBooksInCategory(categoryId);

            if (bookCount > 0) {
                session.setAttribute("errorMessage",
                    "Không thể xóa danh mục này vì còn " + bookCount + " sách đang sử dụng danh mục này");
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                return;
            }

            // Thực hiện xóa
            boolean deleted = categoryDAO.deleteCategory(categoryId);

            if (deleted) {
                session.setAttribute("successMessage", "Xóa danh mục thành công");
            } else {
                session.setAttribute("errorMessage", "Không thể xóa danh mục");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID danh mục không hợp lệ");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi khi xóa danh mục: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
