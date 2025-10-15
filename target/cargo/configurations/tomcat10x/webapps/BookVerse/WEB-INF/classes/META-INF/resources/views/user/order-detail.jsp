<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

    <main class="max-w-5xl mx-auto px-4 py-8">
        <!-- Page Header -->
        <div class="mb-6">
            <a href="${pageContext.request.contextPath}/orders"
               class="inline-flex items-center text-sm text-gray-600 hover:text-gray-900 mb-4">
                <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                </svg>
                Quay lại danh sách đơn hàng
            </a>
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-semibold text-gray-900">Chi tiết đơn hàng</h1>
                    <p class="text-sm text-gray-600 mt-1">Mã đơn hàng: <span class="font-medium text-gray-900">${order.orderCode}</span></p>
                </div>
                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${order.orderStatusClass}">
                    ${order.orderStatusDisplay}
                </span>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Main Content - Col 2 -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Order Information -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Thông tin đơn hàng</h2>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <p class="text-sm text-gray-600 mb-1">Ngày đặt hàng</p>
                            <p class="text-sm font-medium text-gray-900">
                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                            </p>
                        </div>

                        <div>
                            <p class="text-sm text-gray-600 mb-1">Phương thức thanh toán</p>
                            <p class="text-sm font-medium text-gray-900">${order.paymentMethodDisplay}</p>
                        </div>

                        <div>
                            <p class="text-sm text-gray-600 mb-1">Trạng thái thanh toán</p>
                            <p class="text-sm font-medium">
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'paid'}">
                                        <span class="text-green-600">Đã thanh toán</span>
                                    </c:when>
                                    <c:when test="${order.paymentStatus == 'failed'}">
                                        <span class="text-red-600">Thất bại</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-yellow-600">Chưa thanh toán</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div>
                            <p class="text-sm text-gray-600 mb-1">Cập nhật lần cuối</p>
                            <p class="text-sm font-medium text-gray-900">
                                <fmt:formatDate value="${order.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                            </p>
                        </div>
                    </div>

                    <c:if test="${not empty order.notes}">
                        <div class="mt-4 pt-4 border-t border-gray-200">
                            <p class="text-sm text-gray-600 mb-1">Ghi chú</p>
                            <p class="text-sm text-gray-900">${order.notes}</p>
                        </div>
                    </c:if>
                </div>

                <!-- Shipping Information -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Thông tin giao hàng</h2>

                    <div class="space-y-3">
                        <div>
                            <p class="text-sm text-gray-600 mb-1">Người nhận</p>
                            <p class="text-sm font-medium text-gray-900">${order.shippingName}</p>
                        </div>

                        <div>
                            <p class="text-sm text-gray-600 mb-1">Số điện thoại</p>
                            <p class="text-sm font-medium text-gray-900">${order.shippingPhone}</p>
                        </div>

                        <div>
                            <p class="text-sm text-gray-600 mb-1">Địa chỉ giao hàng</p>
                            <p class="text-sm font-medium text-gray-900">${order.shippingAddress}</p>
                        </div>
                    </div>
                </div>

                <!-- Order Items -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">
                        Sản phẩm (${order.orderItems.size()} sản phẩm)
                    </h2>

                    <!-- Desktop Table -->
                    <div class="hidden md:block overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Sản phẩm</th>
                                    <th class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase">Đơn giá</th>
                                    <th class="px-4 py-3 text-center text-xs font-medium text-gray-500 uppercase">Số lượng</th>
                                    <th class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="item" items="${order.orderItems}">
                                    <tr>
                                        <td class="px-4 py-4">
                                            <div class="flex items-start gap-3">
                                                <img src="${pageContext.request.contextPath}${item.bookImageUrl != null ? item.bookImageUrl : '/assets/images/book-placeholder.jpg'}"
                                                     alt="${item.bookTitle}"
                                                     class="w-12 h-16 object-cover rounded border border-gray-200">
                                                <div class="min-w-0">
                                                    <h3 class="text-sm font-medium text-gray-900">${item.bookTitle}</h3>
                                                    <p class="text-xs text-gray-500 mt-0.5">${item.bookAuthor}</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-4 py-4 text-right whitespace-nowrap">
                                            <span class="text-sm text-gray-900">
                                                <fmt:formatNumber value="${item.bookPrice}" pattern="#,##0" /> đ
                                            </span>
                                        </td>
                                        <td class="px-4 py-4 text-center whitespace-nowrap">
                                            <span class="text-sm text-gray-900">${item.quantity}</span>
                                        </td>
                                        <td class="px-4 py-4 text-right whitespace-nowrap">
                                            <span class="text-sm font-semibold text-gray-900">
                                                <fmt:formatNumber value="${item.subtotal}" pattern="#,##0" /> đ
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Mobile Cards -->
                    <div class="md:hidden space-y-4">
                        <c:forEach var="item" items="${order.orderItems}">
                            <div class="border border-gray-200 rounded-lg p-4">
                                <div class="flex items-start gap-3 mb-3">
                                    <img src="${pageContext.request.contextPath}${item.bookImageUrl != null ? item.bookImageUrl : '/assets/images/book-placeholder.jpg'}"
                                         alt="${item.bookTitle}"
                                         class="w-16 h-20 object-cover rounded border border-gray-200">
                                    <div class="flex-1 min-w-0">
                                        <h3 class="text-sm font-medium text-gray-900">${item.bookTitle}</h3>
                                        <p class="text-xs text-gray-500 mt-0.5">${item.bookAuthor}</p>
                                    </div>
                                </div>
                                <div class="flex items-center justify-between text-sm">
                                    <span class="text-gray-600">
                                        <fmt:formatNumber value="${item.bookPrice}" pattern="#,##0" /> đ x ${item.quantity}
                                    </span>
                                    <span class="font-semibold text-gray-900">
                                        <fmt:formatNumber value="${item.subtotal}" pattern="#,##0" /> đ
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Sidebar - Col 1 -->
            <div class="lg:col-span-1">
                <!-- Order Summary -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6 sticky top-4">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Tổng quan đơn hàng</h2>

                    <div class="space-y-3">
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-600">Tạm tính:</span>
                            <span class="font-medium text-gray-900">
                                <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" /> đ
                            </span>
                        </div>

                        <div class="flex justify-between text-sm">
                            <span class="text-gray-600">Phí vận chuyển:</span>
                            <span class="font-medium text-green-600">Miễn phí</span>
                        </div>

                        <div class="border-t border-gray-200 pt-3 mt-3">
                            <div class="flex justify-between">
                                <span class="text-base font-semibold text-gray-900">Tổng cộng:</span>
                                <span class="text-xl font-bold text-blue-600">
                                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" /> đ
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="mt-6 space-y-3">
                        <c:if test="${order.orderStatus == 'pending'}">
                            <form id="cancelOrderForm" action="${pageContext.request.contextPath}/order/cancel" method="POST">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <button type="button" onclick="confirmCancelOrder()"
                                        class="w-full bg-red-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-red-700 transition-colors">
                                    Hủy đơn hàng
                                </button>
                            </form>
                        </c:if>

                        <a href="${pageContext.request.contextPath}/orders"
                           class="block w-full text-center bg-gray-100 text-gray-700 px-4 py-2 rounded-md text-sm font-medium hover:bg-gray-200 transition-colors">
                            Quay lại danh sách
                        </a>
                    </div>

                    <!-- Contact Support -->
                    <div class="mt-6 pt-6 border-t border-gray-200">
                        <p class="text-xs text-gray-600 mb-2">Cần hỗ trợ?</p>
                        <a href="#" class="text-sm text-blue-600 hover:text-blue-700 font-medium">
                            Liên hệ bộ phận chăm sóc khách hàng
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Cancel Order Confirmation Script -->
    <script>
        function confirmCancelOrder() {
            if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này?\n\nĐơn hàng đã hủy không thể khôi phục lại.')) {
                document.getElementById('cancelOrderForm').submit();
            }
        }
    </script>

<jsp:include page="../common/footer.jsp" />
