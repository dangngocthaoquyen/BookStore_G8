<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="404 - Không tìm thấy trang" scope="request"/>
<jsp:include page="/views/common/header.jsp"/>

<!-- 404 Error Page -->
<div class="min-h-screen bg-gray-50 flex items-center justify-center px-4 py-12">
    <div class="max-w-2xl w-full">
        <!-- Error Card -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8 text-center">
            <!-- 404 SVG Icon -->
            <div class="flex justify-center mb-6">
                <svg class="w-32 h-32 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>

            <!-- Error Code -->
            <h1 class="text-6xl font-semibold text-gray-900 mb-4">404</h1>

            <!-- Heading -->
            <h2 class="text-2xl font-semibold text-gray-900 mb-3">
                Trang không tồn tại
            </h2>

            <!-- Message -->
            <p class="text-base text-gray-600 mb-8 leading-relaxed">
                Không tìm thấy trang bạn yêu cầu. Trang có thể đã bị xóa, di chuyển hoặc không tồn tại.
            </p>

            <!-- Search Box -->
            <div class="mb-8">
                <form action="${pageContext.request.contextPath}/books" method="get" class="max-w-md mx-auto">
                    <div class="flex gap-2">
                        <input
                            type="text"
                            name="keyword"
                            placeholder="Tìm kiếm sách theo tên, tác giả..."
                            class="flex-1 px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-transparent text-sm"
                        />
                        <button
                            type="submit"
                            class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors text-sm font-medium"
                        >
                            Tìm kiếm
                        </button>
                    </div>
                </form>
            </div>

            <!-- Navigation Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
                <!-- Home Button -->
                <a
                    href="${pageContext.request.contextPath}/"
                    class="w-full sm:w-auto bg-blue-600 text-white px-6 py-2.5 rounded-md hover:bg-blue-700 transition-colors text-sm font-medium inline-flex items-center justify-center gap-2"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                    </svg>
                    Về trang chủ
                </a>

                <!-- Books List Button -->
                <a
                    href="${pageContext.request.contextPath}/books"
                    class="w-full sm:w-auto bg-gray-100 text-gray-700 px-6 py-2.5 rounded-md hover:bg-gray-200 transition-colors text-sm font-medium inline-flex items-center justify-center gap-2"
                >
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M9 4.804A7.968 7.968 0 005.5 4c-1.255 0-2.443.29-3.5.804v10A7.969 7.969 0 015.5 14c1.669 0 3.218.51 4.5 1.385A7.962 7.962 0 0114.5 14c1.255 0 2.443.29 3.5.804v-10A7.968 7.968 0 0014.5 4c-1.255 0-2.443.29-3.5.804V12a1 1 0 11-2 0V4.804z"/>
                    </svg>
                    Danh sách sách
                </a>
            </div>

            <!-- Help Text -->
            <div class="mt-8 pt-6 border-t border-gray-200">
                <p class="text-sm text-gray-500">
                    Bạn có thể quay lại trang trước hoặc liên hệ với chúng tôi nếu cần hỗ trợ.
                </p>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
