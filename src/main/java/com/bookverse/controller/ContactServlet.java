package com.bookverse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet xử lý trang liên hệ
 * URL: /contact
 */
@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    /**
     * doGet: Hiển thị trang liên hệ
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Forward đến trang contact
        request.getRequestDispatcher("/views/user/contact.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "ContactServlet - Hiển thị trang liên hệ BookVerse";
    }
}
