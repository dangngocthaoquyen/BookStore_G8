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
 * Servlet xử lý đăng nhập
 * URL: /login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    /**
     * doGet: Hiển thị trang đăng nhập
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Kiểm tra nếu đã đăng nhập
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            // Redirect dựa trên role
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
            return;
        }

        // Forward đến trang login
        request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
    }

    /**
     * doPost: Xử lý đăng nhập
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Lấy thông tin từ form
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember"); // checkbox "Ghi nhớ đăng nhập"

        // Validate input
        if (ValidationUtil.isEmpty(email) || ValidationUtil.isEmpty(password)) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ email và mật khẩu");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
            return;
        }

        // Validate email format
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Email không đúng định dạng");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
            return;
        }

        try {
            // Lấy user từ database
            User user = userDAO.getUserByEmail(email);

            // Kiểm tra user tồn tại
            if (user == null) {
                request.setAttribute("errorMessage", "Email hoặc mật khẩu không chính xác");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
                return;
            }

            // Kiểm tra tài khoản có active không
            if (!user.isActive()) {
                request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
                return;
            }

            // Verify password
            if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
                request.setAttribute("errorMessage", "Email hoặc mật khẩu không chính xác");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
                return;
            }

            // Đăng nhập thành công - Tạo session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userFullName", user.getFullName());

            // Thiết lập thời gian session
            if ("on".equals(remember)) {
                // Ghi nhớ 7 ngày
                session.setMaxInactiveInterval(7 * 24 * 60 * 60);
            } else {
                // 30 phút mặc định
                session.setMaxInactiveInterval(30 * 60);
            }

            // Set success message
            session.setAttribute("successMessage", "Đăng nhập thành công! Chào mừng " + user.getFullName());

            // Redirect dựa trên role
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // Kiểm tra có returnUrl không
                String returnUrl = request.getParameter("returnUrl");
                if (ValidationUtil.isNotEmpty(returnUrl)) {
                    response.sendRedirect(request.getContextPath() + returnUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra trong quá trình đăng nhập. Vui lòng thử lại sau");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "LoginServlet - Xử lý đăng nhập người dùng";
    }
}
