<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Lỗi" scope="request"/>
<jsp:include page="/views/common/header.jsp"/>

<!-- Generic Error Page -->
<div class="min-h-screen bg-gray-50 flex items-center justify-center px-4 py-12">
    <div class="max-w-2xl w-full">
        <!-- Error Card -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8 text-center">
            <!-- Generic Error SVG Icon -->
            <div class="flex justify-center mb-6">
                <svg class="w-32 h-32 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>

            <!-- Heading -->
            <h2 class="text-2xl font-semibold text-gray-900 mb-3">
                <c:choose>
                    <c:when test="${not empty requestScope.errorTitle}">
                        ${requestScope.errorTitle}
                    </c:when>
                    <c:otherwise>
                        Đã xảy ra lỗi
                    </c:otherwise>
                </c:choose>
            </h2>

            <!-- Dynamic Error Message -->
            <div class="mb-8">
                <c:choose>
                    <c:when test="${not empty requestScope.errorMessage}">
                        <p class="text-base text-gray-600 leading-relaxed">
                            ${requestScope.errorMessage}
                        </p>
                    </c:when>
                    <c:when test="${not empty param.message}">
                        <p class="text-base text-gray-600 leading-relaxed">
                            ${param.message}
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-base text-gray-600 leading-relaxed">
                            Đã có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn. Vui lòng thử lại sau.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Error Details (if available) -->
            <c:if test="${not empty requestScope.errorDetails}">
                <div class="bg-red-50 border border-red-200 rounded-md p-4 mb-6">
                    <p class="text-sm text-red-800 leading-relaxed">
                        ${requestScope.errorDetails}
                    </p>
                </div>
            </c:if>

            <!-- Navigation Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
                <!-- Back Button -->
                <button
                    onclick="history.back()"
                    class="w-full sm:w-auto bg-gray-100 text-gray-700 px-6 py-2.5 rounded-md hover:bg-gray-200 transition-colors text-sm font-medium inline-flex items-center justify-center gap-2"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                    Quay lại
                </button>

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
            </div>

            <!-- Help Section -->
            <div class="mt-8 pt-6 border-t border-gray-200">
                <p class="text-sm text-gray-600 mb-3">
                    Bạn cần hỗ trợ? Liên hệ với chúng tôi qua:
                </p>
                <div class="flex flex-col sm:flex-row gap-4 justify-center items-center text-sm">
                    <a
                        href="mailto:support@bookverse.com"
                        class="inline-flex items-center gap-2 text-blue-600 hover:text-blue-700 font-medium"
                    >
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                        </svg>
                        Email hỗ trợ
                    </a>
                    <span class="text-gray-400 hidden sm:inline">|</span>
                    <span class="inline-flex items-center gap-2 text-gray-600">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                        </svg>
                        Hotline: 1900 xxxx
                    </span>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
