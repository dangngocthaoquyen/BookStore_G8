package com.bookverse.controller;

import com.bookverse.dao.BookDAO;
import com.bookverse.dao.CategoryDAO;
import com.bookverse.model.Book;
import com.bookverse.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet xử lý trang chủ
 * Hiển thị 8 sách mới nhất và danh sách categories
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookDAO = new BookDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set encoding UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            // Lấy 8 sách mới nhất
            List<Book> latestBooks = bookDAO.getLatestBooks(8);
            System.out.println("========= HOME SERVLET DEBUG =========");
            System.out.println("Latest books count: " + (latestBooks != null ? latestBooks.size() : "null"));

            // Lấy danh sách categories đang active
            List<Category> categories = categoryDAO.getActiveCategories();
            System.out.println("Categories count: " + (categories != null ? categories.size() : "null"));

            // Set attributes
            request.setAttribute("latestBooks", latestBooks);
            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", "Trang chủ");

            // Forward đến home.jsp
            request.getRequestDispatcher("/home.jsp").forward(request, response);

        } catch (SQLException e) {
            // Log error
            getServletContext().log("Lỗi khi load trang chủ: " + e.getMessage(), e);

            // Set empty lists để tránh null pointer
            request.setAttribute("latestBooks", new ArrayList<Book>());
            request.setAttribute("categories", new ArrayList<Category>());
            request.setAttribute("errorMessage", "Không thể tải dữ liệu. Vui lòng thử lại sau.");

            // Forward đến home.jsp với error
            request.getRequestDispatcher("/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET
        doGet(request, response);
    }
}
