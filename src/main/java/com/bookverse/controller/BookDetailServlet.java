package com.bookverse.controller;

import com.bookverse.dao.BookDAO;
import com.bookverse.model.Book;
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
 * Servlet xử lý trang chi tiết sách
 * Hiển thị thông tin chi tiết của 1 cuốn sách và các sách liên quan
 */
@WebServlet("/book")
public class BookDetailServlet extends HttpServlet {

    private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookDAO = new BookDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set encoding UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            // Lấy book_id từ parameter
            String bookIdParam = request.getParameter("id");

            // Validation: kiểm tra book_id có tồn tại không
            if (bookIdParam == null || bookIdParam.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã sách");
                return;
            }

            // Parse book_id
            int bookId;
            try {
                bookId = Integer.parseInt(bookIdParam);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã sách không hợp lệ");
                return;
            }

            // Lấy book từ database (có JOIN với category)
            Book book = bookDAO.getBookById(bookId);

            // Kiểm tra book có tồn tại không
            if (book == null) {
                // Forward đến trang 404
                request.setAttribute("errorMessage", "Không tìm thấy sách với mã: " + bookId);
                request.getRequestDispatcher("/views/error/404.jsp").forward(request, response);
                return;
            }

            // Lấy related books cùng category (limit 4, exclude current book)
            List<Book> relatedBooks = new ArrayList<>();
            if (book.getCategoryId() > 0) {
                try {
                    // Lấy tối đa 5 cuốn để có thể lọc ra cuốn hiện tại
                    List<Book> categoryBooks = bookDAO.getBooksByCategory(book.getCategoryId(), 0, 5);

                    // Lọc bỏ cuốn sách hiện tại và chỉ lấy 4 cuốn
                    for (Book relatedBook : categoryBooks) {
                        if (relatedBook.getBookId() != bookId && relatedBooks.size() < 4) {
                            relatedBooks.add(relatedBook);
                        }
                    }
                } catch (SQLException e) {
                    // Log error nhưng vẫn hiển thị trang chi tiết
                    getServletContext().log("Lỗi khi lấy related books: " + e.getMessage(), e);
                }
            }

            // Set attributes
            request.setAttribute("book", book);
            request.setAttribute("relatedBooks", relatedBooks);
            request.setAttribute("pageTitle", book.getTitle());

            // Forward đến JSP
            request.getRequestDispatcher("/views/user/book-detail.jsp").forward(request, response);

        } catch (SQLException e) {
            // Log error
            getServletContext().log("Lỗi khi load chi tiết sách: " + e.getMessage(), e);

            // Set error message và forward đến error page
            request.setAttribute("errorMessage", "Không thể tải thông tin sách. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/error/500.jsp").forward(request, response);

        } catch (Exception e) {
            // Catch all other exceptions
            getServletContext().log("Lỗi không xác định: " + e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET
        doGet(request, response);
    }
}
