<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

    <main class="max-w-7xl mx-auto px-4 py-8">
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-semibold text-gray-900">Đơn hàng của tôi</h1>
            <p class="text-sm text-gray-600 mt-1">Quản lý và theo dõi đơn hàng của bạn</p>
        </div>

        <!-- Orders List -->
        <c:choose>
            <c:when test="${empty orders}">
                <!-- Empty State -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-12 text-center">
                    <svg class="w-24 h-24 mx-auto text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path>
                    </svg>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Bạn chưa có đơn hàng nào</h3>
                    <p class="text-sm text-gray-600 mb-6">Hãy khám phá các sản phẩm và đặt hàng ngay!</p>
                    <a href="${pageContext.request.contextPath}/"
                       class="inline-flex items-center justify-center bg-blue-600 text-white px-6 py-3 rounded-md font-medium hover:bg-blue-700 transition-colors">
                        Khám phá sách
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Desktop Table -->
                <div class="hidden md:block bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Mã đơn hàng
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Ngày đặt
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Tổng tiền
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Trạng thái
                                    </th>
                                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Thao tác
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="order" items="${orders}">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm font-medium text-gray-900">${order.orderCode}</div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-600">
                                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm font-semibold text-gray-900">
                                                <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" /> đ
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${order.orderStatusClass}">
                                                ${order.orderStatusDisplay}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm">
                                            <a href="${pageContext.request.contextPath}/order?id=${order.orderId}"
                                               class="text-blue-600 hover:text-blue-700 font-medium">
                                                Xem chi tiết
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Mobile Cards -->
                <div class="md:hidden space-y-4">
                    <c:forEach var="order" items="${orders}">
                        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
                            <div class="flex items-start justify-between mb-3">
                                <div>
                                    <div class="text-sm font-medium text-gray-900 mb-1">${order.orderCode}</div>
                                    <div class="text-xs text-gray-500">
                                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </div>
                                </div>
                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${order.orderStatusClass}">
                                    ${order.orderStatusDisplay}
                                </span>
                            </div>

                            <div class="border-t border-gray-200 pt-3">
                                <div class="flex items-center justify-between mb-3">
                                    <span class="text-sm text-gray-600">Tổng tiền:</span>
                                    <span class="text-base font-bold text-gray-900">
                                        <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" /> đ
                                    </span>
                                </div>

                                <a href="${pageContext.request.contextPath}/order?id=${order.orderId}"
                                   class="block w-full text-center bg-blue-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-blue-700 transition-colors">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Order Statistics -->
                <div class="mt-6 grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
                        <div class="text-sm text-gray-600 mb-1">Tổng đơn hàng</div>
                        <div class="text-2xl font-bold text-gray-900">${orders.size()}</div>
                    </div>

                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
                        <div class="text-sm text-gray-600 mb-1">Đang xử lý</div>
                        <div class="text-2xl font-bold text-yellow-600">
                            <c:set var="pendingCount" value="0" />
                            <c:forEach var="order" items="${orders}">
                                <c:if test="${order.orderStatus == 'pending' || order.orderStatus == 'confirmed' || order.orderStatus == 'shipping'}">
                                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${pendingCount}
                        </div>
                    </div>

                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
                        <div class="text-sm text-gray-600 mb-1">Hoàn thành</div>
                        <div class="text-2xl font-bold text-green-600">
                            <c:set var="completedCount" value="0" />
                            <c:forEach var="order" items="${orders}">
                                <c:if test="${order.orderStatus == 'completed'}">
                                    <c:set var="completedCount" value="${completedCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${completedCount}
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

<jsp:include page="../common/footer.jsp" />
