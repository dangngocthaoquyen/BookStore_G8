<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Đăng nhập" scope="request" />
<%@ include file="/views/common/header.jsp" %>

<!-- Main Content -->
<main class="min-h-screen flex items-center justify-center py-12 px-4">
    <div class="max-w-md w-full">
        <!-- Login Card -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8">
            <!-- Title -->
            <div class="text-center mb-8">
                <h2 class="text-2xl font-semibold text-gray-900 mb-2">Đăng nhập</h2>
                <p class="text-sm text-gray-600">Chào mừng bạn quay trở lại với BookVerse</p>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-md">
                    <p class="text-sm text-red-600">${error}</p>
                </div>
            </c:if>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                <!-- Email Field -->
                <div class="mb-4">
                    <label for="email" class="block text-sm font-medium text-gray-900 mb-2">
                        Email
                    </label>
                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Nhập địa chỉ email của bạn"
                        class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-transparent transition-colors"
                        value="${param.email}"
                        required
                    >
                    <p id="emailError" class="text-red-600 text-sm mt-1 hidden"></p>
                </div>

                <!-- Password Field -->
                <div class="mb-6">
                    <label for="password" class="block text-sm font-medium text-gray-900 mb-2">
                        Mật khẩu
                    </label>
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Nhập mật khẩu của bạn"
                        class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-transparent transition-colors"
                        required
                    >
                    <p id="passwordError" class="text-red-600 text-sm mt-1 hidden"></p>
                </div>

                <!-- Remember Me & Forgot Password -->
                <div class="flex items-center justify-between mb-6">
                    <label class="flex items-center">
                        <input
                            type="checkbox"
                            name="remember"
                            class="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-600"
                        >
                        <span class="ml-2 text-sm text-gray-600">Ghi nhớ đăng nhập</span>
                    </label>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="text-sm text-blue-600 hover:text-blue-700 transition-colors">
                        Quên mật khẩu?
                    </a>
                </div>

                <!-- Submit Button -->
                <button
                    type="submit"
                    class="w-full bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors font-medium"
                >
                    Đăng nhập
                </button>
            </form>

            <!-- Register Link -->
            <div class="mt-6 text-center">
                <p class="text-sm text-gray-600">
                    Chưa có tài khoản?
                    <a href="${pageContext.request.contextPath}/register" class="text-blue-600 hover:text-blue-700 font-medium transition-colors">
                        Đăng ký ngay
                    </a>
                </p>
            </div>
        </div>
    </div>
</main>

<!-- Client-side Validation Script -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');

    // Email validation
    function validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    // Show error message
    function showError(element, message) {
        element.textContent = message;
        element.classList.remove('hidden');
        element.previousElementSibling.classList.add('border-red-600');
    }

    // Hide error message
    function hideError(element) {
        element.textContent = '';
        element.classList.add('hidden');
        element.previousElementSibling.classList.remove('border-red-600');
    }

    // Validate email field
    emailInput.addEventListener('blur', function() {
        const email = emailInput.value.trim();

        if (email === '') {
            showError(emailError, 'Vui lòng nhập địa chỉ email');
        } else if (!validateEmail(email)) {
            showError(emailError, 'Địa chỉ email không hợp lệ');
        } else {
            hideError(emailError);
        }
    });

    // Validate password field
    passwordInput.addEventListener('blur', function() {
        const password = passwordInput.value;

        if (password === '') {
            showError(passwordError, 'Vui lòng nhập mật khẩu');
        } else if (password.length < 6) {
            showError(passwordError, 'Mật khẩu phải có ít nhất 6 ký tự');
        } else {
            hideError(passwordError);
        }
    });

    // Form submission validation
    loginForm.addEventListener('submit', function(e) {
        let isValid = true;

        // Validate email
        const email = emailInput.value.trim();
        if (email === '') {
            showError(emailError, 'Vui lòng nhập địa chỉ email');
            isValid = false;
        } else if (!validateEmail(email)) {
            showError(emailError, 'Địa chỉ email không hợp lệ');
            isValid = false;
        } else {
            hideError(emailError);
        }

        // Validate password
        const password = passwordInput.value;
        if (password === '') {
            showError(passwordError, 'Vui lòng nhập mật khẩu');
            isValid = false;
        } else if (password.length < 6) {
            showError(passwordError, 'Mật khẩu phải có ít nhất 6 ký tự');
            isValid = false;
        } else {
            hideError(passwordError);
        }

        if (!isValid) {
            e.preventDefault();
        }
    });

    // Clear errors on input
    emailInput.addEventListener('input', function() {
        if (emailInput.value.trim() !== '') {
            hideError(emailError);
        }
    });

    passwordInput.addEventListener('input', function() {
        if (passwordInput.value !== '') {
            hideError(passwordError);
        }
    });
});
</script>

<%@ include file="/views/common/footer.jsp" %>
