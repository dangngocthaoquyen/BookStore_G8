<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Đăng ký tài khoản" scope="request" />
<%@ include file="/views/common/header.jsp" %>

<!-- Main Content -->
<main class="min-h-screen flex items-center justify-center py-12 px-4">
    <div class="max-w-md w-full">
        <!-- Register Card -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8">
            <!-- Title -->
            <div class="text-center mb-8">
                <h2 class="text-2xl font-semibold text-gray-900 mb-2">Đăng ký tài khoản</h2>
                <p class="text-sm text-gray-600">Tạo tài khoản mới để trải nghiệm BookVerse</p>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-md">
                    <p class="text-sm text-red-600">${error}</p>
                </div>
            </c:if>

            <!-- Success Message -->
            <c:if test="${not empty success}">
                <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-md">
                    <p class="text-sm text-green-600">${success}</p>
                </div>
            </c:if>

            <!-- Register Form -->
            <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                <!-- Full Name Field -->
                <div class="mb-4">
                    <label for="fullName" class="block text-sm font-medium text-gray-900 mb-2">
                        Họ và tên
                    </label>
                    <input
                        type="text"
                        id="fullName"
                        name="fullName"
                        placeholder="Nhập họ và tên đầy đủ"
                        class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-transparent transition-colors"
                        value="${param.fullName}"
                        required
                    >
                    <p id="fullNameError" class="text-red-600 text-sm mt-1 hidden"></p>
                </div>

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

                <!-- Phone Field -->
                <div class="mb-4">
                    <label for="phone" class="block text-sm font-medium text-gray-900 mb-2">
                        Số điện thoại
                    </label>
                    <input
                        type="tel"
                        id="phone"
                        name="phone"
                        placeholder="Nhập số điện thoại (10 số)"
                        class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-transparent transition-colors"
                        value="${param.phone}"
                        required
                    >
                    <p id="phoneError" class="text-red-600 text-sm mt-1 hidden"></p>
                </div>

                <!-- Password Field -->
                <div class="mb-4">
                    <label for="password" class="block text-sm font-medium text-gray-900 mb-2">
                        Mật khẩu
                    </label>
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Nhập mật khẩu (ít nhất 6 ký tự)"
                        class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-transparent transition-colors"
                        required
                    >
                    <p id="passwordError" class="text-red-600 text-sm mt-1 hidden"></p>
                </div>

                <!-- Confirm Password Field -->
                <div class="mb-6">
                    <label for="confirmPassword" class="block text-sm font-medium text-gray-900 mb-2">
                        Xác nhận mật khẩu
                    </label>
                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        placeholder="Nhập lại mật khẩu"
                        class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-transparent transition-colors"
                        required
                    >
                    <p id="confirmPasswordError" class="text-red-600 text-sm mt-1 hidden"></p>
                </div>

                <!-- Terms and Conditions -->
                <div class="mb-6">
                    <label class="flex items-start">
                        <input
                            type="checkbox"
                            id="terms"
                            name="terms"
                            class="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-600 mt-1"
                            required
                        >
                        <span class="ml-2 text-sm text-gray-600">
                            Tôi đồng ý với
                            <a href="#" class="text-blue-600 hover:text-blue-700 transition-colors">Điều khoản sử dụng</a>
                            và
                            <a href="#" class="text-blue-600 hover:text-blue-700 transition-colors">Chính sách bảo mật</a>
                        </span>
                    </label>
                    <p id="termsError" class="text-red-600 text-sm mt-1 hidden"></p>
                </div>

                <!-- Submit Button -->
                <button
                    type="submit"
                    class="w-full bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors font-medium"
                >
                    Đăng ký
                </button>
            </form>

            <!-- Login Link -->
            <div class="mt-6 text-center">
                <p class="text-sm text-gray-600">
                    Đã có tài khoản?
                    <a href="${pageContext.request.contextPath}/login" class="text-blue-600 hover:text-blue-700 font-medium transition-colors">
                        Đăng nhập ngay
                    </a>
                </p>
            </div>
        </div>
    </div>
</main>

<!-- Client-side Validation Script -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const registerForm = document.getElementById('registerForm');
    const fullNameInput = document.getElementById('fullName');
    const emailInput = document.getElementById('email');
    const phoneInput = document.getElementById('phone');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const termsCheckbox = document.getElementById('terms');

    const fullNameError = document.getElementById('fullNameError');
    const emailError = document.getElementById('emailError');
    const phoneError = document.getElementById('phoneError');
    const passwordError = document.getElementById('passwordError');
    const confirmPasswordError = document.getElementById('confirmPasswordError');
    const termsError = document.getElementById('termsError');

    // Validation functions
    function validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    function validatePhone(phone) {
        const phoneRegex = /^(0[3|5|7|8|9])+([0-9]{8})$/;
        return phoneRegex.test(phone);
    }

    function validateFullName(name) {
        return name.trim().length >= 3;
    }

    function validatePassword(password) {
        return password.length >= 6;
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

    // Full name validation
    fullNameInput.addEventListener('blur', function() {
        const fullName = fullNameInput.value.trim();

        if (fullName === '') {
            showError(fullNameError, 'Vui lòng nhập họ và tên');
        } else if (!validateFullName(fullName)) {
            showError(fullNameError, 'Họ và tên phải có ít nhất 3 ký tự');
        } else {
            hideError(fullNameError);
        }
    });

    // Email validation
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

    // Phone validation
    phoneInput.addEventListener('blur', function() {
        const phone = phoneInput.value.trim();

        if (phone === '') {
            showError(phoneError, 'Vui lòng nhập số điện thoại');
        } else if (!validatePhone(phone)) {
            showError(phoneError, 'Số điện thoại không hợp lệ (phải là 10 số bắt đầu bằng 0)');
        } else {
            hideError(phoneError);
        }
    });

    // Password validation
    passwordInput.addEventListener('blur', function() {
        const password = passwordInput.value;

        if (password === '') {
            showError(passwordError, 'Vui lòng nhập mật khẩu');
        } else if (!validatePassword(password)) {
            showError(passwordError, 'Mật khẩu phải có ít nhất 6 ký tự');
        } else {
            hideError(passwordError);

            // Revalidate confirm password if it has value
            if (confirmPasswordInput.value !== '') {
                confirmPasswordInput.dispatchEvent(new Event('blur'));
            }
        }
    });

    // Confirm password validation
    confirmPasswordInput.addEventListener('blur', function() {
        const password = passwordInput.value;
        const confirmPassword = confirmPasswordInput.value;

        if (confirmPassword === '') {
            showError(confirmPasswordError, 'Vui lòng nhập lại mật khẩu');
        } else if (password !== confirmPassword) {
            showError(confirmPasswordError, 'Mật khẩu xác nhận không khớp');
        } else {
            hideError(confirmPasswordError);
        }
    });

    // Terms validation
    termsCheckbox.addEventListener('change', function() {
        if (!termsCheckbox.checked) {
            showError(termsError, 'Bạn phải đồng ý với điều khoản sử dụng');
        } else {
            hideError(termsError);
        }
    });

    // Form submission validation
    registerForm.addEventListener('submit', function(e) {
        let isValid = true;

        // Validate full name
        const fullName = fullNameInput.value.trim();
        if (fullName === '') {
            showError(fullNameError, 'Vui lòng nhập họ và tên');
            isValid = false;
        } else if (!validateFullName(fullName)) {
            showError(fullNameError, 'Họ và tên phải có ít nhất 3 ký tự');
            isValid = false;
        } else {
            hideError(fullNameError);
        }

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

        // Validate phone
        const phone = phoneInput.value.trim();
        if (phone === '') {
            showError(phoneError, 'Vui lòng nhập số điện thoại');
            isValid = false;
        } else if (!validatePhone(phone)) {
            showError(phoneError, 'Số điện thoại không hợp lệ (phải là 10 số bắt đầu bằng 0)');
            isValid = false;
        } else {
            hideError(phoneError);
        }

        // Validate password
        const password = passwordInput.value;
        if (password === '') {
            showError(passwordError, 'Vui lòng nhập mật khẩu');
            isValid = false;
        } else if (!validatePassword(password)) {
            showError(passwordError, 'Mật khẩu phải có ít nhất 6 ký tự');
            isValid = false;
        } else {
            hideError(passwordError);
        }

        // Validate confirm password
        const confirmPassword = confirmPasswordInput.value;
        if (confirmPassword === '') {
            showError(confirmPasswordError, 'Vui lòng nhập lại mật khẩu');
            isValid = false;
        } else if (password !== confirmPassword) {
            showError(confirmPasswordError, 'Mật khẩu xác nhận không khớp');
            isValid = false;
        } else {
            hideError(confirmPasswordError);
        }

        // Validate terms
        if (!termsCheckbox.checked) {
            showError(termsError, 'Bạn phải đồng ý với điều khoản sử dụng');
            isValid = false;
        } else {
            hideError(termsError);
        }

        if (!isValid) {
            e.preventDefault();
        }
    });

    // Clear errors on input
    fullNameInput.addEventListener('input', function() {
        if (fullNameInput.value.trim() !== '') {
            hideError(fullNameError);
        }
    });

    emailInput.addEventListener('input', function() {
        if (emailInput.value.trim() !== '') {
            hideError(emailError);
        }
    });

    phoneInput.addEventListener('input', function() {
        if (phoneInput.value.trim() !== '') {
            hideError(phoneError);
        }
    });

    passwordInput.addEventListener('input', function() {
        if (passwordInput.value !== '') {
            hideError(passwordError);
        }
    });

    confirmPasswordInput.addEventListener('input', function() {
        if (confirmPasswordInput.value !== '') {
            hideError(confirmPasswordError);
        }
    });
});
</script>

<%@ include file="/views/common/footer.jsp" %>
