<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Quản lý sách'} - BookVerse Admin</title>

    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Toast JS -->
    <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</head>
<body class="bg-gray-50">

<!-- Include Sidebar -->
<jsp:include page="sidebar.jsp" />

<!-- Main Content -->
<main class="lg:ml-64 min-h-screen">
    <!-- Header -->
    <div class="bg-white border-b border-gray-200">
        <div class="px-6 py-4">
            <div class="flex items-center justify-between flex-wrap gap-4">
                <div>
                    <h1 class="text-2xl font-semibold text-gray-900">Quản lý sách</h1>
                    <p class="text-sm text-gray-600 mt-1">Quản lý danh sách sách trong hệ thống</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/book-form"
                   class="inline-flex items-center px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 transition-colors">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                    </svg>
                    Thêm sách mới
                </a>
            </div>
        </div>
    </div>

    <!-- Content -->
    <div class="p-6">
        <!-- Search & Filter Section -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4 mb-6">
            <form method="get" action="${pageContext.request.contextPath}/admin/books" class="flex items-center gap-4">
                <div class="flex-1">
                    <label for="keyword" class="sr-only">Tìm kiếm</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                            </svg>
                        </div>
                        <input type="text" name="keyword" id="keyword" value="${keyword}"
                               class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                               placeholder="Tìm theo tên sách, tác giả, ISBN...">
                    </div>
                </div>
                <button type="submit"
                        class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    Tìm kiếm
                </button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/admin/books"
                       class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                        Xóa bộ lọc
                    </a>
                </c:if>
            </form>
        </div>

        <!-- Statistics -->
        <div class="mb-6">
            <p class="text-sm text-gray-600">
                Tổng số: <span class="font-semibold text-gray-900">${totalBooks}</span> sách
                <c:if test="${not empty keyword}">
                    - Kết quả tìm kiếm cho: <span class="font-semibold text-gray-900">"${keyword}"</span>
                </c:if>
            </p>
        </div>

        <!-- Books Table -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
            <!-- Desktop Table -->
            <div class="hidden md:block overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Ảnh bìa
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Tên sách & Tác giả
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Danh mục
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Giá
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Tồn kho
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Trạng thái
                            </th>
                            <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Thao tác
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <c:choose>
                            <c:when test="${empty books}">
                                <tr>
                                    <td colspan="7" class="px-6 py-12 text-center">
                                        <svg class="w-12 h-12 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                                        </svg>
                                        <p class="text-sm text-gray-500">Không tìm thấy sách nào</p>
                                        <c:if test="${not empty keyword}">
                                            <p class="text-xs text-gray-400 mt-2">Thử tìm kiếm với từ khóa khác</p>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="book" items="${books}">
                                    <tr class="hover:bg-gray-50 transition-colors">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${not empty book.imageUrl}">
                                                    <img src="${pageContext.request.contextPath}${book.imageUrl}" alt="${book.title}"
                                                         class="h-16 w-12 object-cover rounded-md border border-gray-200">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="h-16 w-12 bg-gray-100 rounded-md border border-gray-200 flex items-center justify-center">
                                                        <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                                        </svg>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="text-sm font-medium text-gray-900">${book.title}</div>
                                            <div class="text-sm text-gray-500">${book.author}</div>
                                            <c:if test="${not empty book.isbn}">
                                                <div class="text-xs text-gray-400 mt-1">ISBN: ${book.isbn}</div>
                                            </c:if>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                ${book.categoryName}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm font-medium text-gray-900">
                                                <fmt:formatNumber value="${book.price}" pattern="#,##0" /> đ
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900">${book.stockQuantity}</div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${book.status == 'available'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        Có sẵn
                                                    </span>
                                                </c:when>
                                                <c:when test="${book.status == 'out_of_stock'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        Hết hàng
                                                    </span>
                                                </c:when>
                                                <c:when test="${book.status == 'discontinued'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                        Ngừng bán
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                        ${book.status}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                            <a href="${pageContext.request.contextPath}/admin/book-form?id=${book.bookId}"
                                               class="text-blue-600 hover:text-blue-900 mr-3">
                                                Sửa
                                            </a>
                                            <button onclick="confirmDelete(${book.bookId}, '${book.title}')"
                                                    class="text-red-600 hover:text-red-900">
                                                Xóa
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Mobile Cards -->
            <div class="md:hidden divide-y divide-gray-200">
                <c:choose>
                    <c:when test="${empty books}">
                        <div class="px-6 py-12 text-center">
                            <svg class="w-12 h-12 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                            </svg>
                            <p class="text-sm text-gray-500">Không tìm thấy sách nào</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="book" items="${books}">
                            <div class="p-4">
                                <div class="flex space-x-4">
                                    <div class="flex-shrink-0">
                                        <c:choose>
                                            <c:when test="${not empty book.imageUrl}">
                                                <img src="${pageContext.request.contextPath}${book.imageUrl}" alt="${book.title}"
                                                     class="h-24 w-16 object-cover rounded-md border border-gray-200">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="h-24 w-16 bg-gray-100 rounded-md border border-gray-200 flex items-center justify-center">
                                                    <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                                    </svg>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <p class="text-sm font-medium text-gray-900 truncate">${book.title}</p>
                                        <p class="text-sm text-gray-500">${book.author}</p>
                                        <p class="text-xs text-gray-400 mt-1">${book.categoryName}</p>
                                        <div class="mt-2 flex items-center justify-between">
                                            <div>
                                                <p class="text-sm font-medium text-gray-900">
                                                    <fmt:formatNumber value="${book.price}" pattern="#,##0" /> đ
                                                </p>
                                                <p class="text-xs text-gray-500">Tồn kho: ${book.stockQuantity}</p>
                                            </div>
                                            <c:choose>
                                                <c:when test="${book.status == 'available'}">
                                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800">
                                                        Có sẵn
                                                    </span>
                                                </c:when>
                                                <c:when test="${book.status == 'out_of_stock'}">
                                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        Hết hàng
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-800">
                                                        Ngừng bán
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="mt-3 flex items-center space-x-3">
                                            <a href="${pageContext.request.contextPath}/admin/book-form?id=${book.bookId}"
                                               class="text-sm text-blue-600 hover:text-blue-900 font-medium">
                                                Sửa
                                            </a>
                                            <button onclick="confirmDelete(${book.bookId}, '${book.title}')"
                                                    class="text-sm text-red-600 hover:text-red-900 font-medium">
                                                Xóa
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6 mt-6 rounded-lg shadow-sm border">
                <div class="flex-1 flex justify-between sm:hidden">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                           class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                            Trước
                        </a>
                    </c:if>
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                           class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                            Sau
                        </a>
                    </c:if>
                </div>
                <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                    <div>
                        <p class="text-sm text-gray-700">
                            Hiển thị
                            <span class="font-medium">${(currentPage - 1) * 10 + 1}</span>
                            đến
                            <span class="font-medium">${currentPage * 10 > totalBooks ? totalBooks : currentPage * 10}</span>
                            trong tổng số
                            <span class="font-medium">${totalBooks}</span>
                            kết quả
                        </p>
                    </div>
                    <div>
                        <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                                   class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                    <span class="sr-only">Trước</span>
                                    <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd"/>
                                    </svg>
                                </a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="z-10 bg-blue-50 border-blue-500 text-blue-600 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                                            ${i}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="?page=${i}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                                           class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                                            ${i}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                                   class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                    <span class="sr-only">Sau</span>
                                    <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"/>
                                    </svg>
                                </a>
                            </c:if>
                        </nav>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</main>

<!-- Toast Container -->
<div id="toast-container" class="fixed top-4 right-4 z-50"></div>

<!-- Hidden form for delete -->
<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/books" style="display: none;">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="bookId" id="deleteBookId">
</form>

<script>
// Show toast messages from session
window.addEventListener('DOMContentLoaded', function() {
    <c:if test="${not empty sessionScope.successMessage}">
        showToast('${sessionScope.successMessage}', 'success');
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        showToast('${sessionScope.errorMessage}', 'error');
        <c:remove var="errorMessage" scope="session" />
    </c:if>
});

// Confirm delete function
function confirmDelete(bookId, bookTitle) {
    const message = 'Bạn có chắc chắn muốn xóa sách "' + bookTitle + '"?\n\nLưu ý: Không thể xóa nếu sách đã có trong đơn hàng.';

    if (confirm(message)) {
        document.getElementById('deleteBookId').value = bookId;
        document.getElementById('deleteForm').submit();
    }
}
</script>

</body>
</html>
