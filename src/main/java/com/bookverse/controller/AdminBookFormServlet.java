package com.bookverse.controller;

import com.bookverse.dao.BookDAO;
import com.bookverse.dao.CategoryDAO;
import com.bookverse.model.Book;
import com.bookverse.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Servlet quản lý form thêm/sửa sách cho Admin
 * URL: /admin/book-form
 * Chức năng: Show form và xử lý create/update sách
 */
@WebServlet("/admin/book-form")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 10,        // 10 MB
    maxRequestSize = 1024 * 1024 * 15      // 15 MB
)
public class AdminBookFormServlet extends HttpServlet {

    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        categoryDAO = new CategoryDAO();
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
            String idParam = request.getParameter("id");
            Book book = null;
            String pageTitle = "Thêm sách mới";

            // Nếu có id => Edit mode
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int bookId = Integer.parseInt(idParam);
                    book = bookDAO.getBookById(bookId);

                    if (book == null) {
                        session.setAttribute("errorMessage", "Không tìm thấy sách với ID: " + bookId);
                        response.sendRedirect(request.getContextPath() + "/admin/books");
                        return;
                    }

                    pageTitle = "Chỉnh sửa sách";
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "ID sách không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/admin/books");
                    return;
                }
            }

            // Lấy danh sách categories cho dropdown
            List<Category> categories = categoryDAO.getAllCategories();

            // Set attributes
            request.setAttribute("book", book);
            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", pageTitle);

            // Forward đến JSP
            request.getRequestDispatcher("/views/admin/book-form.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi khi tải form: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/books");
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

        // Lấy form data
        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String categoryIdParam = request.getParameter("categoryId");
        String description = request.getParameter("description");
        String priceParam = request.getParameter("price");
        String stockQuantityParam = request.getParameter("stockQuantity");
        String isbn = request.getParameter("isbn");
        String publisher = request.getParameter("publisher");
        String publishYearParam = request.getParameter("publishYear");
        String status = request.getParameter("status");

        // Xử lý upload ảnh
        String imageUrl = null;
        Part imagePart = request.getPart("imageFile");

        if (imagePart != null && imagePart.getSize() > 0) {
            // Có file mới được upload
            imageUrl = handleFileUpload(imagePart, request);
            if (imageUrl == null) {
                session.setAttribute("errorMessage", "Lỗi khi upload ảnh. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/admin/book-form" +
                    (idParam != null && !idParam.isEmpty() ? "?id=" + idParam : ""));
                return;
            }
        } else {
            // Không có file mới, giữ ảnh cũ nếu đang edit
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int bookId = Integer.parseInt(idParam);
                    Book existingBook = bookDAO.getBookById(bookId);
                    if (existingBook != null) {
                        imageUrl = existingBook.getImageUrl();
                    }
                } catch (Exception e) {
                    // Keep imageUrl as null
                }
            }
        }

        // Validate dữ liệu
        List<String> errors = new ArrayList<>();

        if (title == null || title.trim().isEmpty()) {
            errors.add("Tên sách không được để trống");
        }

        if (author == null || author.trim().isEmpty()) {
            errors.add("Tác giả không được để trống");
        }

        if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
            errors.add("Danh mục không được để trống");
        }

        if (priceParam == null || priceParam.trim().isEmpty()) {
            errors.add("Giá sách không được để trống");
        }

        if (stockQuantityParam == null || stockQuantityParam.trim().isEmpty()) {
            errors.add("Số lượng tồn kho không được để trống");
        }

        if (isbn == null || isbn.trim().isEmpty()) {
            errors.add("ISBN không được để trống");
        }

        // Nếu có lỗi validation, quay lại form
        if (!errors.isEmpty()) {
            try {
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.setAttribute("errors", errors);
                request.setAttribute("formData", request.getParameterMap());

                String pageTitle = (idParam != null && !idParam.trim().isEmpty()) ?
                        "Chỉnh sửa sách" : "Thêm sách mới";
                request.setAttribute("pageTitle", pageTitle);

                request.getRequestDispatcher("/views/admin/book-form.jsp").forward(request, response);
                return;
            } catch (SQLException e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi khi xử lý form: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/admin/books");
                return;
            }
        }

        try {
            // Parse dữ liệu
            int categoryId = Integer.parseInt(categoryIdParam);
            BigDecimal price = new BigDecimal(priceParam);
            int stockQuantity = Integer.parseInt(stockQuantityParam);

            Integer publishYear = null;
            if (publishYearParam != null && !publishYearParam.trim().isEmpty()) {
                try {
                    publishYear = Integer.parseInt(publishYearParam);
                    if (publishYear < 1000 || publishYear > 9999) {
                        errors.add("Năm xuất bản không hợp lệ (phải từ 1000-9999)");
                    }
                } catch (NumberFormatException e) {
                    errors.add("Năm xuất bản phải là số");
                }
            }

            // Validate giá và số lượng
            if (price.compareTo(BigDecimal.ZERO) <= 0) {
                errors.add("Giá sách phải lớn hơn 0");
            }

            if (stockQuantity < 0) {
                errors.add("Số lượng tồn kho không được âm");
            }

            // Nếu có lỗi validation số, quay lại form
            if (!errors.isEmpty()) {
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.setAttribute("errors", errors);
                request.setAttribute("formData", request.getParameterMap());

                String pageTitle = (idParam != null && !idParam.trim().isEmpty()) ?
                        "Chỉnh sửa sách" : "Thêm sách mới";
                request.setAttribute("pageTitle", pageTitle);

                request.getRequestDispatcher("/views/admin/book-form.jsp").forward(request, response);
                return;
            }

            // Tạo Book object
            Book book = new Book();
            book.setTitle(title.trim());
            book.setAuthor(author.trim());
            book.setCategoryId(categoryId);
            book.setDescription(description != null ? description.trim() : "");
            book.setPrice(price);
            book.setStockQuantity(stockQuantity);
            book.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
            book.setIsbn(isbn.trim());
            book.setPublisher(publisher != null ? publisher.trim() : "");
            book.setPublishYear(publishYear);
            book.setStatus(status != null && !status.trim().isEmpty() ? status : "available");

            boolean success;

            // Nếu có id => Update
            if (idParam != null && !idParam.trim().isEmpty()) {
                int bookId = Integer.parseInt(idParam);
                book.setBookId(bookId);

                // Kiểm tra ISBN trùng (trừ sách hiện tại)
                if (bookDAO.isbnExists(isbn.trim(), bookId)) {
                    errors.add("ISBN đã tồn tại cho sách khác");
                    List<Category> categories = categoryDAO.getAllCategories();
                    request.setAttribute("categories", categories);
                    request.setAttribute("errors", errors);
                    request.setAttribute("formData", request.getParameterMap());
                    request.setAttribute("pageTitle", "Chỉnh sửa sách");
                    request.getRequestDispatcher("/views/admin/book-form.jsp").forward(request, response);
                    return;
                }

                success = bookDAO.updateBook(book);

                if (success) {
                    session.setAttribute("successMessage", "Đã cập nhật sách \"" + book.getTitle() + "\" thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không thể cập nhật sách. Vui lòng thử lại.");
                }
            }
            // Nếu không có id => Create
            else {
                // Kiểm tra ISBN trùng
                if (bookDAO.isbnExists(isbn.trim())) {
                    errors.add("ISBN đã tồn tại");
                    List<Category> categories = categoryDAO.getAllCategories();
                    request.setAttribute("categories", categories);
                    request.setAttribute("errors", errors);
                    request.setAttribute("formData", request.getParameterMap());
                    request.setAttribute("pageTitle", "Thêm sách mới");
                    request.getRequestDispatcher("/views/admin/book-form.jsp").forward(request, response);
                    return;
                }

                success = bookDAO.createBook(book);

                if (success) {
                    session.setAttribute("successMessage", "Đã thêm sách \"" + book.getTitle() + "\" thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không thể thêm sách. Vui lòng thử lại.");
                }
            }

            // Redirect về trang danh sách
            response.sendRedirect(request.getContextPath() + "/admin/books");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/books");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi khi lưu sách: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/books");
        }
    }

    /**
     * Xử lý upload file ảnh
     * @param part File part từ request
     * @param request HTTP request để lấy servlet context
     * @return Đường dẫn tương đối của ảnh (hoặc null nếu lỗi)
     */
    private String handleFileUpload(Part part, HttpServletRequest request) {
        try {
            // Lấy tên file gốc
            String originalFileName = part.getSubmittedFileName();
            if (originalFileName == null || originalFileName.isEmpty()) {
                return null;
            }

            // Validate file extension
            String fileExtension = "";
            int lastDotIndex = originalFileName.lastIndexOf('.');
            if (lastDotIndex > 0) {
                fileExtension = originalFileName.substring(lastDotIndex).toLowerCase();
            }

            // Chỉ chấp nhận các định dạng ảnh phổ biến
            List<String> allowedExtensions = List.of(".jpg", ".jpeg", ".png", ".gif", ".webp");
            if (!allowedExtensions.contains(fileExtension)) {
                return null;
            }

            // Tạo tên file unique để tránh trùng lặp
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

            // Lưu vào thư mục SOURCE thay vì target để không bị mất khi rebuild
            // Lấy đường dẫn thực tế của webapp trong target
            String realPath = request.getServletContext().getRealPath("/assets/images/books");

            // Tìm thư mục source bằng cách đi ngược lên từ target
            String sourcePath = realPath;
            if (realPath.contains("target")) {
                // Thay thế target/BookVerse bằng src/main/webapp
                sourcePath = realPath.replace("target\\BookVerse", "src\\main\\webapp")
                                    .replace("target/BookVerse", "src/main/webapp");
            }

            // Tạo thư mục nếu chưa tồn tại (cả source và target)
            File sourceDir = new File(sourcePath);
            if (!sourceDir.exists()) {
                sourceDir.mkdirs();
            }

            File targetDir = new File(realPath);
            if (!targetDir.exists()) {
                targetDir.mkdirs();
            }

            // Lưu file vào CẢ HAI thư mục: source (vĩnh viễn) và target (dùng ngay)
            try (InputStream fileContent = part.getInputStream()) {
                // Lưu vào source
                String sourceFilePath = sourcePath + File.separator + uniqueFileName;
                Files.copy(fileContent, Paths.get(sourceFilePath), StandardCopyOption.REPLACE_EXISTING);
            }

            // Copy sang target để dùng ngay không cần rebuild
            try (InputStream fileContent = part.getInputStream()) {
                String targetFilePath = realPath + File.separator + uniqueFileName;
                Files.copy(fileContent, Paths.get(targetFilePath), StandardCopyOption.REPLACE_EXISTING);
            }

            // Trả về đường dẫn tương đối (để lưu vào database)
            // Không bao gồm contextPath vì nó sẽ được thêm ở view
            return "/assets/images/books/" + uniqueFileName;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
