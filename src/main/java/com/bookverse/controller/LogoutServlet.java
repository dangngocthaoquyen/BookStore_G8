package com.bookverse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet xử lý đăng xuất
 * URL: /logout
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    /**
     * doGet: Xử lý đăng xuất
     * Invalidate session và redirect về trang login
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Lấy session hiện tại (không tạo mới nếu không tồn tại)
        HttpSession session = request.getSession(false);

        // Lưu tên người dùng trước khi xóa session
        String userName = null;
        if (session != null && session.getAttribute("userFullName") != null) {
            userName = (String) session.getAttribute("userFullName");
        }

        // Invalidate session để đăng xuất
        if (session != null) {
            session.invalidate();
        }

        // Tạo session mới để lưu message
        HttpSession newSession = request.getSession(true);

        // Set success message
        if (userName != null) {
            newSession.setAttribute("successMessage", "Đăng xuất thành công! Hẹn gặp lại " + userName);
        } else {
            newSession.setAttribute("successMessage", "Đăng xuất thành công!");
        }

        // Redirect về trang login
        response.sendRedirect(request.getContextPath() + "/login");
    }

    /**
     * doPost: Cũng xử lý đăng xuất giống doGet
     * Cho phép logout qua POST method
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "LogoutServlet - Xử lý đăng xuất người dùng";
    }
}
