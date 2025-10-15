<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

    <main class="max-w-7xl mx-auto px-4 py-8">
        <!-- Error Debug Info -->
        <c:if test="${not empty errorMessage}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                <h3 class="font-bold text-lg">ERROR DETAILS:</h3>
                <p class="mt-2"><strong>Message:</strong> ${errorMessage}</p>
                <c:if test="${not empty errorStackTrace}">
                    <details class="mt-3">
                        <summary class="cursor-pointer font-semibold">Stack Trace (click to expand)</summary>
                        <pre class="text-xs mt-2 bg-white p-2 rounded overflow-auto max-h-96">${errorStackTrace}</pre>
                    </details>
                </c:if>
            </div>
        </c:if>

        <div class="mb-6">
            <h1 class="text-2xl font-semibold text-gray-900">Thanh toán</h1>
            <p class="text-sm text-gray-600 mt-1">Vui lòng kiểm tra thông tin và hoàn tất đơn hàng</p>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Order Summary - Cột 1 -->
            <div class="lg:col-span-1 order-2 lg:order-1">
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Đơn hàng của bạn</h2>

                    <!-- Cart Items -->
                    <div class="space-y-4 mb-4">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="flex items-start gap-3">
                                <img src="${pageContext.request.contextPath}${item.bookImageUrl != null ? item.bookImageUrl : '/assets/images/book-placeholder.jpg'}"
                                     alt="${item.bookTitle}"
                                     class="w-16 h-20 object-cover rounded border border-gray-200">
                                <div class="flex-1 min-w-0">
                                    <h3 class="text-sm font-medium text-gray-900 truncate">${item.bookTitle}</h3>
                                    <p class="text-xs text-gray-500 mt-0.5">${item.bookAuthor}</p>
                                    <div class="flex items-center justify-between mt-2">
                                        <span class="text-xs text-gray-600">x${item.quantity}</span>
                                        <span class="text-sm font-medium text-gray-900">
                                            <fmt:formatNumber value="${item.subtotal}" pattern="#,##0" /> đ
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Divider -->
                    <div class="border-t border-gray-200 my-4"></div>

                    <!-- Total -->
                    <div class="space-y-2">
                        <div class="flex justify-between text-sm text-gray-600">
                            <span>Tạm tính:</span>
                            <span><fmt:formatNumber value="${totalAmount}" pattern="#,##0" /> đ</span>
                        </div>
                        <div class="flex justify-between text-sm text-gray-600">
                            <span>Phí vận chuyển:</span>
                            <span class="text-green-600">Miễn phí</span>
                        </div>
                        <div class="border-t border-gray-200 pt-2 mt-2">
                            <div class="flex justify-between">
                                <span class="text-base font-semibold text-gray-900">Tổng cộng:</span>
                                <span class="text-lg font-bold text-blue-600">
                                    <fmt:formatNumber value="${totalAmount}" pattern="#,##0" /> đ
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Shipping Form - Cột 2 -->
            <div class="lg:col-span-2 order-1 lg:order-2">
                <form action="${pageContext.request.contextPath}/checkout" method="POST" id="checkoutForm" class="space-y-6">
                    <!-- Thông tin giao hàng -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <h2 class="text-lg font-semibold text-gray-900 mb-4">Thông tin giao hàng</h2>

                        <div class="space-y-4">
                            <!-- Tên người nhận -->
                            <div>
                                <label for="shippingName" class="block text-sm font-medium text-gray-700 mb-1">
                                    Tên người nhận <span class="text-red-500">*</span>
                                </label>
                                <input type="text"
                                       id="shippingName"
                                       name="shippingName"
                                       value="${shippingName}"
                                       required
                                       placeholder="Nhập tên người nhận"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            </div>

                            <!-- Số điện thoại -->
                            <div>
                                <label for="shippingPhone" class="block text-sm font-medium text-gray-700 mb-1">
                                    Số điện thoại <span class="text-red-500">*</span>
                                </label>
                                <input type="tel"
                                       id="shippingPhone"
                                       name="shippingPhone"
                                       value="${shippingPhone}"
                                       required
                                       pattern="^(0|\+84)[3|5|7|8|9][0-9]{8}$"
                                       placeholder="Nhập số điện thoại (VD: 0912345678)"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <p class="text-xs text-gray-500 mt-1">Định dạng: 0912345678</p>
                            </div>

                            <!-- Địa chỉ giao hàng -->
                            <div>
                                <label for="shippingAddress" class="block text-sm font-medium text-gray-700 mb-1">
                                    Địa chỉ giao hàng <span class="text-red-500">*</span>
                                </label>
                                <textarea id="shippingAddress"
                                          name="shippingAddress"
                                          rows="3"
                                          required
                                          placeholder="Nhập địa chỉ chi tiết (số nhà, đường, phường, quận, thành phố)"
                                          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">${shippingAddress}</textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Phương thức thanh toán -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <h2 class="text-lg font-semibold text-gray-900 mb-4">Phương thức thanh toán</h2>

                        <div class="space-y-3">
                            <!-- COD -->
                            <label class="flex items-start p-4 border-2 border-gray-200 rounded-lg cursor-pointer hover:border-blue-500 transition-colors">
                                <input type="radio"
                                       name="paymentMethod"
                                       value="cod"
                                       checked
                                       class="mt-1 w-4 h-4 text-blue-600 focus:ring-blue-500">
                                <div class="ml-3 flex-1">
                                    <div class="font-medium text-gray-900">Thanh toán khi nhận hàng (COD)</div>
                                    <p class="text-sm text-gray-500 mt-1">Thanh toán bằng tiền mặt khi nhận hàng</p>
                                </div>
                            </label>

                            <!-- VNPay -->
                            <label class="flex items-start p-4 border-2 border-gray-200 rounded-lg cursor-pointer hover:border-blue-500 transition-colors">
                                <input type="radio"
                                       name="paymentMethod"
                                       value="vnpay"
                                       class="mt-1 w-4 h-4 text-blue-600 focus:ring-blue-500">
                                <div class="ml-3 flex-1">
                                    <div class="font-medium text-gray-900 flex items-center">
                                        VNPay
                                        <span class="ml-2 px-2 py-0.5 bg-blue-100 text-blue-600 text-xs font-medium rounded">Khuyên dùng</span>
                                    </div>
                                    <p class="text-sm text-gray-500 mt-1">Thanh toán qua VNPay - Hỗ trợ thẻ ATM, Visa, MasterCard, QR Code</p>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Ghi chú -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <h2 class="text-lg font-semibold text-gray-900 mb-4">Ghi chú đơn hàng (tùy chọn)</h2>
                        <textarea id="notes"
                                  name="notes"
                                  rows="3"
                                  placeholder="Ghi chú về đơn hàng, ví dụ: thời gian giao hàng chi tiết hơn"
                                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"></textarea>
                    </div>

                    <!-- Submit Button -->
                    <div class="flex items-center justify-between">
                        <a href="${pageContext.request.contextPath}/cart"
                           class="text-sm text-gray-600 hover:text-gray-900 transition-colors">
                            &larr; Quay lại giỏ hàng
                        </a>
                        <button type="submit"
                                class="bg-blue-600 text-white px-6 py-3 rounded-md font-medium hover:bg-blue-700 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                            Hoàn tất đặt hàng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <!-- Client-side Validation -->
    <script>
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            const phone = document.getElementById('shippingPhone').value;
            const phoneRegex = /^(0|\+84)[3|5|7|8|9][0-9]{8}$/;

            if (!phoneRegex.test(phone)) {
                e.preventDefault();
                alert('Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam (VD: 0912345678)');
                return false;
            }
        });
    </script>

<jsp:include page="../common/footer.jsp" />
