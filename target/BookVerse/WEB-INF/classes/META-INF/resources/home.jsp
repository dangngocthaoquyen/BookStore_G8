<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Trang chủ" scope="request" />
<jsp:include page="/views/common/header.jsp" />

<!-- Main Content -->
<main class="min-h-screen">
    <!-- Error Message -->
    <c:if test="${not empty errorMessage}">
        <div class="max-w-7xl mx-auto px-4 py-4">
            <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
                ${errorMessage}
            </div>
        </div>
    </c:if>

    <!-- Hero Section -->
    <section class="bg-white border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 py-12">
            <div class="text-center">
                <h1 class="text-4xl font-semibold text-gray-900 mb-4">
                    Chào mừng đến với BookVerse
                </h1>
                <p class="text-lg text-gray-600 mb-8 max-w-2xl mx-auto leading-relaxed">
                    Khám phá kho sách phong phú với hàng ngàn đầu sách chất lượng.
                    Mua sắm dễ dàng, giao hàng nhanh chóng.
                </p>

                <!-- Search Form -->
                <form action="${pageContext.request.contextPath}/books" method="get" class="max-w-2xl mx-auto">
                    <div class="flex items-center bg-gray-50 rounded-lg border border-gray-300 overflow-hidden">
                        <input
                            type="text"
                            name="keyword"
                            placeholder="Tìm kiếm sách theo tên, tác giả, ISBN..."
                            class="flex-1 px-4 py-3 bg-transparent border-none focus:outline-none focus:ring-0 text-sm"
                        />
                        <button
                            type="submit"
                            class="bg-blue-600 text-white px-6 py-3 hover:bg-blue-700 transition-colors"
                        >
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                            </svg>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <!-- Latest Books Section -->
    <section class="max-w-7xl mx-auto px-4 py-12">
        <div class="flex items-center justify-between mb-8">
            <h2 class="text-2xl font-semibold text-gray-900">Sách mới nhất</h2>
            <a href="${pageContext.request.contextPath}/books" class="text-sm text-blue-600 hover:text-blue-700 transition-colors">
                Xem tất cả
                <svg class="inline w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                </svg>
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty latestBooks}">
                <!-- Books Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <c:forEach var="book" items="${latestBooks}">
                        <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow">
                            <!-- Book Image -->
                            <div class="aspect-w-3 aspect-h-4 bg-gray-100">
                                <c:choose>
                                    <c:when test="${not empty book.imageUrl}">
                                        <img
                                            src="${pageContext.request.contextPath}${book.imageUrl}"
                                            alt="${book.title}"
                                            class="w-full h-64 object-cover"
                                            onerror="this.src='${pageContext.request.contextPath}/assets/images/no-image.jpg'"
                                        />
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-full h-64 flex items-center justify-center bg-gray-200">
                                            <svg class="w-16 h-16 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                                <path d="M9 4.804A7.968 7.968 0 005.5 4c-1.255 0-2.443.29-3.5.804v10A7.969 7.969 0 015.5 14c1.669 0 3.218.51 4.5 1.385A7.962 7.962 0 0114.5 14c1.255 0 2.443.29 3.5.804v-10A7.968 7.968 0 0014.5 4c-1.255 0-2.443.29-3.5.804V12a1 1 0 11-2 0V4.804z"/>
                                            </svg>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Book Info -->
                            <div class="p-4">
                                <h3 class="text-base font-semibold text-gray-900 mb-1 line-clamp-2">
                                    ${book.title}
                                </h3>
                                <p class="text-sm text-gray-600 mb-2">
                                    ${book.author}
                                </p>

                                <!-- Category Badge -->
                                <c:if test="${not empty book.categoryName}">
                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800 mb-3">
                                        ${book.categoryName}
                                    </span>
                                </c:if>

                                <!-- Price -->
                                <div class="flex items-center justify-between mb-4">
                                    <span class="text-lg font-semibold text-blue-600">
                                        <fmt:formatNumber value="${book.price}" type="number" maxFractionDigits="0"/> đ
                                    </span>
                                    <c:choose>
                                        <c:when test="${book.stockQuantity > 0}">
                                            <span class="text-xs text-green-600">Còn hàng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-xs text-red-600">Hết hàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Actions -->
                                <div class="flex items-center gap-2">
                                    <a
                                        href="${pageContext.request.contextPath}/book?id=${book.bookId}"
                                        class="flex-1 text-center bg-gray-100 text-gray-700 px-3 py-2 rounded-md text-sm hover:bg-gray-200 transition-colors"
                                    >
                                        Xem chi tiết
                                    </a>
                                    <c:if test="${book.stockQuantity > 0}">
                                        <button
                                            onclick="addToCart(${book.bookId})"
                                            class="flex-1 bg-blue-600 text-white px-3 py-2 rounded-md text-sm hover:bg-blue-700 transition-colors"
                                        >
                                            Thêm vào giỏ
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-12">
                    <svg class="w-16 h-16 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                    </svg>
                    <p class="text-gray-600">Chưa có sách nào được thêm vào hệ thống.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <!-- Categories Section -->
    <c:if test="${not empty categories}">
        <section class="bg-white border-t border-gray-200">
            <div class="max-w-7xl mx-auto px-4 py-12">
                <h2 class="text-2xl font-semibold text-gray-900 mb-8">Danh mục sách</h2>
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
                    <c:forEach var="category" items="${categories}">
                        <a
                            href="${pageContext.request.contextPath}/books?categoryId=${category.categoryId}"
                            class="bg-gray-50 rounded-lg border border-gray-200 p-4 text-center hover:bg-blue-50 hover:border-blue-300 transition-colors"
                        >
                            <h3 class="text-sm font-medium text-gray-900">
                                ${category.categoryName}
                            </h3>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </section>
    </c:if>
</main>

<script>
// Hàm thêm sách vào giỏ hàng
function addToCart(bookId) {
    // Kiểm tra đăng nhập
    <c:choose>
        <c:when test="${sessionScope.user == null}">
            Toast.warning('Vui lòng đăng nhập để thêm sách vào giỏ hàng');
            setTimeout(() => {
                window.location.href = '${pageContext.request.contextPath}/login';
            }, 1500);
            return;
        </c:when>
        <c:otherwise>
            // Gọi API thêm vào giỏ hàng
            fetch('${pageContext.request.contextPath}/add-to-cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'bookId=' + bookId + '&quantity=1'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    Toast.success(data.message || 'Đã thêm sách vào giỏ hàng');
                    // Cập nhật số lượng giỏ hàng
                    if (data.cartCount) {
                        updateCartCount(data.cartCount);
                    }
                } else {
                    Toast.error(data.message || 'Không thể thêm sách vào giỏ hàng');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Toast.error('Có lỗi xảy ra, vui lòng thử lại');
            });
        </c:otherwise>
    </c:choose>
}

// Cập nhật số lượng giỏ hàng trên header
function updateCartCount(count) {
    // TODO: Implement cart count update
}
</script>

<style>
/* Line clamp utility */
.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
</style>

<jsp:include page="/views/common/footer.jsp" />
