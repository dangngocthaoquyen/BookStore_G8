package com.bookverse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet xử lý trang giới thiệu
 * URL: /about
 */
@WebServlet("/about")
public class AboutServlet extends HttpServlet {

    /**
     * doGet: Hiển thị trang giới thiệu
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Forward đến trang about
        request.getRequestDispatcher("/views/user/about.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "AboutServlet - Hiển thị trang giới thiệu BookVerse";
    }
}
