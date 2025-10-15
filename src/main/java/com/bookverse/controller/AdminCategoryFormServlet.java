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

/**
 * Servlet quản lý form tạo/sửa category (Admin)
 * URL: /admin/category-form
 * - GET: Hiển thị form (create mới hoặc edit)
 * - POST: Xử lý tạo/cập nhật category
 */
@WebServlet("/admin/category-form")
public class AdminCategoryFormServlet extends HttpServlet {

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

        String categoryIdStr = request.getParameter("id");

        try {
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                // Edit mode
                int categoryId = Integer.parseInt(categoryIdStr);
                Category category = categoryDAO.getCategoryById(categoryId);

                if (category == null) {
                    session.setAttribute("errorMessage", "Không tìm thấy danh mục");
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    return;
                }

                request.setAttribute("category", category);
                request.setAttribute("isEdit", true);
            } else {
                // Create mode
                request.setAttribute("isEdit", false);
            }

            // Forward đến form
            request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID danh mục không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi khi tải thông tin danh mục: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/categories");
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
        String categoryIdStr = request.getParameter("categoryId");
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (categoryName == null || categoryName.trim().isEmpty()) {
            errors.append("Tên danh mục không được để trống. ");
        } else if (categoryName.trim().length() > 100) {
            errors.append("Tên danh mục không được vượt quá 100 ký tự. ");
        }

        if (description != null && description.trim().length() > 500) {
            errors.append("Mô tả không được vượt quá 500 ký tự. ");
        }

        if (status == null || (!status.equals("active") && !status.equals("inactive"))) {
            errors.append("Trạng thái không hợp lệ. ");
        }

        // Nếu có lỗi validation
        if (errors.length() > 0) {
            session.setAttribute("errorMessage", errors.toString().trim());

            // Giữ lại dữ liệu đã nhập
            Category category = new Category();
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    category.setCategoryId(Integer.parseInt(categoryIdStr));
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            category.setCategoryName(categoryName);
            category.setDescription(description);
            category.setStatus(status);

            request.setAttribute("category", category);
            request.setAttribute("isEdit", categoryIdStr != null && !categoryIdStr.trim().isEmpty());
            request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
            return;
        }

        try {
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                // Update existing category
                handleUpdate(request, response, session, categoryIdStr, categoryName, description, status);
            } else {
                // Create new category
                handleCreate(request, response, session, categoryName, description, status);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi database: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }

    /**
     * Xử lý tạo category mới
     */
    private void handleCreate(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session, String categoryName, String description, String status)
            throws SQLException, IOException {

        // Kiểm tra tên category đã tồn tại chưa
        if (categoryDAO.categoryNameExists(categoryName.trim())) {
            session.setAttribute("errorMessage", "Tên danh mục đã tồn tại");

            // Giữ lại dữ liệu
            Category category = new Category();
            category.setCategoryName(categoryName);
            category.setDescription(description);
            category.setStatus(status);

            request.setAttribute("category", category);
            request.setAttribute("isEdit", false);
            try {
                request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
            } catch (ServletException e) {
                e.printStackTrace();
            }
            return;
        }

        // Tạo category mới
        Category category = new Category();
        category.setCategoryName(categoryName.trim());
        category.setDescription(description != null ? description.trim() : null);
        category.setStatus(status);

        boolean created = categoryDAO.createCategory(category);

        if (created) {
            session.setAttribute("successMessage", "Thêm danh mục thành công");
        } else {
            session.setAttribute("errorMessage", "Không thể thêm danh mục");
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    /**
     * Xử lý cập nhật category
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session, String categoryIdStr,
                              String categoryName, String description, String status)
            throws SQLException, IOException {

        try {
            int categoryId = Integer.parseInt(categoryIdStr);

            // Kiểm tra category có tồn tại không
            Category existingCategory = categoryDAO.getCategoryById(categoryId);
            if (existingCategory == null) {
                session.setAttribute("errorMessage", "Không tìm thấy danh mục");
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                return;
            }

            // Kiểm tra tên category đã tồn tại chưa (trừ category hiện tại)
            if (categoryDAO.categoryNameExists(categoryName.trim(), categoryId)) {
                session.setAttribute("errorMessage", "Tên danh mục đã tồn tại");

                // Giữ lại dữ liệu
                Category category = new Category();
                category.setCategoryId(categoryId);
                category.setCategoryName(categoryName);
                category.setDescription(description);
                category.setStatus(status);

                request.setAttribute("category", category);
                request.setAttribute("isEdit", true);
                try {
                    request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
                } catch (ServletException e) {
                    e.printStackTrace();
                }
                return;
            }

            // Cập nhật category
            Category category = new Category();
            category.setCategoryId(categoryId);
            category.setCategoryName(categoryName.trim());
            category.setDescription(description != null ? description.trim() : null);
            category.setStatus(status);

            boolean updated = categoryDAO.updateCategory(category);

            if (updated) {
                session.setAttribute("successMessage", "Cập nhật danh mục thành công");
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật danh mục");
            }

            response.sendRedirect(request.getContextPath() + "/admin/categories");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID danh mục không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }
}
