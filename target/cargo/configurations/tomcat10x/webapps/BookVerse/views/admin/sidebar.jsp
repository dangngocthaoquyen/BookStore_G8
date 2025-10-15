<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="currentUrl" value="${pageContext.request.requestURI}" />

<!-- Sidebar Navigation cho Admin -->
<aside class="w-64 bg-white border-r border-gray-200 h-screen fixed left-0 top-0 flex flex-col" id="admin-sidebar">
    <!-- Logo & Brand -->
    <div class="h-16 flex items-center px-6 border-b border-gray-200">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center space-x-2">
            <svg class="w-8 h-8 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9 4.804A7.968 7.968 0 005.5 4c-1.255 0-2.443.29-3.5.804v10A7.969 7.969 0 015.5 14c1.669 0 3.218.51 4.5 1.385A7.962 7.962 0 0114.5 14c1.255 0 2.443.29 3.5.804v-10A7.968 7.968 0 0014.5 4c-1.255 0-2.443.29-3.5.804V12a1 1 0 11-2 0V4.804z"/>
            </svg>
            <div>
                <div class="text-sm font-semibold text-gray-900">BookVerse</div>
                <div class="text-xs text-gray-500">Admin Panel</div>
            </div>
        </a>
    </div>

    <!-- Navigation Menu -->
    <nav class="flex-1 px-4 py-6 overflow-y-auto">
        <div class="space-y-1">
            <!-- Dashboard -->
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="flex items-center space-x-3 px-3 py-2.5 rounded-md transition-colors ${currentUrl.contains('/admin/dashboard') ? 'bg-blue-50 text-blue-600' : 'text-gray-700 hover:bg-gray-50'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                </svg>
                <span class="text-sm font-medium">Dashboard</span>
            </a>

            <!-- Quản lý sách -->
            <a href="${pageContext.request.contextPath}/admin/books"
               class="flex items-center space-x-3 px-3 py-2.5 rounded-md transition-colors ${currentUrl.contains('/admin/books') ? 'bg-blue-50 text-blue-600' : 'text-gray-700 hover:bg-gray-50'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                </svg>
                <span class="text-sm font-medium">Quản lý sách</span>
            </a>

            <!-- Quản lý danh mục -->
            <a href="${pageContext.request.contextPath}/admin/categories"
               class="flex items-center space-x-3 px-3 py-2.5 rounded-md transition-colors ${currentUrl.contains('/admin/categories') ? 'bg-blue-50 text-blue-600' : 'text-gray-700 hover:bg-gray-50'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"/>
                </svg>
                <span class="text-sm font-medium">Quản lý danh mục</span>
            </a>

            <!-- Quản lý đơn hàng -->
            <a href="${pageContext.request.contextPath}/admin/orders"
               class="flex items-center space-x-3 px-3 py-2.5 rounded-md transition-colors ${currentUrl.contains('/admin/orders') ? 'bg-blue-50 text-blue-600' : 'text-gray-700 hover:bg-gray-50'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
                <span class="text-sm font-medium">Quản lý đơn hàng</span>
            </a>

            <!-- Quản lý người dùng -->
            <a href="${pageContext.request.contextPath}/admin/users"
               class="flex items-center space-x-3 px-3 py-2.5 rounded-md transition-colors ${currentUrl.contains('/admin/users') ? 'bg-blue-50 text-blue-600' : 'text-gray-700 hover:bg-gray-50'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                </svg>
                <span class="text-sm font-medium">Quản lý người dùng</span>
            </a>
        </div>

        <!-- Divider -->
        <div class="my-6 border-t border-gray-200"></div>

        <!-- Additional Links -->
        <div class="space-y-1">
            <a href="${pageContext.request.contextPath}/"
               class="flex items-center space-x-3 px-3 py-2.5 rounded-md text-gray-700 hover:bg-gray-50 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"/>
                </svg>
                <span class="text-sm font-medium">Xem trang web</span>
            </a>
        </div>
    </nav>

    <!-- User Info & Logout -->
    <div class="border-t border-gray-200 p-4">
        <div class="flex items-center space-x-3 mb-3">
            <div class="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
                <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                </svg>
            </div>
            <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-gray-900 truncate">${sessionScope.user.fullName}</p>
                <p class="text-xs text-gray-500 truncate">
                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'admin'}">Quản trị viên</c:when>
                        <c:otherwise>Người dùng</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout"
           class="w-full flex items-center justify-center space-x-2 px-4 py-2 bg-red-50 text-red-600 rounded-md hover:bg-red-100 transition-colors">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
            <span class="text-sm font-medium">Đăng xuất</span>
        </a>
    </div>
</aside>

<!-- Mobile Sidebar Toggle Button -->
<button id="mobile-sidebar-toggle" class="lg:hidden fixed top-4 left-4 z-50 p-2 bg-white rounded-md shadow-md border border-gray-200">
    <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
    </svg>
</button>

<!-- Mobile Sidebar Overlay -->
<div id="sidebar-overlay" class="lg:hidden fixed inset-0 bg-black bg-opacity-50 z-40 hidden"></div>

<style>
    /* Responsive sidebar */
    @media (max-width: 1023px) {
        #admin-sidebar {
            transform: translateX(-100%);
            transition: transform 0.3s ease-in-out;
            z-index: 50;
        }

        #admin-sidebar.open {
            transform: translateX(0);
        }
    }

    @media (min-width: 1024px) {
        #mobile-sidebar-toggle {
            display: none;
        }
    }
</style>

<script>
    // Mobile sidebar toggle
    document.addEventListener('DOMContentLoaded', function() {
        const sidebar = document.getElementById('admin-sidebar');
        const toggleBtn = document.getElementById('mobile-sidebar-toggle');
        const overlay = document.getElementById('sidebar-overlay');

        if (toggleBtn) {
            toggleBtn.addEventListener('click', function() {
                sidebar.classList.toggle('open');
                overlay.classList.toggle('hidden');
            });
        }

        if (overlay) {
            overlay.addEventListener('click', function() {
                sidebar.classList.remove('open');
                overlay.classList.add('hidden');
            });
        }
    });
</script>
