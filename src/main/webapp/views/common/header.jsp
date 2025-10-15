<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'BookVerse'} - Hệ thống quản lý bán sách</title>

    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <!-- Toast JS - deferred to load after DOM -->
    <script defer src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</head>
<body class="bg-gray-50">

<!-- Header Navigation -->
<header class="bg-white shadow-sm border-b border-gray-200">
    <div class="max-w-7xl mx-auto px-4">
        <div class="flex items-center justify-between h-16">
            <!-- Logo -->
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/home" class="flex items-center space-x-2">
                    <svg class="w-8 h-8 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M9 4.804A7.968 7.968 0 005.5 4c-1.255 0-2.443.29-3.5.804v10A7.969 7.969 0 015.5 14c1.669 0 3.218.51 4.5 1.385A7.962 7.962 0 0114.5 14c1.255 0 2.443.29 3.5.804v-10A7.968 7.968 0 0014.5 4c-1.255 0-2.443.29-3.5.804V12a1 1 0 11-2 0V4.804z"/>
                    </svg>
                    <span class="text-xl font-semibold text-gray-900">BookVerse</span>
                </a>
            </div>

            <!-- Navigation -->
            <nav class="hidden md:flex items-center space-x-6">
                <c:if test="${sessionScope.user == null}">
                    <!-- Guest Menu -->
                    <a href="${pageContext.request.contextPath}/home" class="text-sm text-gray-600 hover:text-blue-600 transition-colors">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/books" class="text-sm text-gray-600 hover:text-blue-600 transition-colors">Sách</a>
                    <a href="${pageContext.request.contextPath}/about" class="text-sm text-gray-600 hover:text-blue-600 transition-colors">Giới thiệu</a>
                    <a href="${pageContext.request.contextPath}/contact" class="text-sm text-gray-600 hover:text-blue-600 transition-colors">Liên hệ</a>
                    <a href="${pageContext.request.contextPath}/login" class="text-sm text-gray-600 hover:text-blue-600 transition-colors">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="bg-blue-600 text-white px-4 py-2 rounded-md text-sm hover:bg-blue-700 transition-colors">Đăng ký</a>
                </c:if>

                <c:if test="${sessionScope.user != null}">
                    <!-- User Menu -->
                    <a href="${pageContext.request.contextPath}/home" class="text-sm text-gray-600 hover:text-blue-600 transition-colors">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/books" class="text-sm text-gray-600 hover:text-blue-600 transition-colors">Sách</a>
                    <a href="${pageContext.request.contextPath}/about" class="text-sm text-gray-600 hover:text-blue-600 transition-colors">Giới thiệu</a>
                    <a href="${pageContext.request.contextPath}/contact" class="text-sm text-gray-600 hover:text-blue-600 transition-colors">Liên hệ</a>

                    <c:if test="${sessionScope.user.role == 'admin'}">
                        <!-- Admin Menu -->
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-sm text-gray-600 hover:text-blue-600 transition-colors">Quản trị</a>
                    </c:if>

                    <!-- Cart -->
                    <a href="${pageContext.request.contextPath}/cart" class="relative text-gray-600 hover:text-blue-600 transition-colors">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        <c:if test="${sessionScope.cartCount != null && sessionScope.cartCount > 0}">
                            <span class="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">${sessionScope.cartCount}</span>
                        </c:if>
                    </a>

                    <!-- User Dropdown -->
                    <div class="relative" x-data="{ open: false }">
                        <button @click="open = !open" class="flex items-center space-x-2 text-sm text-gray-700 hover:text-blue-600 transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                            </svg>
                            <span>${sessionScope.user.fullName}</span>
                        </button>

                        <!-- Dropdown Menu -->
                        <div x-show="open" @click.away="open = false" class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50">
                            <a href="${pageContext.request.contextPath}/profile" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">Thông tin cá nhân</a>
                            <a href="${pageContext.request.contextPath}/orders" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">Đơn hàng của tôi</a>
                            <hr class="my-2">
                            <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-50">Đăng xuất</a>
                        </div>
                    </div>
                </c:if>
            </nav>

            <!-- Mobile Menu Button -->
            <button class="md:hidden p-2" onclick="toggleMobileMenu()">
                <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                </svg>
            </button>
        </div>
    </div>
</header>

<!-- Alpine.js for dropdown -->
<script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>

<script>
function toggleMobileMenu() {
    // TODO: Implement mobile menu toggle
    Toast.info('Mobile menu - coming soon');
}
</script>
