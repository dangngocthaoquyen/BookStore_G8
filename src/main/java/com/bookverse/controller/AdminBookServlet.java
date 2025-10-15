package com.bookverse.controller;

import com.bookverse.dao.BookDAO;
import com.bookverse.dao.CategoryDAO;
import com.bookverse.dao.OrderDAO;
import com.bookverse.model.Book;
import com.bookverse.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet quản lý sách cho Admin
 * URL: /admin/books
 * Chức năng: List books với pagination, search, delete
 */
@WebServlet("/admin/books")
public class AdminBookServlet extends HttpServlet {

    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;
    private OrderDAO orderDAO;

    private static final int BOOKS_PER_PAGE = 10;

    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        categoryDAO = new CategoryDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy parameters
            String pageParam = request.getParameter("page");
            String keyword = request.getParameter("keyword");

            int currentPage = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int offset = (currentPage - 1) * BOOKS_PER_PAGE;

            List<Book> books;
            int totalBooks;

            // Tìm kiếm hoặc lấy tất cả
            if (keyword != null && !keyword.trim().isEmpty()) {
                books = bookDAO.searchBooks(keyword.trim(), offset, BOOKS_PER_PAGE);
                totalBooks = bookDAO.countSearchResults(keyword.trim());
                request.setAttribute("keyword", keyword.trim());
            } else {
                books = bookDAO.getAllBooks(offset, BOOKS_PER_PAGE);
                totalBooks = bookDAO.countBooks();
            }

            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalBooks / BOOKS_PER_PAGE);

            // Lấy categories để hiển thị category name (đã có trong Book qua join)
            List<Category> categories = categoryDAO.getAllCategories();
            Map<Integer, String> categoryMap = new HashMap<>();
            for (Category category : categories) {
                categoryMap.put(category.getCategoryId(), category.getCategoryName());
            }

            // Set attributes
            request.setAttribute("books", books);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("categoryMap", categoryMap);
            request.setAttribute("pageTitle", "Quản lý sách");

            // Forward đến JSP
            request.getRequestDispatcher("/views/admin/books.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách sách: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/books.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            handleDelete(request, response, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/books");
        }
    }

    /**
     * Xử lý xóa sách
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {

        String bookIdParam = request.getParameter("bookId");

        // Validate bookId
        if (bookIdParam == null || bookIdParam.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID sách không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/books");
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdParam);

            // Kiểm tra sách có tồn tại không
            Book book = bookDAO.getBookById(bookId);
            if (book == null) {
                session.setAttribute("errorMessage", "Không tìm thấy sách với ID: " + bookId);
                response.sendRedirect(request.getContextPath() + "/admin/books");
                return;
            }

            // Kiểm tra xem sách có trong order_items không
            // Nếu có thì không cho xóa
            if (hasOrderItems(bookId)) {
                session.setAttribute("errorMessage",
                    "Không thể xóa sách \"" + book.getTitle() + "\" vì đã có trong đơn hàng. " +
                    "Bạn có thể đổi trạng thái sách thành 'discontinued' thay vì xóa.");
                response.sendRedirect(request.getContextPath() + "/admin/books");
                return;
            }

            // Thực hiện xóa
            boolean deleted = bookDAO.deleteBook(bookId);

            if (deleted) {
                session.setAttribute("successMessage", "Đã xóa sách \"" + book.getTitle() + "\" thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể xóa sách. Vui lòng thử lại.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID sách không hợp lệ");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi khi xóa sách: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    /**
     * Kiểm tra xem sách có trong order_items không
     */
    private boolean hasOrderItems(int bookId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM order_items WHERE book_id = ?";
        try (java.sql.Connection conn = com.bookverse.util.DatabaseConnection.getNewConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookId);
            java.sql.ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        }
        return false;
    }
}
