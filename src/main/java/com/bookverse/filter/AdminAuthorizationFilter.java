package com.bookverse.filter;

import com.bookverse.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter để kiểm tra authorization cho admin
 * Chỉ cho phép user có role='admin' truy cập
 */
@WebFilter(urlPatterns = {
        "/admin",
        "/admin/*"
})
public class AdminAuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String contextPath = httpRequest.getContextPath();

        // Kiểm tra đã đăng nhập chưa
        if (session == null || session.getAttribute("user") == null) {
            // Chưa đăng nhập, redirect về login
            session = httpRequest.getSession(true);
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để truy cập trang quản trị.");
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // Kiểm tra role có phải admin không
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");

        boolean isAdmin = (user != null && user.isAdmin()) || "admin".equals(userRole);

        if (isAdmin) {
            // User là admin, cho phép tiếp tục
            chain.doFilter(request, response);
        } else {
            // User không phải admin, từ chối truy cập
            session.setAttribute("errorMessage", "Bạn không có quyền truy cập trang này.");
            httpResponse.sendRedirect(contextPath + "/");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
