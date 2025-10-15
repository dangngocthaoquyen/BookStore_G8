<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết người dùng - BookVerse Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-gray-50">
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Main Content -->
    <div class="lg:ml-64 min-h-screen">
        <div class="p-6">
            <!-- Header -->
            <div class="mb-6 flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-semibold text-gray-900">Chi tiết người dùng</h1>
                    <p class="text-sm text-gray-600 mt-1">Thông tin chi tiết và lịch sử hoạt động</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/users"
                   class="px-4 py-2 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 transition-colors">
                    Quay lại
                </a>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded-md mb-4">
                    ${sessionScope.success}
                </div>
                <c:remove var="success" scope="session" />
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-md mb-4">
                    ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- User Information -->
                <div class="lg:col-span-2 space-y-6">
                    <!-- Basic Info Card -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h2 class="text-lg font-semibold text-gray-900">Thông tin cá nhân</h2>
                            <c:choose>
                                <c:when test="${user.status == 'active'}">
                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                                        Đang hoạt động
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                                        Đã khóa
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="space-y-4">
                            <div class="flex items-start">
                                <div class="w-32 text-sm font-medium text-gray-500">ID:</div>
                                <div class="flex-1 text-sm text-gray-900">${user.userId}</div>
                            </div>
                            <div class="flex items-start">
                                <div class="w-32 text-sm font-medium text-gray-500">Họ tên:</div>
                                <div class="flex-1 text-sm text-gray-900">${user.fullName}</div>
                            </div>
                            <div class="flex items-start">
                                <div class="w-32 text-sm font-medium text-gray-500">Email:</div>
                                <div class="flex-1 text-sm text-gray-900">${user.email}</div>
                            </div>
                            <div class="flex items-start">
                                <div class="w-32 text-sm font-medium text-gray-500">Số điện thoại:</div>
                                <div class="flex-1 text-sm text-gray-900">${user.phone}</div>
                            </div>
                            <div class="flex items-start">
                                <div class="w-32 text-sm font-medium text-gray-500">Địa chỉ:</div>
                                <div class="flex-1 text-sm text-gray-900">${user.address}</div>
                            </div>
                            <div class="flex items-start">
                                <div class="w-32 text-sm font-medium text-gray-500">Vai trò:</div>
                                <div class="flex-1">
                                    <c:choose>
                                        <c:when test="${user.role == 'admin'}">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                                                Quản trị viên
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                Người dùng
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <div class="w-32 text-sm font-medium text-gray-500">Ngày đăng ký:</div>
                                <div class="flex-1 text-sm text-gray-900">
                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </div>
                            </div>
                            <div class="flex items-start">
                                <div class="w-32 text-sm font-medium text-gray-500">Cập nhật cuối:</div>
                                <div class="flex-1 text-sm text-gray-900">
                                    <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                </div>
                            </div>
                        </div>

                        <!-- Actions -->
                        <c:if test="${user.userId != sessionScope.user.userId}">
                            <div class="mt-6 pt-6 border-t border-gray-200">
                                <div class="flex gap-3">
                                    <c:choose>
                                        <c:when test="${user.status == 'active'}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/user" class="inline"
                                                  onsubmit="return confirm('Bạn có chắc muốn khóa người dùng này?')">
                                                <input type="hidden" name="action" value="deactivate">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <button type="submit"
                                                        class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors">
                                                    Khóa tài khoản
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/user" class="inline">
                                                <input type="hidden" name="action" value="activate">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <button type="submit"
                                                        class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors">
                                                    Mở khóa tài khoản
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Order History -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <h2 class="text-lg font-semibold text-gray-900 mb-4">Lịch sử đơn hàng</h2>

                        <c:choose>
                            <c:when test="${empty orders}">
                                <div class="text-center py-8 text-gray-500">
                                    Người dùng chưa có đơn hàng nào
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="overflow-x-auto">
                                    <table class="w-full">
                                        <thead class="bg-gray-50">
                                            <tr>
                                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Mã đơn</th>
                                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Ngày đặt</th>
                                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tổng tiền</th>
                                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Trạng thái</th>
                                                <th class="px-4 py-3 text-center text-xs font-medium text-gray-500 uppercase">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            <c:forEach var="order" items="${orders}">
                                                <tr class="hover:bg-gray-50">
                                                    <td class="px-4 py-3 text-sm font-medium text-gray-900">
                                                        ${order.orderCode}
                                                    </td>
                                                    <td class="px-4 py-3 text-sm text-gray-600">
                                                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td class="px-4 py-3 text-sm text-gray-900">
                                                        <fmt:formatNumber value="${order.totalAmount}" pattern="#,###" /> đ
                                                    </td>
                                                    <td class="px-4 py-3">
                                                        <c:choose>
                                                            <c:when test="${order.orderStatus == 'pending'}">
                                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                                    Chờ xác nhận
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.orderStatus == 'confirmed'}">
                                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                                    Đã xác nhận
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.orderStatus == 'shipping'}">
                                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                                                                    Đang giao hàng
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.orderStatus == 'completed'}">
                                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                                    Hoàn thành
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                                    Đã hủy
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="px-4 py-3 text-center">
                                                        <a href="${pageContext.request.contextPath}/admin/order?id=${order.orderId}"
                                                           class="text-blue-600 hover:text-blue-900 text-sm">
                                                            Xem chi tiết
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Statistics Sidebar -->
                <div class="space-y-6">
                    <!-- Statistics Card -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <h2 class="text-lg font-semibold text-gray-900 mb-4">Thống kê</h2>
                        <div class="space-y-4">
                            <div class="flex items-center justify-between">
                                <span class="text-sm text-gray-600">Tổng đơn hàng:</span>
                                <span class="text-lg font-semibold text-gray-900">${totalOrders}</span>
                            </div>
                            <div class="flex items-center justify-between">
                                <span class="text-sm text-gray-600">Chờ xử lý:</span>
                                <span class="text-lg font-semibold text-yellow-600">${pendingOrders}</span>
                            </div>
                            <div class="flex items-center justify-between">
                                <span class="text-sm text-gray-600">Hoàn thành:</span>
                                <span class="text-lg font-semibold text-green-600">${completedOrders}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Info Card -->
                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
                        <h3 class="text-sm font-medium text-blue-900 mb-2">Lưu ý</h3>
                        <p class="text-sm text-blue-700">
                            Khi khóa tài khoản, người dùng sẽ không thể đăng nhập vào hệ thống.
                            Các đơn hàng hiện tại sẽ không bị ảnh hưởng.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div id="toast-container" class="fixed top-4 right-4 z-50"></div>

    <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
</body>
</html>
