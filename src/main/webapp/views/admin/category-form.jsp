<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Sửa' : 'Thêm'} danh mục - BookVerse Admin</title>
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
                    <h1 class="text-2xl font-semibold text-gray-900">
                        ${isEdit ? 'Sửa danh mục' : 'Thêm danh mục mới'}
                    </h1>
                    <p class="text-sm text-gray-500 mt-1">
                        ${isEdit ? 'Cập nhật thông tin danh mục' : 'Tạo danh mục sách mới'}
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/categories"
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
        <!-- Error Messages -->
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

        <!-- Form -->
        <div class="max-w-3xl">
            <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
                <form method="POST" action="${pageContext.request.contextPath}/admin/category-form" onsubmit="return validateForm()">
                    <!-- Hidden field for edit mode -->
                    <c:if test="${isEdit}">
                        <input type="hidden" name="categoryId" value="${category.categoryId}">
                    </c:if>

                    <div class="p-6 space-y-6">
                        <!-- Tên danh mục -->
                        <div>
                            <label for="categoryName" class="block text-sm font-medium text-gray-700 mb-2">
                                Tên danh mục <span class="text-red-500">*</span>
                            </label>
                            <input type="text"
                                   id="categoryName"
                                   name="categoryName"
                                   value="${category.categoryName}"
                                   maxlength="100"
                                   required
                                   placeholder="Nhập tên danh mục (VD: Văn học, Khoa học, ...)"
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-sm">
                            <p class="mt-1.5 text-xs text-gray-500">Tối đa 100 ký tự</p>
                        </div>

                        <!-- Mô tả -->
                        <div>
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                                Mô tả
                            </label>
                            <textarea id="description"
                                      name="description"
                                      rows="4"
                                      maxlength="500"
                                      placeholder="Nhập mô tả cho danh mục (không bắt buộc)"
                                      class="w-full px-4 py-2.5 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-sm resize-none">${category.description}</textarea>
                            <p class="mt-1.5 text-xs text-gray-500">Tối đa 500 ký tự</p>
                        </div>

                        <!-- Trạng thái -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-3">
                                Trạng thái <span class="text-red-500">*</span>
                            </label>
                            <div class="space-y-3">
                                <label class="flex items-start cursor-pointer group">
                                    <input type="radio"
                                           name="status"
                                           value="active"
                                           ${empty category || category.status == 'active' ? 'checked' : ''}
                                           required
                                           class="mt-0.5 w-4 h-4 text-blue-600 focus:ring-blue-500 border-gray-300">
                                    <div class="ml-3">
                                        <span class="text-sm font-medium text-gray-900 group-hover:text-blue-600">Hoạt động</span>
                                        <p class="text-xs text-gray-500">Danh mục sẽ hiển thị trên website</p>
                                    </div>
                                </label>
                                <label class="flex items-start cursor-pointer group">
                                    <input type="radio"
                                           name="status"
                                           value="inactive"
                                           ${category.status == 'inactive' ? 'checked' : ''}
                                           required
                                           class="mt-0.5 w-4 h-4 text-blue-600 focus:ring-blue-500 border-gray-300">
                                    <div class="ml-3">
                                        <span class="text-sm font-medium text-gray-900 group-hover:text-blue-600">Không hoạt động</span>
                                        <p class="text-xs text-gray-500">Danh mục sẽ bị ẩn khỏi website</p>
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="bg-gray-50 px-6 py-4 flex items-center justify-end space-x-3 border-t border-gray-200">
                        <a href="${pageContext.request.contextPath}/admin/categories"
                           class="px-4 py-2.5 bg-white text-gray-700 border border-gray-300 rounded-md hover:bg-gray-50 transition-colors text-sm font-medium">
                            Hủy
                        </a>
                        <button type="submit"
                                class="px-6 py-2.5 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors text-sm font-medium">
                            ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                        </button>
                    </div>
                </form>
            </div>

            <!-- Help Text -->
            <div class="mt-6 bg-blue-50 border border-blue-200 rounded-lg p-4">
                <div class="flex items-start space-x-3">
                    <svg class="w-5 h-5 text-blue-600 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <div class="text-sm text-blue-800">
                        <p class="font-medium mb-1">Lưu ý:</p>
                        <ul class="list-disc list-inside space-y-1 text-blue-700">
                            <li>Tên danh mục phải là duy nhất trong hệ thống</li>
                            <li>Không thể xóa danh mục nếu đang có sách sử dụng</li>
                            <li>Danh mục không hoạt động sẽ không hiển thị trên trang khách hàng</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    function validateForm() {
        const categoryName = document.getElementById('categoryName').value.trim();
        const description = document.getElementById('description').value.trim();

        if (categoryName.length === 0) {
            alert('Vui lòng nhập tên danh mục');
            document.getElementById('categoryName').focus();
            return false;
        }

        if (categoryName.length > 100) {
            alert('Tên danh mục không được vượt quá 100 ký tự');
            document.getElementById('categoryName').focus();
            return false;
        }

        if (description.length > 500) {
            alert('Mô tả không được vượt quá 500 ký tự');
            document.getElementById('description').focus();
            return false;
        }

        return true;
    }

    // Auto hide error messages after 5 seconds
    setTimeout(function() {
        const errorToast = document.querySelector('[class*="bg-red-50"]');
        if (errorToast && errorToast.querySelector('button')) {
            errorToast.remove();
        }
    }, 5000);
</script>

</body>
</html>
