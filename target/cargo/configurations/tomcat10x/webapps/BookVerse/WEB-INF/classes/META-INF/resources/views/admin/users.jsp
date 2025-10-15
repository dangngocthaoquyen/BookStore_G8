<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - BookVerse Admin</title>
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
            <div class="mb-6">
                <h1 class="text-2xl font-semibold text-gray-900">Quản lý người dùng</h1>
                <p class="text-sm text-gray-600 mt-1">Quản lý tài khoản người dùng và phân quyền</p>
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

            <!-- Search & Filter -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4 mb-6">
                <form method="get" action="${pageContext.request.contextPath}/admin/users" class="flex flex-col md:flex-row gap-4">
                    <!-- Search -->
                    <div class="flex-1">
                        <input type="text"
                               name="keyword"
                               value="${param.keyword}"
                               placeholder="Tìm kiếm theo tên hoặc email..."
                               class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    </div>

                    <!-- Role Filter -->
                    <div class="w-full md:w-48">
                        <select name="role" class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="">Tất cả vai trò</option>
                            <option value="user" ${param.role == 'user' ? 'selected' : ''}>Người dùng</option>
                            <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Quản trị viên</option>
                        </select>
                    </div>

                    <!-- Status Filter -->
                    <div class="w-full md:w-48">
                        <select name="status" class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="">Tất cả trạng thái</option>
                            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Đã khóa</option>
                        </select>
                    </div>

                    <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors">
                        Tìm kiếm
                    </button>

                    <c:if test="${not empty param.keyword or not empty param.role or not empty param.status}">
                        <a href="${pageContext.request.contextPath}/admin/users" class="px-6 py-2 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 transition-colors text-center">
                            Xóa bộ lọc
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- Users Table -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b border-gray-200">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Họ tên</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Số điện thoại</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Vai trò</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Trạng thái</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ngày đăng ký</th>
                                <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="8" class="px-6 py-8 text-center text-gray-500">
                                            Không tìm thấy người dùng nào
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="user" items="${users}">
                                        <tr class="hover:bg-gray-50">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                                ${user.userId}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm font-medium text-gray-900">${user.fullName}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm text-gray-600">${user.email}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm text-gray-600">${user.phone}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
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
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <c:choose>
                                                    <c:when test="${user.status == 'active'}">
                                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                            Hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                            Đã khóa
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium">
                                                <a href="${pageContext.request.contextPath}/admin/user?id=${user.userId}"
                                                   class="text-blue-600 hover:text-blue-900 mr-3">
                                                    Chi tiết
                                                </a>
                                                <c:if test="${user.userId != sessionScope.user.userId}">
                                                    <c:choose>
                                                        <c:when test="${user.status == 'active'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/users" class="inline"
                                                                  onsubmit="return confirm('Bạn có chắc muốn khóa người dùng này?')">
                                                                <input type="hidden" name="action" value="deactivate">
                                                                <input type="hidden" name="userId" value="${user.userId}">
                                                                <button type="submit" class="text-red-600 hover:text-red-900">
                                                                    Khóa
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/users" class="inline">
                                                                <input type="hidden" name="action" value="activate">
                                                                <input type="hidden" name="userId" value="${user.userId}">
                                                                <button type="submit" class="text-green-600 hover:text-green-900">
                                                                    Mở khóa
                                                                </button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="bg-gray-50 px-6 py-4 border-t border-gray-200">
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-600">
                                Trang ${currentPage} / ${totalPages} (Tổng ${totalUsers} người dùng)
                            </div>
                            <div class="flex gap-2">
                                <c:if test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}${not empty param.role ? '&role='.concat(param.role) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}"
                                       class="px-4 py-2 bg-white border border-gray-300 rounded-md hover:bg-gray-50 text-sm">
                                        Trước
                                    </a>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                        <a href="?page=${i}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}${not empty param.role ? '&role='.concat(param.role) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}"
                                           class="px-4 py-2 ${i == currentPage ? 'bg-blue-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'} border border-gray-300 rounded-md text-sm">
                                            ${i}
                                        </a>
                                    </c:if>
                                    <c:if test="${i == currentPage - 3 || i == currentPage + 3}">
                                        <span class="px-2 py-2 text-gray-500">...</span>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}${not empty param.role ? '&role='.concat(param.role) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}"
                                       class="px-4 py-2 bg-white border border-gray-300 rounded-md hover:bg-gray-50 text-sm">
                                        Sau
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div id="toast-container" class="fixed top-4 right-4 z-50"></div>

    <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
</body>
</html>
