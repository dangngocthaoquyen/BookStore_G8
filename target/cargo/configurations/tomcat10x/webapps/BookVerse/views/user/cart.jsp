<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Giỏ hàng" scope="request" />
<jsp:include page="/views/common/header.jsp" />

<!-- Main Content -->
<main class="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50">
    <div class="max-w-7xl mx-auto px-4 py-8">
        <!-- Page Header with Breadcrumb -->
        <div class="mb-8">
            <nav class="flex items-center text-sm text-gray-500 mb-4">
                <a href="${pageContext.request.contextPath}/home" class="hover:text-blue-600 transition-colors">Trang chủ</a>
                <svg class="w-4 h-4 mx-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                </svg>
                <span class="text-gray-900 font-medium">Giỏ hàng</span>
            </nav>
            <div class="flex items-center gap-3">
                <div class="bg-gradient-to-r from-blue-600 to-blue-700 p-3 rounded-xl shadow-lg">
                    <svg class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                </div>
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">Giỏ hàng của bạn</h1>
                    <p class="text-sm text-gray-600 mt-1">
                        <c:choose>
                            <c:when test="${not empty cartItems}">
                                <span class="font-semibold text-blue-600">${cartItems.size()}</span> sản phẩm đang chờ thanh toán
                            </c:when>
                            <c:otherwise>
                                Chưa có sản phẩm nào trong giỏ hàng
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="bg-red-50 border-l-4 border-red-500 text-red-700 px-6 py-4 rounded-r-lg mb-6 shadow-sm">
                <div class="flex items-center">
                    <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                    </svg>
                    ${errorMessage}
                </div>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty cartItems}">
                <!-- Empty Cart State -->
                <div class="bg-white rounded-2xl shadow-xl border border-gray-100 p-16 text-center">
                    <div class="max-w-md mx-auto">
                        <div class="bg-gradient-to-br from-blue-100 to-blue-200 w-32 h-32 rounded-full flex items-center justify-center mx-auto mb-6">
                            <svg class="w-16 h-16 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                            </svg>
                        </div>
                        <h2 class="text-2xl font-bold text-gray-900 mb-3">Giỏ hàng trống</h2>
                        <p class="text-gray-600 mb-8 leading-relaxed">Hãy khám phá các cuốn sách tuyệt vời và thêm chúng vào giỏ hàng của bạn!</p>
                        <a
                            href="${pageContext.request.contextPath}/books"
                            class="inline-flex items-center bg-gradient-to-r from-blue-600 to-blue-700 text-white px-8 py-4 rounded-xl hover:shadow-lg transform hover:-translate-y-0.5 transition-all font-semibold"
                        >
                            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                            </svg>
                            Khám phá sách ngay
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Cart Content -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <!-- Cart Items -->
                    <div class="lg:col-span-2 space-y-4">
                        <c:forEach var="item" items="${cartItems}" varStatus="status">
                            <div class="bg-white rounded-xl shadow-md border border-gray-100 p-6 hover:shadow-lg transition-all duration-300" data-cart-id="${item.cartId}" data-book-id="${item.bookId}">
                                <div class="flex flex-col md:flex-row gap-6">
                                    <!-- Book Image -->
                                    <div class="flex-shrink-0">
                                        <div class="w-32 h-44 bg-gradient-to-br from-gray-100 to-gray-200 rounded-lg overflow-hidden shadow-md">
                                            <c:choose>
                                                <c:when test="${not empty item.bookImageUrl}">
                                                    <img
                                                        src="${pageContext.request.contextPath}${item.bookImageUrl}"
                                                        alt="${item.bookTitle}"
                                                        class="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
                                                        onerror="this.src='${pageContext.request.contextPath}/assets/images/no-image.jpg'"
                                                    />
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="w-full h-full flex items-center justify-center">
                                                        <svg class="w-12 h-12 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                                            <path d="M9 4.804A7.968 7.968 0 005.5 4c-1.255 0-2.443.29-3.5.804v10A7.969 7.969 0 015.5 14c1.669 0 3.218.51 4.5 1.385A7.962 7.962 0 0114.5 14c1.255 0 2.443.29 3.5.804v-10A7.968 7.968 0 0014.5 4c-1.255 0-2.443.29-3.5.804V12a1 1 0 11-2 0V4.804z"/>
                                                        </svg>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Book Details -->
                                    <div class="flex-1 min-w-0">
                                        <div class="flex justify-between items-start mb-3">
                                            <div class="flex-1 pr-4">
                                                <h3 class="text-lg font-bold text-gray-900 mb-2 hover:text-blue-600 transition-colors">
                                                    <a href="${pageContext.request.contextPath}/book?id=${item.bookId}">
                                                        ${item.bookTitle}
                                                    </a>
                                                </h3>
                                                <p class="text-sm text-gray-600 flex items-center gap-2">
                                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                                    </svg>
                                                    ${item.bookAuthor}
                                                </p>
                                            </div>
                                            <!-- Remove Button -->
                                            <button
                                                type="button"
                                                onclick="removeItem(${item.cartId})"
                                                class="p-2 text-red-500 hover:bg-red-50 rounded-lg transition-all"
                                                title="Xóa khỏi giỏ hàng"
                                            >
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                                </svg>
                                            </button>
                                        </div>

                                        <!-- Stock Warning -->
                                        <c:if test="${item.bookStockQuantity < 10}">
                                            <div class="mb-3 inline-flex items-center gap-2 px-3 py-1.5 bg-orange-50 text-orange-700 rounded-lg text-xs font-medium">
                                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                                    <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                                </svg>
                                                Chỉ còn ${item.bookStockQuantity} sản phẩm
                                            </div>
                                        </c:if>

                                        <div class="flex flex-wrap items-center gap-6 mt-4">
                                            <!-- Price -->
                                            <div>
                                                <p class="text-xs text-gray-500 mb-1">Đơn giá</p>
                                                <p class="text-xl font-bold text-gray-900">
                                                    <fmt:formatNumber value="${item.bookPrice}" type="number" maxFractionDigits="0"/> đ
                                                </p>
                                            </div>

                                            <!-- Quantity -->
                                            <div>
                                                <p class="text-xs text-gray-500 mb-1">Số lượng</p>
                                                <div class="flex items-center bg-gray-50 border border-gray-300 rounded-lg overflow-hidden">
                                                    <button
                                                        type="button"
                                                        onclick="decrementQuantity(${item.cartId})"
                                                        class="px-4 py-2 text-gray-700 hover:bg-gray-200 transition-colors font-bold"
                                                    >
                                                        −
                                                    </button>
                                                    <input
                                                        type="number"
                                                        id="quantity-${item.cartId}"
                                                        value="${item.quantity}"
                                                        min="1"
                                                        max="${item.bookStockQuantity}"
                                                        class="w-16 px-3 py-2 text-center bg-white border-x border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 font-semibold"
                                                        onchange="updateQuantity(${item.cartId}, this.value)"
                                                    />
                                                    <button
                                                        type="button"
                                                        onclick="incrementQuantity(${item.cartId}, ${item.bookStockQuantity})"
                                                        class="px-4 py-2 text-gray-700 hover:bg-gray-200 transition-colors font-bold"
                                                    >
                                                        +
                                                    </button>
                                                </div>
                                            </div>

                                            <!-- Subtotal -->
                                            <div class="ml-auto text-right">
                                                <p class="text-xs text-gray-500 mb-1">Thành tiền</p>
                                                <p class="text-2xl font-bold text-blue-600" id="subtotal-${item.cartId}">
                                                    <fmt:formatNumber value="${item.subtotal}" type="number" maxFractionDigits="0"/> đ
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Order Summary (Sticky) -->
                    <div class="lg:col-span-1">
                        <div class="bg-gradient-to-br from-white to-blue-50 rounded-2xl shadow-xl border border-gray-100 p-6 sticky top-4">
                            <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                                <div class="w-8 h-8 bg-gradient-to-r from-blue-600 to-blue-700 rounded-lg flex items-center justify-center">
                                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                                    </svg>
                                </div>
                                Tóm tắt đơn hàng
                            </h2>

                            <!-- Summary Details -->
                            <div class="space-y-4 mb-6">
                                <div class="flex items-center justify-between text-base">
                                    <span class="text-gray-600">Tạm tính</span>
                                    <span class="font-bold text-gray-900" id="cart-subtotal">
                                        <fmt:formatNumber value="${totalAmount}" type="number" maxFractionDigits="0"/> đ
                                    </span>
                                </div>

                                <!-- Shipping Progress -->
                                <div class="bg-white rounded-lg p-4 border border-gray-200">
                                    <div class="flex items-center justify-between text-sm mb-2">
                                        <span class="text-gray-600">Phí vận chuyển</span>
                                        <c:choose>
                                            <c:when test="${totalAmount >= 200000}">
                                                <span class="font-bold text-green-600">Miễn phí</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="font-medium text-orange-600">30.000 đ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <c:if test="${totalAmount < 200000}">
                                        <div class="w-full bg-gray-200 rounded-full h-2 mb-2">
                                            <div class="bg-gradient-to-r from-blue-500 to-blue-600 h-2 rounded-full transition-all" style="width: ${(totalAmount / 200000) * 100}%"></div>
                                        </div>
                                        <p class="text-xs text-gray-600">
                                            Mua thêm <strong class="text-blue-600"><fmt:formatNumber value="${200000 - totalAmount}" type="number" maxFractionDigits="0"/> đ</strong> để được miễn phí vận chuyển
                                        </p>
                                    </c:if>
                                    <c:if test="${totalAmount >= 200000}">
                                        <div class="flex items-center gap-2 text-green-600 text-sm">
                                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                            </svg>
                                            <span class="font-medium">Đã đủ điều kiện miễn phí ship!</span>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="border-t border-gray-300 pt-4">
                                    <div class="flex items-center justify-between">
                                        <span class="text-lg font-bold text-gray-900">Tổng cộng</span>
                                        <span class="text-2xl font-bold bg-gradient-to-r from-blue-600 to-blue-700 bg-clip-text text-transparent" id="cart-total">
                                            <fmt:formatNumber value="${totalAmount >= 200000 ? totalAmount : totalAmount + 30000}" type="number" maxFractionDigits="0"/> đ
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="space-y-3">
                                <a
                                    href="${pageContext.request.contextPath}/checkout"
                                    class="flex items-center justify-center gap-2 w-full bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-4 rounded-xl hover:shadow-xl transform hover:-translate-y-0.5 transition-all font-bold"
                                >
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                                    </svg>
                                    Thanh toán ngay
                                </a>
                                <a
                                    href="${pageContext.request.contextPath}/books"
                                    class="flex items-center justify-center gap-2 w-full bg-white text-gray-700 px-6 py-3 rounded-xl hover:bg-gray-50 border-2 border-gray-200 transition-all font-semibold"
                                >
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                                    </svg>
                                    Tiếp tục mua sắm
                                </a>
                            </div>

                            <!-- Benefits -->
                            <div class="mt-6 pt-6 border-t border-gray-200 space-y-3">
                                <div class="flex items-start gap-3">
                                    <div class="flex-shrink-0 w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center">
                                        <svg class="w-5 h-5 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                        </svg>
                                    </div>
                                    <p class="text-sm text-gray-700 leading-relaxed">
                                        <strong>Miễn phí vận chuyển</strong> cho đơn hàng từ 200.000đ
                                    </p>
                                </div>
                                <div class="flex items-start gap-3">
                                    <div class="flex-shrink-0 w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                                        <svg class="w-5 h-5 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                        </svg>
                                    </div>
                                    <p class="text-sm text-gray-700 leading-relaxed">
                                        <strong>Đổi trả miễn phí</strong> trong vòng 7 ngày
                                    </p>
                                </div>
                                <div class="flex items-start gap-3">
                                    <div class="flex-shrink-0 w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center">
                                        <svg class="w-5 h-5 text-purple-600" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                        </svg>
                                    </div>
                                    <p class="text-sm text-gray-700 leading-relaxed">
                                        <strong>Thanh toán an toàn</strong> & bảo mật tuyệt đối
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
// Global variables
const contextPath = '${pageContext.request.contextPath}';

/**
 * Increment quantity
 */
function incrementQuantity(cartId, maxStock) {
    const input = document.getElementById('quantity-' + cartId);
    const currentValue = parseInt(input.value);

    if (currentValue < maxStock) {
        input.value = currentValue + 1;
        updateQuantity(cartId, input.value);
    } else {
        Toast.warning('Số lượng không được vượt quá số lượng tồn kho');
    }
}

/**
 * Decrement quantity
 */
function decrementQuantity(cartId) {
    const input = document.getElementById('quantity-' + cartId);
    const currentValue = parseInt(input.value);

    if (currentValue > 1) {
        input.value = currentValue - 1;
        updateQuantity(cartId, input.value);
    } else {
        Toast.warning('Số lượng phải lớn hơn 0');
    }
}

/**
 * Update cart quantity via AJAX
 */
function updateQuantity(cartId, quantity) {
    // Validate quantity
    quantity = parseInt(quantity);

    if (isNaN(quantity) || quantity < 1) {
        Toast.error('Số lượng không hợp lệ');
        return;
    }

    // Show loading state
    const input = document.getElementById('quantity-' + cartId);
    const originalValue = input.value;
    input.disabled = true;

    // Call API
    fetch(contextPath + '/update-cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'cartId=' + cartId + '&quantity=' + quantity
    })
    .then(response => response.json())
    .then(data => {
        input.disabled = false;

        if (data.success) {
            Toast.success(data.message);

            // Update subtotal for this item
            if (data.subtotal) {
                const subtotalElement = document.getElementById('subtotal-' + cartId);
                subtotalElement.textContent = formatCurrency(data.subtotal) + ' đ';
            }

            // Recalculate total
            recalculateTotal();
        } else {
            Toast.error(data.message || 'Không thể cập nhật số lượng');
            // Revert to original value
            input.value = originalValue;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        input.disabled = false;
        Toast.error('Có lỗi xảy ra, vui lòng thử lại');
        // Revert to original value
        input.value = originalValue;
    });
}

/**
 * Remove item from cart via AJAX
 */
function removeItem(cartId) {
    // Confirm before removing
    if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?')) {
        return;
    }

    // Call API
    fetch(contextPath + '/remove-from-cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'cartId=' + cartId
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            Toast.success(data.message);

            // Remove the item from DOM with animation
            const itemElement = document.querySelector('[data-cart-id="' + cartId + '"]');
            if (itemElement) {
                itemElement.style.transition = 'all 0.3s ease-out';
                itemElement.style.transform = 'translateX(-100%)';
                itemElement.style.opacity = '0';
                setTimeout(() => {
                    itemElement.remove();

                    // Check if cart is now empty
                    const remainingItems = document.querySelectorAll('[data-cart-id]');
                    if (remainingItems.length === 0) {
                        // Reload page to show empty state
                        setTimeout(() => {
                            window.location.reload();
                        }, 500);
                    } else {
                        // Recalculate total
                        recalculateTotal();
                    }
                }, 300);
            }
        } else {
            Toast.error(data.message || 'Không thể xóa sản phẩm');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        Toast.error('Có lỗi xảy ra, vui lòng thử lại');
    });
}

/**
 * Recalculate cart total
 */
function recalculateTotal() {
    let total = 0;

    // Sum all subtotals
    const subtotalElements = document.querySelectorAll('[id^="subtotal-"]');
    subtotalElements.forEach(element => {
        const subtotalText = element.textContent.replace(/[^\d]/g, '');
        const subtotal = parseInt(subtotalText);
        if (!isNaN(subtotal)) {
            total += subtotal;
        }
    });

    // Update total display
    const subtotalElement = document.getElementById('cart-subtotal');
    const totalElement = document.getElementById('cart-total');

    if (subtotalElement) {
        subtotalElement.textContent = formatCurrency(total) + ' đ';
    }

    if (totalElement) {
        // Add shipping fee if total < 200000
        const finalTotal = total >= 200000 ? total : total + 30000;
        totalElement.textContent = formatCurrency(finalTotal) + ' đ';
    }

    // Reload page to update shipping progress bar
    setTimeout(() => {
        window.location.reload();
    }, 500);
}

/**
 * Format number as currency
 */
function formatCurrency(amount) {
    return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
}
</script>

<jsp:include page="/views/common/footer.jsp" />
