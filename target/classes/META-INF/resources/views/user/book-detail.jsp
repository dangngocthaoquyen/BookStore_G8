<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${book.title}" scope="request" />
<jsp:include page="/views/common/header.jsp" />

<!-- Main Content -->
<main class="min-h-screen bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 py-8">

        <!-- Breadcrumb -->
        <nav class="mb-6">
            <ol class="flex items-center space-x-2 text-sm text-gray-600">
                <li>
                    <a href="${pageContext.request.contextPath}/" class="hover:text-blue-600 transition-colors">Trang chủ</a>
                </li>
                <li>
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                    </svg>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/books" class="hover:text-blue-600 transition-colors">Sách</a>
                </li>
                <c:if test="${not empty book.categoryName}">
                    <li>
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                        </svg>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/books?categoryId=${book.categoryId}" class="hover:text-blue-600 transition-colors">${book.categoryName}</a>
                    </li>
                </c:if>
                <li>
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                    </svg>
                </li>
                <li class="text-gray-900 font-medium truncate max-w-xs">${book.title}</li>
            </ol>
        </nav>

        <!-- Book Detail Section -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden mb-8">
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 p-6">

                <!-- Column 1: Book Image -->
                <div class="lg:col-span-1">
                    <div class="sticky top-4">
                        <c:choose>
                            <c:when test="${not empty book.imageUrl}">
                                <img
                                    src="${pageContext.request.contextPath}${book.imageUrl}"
                                    alt="${book.title}"
                                    class="w-full rounded-lg shadow-md"
                                    onerror="this.src='${pageContext.request.contextPath}/assets/images/no-image.jpg'"
                                />
                            </c:when>
                            <c:otherwise>
                                <div class="w-full aspect-[3/4] bg-gray-200 rounded-lg flex items-center justify-center">
                                    <svg class="w-24 h-24 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                        <path d="M9 4.804A7.968 7.968 0 005.5 4c-1.255 0-2.443.29-3.5.804v10A7.969 7.969 0 015.5 14c1.669 0 3.218.51 4.5 1.385A7.962 7.962 0 0114.5 14c1.255 0 2.443.29 3.5.804v-10A7.968 7.968 0 0014.5 4c-1.255 0-2.443.29-3.5.804V12a1 1 0 11-2 0V4.804z"/>
                                    </svg>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Column 2: Book Information -->
                <div class="lg:col-span-2">

                    <!-- Title -->
                    <h1 class="text-2xl font-semibold text-gray-900 mb-2">
                        ${book.title}
                    </h1>

                    <!-- Author -->
                    <p class="text-base text-gray-600 mb-4">
                        Tác giả: <span class="font-medium">${book.author}</span>
                    </p>

                    <!-- Category Badge -->
                    <c:if test="${not empty book.categoryName}">
                        <a href="${pageContext.request.contextPath}/books?categoryId=${book.categoryId}"
                           class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800 hover:bg-blue-200 transition-colors mb-4">
                            ${book.categoryName}
                        </a>
                    </c:if>

                    <!-- Price -->
                    <div class="mb-6">
                        <div class="flex items-baseline gap-2">
                            <span class="text-3xl font-semibold text-blue-600">
                                <fmt:formatNumber value="${book.price}" type="number" maxFractionDigits="0"/> đ
                            </span>
                        </div>
                    </div>

                    <!-- Stock Status -->
                    <div class="mb-6">
                        <p class="text-sm text-gray-600 mb-2">Tình trạng:</p>
                        <c:choose>
                            <c:when test="${book.stockQuantity > 0}">
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                                    <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                    </svg>
                                    Còn hàng (${book.stockQuantity} cuốn)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                                    <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                                    </svg>
                                    Hết hàng
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Book Details -->
                    <div class="bg-gray-50 rounded-lg p-4 mb-6">
                        <h3 class="text-base font-semibold text-gray-900 mb-3">Thông tin chi tiết</h3>
                        <div class="grid grid-cols-2 gap-3 text-sm">
                            <c:if test="${not empty book.isbn}">
                                <div>
                                    <span class="text-gray-600">ISBN:</span>
                                    <span class="text-gray-900 font-medium ml-2">${book.isbn}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty book.publisher}">
                                <div>
                                    <span class="text-gray-600">Nhà xuất bản:</span>
                                    <span class="text-gray-900 font-medium ml-2">${book.publisher}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty book.publishYear}">
                                <div>
                                    <span class="text-gray-600">Năm xuất bản:</span>
                                    <span class="text-gray-900 font-medium ml-2">${book.publishYear}</span>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Description -->
                    <c:if test="${not empty book.description}">
                        <div class="mb-6">
                            <h3 class="text-base font-semibold text-gray-900 mb-3">Mô tả sản phẩm</h3>
                            <p class="text-sm text-gray-600 leading-relaxed whitespace-pre-line">
                                ${book.description}
                            </p>
                        </div>
                    </c:if>

                    <!-- Add to Cart Section -->
                    <c:if test="${book.stockQuantity > 0}">
                        <div class="border-t border-gray-200 pt-6">
                            <div class="flex items-center gap-4 mb-4">
                                <label class="text-sm text-gray-600 font-medium">Số lượng:</label>
                                <div class="flex items-center border border-gray-300 rounded-md">
                                    <button
                                        type="button"
                                        onclick="decreaseQuantity()"
                                        class="px-3 py-2 text-gray-600 hover:bg-gray-100 transition-colors">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"/>
                                        </svg>
                                    </button>
                                    <input
                                        type="number"
                                        id="quantity"
                                        name="quantity"
                                        value="1"
                                        min="1"
                                        max="${book.stockQuantity}"
                                        class="w-16 text-center border-x border-gray-300 py-2 focus:outline-none focus:ring-0"
                                        onchange="validateQuantity()"
                                    />
                                    <button
                                        type="button"
                                        onclick="increaseQuantity()"
                                        class="px-3 py-2 text-gray-600 hover:bg-gray-100 transition-colors">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <button
                                onclick="addToCart(${book.bookId})"
                                class="w-full bg-blue-600 text-white px-6 py-3 rounded-md font-medium hover:bg-blue-700 transition-colors flex items-center justify-center gap-2">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                                </svg>
                                Thêm vào giỏ hàng
                            </button>
                        </div>
                    </c:if>

                </div>
            </div>
        </div>

        <!-- Related Books Section -->
        <c:if test="${not empty relatedBooks}">
            <section class="mb-8">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-2xl font-semibold text-gray-900">Sách cùng thể loại</h2>
                    <a href="${pageContext.request.contextPath}/books?categoryId=${book.categoryId}"
                       class="text-sm text-blue-600 hover:text-blue-700 transition-colors">
                        Xem tất cả
                        <svg class="inline w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                        </svg>
                    </a>
                </div>

                <!-- Related Books Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <c:forEach var="relatedBook" items="${relatedBooks}">
                        <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow">
                            <!-- Book Image -->
                            <div class="aspect-w-3 aspect-h-4 bg-gray-100">
                                <c:choose>
                                    <c:when test="${not empty relatedBook.imageUrl}">
                                        <img
                                            src="${pageContext.request.contextPath}${relatedBook.imageUrl}"
                                            alt="${relatedBook.title}"
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
                                    ${relatedBook.title}
                                </h3>
                                <p class="text-sm text-gray-600 mb-2">
                                    ${relatedBook.author}
                                </p>

                                <!-- Category Badge -->
                                <c:if test="${not empty relatedBook.categoryName}">
                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800 mb-3">
                                        ${relatedBook.categoryName}
                                    </span>
                                </c:if>

                                <!-- Price -->
                                <div class="flex items-center justify-between mb-4">
                                    <span class="text-lg font-semibold text-blue-600">
                                        <fmt:formatNumber value="${relatedBook.price}" type="number" maxFractionDigits="0"/> đ
                                    </span>
                                    <c:choose>
                                        <c:when test="${relatedBook.stockQuantity > 0}">
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
                                        href="${pageContext.request.contextPath}/book?id=${relatedBook.bookId}"
                                        class="flex-1 text-center bg-gray-100 text-gray-700 px-3 py-2 rounded-md text-sm hover:bg-gray-200 transition-colors"
                                    >
                                        Xem chi tiết
                                    </a>
                                    <c:if test="${relatedBook.stockQuantity > 0}">
                                        <button
                                            onclick="addToCart(${relatedBook.bookId})"
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
            </section>
        </c:if>

    </div>
</main>

<script>
// Số lượng tối đa
const MAX_QUANTITY = ${book.stockQuantity};

// Hàm giảm số lượng
function decreaseQuantity() {
    const input = document.getElementById('quantity');
    let value = parseInt(input.value);
    if (value > 1) {
        input.value = value - 1;
    }
}

// Hàm tăng số lượng
function increaseQuantity() {
    const input = document.getElementById('quantity');
    let value = parseInt(input.value);
    if (value < MAX_QUANTITY) {
        input.value = value + 1;
    }
}

// Hàm validate số lượng
function validateQuantity() {
    const input = document.getElementById('quantity');
    let value = parseInt(input.value);

    if (isNaN(value) || value < 1) {
        input.value = 1;
        Toast.warning('Số lượng tối thiểu là 1');
        return false;
    }

    if (value > MAX_QUANTITY) {
        input.value = MAX_QUANTITY;
        Toast.warning('Số lượng tối đa là ' + MAX_QUANTITY);
        return false;
    }

    return true;
}

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
            // Lấy số lượng
            let quantity = 1;
            const quantityInput = document.getElementById('quantity');
            if (quantityInput && bookId === ${book.bookId}) {
                quantity = parseInt(quantityInput.value);

                // Validate số lượng
                if (!validateQuantity()) {
                    return;
                }
            }

            // Gọi API thêm vào giỏ hàng
            fetch('${pageContext.request.contextPath}/add-to-cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'bookId=' + bookId + '&quantity=' + quantity
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    Toast.success(data.message || 'Đã thêm sách vào giỏ hàng');
                    // Cập nhật số lượng giỏ hàng
                    if (data.cartCount) {
                        updateCartCount(data.cartCount);
                    }
                    // Reset số lượng về 1
                    if (quantityInput && bookId === ${book.bookId}) {
                        quantityInput.value = 1;
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
