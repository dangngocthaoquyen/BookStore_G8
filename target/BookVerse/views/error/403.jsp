<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="403 - Truy cập bị từ chối" scope="request"/>
<jsp:include page="/views/common/header.jsp"/>

<!-- 403 Forbidden Page -->
<div class="min-h-screen bg-gray-50 flex items-center justify-center px-4 py-12">
    <div class="max-w-2xl w-full">
        <!-- Error Card -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8 text-center">
            <!-- 403 SVG Icon (Lock/Shield) -->
            <div class="flex justify-center mb-6">
                <svg class="w-32 h-32 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                </svg>
            </div>

            <!-- Error Code -->
            <h1 class="text-6xl font-semibold text-gray-900 mb-4">403</h1>

            <!-- Heading -->
            <h2 class="text-2xl font-semibold text-gray-900 mb-3">
                Truy cập bị từ chối
            </h2>

            <!-- Message -->
            <p class="text-base text-gray-600 mb-8 leading-relaxed">
                Bạn không có quyền truy cập trang này. Vui lòng kiểm tra lại quyền truy cập hoặc đăng nhập với tài khoản có quyền phù hợp.
            </p>

            <!-- Reason Box (if provided) -->
            <c:if test="${not empty requestScope.forbiddenReason}">
                <div class="bg-red-50 border border-red-200 rounded-md p-4 mb-6">
                    <div class="flex items-start gap-3">
                        <svg class="w-5 h-5 text-red-600 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                        </svg>
                        <p class="text-sm text-red-800 leading-relaxed text-left">
                            ${requestScope.forbiddenReason}
                        </p>
                    </div>
                </div>
            </c:if>

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

                <!-- Login Button (if not logged in) -->
                <c:if test="${sessionScope.user == null}">
                    <a
                        href="${pageContext.request.contextPath}/login"
                        class="w-full sm:w-auto bg-gray-100 text-gray-700 px-6 py-2.5 rounded-md hover:bg-gray-200 transition-colors text-sm font-medium inline-flex items-center justify-center gap-2"
                    >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"/>
                        </svg>
                        Đăng nhập
                    </a>
                </c:if>

                <!-- Back Button (if logged in) -->
                <c:if test="${sessionScope.user != null}">
                    <button
                        onclick="history.back()"
                        class="w-full sm:w-auto bg-gray-100 text-gray-700 px-6 py-2.5 rounded-md hover:bg-gray-200 transition-colors text-sm font-medium inline-flex items-center justify-center gap-2"
                    >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                        </svg>
                        Quay lại
                    </button>
                </c:if>
            </div>

            <!-- Additional Information -->
            <div class="mt-8 pt-6 border-t border-gray-200">
                <p class="text-sm text-gray-600 mb-4">
                    Lý do có thể gây ra lỗi này:
                </p>
                <ul class="text-sm text-gray-600 text-left max-w-md mx-auto space-y-2">
                    <li class="flex items-start gap-2">
                        <svg class="w-4 h-4 text-gray-400 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                        </svg>
                        <span>Bạn chưa đăng nhập vào hệ thống</span>
                    </li>
                    <li class="flex items-start gap-2">
                        <svg class="w-4 h-4 text-gray-400 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                        </svg>
                        <span>Tài khoản của bạn không có quyền truy cập</span>
                    </li>
                    <li class="flex items-start gap-2">
                        <svg class="w-4 h-4 text-gray-400 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                        </svg>
                        <span>Trang yêu cầu quyền quản trị viên</span>
                    </li>
                </ul>
            </div>

            <!-- Contact Support -->
            <div class="mt-6">
                <p class="text-sm text-gray-500">
                    Nếu bạn cho rằng đây là lỗi, vui lòng
                    <a href="mailto:support@bookverse.com" class="text-blue-600 hover:text-blue-700 font-medium">liên hệ hỗ trợ</a>
                </p>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
