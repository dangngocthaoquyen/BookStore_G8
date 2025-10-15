package com.bookverse.controller;

import com.bookverse.dao.UserDAO;
import com.bookverse.model.User;
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
 * Servlet xử lý thông tin cá nhân người dùng
 * URL: /profile
 */
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    /**
     * doGet: Hiển thị trang thông tin cá nhân
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=/profile");
            return;
        }

        // Lấy thông tin user từ session
        User user = (User) session.getAttribute("user");

        // Refresh user data từ database để đảm bảo dữ liệu mới nhất
        try {
            User freshUser = userDAO.getUserById(user.getUserId());
            if (freshUser != null) {
                // Update session với dữ liệu mới
                session.setAttribute("user", freshUser);
                request.setAttribute("user", freshUser);
            } else {
                request.setAttribute("user", user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("user", user);
        }

        // Set page title
        request.setAttribute("pageTitle", "Thông tin cá nhân");

        // Forward đến profile.jsp
        request.getRequestDispatcher("/views/user/profile.jsp").forward(request, response);
    }

    /**
     * doPost: Cập nhật thông tin cá nhân
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
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validation
        StringBuilder errors = new StringBuilder();

        // Validate full name
        if (ValidationUtil.isEmpty(fullName)) {
            errors.append("Họ tên không được để trống. ");
        } else if (!ValidationUtil.isValidFullName(fullName)) {
            errors.append("Họ tên chỉ được chứa chữ cái và khoảng trắng. ");
        }

        // Validate phone
        if (ValidationUtil.isEmpty(phone)) {
            errors.append("Số điện thoại không được để trống. ");
        } else if (!ValidationUtil.isValidPhone(phone)) {
            errors.append("Số điện thoại không đúng định dạng (phải là số điện thoại Việt Nam). ");
        }

        // Validate address (optional nhưng nếu có thì phải hợp lệ)
        if (ValidationUtil.isNotEmpty(address) && !ValidationUtil.isValidLength(address, 5, 200)) {
            errors.append("Địa chỉ phải có độ dài từ 5 đến 200 ký tự. ");
        }

        // Nếu có lỗi validation
        if (errors.length() > 0) {
            session.setAttribute("errorMessage", errors.toString().trim());
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        try {
            // Cập nhật thông tin user
            currentUser.setFullName(fullName.trim());
            currentUser.setPhone(phone.trim());
            currentUser.setAddress(address != null ? address.trim() : "");

            // Update vào database
            boolean success = userDAO.updateUser(currentUser);

            if (success) {
                // Refresh user từ database
                User updatedUser = userDAO.getUserById(currentUser.getUserId());

                // Cập nhật session
                session.setAttribute("user", updatedUser);
                session.setAttribute("userFullName", updatedUser.getFullName());

                // Thông báo thành công
                session.setAttribute("successMessage", "Cập nhật thông tin cá nhân thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật thông tin. Vui lòng thử lại!");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra trong quá trình cập nhật. Vui lòng thử lại sau!");
        }

        // Redirect về trang profile
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    @Override
    public String getServletInfo() {
        return "ProfileServlet - Quản lý thông tin cá nhân người dùng";
    }
}
