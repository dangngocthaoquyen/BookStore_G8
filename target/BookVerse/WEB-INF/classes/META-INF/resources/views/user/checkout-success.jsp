<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

    <main class="max-w-3xl mx-auto px-4 py-12">
        <!-- Success Card -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8 text-center">
            <!-- Success Icon -->
            <div class="flex justify-center mb-6">
                <svg class="w-20 h-20 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
            </div>

            <!-- Success Message -->
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Đặt hàng thành công!</h1>
            <p class="text-base text-gray-600 mb-8">
                Cảm ơn bạn đã đặt hàng. Chúng tôi sẽ xử lý đơn hàng của bạn trong thời gian sớm nhất.
            </p>

            <!-- Order Code -->
            <div class="bg-blue-50 border-2 border-blue-200 rounded-lg p-6 mb-8">
                <p class="text-sm text-gray-600 mb-2">Mã đơn hàng của bạn</p>
                <p class="text-2xl font-bold text-blue-600">${order.orderCode}</p>
            </div>

            <!-- Order Info Summary -->
            <div class="text-left bg-gray-50 rounded-lg p-6 mb-8">
                <h2 class="text-lg font-semibold text-gray-900 mb-4">Thông tin đơn hàng</h2>

                <div class="space-y-3">
                    <div class="flex justify-between text-sm">
                        <span class="text-gray-600">Người nhận:</span>
                        <span class="font-medium text-gray-900">${order.shippingName}</span>
                    </div>

                    <div class="flex justify-between text-sm">
                        <span class="text-gray-600">Số điện thoại:</span>
                        <span class="font-medium text-gray-900">${order.shippingPhone}</span>
                    </div>

                    <div class="flex justify-between text-sm">
                        <span class="text-gray-600">Địa chỉ:</span>
                        <span class="font-medium text-gray-900 text-right max-w-xs">${order.shippingAddress}</span>
                    </div>

                    <div class="border-t border-gray-200 pt-3 mt-3">
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-600">Phương thức thanh toán:</span>
                            <span class="font-medium text-gray-900">${order.paymentMethodDisplay}</span>
                        </div>
                    </div>

                    <div class="border-t border-gray-200 pt-3 mt-3">
                        <div class="flex justify-between">
                            <span class="font-semibold text-gray-900">Tổng tiền:</span>
                            <span class="text-xl font-bold text-blue-600">
                                <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" /> đ
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Items -->
            <div class="text-left bg-gray-50 rounded-lg p-6 mb-8">
                <h2 class="text-lg font-semibold text-gray-900 mb-4">Sản phẩm đã đặt (${order.orderItems.size()} sản phẩm)</h2>

                <div class="space-y-4">
                    <c:forEach var="item" items="${order.orderItems}">
                        <div class="flex items-start gap-3">
                            <img src="${pageContext.request.contextPath}${item.bookImageUrl != null ? item.bookImageUrl : '/assets/images/book-placeholder.jpg'}"
                                 alt="${item.bookTitle}"
                                 class="w-16 h-20 object-cover rounded border border-gray-200">
                            <div class="flex-1 min-w-0">
                                <h3 class="text-sm font-medium text-gray-900">${item.bookTitle}</h3>
                                <p class="text-xs text-gray-500 mt-0.5">${item.bookAuthor}</p>
                                <div class="flex items-center justify-between mt-2">
                                    <span class="text-sm text-gray-600">
                                        <fmt:formatNumber value="${item.bookPrice}" pattern="#,##0" /> đ x ${item.quantity}
                                    </span>
                                    <span class="text-sm font-semibold text-gray-900">
                                        <fmt:formatNumber value="${item.subtotal}" pattern="#,##0" /> đ
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="${pageContext.request.contextPath}/order?id=${order.orderId}"
                   class="inline-flex items-center justify-center bg-blue-600 text-white px-6 py-3 rounded-md font-medium hover:bg-blue-700 transition-colors">
                    Xem chi tiết đơn hàng
                </a>
                <a href="${pageContext.request.contextPath}/"
                   class="inline-flex items-center justify-center bg-gray-100 text-gray-700 px-6 py-3 rounded-md font-medium hover:bg-gray-200 transition-colors">
                    Tiếp tục mua sắm
                </a>
            </div>

            <!-- Note -->
            <div class="mt-8 text-sm text-gray-500">
                <p>Bạn có thể theo dõi đơn hàng tại trang
                    <a href="${pageContext.request.contextPath}/orders" class="text-blue-600 hover:text-blue-700 font-medium">Đơn hàng của tôi</a>
                </p>
            </div>
        </div>
    </main>

<jsp:include page="../common/footer.jsp" />
