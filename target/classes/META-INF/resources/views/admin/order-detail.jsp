<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng - BookVerse Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">

<!-- Include Sidebar -->
<jsp:include page="sidebar.jsp" />

<!-- Main Content -->
<div class="lg:ml-64 min-h-screen">
    <!-- Header -->
    <header class="bg-white border-b border-gray-200 sticky top-0 z-30">
        <div class="px-6 py-4">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-semibold text-gray-900">Chi tiết đơn hàng</h1>
                    <p class="text-sm text-gray-500 mt-1">Mã đơn hàng: <span class="font-medium text-blue-600">${order.orderCode}</span></p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/orders"
                   class="inline-flex items-center space-x-2 text-gray-600 hover:text-gray-900 transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                    <span class="text-sm font-medium">Quay lại</span>
                </a>
            </div>
        </div>
    </header>

    <!-- Main Content Area -->
    <main class="p-6">
        <!-- Toast Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="mb-6 bg-green-50 border border-green-200 rounded-lg p-4 flex items-start space-x-3">
                <svg class="w-5 h-5 text-green-600 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <div class="flex-1">
                    <p class="text-sm font-medium text-green-800">${sessionScope.successMessage}</p>
                </div>
                <button onclick="this.parentElement.remove()" class="text-green-600 hover:text-green-800">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="mb-6 bg-red-50 border border-red-200 rounded-lg p-4 flex items-start space-x-3">
                <svg class="w-5 h-5 text-red-600 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <div class="flex-1">
                    <p class="text-sm font-medium text-red-800">${sessionScope.errorMessage}</p>
                </div>
                <button onclick="this.parentElement.remove()" class="text-red-600 hover:text-red-800">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Left Column: Order Info & Items -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Order Items -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-gray-900">Sản phẩm đã đặt</h2>
                    </div>
                    <div class="divide-y divide-gray-200">
                        <c:forEach var="item" items="${order.orderItems}">
                            <div class="px-6 py-4 flex items-start space-x-4">
                                <div class="flex-shrink-0 w-20 h-28 bg-gray-100 rounded-md overflow-hidden border border-gray-200">
                                    <c:choose>
                                        <c:when test="${not empty item.bookImageUrl}">
                                            <img src="${pageContext.request.contextPath}${item.bookImageUrl}" alt="${item.bookTitle}" class="w-full h-full object-cover">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-full h-full flex items-center justify-center">
                                                <svg class="w-8 h-8 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                                                </svg>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <h3 class="text-sm font-medium text-gray-900 mb-1">${item.bookTitle}</h3>
                                    <c:if test="${not empty item.bookAuthor}">
                                        <p class="text-xs text-gray-500 mb-2">Tác giả: ${item.bookAuthor}</p>
                                    </c:if>
                                    <div class="flex items-center justify-between">
                                        <div>
                                            <p class="text-sm text-gray-600">
                                                <fmt:formatNumber value="${item.bookPrice}" type="number" pattern="#,##0"/> đ × ${item.quantity}
                                            </p>
                                        </div>
                                        <div class="text-right">
                                            <p class="text-sm font-semibold text-gray-900">
                                                <fmt:formatNumber value="${item.subtotal}" type="number" pattern="#,##0"/> đ
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Customer Information -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-gray-900">Thông tin khách hàng</h2>
                    </div>
                    <div class="px-6 py-4 space-y-3">
                        <div class="flex items-start">
                            <svg class="w-5 h-5 text-gray-400 mt-0.5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                            </svg>
                            <div>
                                <p class="text-xs text-gray-500">Người nhận</p>
                                <p class="text-sm font-medium text-gray-900">${order.shippingName}</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <svg class="w-5 h-5 text-gray-400 mt-0.5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                            </svg>
                            <div>
                                <p class="text-xs text-gray-500">Số điện thoại</p>
                                <p class="text-sm font-medium text-gray-900">${order.shippingPhone}</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <svg class="w-5 h-5 text-gray-400 mt-0.5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                            </svg>
                            <div>
                                <p class="text-xs text-gray-500">Địa chỉ giao hàng</p>
                                <p class="text-sm font-medium text-gray-900">${order.shippingAddress}</p>
                            </div>
                        </div>
                        <c:if test="${not empty order.notes}">
                            <div class="flex items-start">
                                <svg class="w-5 h-5 text-gray-400 mt-0.5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-3l-4 4z"/>
                                </svg>
                                <div>
                                    <p class="text-xs text-gray-500">Ghi chú</p>
                                    <p class="text-sm font-medium text-gray-900">${order.notes}</p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Right Column: Order Summary & Actions -->
            <div class="lg:col-span-1 space-y-6">
                <!-- Order Summary -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-gray-900">Tóm tắt đơn hàng</h2>
                    </div>
                    <div class="px-6 py-4 space-y-3">
                        <div class="flex items-center justify-between">
                            <span class="text-sm text-gray-600">Ngày đặt</span>
                            <span class="text-sm font-medium text-gray-900">
                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>
                        <div class="flex items-center justify-between">
                            <span class="text-sm text-gray-600">Phương thức thanh toán</span>
                            <span class="text-sm font-medium text-gray-900">
                                <c:choose>
                                    <c:when test="${order.paymentMethod == 'cod'}">COD</c:when>
                                    <c:when test="${order.paymentMethod == 'bank_transfer'}">Chuyển khoản</c:when>
                                    <c:when test="${order.paymentMethod == 'credit_card'}">Thẻ tín dụng</c:when>
                                    <c:otherwise>${order.paymentMethod}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="pt-3 border-t border-gray-200">
                            <div class="flex items-center justify-between">
                                <span class="text-base font-semibold text-gray-900">Tổng cộng</span>
                                <span class="text-xl font-bold text-blue-600">
                                    <fmt:formatNumber value="${order.totalAmount}" type="number" pattern="#,##0"/> đ
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Update Status Form -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-gray-900">Cập nhật trạng thái</h2>
                    </div>
                    <form method="POST" action="${pageContext.request.contextPath}/admin/order-detail" class="px-6 py-4 space-y-4">
                        <input type="hidden" name="orderId" value="${order.orderId}">

                        <!-- Order Status -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                Trạng thái đơn hàng <span class="text-red-500">*</span>
                            </label>
                            <select name="orderStatus"
                                    required
                                    ${order.orderStatus == 'completed' || order.orderStatus == 'cancelled' ? 'disabled' : ''}
                                    class="w-full px-4 py-2.5 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm ${order.orderStatus == 'completed' || order.orderStatus == 'cancelled' ? 'bg-gray-100 cursor-not-allowed' : ''}">
                                <option value="pending" ${order.orderStatus == 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                                <option value="confirmed" ${order.orderStatus == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                <option value="shipping" ${order.orderStatus == 'shipping' ? 'selected' : ''}>Đang giao hàng</option>
                                <option value="completed" ${order.orderStatus == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                                <option value="cancelled" ${order.orderStatus == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                            <c:if test="${order.orderStatus == 'completed' || order.orderStatus == 'cancelled'}">
                                <input type="hidden" name="orderStatus" value="${order.orderStatus}">
                                <p class="mt-1.5 text-xs text-gray-500">Không thể thay đổi trạng thái đơn hàng đã hoàn thành hoặc đã hủy</p>
                            </c:if>
                        </div>

                        <!-- Payment Status -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                Trạng thái thanh toán <span class="text-red-500">*</span>
                            </label>
                            <select name="paymentStatus"
                                    required
                                    class="w-full px-4 py-2.5 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm">
                                <option value="pending" ${order.paymentStatus == 'pending' ? 'selected' : ''}>Chờ thanh toán</option>
                                <option value="paid" ${order.paymentStatus == 'paid' ? 'selected' : ''}>Đã thanh toán</option>
                                <option value="failed" ${order.paymentStatus == 'failed' ? 'selected' : ''}>Thất bại</option>
                            </select>
                        </div>

                        <button type="submit"
                                ${order.orderStatus == 'completed' || order.orderStatus == 'cancelled' ? 'disabled' : ''}
                                class="w-full px-4 py-2.5 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors text-sm font-medium ${order.orderStatus == 'completed' || order.orderStatus == 'cancelled' ? 'opacity-50 cursor-not-allowed' : ''}">
                            Cập nhật trạng thái
                        </button>
                    </form>
                </div>

                <!-- Timeline Status -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-gray-900">Trạng thái đơn hàng</h2>
                    </div>
                    <div class="px-6 py-4">
                        <div class="space-y-4">
                            <div class="flex items-start space-x-3">
                                <div class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center ${order.orderStatus == 'pending' || order.orderStatus == 'confirmed' || order.orderStatus == 'shipping' || order.orderStatus == 'completed' ? 'bg-green-100' : 'bg-gray-100'}">
                                    <svg class="w-4 h-4 ${order.orderStatus == 'pending' || order.orderStatus == 'confirmed' || order.orderStatus == 'shipping' || order.orderStatus == 'completed' ? 'text-green-600' : 'text-gray-400'}" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                    </svg>
                                </div>
                                <div class="flex-1">
                                    <p class="text-sm font-medium text-gray-900">Chờ xử lý</p>
                                    <p class="text-xs text-gray-500">Đơn hàng đã được tạo</p>
                                </div>
                            </div>

                            <div class="flex items-start space-x-3">
                                <div class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center ${order.orderStatus == 'confirmed' || order.orderStatus == 'shipping' || order.orderStatus == 'completed' ? 'bg-green-100' : 'bg-gray-100'}">
                                    <svg class="w-4 h-4 ${order.orderStatus == 'confirmed' || order.orderStatus == 'shipping' || order.orderStatus == 'completed' ? 'text-green-600' : 'text-gray-400'}" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                    </svg>
                                </div>
                                <div class="flex-1">
                                    <p class="text-sm font-medium text-gray-900">Đã xác nhận</p>
                                    <p class="text-xs text-gray-500">Đơn hàng đã được xác nhận</p>
                                </div>
                            </div>

                            <div class="flex items-start space-x-3">
                                <div class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center ${order.orderStatus == 'shipping' || order.orderStatus == 'completed' ? 'bg-green-100' : 'bg-gray-100'}">
                                    <svg class="w-4 h-4 ${order.orderStatus == 'shipping' || order.orderStatus == 'completed' ? 'text-green-600' : 'text-gray-400'}" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                    </svg>
                                </div>
                                <div class="flex-1">
                                    <p class="text-sm font-medium text-gray-900">Đang giao hàng</p>
                                    <p class="text-xs text-gray-500">Đơn hàng đang được giao</p>
                                </div>
                            </div>

                            <div class="flex items-start space-x-3">
                                <div class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center ${order.orderStatus == 'completed' ? 'bg-green-100' : order.orderStatus == 'cancelled' ? 'bg-red-100' : 'bg-gray-100'}">
                                    <svg class="w-4 h-4 ${order.orderStatus == 'completed' ? 'text-green-600' : order.orderStatus == 'cancelled' ? 'text-red-600' : 'text-gray-400'}" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                    </svg>
                                </div>
                                <div class="flex-1">
                                    <p class="text-sm font-medium text-gray-900">
                                        ${order.orderStatus == 'completed' ? 'Hoàn thành' : order.orderStatus == 'cancelled' ? 'Đã hủy' : 'Hoàn thành'}
                                    </p>
                                    <p class="text-xs text-gray-500">
                                        ${order.orderStatus == 'completed' ? 'Đơn hàng đã giao thành công' : order.orderStatus == 'cancelled' ? 'Đơn hàng đã bị hủy' : 'Đơn hàng chưa hoàn thành'}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    // Auto hide toast messages after 5 seconds
    setTimeout(function() {
        const toasts = document.querySelectorAll('[class*="bg-green-50"], [class*="bg-red-50"]');
        toasts.forEach(function(toast) {
            if (toast.querySelector('button')) {
                toast.remove();
            }
        });
    }, 5000);
</script>

</body>
</html>
