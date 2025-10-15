<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - BookVerse Admin</title>
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
                    <h1 class="text-2xl font-semibold text-gray-900">Quản lý đơn hàng</h1>
                    <p class="text-sm text-gray-500 mt-1">Quản lý tất cả đơn hàng trong hệ thống</p>
                </div>
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

        <!-- Filter Tabs -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 mb-6">
            <div class="flex flex-wrap items-center gap-2 p-4 border-b border-gray-200">
                <a href="${pageContext.request.contextPath}/admin/orders?status=all"
                   class="px-4 py-2 rounded-md text-sm font-medium transition-colors ${statusFilter == 'all' ? 'bg-blue-600 text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">
                    Tất cả (${allCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=pending"
                   class="px-4 py-2 rounded-md text-sm font-medium transition-colors ${statusFilter == 'pending' ? 'bg-yellow-100 text-yellow-700' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">
                    Chờ xử lý (${pendingCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=confirmed"
                   class="px-4 py-2 rounded-md text-sm font-medium transition-colors ${statusFilter == 'confirmed' ? 'bg-blue-100 text-blue-700' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">
                    Đã xác nhận (${confirmedCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=shipping"
                   class="px-4 py-2 rounded-md text-sm font-medium transition-colors ${statusFilter == 'shipping' ? 'bg-blue-100 text-blue-700' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">
                    Đang giao (${shippingCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=completed"
                   class="px-4 py-2 rounded-md text-sm font-medium transition-colors ${statusFilter == 'completed' ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">
                    Hoàn thành (${completedCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=cancelled"
                   class="px-4 py-2 rounded-md text-sm font-medium transition-colors ${statusFilter == 'cancelled' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">
                    Đã hủy (${cancelledCount})
                </a>
            </div>

            <!-- Search Box -->
            <div class="p-4">
                <form method="GET" action="${pageContext.request.contextPath}/admin/orders" class="flex items-center space-x-3">
                    <div class="flex-1">
                        <div class="relative">
                            <input type="text"
                                   name="keyword"
                                   value="${keyword}"
                                   placeholder="Tìm kiếm theo mã đơn hàng, tên khách hàng..."
                                   class="w-full pl-10 pr-4 py-2.5 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm">
                            <svg class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                            </svg>
                        </div>
                    </div>
                    <button type="submit"
                            class="px-6 py-2.5 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors text-sm font-medium">
                        Tìm kiếm
                    </button>
                    <c:if test="${not empty keyword}">
                        <a href="${pageContext.request.contextPath}/admin/orders"
                           class="px-6 py-2.5 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 transition-colors text-sm font-medium">
                            Xóa bộ lọc
                        </a>
                    </c:if>
                </form>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="text-center py-12">
                        <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        <p class="text-gray-500 text-sm">Không tìm thấy đơn hàng nào</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50 border-b border-gray-200">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Mã đơn hàng
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Khách hàng
                                    </th>
                                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Tổng tiền
                                    </th>
                                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Trạng thái
                                    </th>
                                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Ngày đặt
                                    </th>
                                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Thao tác
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="order" items="${orders}">
                                    <tr class="hover:bg-gray-50 transition-colors">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm font-medium text-blue-600">${order.orderCode}</div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="text-sm font-medium text-gray-900">${order.shippingName}</div>
                                            <div class="text-xs text-gray-500">${order.shippingPhone}</div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-right">
                                            <div class="text-sm font-semibold text-gray-900">
                                                <fmt:formatNumber value="${order.totalAmount}" type="number" pattern="#,##0"/> đ
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-center">
                                            <c:choose>
                                                <c:when test="${order.orderStatus == 'pending'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        Chờ xử lý
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'confirmed'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                        Đã xác nhận
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'shipping'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                        Đang giao
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'completed'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        Hoàn thành
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'cancelled'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                        Đã hủy
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                        ${order.orderStatus}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-center">
                                            <div class="text-sm text-gray-900">
                                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy"/>
                                            </div>
                                            <div class="text-xs text-gray-500">
                                                <fmt:formatDate value="${order.createdAt}" pattern="HH:mm"/>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-center">
                                            <a href="${pageContext.request.contextPath}/admin/order-detail?id=${order.orderId}"
                                               class="inline-flex items-center px-3 py-1.5 bg-blue-50 text-blue-600 rounded-md hover:bg-blue-100 transition-colors">
                                                <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                                </svg>
                                                <span class="text-xs font-medium">Chi tiết</span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="bg-gray-50 px-6 py-4 border-t border-gray-200">
                            <div class="flex items-center justify-between">
                                <div class="text-sm text-gray-500">
                                    Hiển thị trang ${currentPage} / ${totalPages} (Tổng ${totalOrders} đơn hàng)
                                </div>
                                <div class="flex items-center space-x-2">
                                    <!-- Previous Button -->
                                    <c:if test="${currentPage > 1}">
                                        <a href="${pageContext.request.contextPath}/admin/orders?page=${currentPage - 1}${not empty statusFilter and statusFilter != 'all' ? '&status='.concat(statusFilter) : ''}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                                           class="px-3 py-2 rounded-md text-sm text-gray-600 hover:bg-gray-100 transition-colors border border-gray-300">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                                            </svg>
                                        </a>
                                    </c:if>

                                    <!-- Page Numbers -->
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                            <c:choose>
                                                <c:when test="${i == currentPage}">
                                                    <span class="px-4 py-2 rounded-md text-sm font-medium bg-blue-600 text-white">
                                                        ${i}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/admin/orders?page=${i}${not empty statusFilter and statusFilter != 'all' ? '&status='.concat(statusFilter) : ''}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                                                       class="px-4 py-2 rounded-md text-sm text-gray-600 hover:bg-gray-100 transition-colors border border-gray-300">
                                                        ${i}
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </c:forEach>

                                    <!-- Next Button -->
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="${pageContext.request.contextPath}/admin/orders?page=${currentPage + 1}${not empty statusFilter and statusFilter != 'all' ? '&status='.concat(statusFilter) : ''}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                                           class="px-3 py-2 rounded-md text-sm text-gray-600 hover:bg-gray-100 transition-colors border border-gray-300">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                                            </svg>
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
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
