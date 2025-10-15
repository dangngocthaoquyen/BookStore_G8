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
 * Servlet xử lý danh sách sách
 * Hỗ trợ phân trang, tìm kiếm và lọc theo category
 */
@WebServlet("/books")
public class BookListServlet extends HttpServlet {

    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;

    private static final int BOOKS_PER_PAGE = 12;

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
            // Lấy parameters
            String keyword = request.getParameter("keyword");
            String categoryIdStr = request.getParameter("categoryId");
            String pageStr = request.getParameter("page");

            // Parse parameters
            Integer categoryId = null;
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                } catch (NumberFormatException e) {
                    // Invalid category ID, ignore
                }
            }

            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // Calculate offset
            int offset = (currentPage - 1) * BOOKS_PER_PAGE;

            // Lấy danh sách sách theo điều kiện
            List<Book> books;
            int totalBooks;

            if (keyword != null && !keyword.trim().isEmpty()) {
                // Tìm kiếm theo keyword
                keyword = keyword.trim();
                books = bookDAO.searchBooks(keyword, offset, BOOKS_PER_PAGE);
                totalBooks = bookDAO.countSearchResults(keyword);
                request.setAttribute("keyword", keyword);
            } else if (categoryId != null) {
                // Lọc theo category
                books = bookDAO.getBooksByCategory(categoryId, offset, BOOKS_PER_PAGE);
                totalBooks = bookDAO.countBooksByCategory(categoryId);
                request.setAttribute("categoryId", categoryId);

                // Lấy thông tin category để hiển thị
                Category category = categoryDAO.getCategoryById(categoryId);
                request.setAttribute("currentCategory", category);
            } else {
                // Lấy tất cả sách
                books = bookDAO.getAllBooks(offset, BOOKS_PER_PAGE);
                totalBooks = bookDAO.countBooks();
            }

            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalBooks / BOOKS_PER_PAGE);
            if (totalPages < 1) totalPages = 1;

            // Lấy danh sách categories để hiển thị sidebar
            List<Category> categories = categoryDAO.getActiveCategories();

            // Set attributes
            request.setAttribute("books", books);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("booksPerPage", BOOKS_PER_PAGE);
            request.setAttribute("pageTitle", "Danh sách sách");

            // Forward đến books.jsp
            request.getRequestDispatcher("/views/user/books.jsp").forward(request, response);

        } catch (SQLException e) {
            // Log error
            getServletContext().log("Lỗi khi load danh sách sách: " + e.getMessage(), e);

            // Set empty lists để tránh null pointer
            request.setAttribute("books", new ArrayList<Book>());
            request.setAttribute("categories", new ArrayList<Category>());
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalBooks", 0);
            request.setAttribute("errorMessage", "Không thể tải danh sách sách. Vui lòng thử lại sau.");

            // Forward đến books.jsp với error
            request.getRequestDispatcher("/views/user/books.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET
        doGet(request, response);
    }
}
