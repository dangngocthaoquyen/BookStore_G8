<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Thêm sách mới'} - BookVerse Admin</title>

    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Toast JS -->
    <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</head>
<body class="bg-gray-50">

<!-- Include Sidebar -->
<jsp:include page="sidebar.jsp" />

<!-- Main Content -->
<main class="lg:ml-64 min-h-screen">
    <!-- Header -->
    <div class="bg-white border-b border-gray-200">
        <div class="px-6 py-4">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-semibold text-gray-900">${pageTitle != null ? pageTitle : 'Thêm sách mới'}</h1>
                    <p class="text-sm text-gray-600 mt-1">Điền thông tin chi tiết của sách</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/books"
                   class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 transition-colors">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                    Quay lại
                </a>
            </div>
        </div>
    </div>

    <!-- Content -->
    <div class="p-6">
        <div class="max-w-4xl mx-auto">
            <!-- Error Messages -->
            <c:if test="${not empty errors}">
                <div class="mb-6 bg-red-50 border border-red-200 rounded-lg p-4">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <svg class="h-5 w-5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                            </svg>
                        </div>
                        <div class="ml-3">
                            <h3 class="text-sm font-medium text-red-800">Có lỗi xảy ra:</h3>
                            <div class="mt-2 text-sm text-red-700">
                                <ul class="list-disc pl-5 space-y-1">
                                    <c:forEach var="error" items="${errors}">
                                        <li>${error}</li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Form -->
            <form method="post" action="${pageContext.request.contextPath}/admin/book-form" enctype="multipart/form-data" class="space-y-6">
                <!-- Hidden ID field for edit mode -->
                <c:if test="${not empty book}">
                    <input type="hidden" name="id" value="${book.bookId}">
                </c:if>

                <!-- Card 1: Thông tin cơ bản -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Thông tin cơ bản</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Tên sách -->
                        <div class="md:col-span-2">
                            <label for="title" class="block text-sm font-medium text-gray-700 mb-2">
                                Tên sách <span class="text-red-500">*</span>
                            </label>
                            <input type="text" name="title" id="title"
                                   value="${not empty book ? book.title : (not empty formData ? formData['title'][0] : '')}"
                                   required
                                   class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                                   placeholder="Nhập tên sách...">
                        </div>

                        <!-- Tác giả -->
                        <div>
                            <label for="author" class="block text-sm font-medium text-gray-700 mb-2">
                                Tác giả <span class="text-red-500">*</span>
                            </label>
                            <input type="text" name="author" id="author"
                                   value="${not empty book ? book.author : (not empty formData ? formData['author'][0] : '')}"
                                   required
                                   class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                                   placeholder="Nhập tên tác giả...">
                        </div>

                        <!-- Danh mục -->
                        <div>
                            <label for="categoryId" class="block text-sm font-medium text-gray-700 mb-2">
                                Danh mục <span class="text-red-500">*</span>
                            </label>
                            <select name="categoryId" id="categoryId" required
                                    class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryId}"
                                            ${(not empty book && book.categoryId == category.categoryId) || (not empty formData && formData['categoryId'][0] == category.categoryId) ? 'selected' : ''}>
                                        ${category.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Giá -->
                        <div>
                            <label for="price" class="block text-sm font-medium text-gray-700 mb-2">
                                Giá bán (VNĐ) <span class="text-red-500">*</span>
                            </label>
                            <input type="number" name="price" id="price"
                                   value="${not empty book ? book.price : (not empty formData ? formData['price'][0] : '')}"
                                   required min="0" step="1000"
                                   class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                                   placeholder="Nhập giá bán...">
                        </div>

                        <!-- Số lượng tồn kho -->
                        <div>
                            <label for="stockQuantity" class="block text-sm font-medium text-gray-700 mb-2">
                                Số lượng tồn kho <span class="text-red-500">*</span>
                            </label>
                            <input type="number" name="stockQuantity" id="stockQuantity"
                                   value="${not empty book ? book.stockQuantity : (not empty formData ? formData['stockQuantity'][0] : '')}"
                                   required min="0"
                                   class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                                   placeholder="Nhập số lượng...">
                        </div>

                        <!-- Trạng thái -->
                        <div>
                            <label for="status" class="block text-sm font-medium text-gray-700 mb-2">
                                Trạng thái
                            </label>
                            <select name="status" id="status"
                                    class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                                <option value="available"
                                        ${(not empty book && book.status == 'available') || (not empty formData && formData['status'][0] == 'available') || empty book ? 'selected' : ''}>
                                    Có sẵn
                                </option>
                                <option value="out_of_stock"
                                        ${(not empty book && book.status == 'out_of_stock') || (not empty formData && formData['status'][0] == 'out_of_stock') ? 'selected' : ''}>
                                    Hết hàng
                                </option>
                                <option value="discontinued"
                                        ${(not empty book && book.status == 'discontinued') || (not empty formData && formData['status'][0] == 'discontinued') ? 'selected' : ''}>
                                    Ngừng bán
                                </option>
                            </select>
                        </div>

                        <!-- Mô tả -->
                        <div class="md:col-span-2">
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                                Mô tả
                            </label>
                            <textarea name="description" id="description" rows="4"
                                      class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                                      placeholder="Nhập mô tả sách...">${not empty book ? book.description : (not empty formData ? formData['description'][0] : '')}</textarea>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Thông tin chi tiết -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Thông tin chi tiết</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- ISBN -->
                        <div>
                            <label for="isbn" class="block text-sm font-medium text-gray-700 mb-2">
                                ISBN <span class="text-red-500">*</span>
                            </label>
                            <input type="text" name="isbn" id="isbn"
                                   value="${not empty book ? book.isbn : (not empty formData ? formData['isbn'][0] : '')}"
                                   required
                                   class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                                   placeholder="Nhập mã ISBN...">
                        </div>

                        <!-- Nhà xuất bản -->
                        <div>
                            <label for="publisher" class="block text-sm font-medium text-gray-700 mb-2">
                                Nhà xuất bản
                            </label>
                            <input type="text" name="publisher" id="publisher"
                                   value="${not empty book ? book.publisher : (not empty formData ? formData['publisher'][0] : '')}"
                                   class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                                   placeholder="Nhập nhà xuất bản...">
                        </div>

                        <!-- Năm xuất bản -->
                        <div>
                            <label for="publishYear" class="block text-sm font-medium text-gray-700 mb-2">
                                Năm xuất bản
                            </label>
                            <input type="number" name="publishYear" id="publishYear"
                                   value="${not empty book ? book.publishYear : (not empty formData ? formData['publishYear'][0] : '')}"
                                   min="1000" max="9999"
                                   class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                                   placeholder="Nhập năm xuất bản...">
                        </div>

                        <!-- Upload ảnh bìa -->
                        <div class="md:col-span-2">
                            <label for="imageFile" class="block text-sm font-medium text-gray-700 mb-2">
                                Ảnh bìa sách
                            </label>
                            <div class="flex items-center space-x-4">
                                <label for="imageFile" class="cursor-pointer inline-flex items-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 transition-colors">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                    </svg>
                                    Chọn ảnh
                                </label>
                                <input type="file" name="imageFile" id="imageFile" accept="image/*" class="hidden" onchange="previewImage(this)">
                                <span id="fileName" class="text-sm text-gray-500">Chưa chọn file</span>
                            </div>
                            <p class="mt-1 text-xs text-gray-500">Định dạng: JPG, PNG, GIF, WebP. Dung lượng tối đa: 10MB</p>
                        </div>

                        <!-- Preview ảnh -->
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                Xem trước ảnh bìa
                            </label>
                            <div id="imagePreview" class="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center">
                                <c:choose>
                                    <c:when test="${not empty book && not empty book.imageUrl}">
                                        <img src="${book.imageUrl}" alt="Preview" class="mx-auto h-48 rounded-md object-cover">
                                        <p class="text-xs text-gray-500 mt-2">Ảnh hiện tại</p>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="h-48 flex items-center justify-center">
                                            <svg class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                            </svg>
                                        </div>
                                        <p class="text-sm text-gray-500 mt-2">Chọn ảnh để xem trước</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="flex items-center justify-end space-x-4 pt-4">
                    <a href="${pageContext.request.contextPath}/admin/books"
                       class="px-6 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors">
                        Hủy
                    </a>
                    <button type="submit"
                            class="px-6 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors">
                        <c:choose>
                            <c:when test="${not empty book}">
                                Cập nhật sách
                            </c:when>
                            <c:otherwise>
                                Thêm sách
                            </c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<!-- Toast Container -->
<div id="toast-container" class="fixed top-4 right-4 z-50"></div>

<script>
// Image upload preview
function previewImage(input) {
    const fileName = document.getElementById('fileName');
    const imagePreview = document.getElementById('imagePreview');

    if (input.files && input.files[0]) {
        const file = input.files[0];
        fileName.textContent = file.name;

        // Validate file size (10MB)
        if (file.size > 10 * 1024 * 1024) {
            alert('Kích thước file không được vượt quá 10MB');
            input.value = '';
            fileName.textContent = 'Chưa chọn file';
            return;
        }

        // Validate file type
        const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
        if (!allowedTypes.includes(file.type)) {
            alert('Chỉ chấp nhận file ảnh định dạng: JPG, PNG, GIF, WebP');
            input.value = '';
            fileName.textContent = 'Chưa chọn file';
            return;
        }

        // Preview image
        const reader = new FileReader();
        reader.onload = function(e) {
            imagePreview.innerHTML = '<img src="' + e.target.result + '" alt="Preview" class="mx-auto h-48 rounded-md object-cover"><p class="text-xs text-gray-500 mt-2">Ảnh mới đã chọn</p>';
        };
        reader.readAsDataURL(file);
    } else {
        fileName.textContent = 'Chưa chọn file';
    }
}

// Form validation
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');

    if (form) {
        form.addEventListener('submit', function(e) {
            const price = document.getElementById('price').value;
            const stockQuantity = document.getElementById('stockQuantity').value;

            if (parseFloat(price) <= 0) {
                e.preventDefault();
                showToast('Giá sách phải lớn hơn 0', 'error');
                return;
            }

            if (parseInt(stockQuantity) < 0) {
                e.preventDefault();
                showToast('Số lượng tồn kho không được âm', 'error');
                return;
            }
        });
    }
});
</script>

</body>
</html>
