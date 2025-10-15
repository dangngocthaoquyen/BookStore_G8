package com.bookverse.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter để kiểm tra authentication
 * Bảo vệ các trang yêu cầu đăng nhập
 */
@WebFilter(urlPatterns = {
        "/cart",
        "/cart/*",
        "/checkout",
        "/checkout/*",
        "/orders",
        "/orders/*",
        "/profile",
        "/profile/*"
})
public class AuthenticationFilter implements Filter {

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

        // Kiểm tra session và user
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            // User đã đăng nhập, cho phép tiếp tục
            chain.doFilter(request, response);
        } else {
            // User chưa đăng nhập, redirect về login
            String requestURI = httpRequest.getRequestURI();
            String contextPath = httpRequest.getContextPath();

            // Lưu URL hiện tại để redirect sau khi login
            String returnUrl = requestURI;
            String queryString = httpRequest.getQueryString();
            if (queryString != null) {
                returnUrl += "?" + queryString;
            }

            // Set message và redirect
            HttpSession newSession = httpRequest.getSession(true);
            newSession.setAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục.");
            newSession.setAttribute("returnUrl", returnUrl);

            httpResponse.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
