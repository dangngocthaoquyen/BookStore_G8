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
 * Servlet xử lý đăng ký tài khoản
 * URL: /register
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    /**
     * doGet: Hiển thị trang đăng ký
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Kiểm tra nếu đã đăng nhập thì redirect về trang chủ
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Forward đến trang register
        request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
    }

    /**
     * doPost: Xử lý đăng ký
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Lấy thông tin từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String address = request.getParameter("address"); // Optional

        // ========== VALIDATION ==========

        // 1. Kiểm tra các trường bắt buộc
        if (ValidationUtil.isEmpty(fullName) || ValidationUtil.isEmpty(email) ||
            ValidationUtil.isEmpty(phone) || ValidationUtil.isEmpty(password) ||
            ValidationUtil.isEmpty(confirmPassword)) {

            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc");
            setFormData(request, fullName, email, phone, address);
            request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
            return;
        }

        // 2. Validate họ tên
        if (!ValidationUtil.isValidFullName(fullName)) {
            request.setAttribute("errorMessage", "Họ tên không hợp lệ. Vui lòng chỉ nhập chữ cái và khoảng trắng");
            setFormData(request, fullName, email, phone, address);
            request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
            return;
        }

        // 3. Validate email
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Email không đúng định dạng");
            setFormData(request, fullName, email, phone, address);
            request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
            return;
        }

        // 4. Validate số điện thoại
        if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("errorMessage", "Số điện thoại không đúng định dạng. Vui lòng nhập số điện thoại Việt Nam hợp lệ");
            setFormData(request, fullName, email, phone, address);
            request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
            return;
        }

        // 5. Validate password
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("errorMessage", "Mật khẩu phải có ít nhất 6 ký tự");
            setFormData(request, fullName, email, phone, address);
            request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
            return;
        }

        // 6. Kiểm tra password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp");
            setFormData(request, fullName, email, phone, address);
            request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
            return;
        }

        // 7. Validate độ dài họ tên
        if (!ValidationUtil.isValidLength(fullName, 2, 100)) {
            request.setAttribute("errorMessage", "Họ tên phải từ 2 đến 100 ký tự");
            setFormData(request, fullName, email, phone, address);
            request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
            return;
        }

        // 8. Validate địa chỉ nếu có
        if (ValidationUtil.isNotEmpty(address) && !ValidationUtil.isValidLength(address, 5, 500)) {
            request.setAttribute("errorMessage", "Địa chỉ phải từ 5 đến 500 ký tự");
            setFormData(request, fullName, email, phone, address);
            request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
            return;
        }

        try {
            // ========== KIỂM TRA EMAIL TỒN TẠI ==========
            if (userDAO.emailExists(email)) {
                request.setAttribute("errorMessage", "Email đã được sử dụng. Vui lòng sử dụng email khác");
                setFormData(request, fullName, email, phone, address);
                request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
                return;
            }

            // ========== HASH PASSWORD ==========
            String hashedPassword = PasswordUtil.hashPassword(password);

            // ========== TẠO USER OBJECT ==========
            User newUser = new User();
            newUser.setFullName(fullName.trim());
            newUser.setEmail(email.trim().toLowerCase());
            newUser.setPassword(hashedPassword);
            newUser.setPhone(phone.trim());
            newUser.setAddress(ValidationUtil.isNotEmpty(address) ? address.trim() : "");
            newUser.setRole("user"); // Mặc định là user
            newUser.setStatus("active"); // Mặc định là active

            // ========== LƯU VÀO DATABASE ==========
            boolean isCreated = userDAO.createUser(newUser);

            if (isCreated) {
                // Đăng ký thành công
                HttpSession session = request.getSession(true);
                session.setAttribute("successMessage", "Đăng ký tài khoản thành công! Vui lòng đăng nhập");

                // Redirect về trang login
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                // Lỗi khi tạo user
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo tài khoản. Vui lòng thử lại sau");
                setFormData(request, fullName, email, phone, address);
                request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();

            // Xử lý lỗi database
            String errorMsg = "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại sau";

            // Kiểm tra lỗi duplicate email (MySQL error code 1062)
            if (e.getMessage() != null && e.getMessage().contains("Duplicate entry")) {
                errorMsg = "Email đã được sử dụng. Vui lòng sử dụng email khác";
            }

            request.setAttribute("errorMessage", errorMsg);
            setFormData(request, fullName, email, phone, address);
            request.getRequestDispatcher("/views/user/register.jsp").forward(request, response);
        }
    }

    /**
     * Helper method để set lại form data khi có lỗi
     */
    private void setFormData(HttpServletRequest request, String fullName, String email,
                             String phone, String address) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
    }

    @Override
    public String getServletInfo() {
        return "RegisterServlet - Xử lý đăng ký tài khoản người dùng";
    }
}
