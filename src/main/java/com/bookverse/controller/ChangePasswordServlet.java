package com.bookverse.controller;

import com.bookverse.dao.UserDAO;
import com.bookverse.model.User;
import com.bookverse.util.PasswordUtil;
import com.bookverse.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet xử lý đổi mật khẩu
 * URL: /change-password
 */
@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    /**
     * doPost: Xử lý đổi mật khẩu
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        // Lấy dữ liệu từ form
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        StringBuilder errors = new StringBuilder();

        // Validate old password
        if (ValidationUtil.isEmpty(oldPassword)) {
            errors.append("Mật khẩu cũ không được để trống. ");
        }

        // Validate new password
        if (ValidationUtil.isEmpty(newPassword)) {
            errors.append("Mật khẩu mới không được để trống. ");
        } else if (!ValidationUtil.isValidPassword(newPassword)) {
            errors.append("Mật khẩu mới phải có ít nhất 6 ký tự. ");
        }

        // Validate confirm password
        if (ValidationUtil.isEmpty(confirmPassword)) {
            errors.append("Vui lòng xác nhận mật khẩu mới. ");
        } else if (!newPassword.equals(confirmPassword)) {
            errors.append("Mật khẩu xác nhận không khớp. ");
        }

        // Check mật khẩu mới khác mật khẩu cũ
        if (ValidationUtil.isNotEmpty(oldPassword) && ValidationUtil.isNotEmpty(newPassword)
                && oldPassword.equals(newPassword)) {
            errors.append("Mật khẩu mới phải khác mật khẩu cũ. ");
        }

        // Nếu có lỗi validation
        if (errors.length() > 0) {
            session.setAttribute("errorMessage", errors.toString().trim());
            response.sendRedirect(request.getContextPath() + "/profile#change-password");
            return;
        }

        try {
            // Lấy user từ database để có password hash đầy đủ
            User dbUser = userDAO.getUserById(currentUser.getUserId());

            if (dbUser == null) {
                session.setAttribute("errorMessage", "Không tìm thấy thông tin người dùng!");
                response.sendRedirect(request.getContextPath() + "/profile#change-password");
                return;
            }

            // Verify old password
            if (!PasswordUtil.verifyPassword(oldPassword, dbUser.getPassword())) {
                session.setAttribute("errorMessage", "Mật khẩu cũ không chính xác!");
                response.sendRedirect(request.getContextPath() + "/profile#change-password");
                return;
            }

            // Hash mật khẩu mới
            String hashedNewPassword = PasswordUtil.hashPassword(newPassword);

            // Update password trong database
            boolean success = userDAO.updatePassword(currentUser.getUserId(), hashedNewPassword);

            if (success) {
                // Cập nhật password trong session user
                currentUser.setPassword(hashedNewPassword);
                session.setAttribute("user", currentUser);

                // Thông báo thành công
                session.setAttribute("successMessage", "Đổi mật khẩu thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể đổi mật khẩu. Vui lòng thử lại!");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra trong quá trình đổi mật khẩu. Vui lòng thử lại sau!");
        }

        // Redirect về trang profile với tab change-password
        response.sendRedirect(request.getContextPath() + "/profile#change-password");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect về profile page
        response.sendRedirect(request.getContextPath() + "/profile#change-password");
    }

    @Override
    public String getServletInfo() {
        return "ChangePasswordServlet - Xử lý đổi mật khẩu người dùng";
    }
}
