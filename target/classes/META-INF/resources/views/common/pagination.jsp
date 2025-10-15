<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
    Pagination Component
    Parameters:
    - currentPage: số trang hiện tại
    - totalPages: tổng số trang
    - baseUrl: URL cơ sở (ví dụ: /books)
--%>

<c:if test="${totalPages > 1}">
    <div class="flex items-center justify-center space-x-2 mt-8">
        <!-- Previous Button -->
        <c:if test="${currentPage > 1}">
            <a href="${baseUrl}?page=${currentPage - 1}"
               class="px-3 py-2 rounded-md text-sm text-gray-600 hover:bg-gray-100 transition-colors border border-gray-300">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                </svg>
            </a>
        </c:if>
        <c:if test="${currentPage <= 1}">
            <span class="px-3 py-2 rounded-md text-sm text-gray-400 border border-gray-200 cursor-not-allowed">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                </svg>
            </span>
        </c:if>

        <!-- Page Numbers -->
        <c:forEach var="i" begin="1" end="${totalPages}">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span class="px-4 py-2 rounded-md text-sm font-medium bg-blue-600 text-white">
                        ${i}
                    </span>
                </c:when>
                <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                    <a href="${baseUrl}?page=${i}"
                       class="px-4 py-2 rounded-md text-sm text-gray-600 hover:bg-gray-100 transition-colors border border-gray-300">
                        ${i}
                    </a>
                </c:when>
                <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                    <span class="px-2 text-gray-400">...</span>
                </c:when>
            </c:choose>
        </c:forEach>

        <!-- Next Button -->
        <c:if test="${currentPage < totalPages}">
            <a href="${baseUrl}?page=${currentPage + 1}"
               class="px-3 py-2 rounded-md text-sm text-gray-600 hover:bg-gray-100 transition-colors border border-gray-300">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                </svg>
            </a>
        </c:if>
        <c:if test="${currentPage >= totalPages}">
            <span class="px-3 py-2 rounded-md text-sm text-gray-400 border border-gray-200 cursor-not-allowed">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                </svg>
            </span>
        </c:if>
    </div>

    <!-- Page Info -->
    <div class="text-center mt-4 text-sm text-gray-500">
        Trang ${currentPage} / ${totalPages}
    </div>
</c:if>
