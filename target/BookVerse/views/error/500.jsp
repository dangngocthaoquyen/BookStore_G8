<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="500 - Lỗi hệ thống" scope="request"/>
<jsp:include page="/views/common/header.jsp"/>

<!-- 500 Error Page -->
<div class="min-h-screen bg-gray-50 flex items-center justify-center px-4 py-12">
    <div class="max-w-2xl w-full">
        <!-- Error Card -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8 text-center">
            <!-- 500 SVG Icon -->
            <div class="flex justify-center mb-6">
                <svg class="w-32 h-32 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                </svg>
            </div>

            <!-- Error Code -->
            <h1 class="text-6xl font-semibold text-gray-900 mb-4">500</h1>

            <!-- Heading -->
            <h2 class="text-2xl font-semibold text-gray-900 mb-3">
                Lỗi hệ thống
            </h2>

            <!-- Message -->
            <p class="text-base text-gray-600 mb-6 leading-relaxed">
                Đã có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn. Vui lòng thử lại sau vài phút.
            </p>

            <!-- Error Code Display (Optional) -->
            <c:if test="${not empty requestScope.errorCode}">
                <div class="bg-gray-50 rounded-md p-4 mb-6">
                    <p class="text-sm text-gray-500 mb-1">Mã lỗi:</p>
                    <p class="text-sm font-medium text-gray-900 font-mono">${requestScope.errorCode}</p>
                </div>
            </c:if>

            <!-- Navigation Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center items-center mb-6">
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

                <!-- Retry Button -->
                <button
                    onclick="location.reload()"
                    class="w-full sm:w-auto bg-gray-100 text-gray-700 px-6 py-2.5 rounded-md hover:bg-gray-200 transition-colors text-sm font-medium inline-flex items-center justify-center gap-2"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                    </svg>
                    Thử lại
                </button>
            </div>

            <!-- Support Link -->
            <div class="pt-6 border-t border-gray-200">
                <p class="text-sm text-gray-600 mb-3">
                    Nếu lỗi vẫn tiếp tục, vui lòng liên hệ với chúng tôi để được hỗ trợ.
                </p>
                <a
                    href="mailto:support@bookverse.com"
                    class="inline-flex items-center gap-2 text-sm text-blue-600 hover:text-blue-700 font-medium"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                    </svg>
                    Liên hệ hỗ trợ
                </a>
            </div>
        </div>

        <!-- Additional Info -->
        <div class="mt-6 text-center">
            <p class="text-sm text-gray-500">
                Hotline hỗ trợ: <span class="font-medium text-gray-700">1900 xxxx</span>
            </p>
        </div>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
