<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${sessionScope.user == null}">
    <c:redirect url="/login?returnUrl=/profile"/>
</c:if>

<jsp:include page="../common/header.jsp"/>

<!-- Main Content -->
<main class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4">

        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-semibold text-gray-900">Thông tin cá nhân</h1>
            <p class="text-sm text-gray-600 mt-1">Quản lý thông tin và bảo mật tài khoản của bạn</p>
        </div>

        <!-- Tabs Navigation -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200">
            <div class="border-b border-gray-200">
                <nav class="flex -mb-px">
                    <button onclick="switchTab('profile')" id="tab-profile"
                            class="tab-button px-6 py-4 text-sm font-medium border-b-2 transition-colors">
                        Thông tin cá nhân
                    </button>
                    <button onclick="switchTab('change-password')" id="tab-change-password"
                            class="tab-button px-6 py-4 text-sm font-medium border-b-2 transition-colors">
                        Đổi mật khẩu
                    </button>
                    <button onclick="switchTab('orders')" id="tab-orders"
                            class="tab-button px-6 py-4 text-sm font-medium border-b-2 transition-colors">
                        Đơn hàng của tôi
                    </button>
                </nav>
            </div>

            <!-- Tab Contents -->
            <div class="p-6">

                <!-- Tab 1: Profile Information -->
                <div id="content-profile" class="tab-content">
                    <form action="${pageContext.request.contextPath}/profile" method="POST"
                          onsubmit="return validateProfileForm()" class="max-w-2xl">

                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Cập nhật thông tin cá nhân</h3>

                        <!-- Full Name -->
                        <div class="mb-4">
                            <label for="fullName" class="block text-sm font-medium text-gray-700 mb-2">
                                Họ và tên <span class="text-red-500">*</span>
                            </label>
                            <input type="text"
                                   id="fullName"
                                   name="fullName"
                                   value="${sessionScope.user.fullName}"
                                   placeholder="Nhập họ và tên đầy đủ"
                                   required
                                   class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors">
                            <p id="fullName-error" class="text-sm text-red-600 mt-1 hidden"></p>
                        </div>

                        <!-- Email (readonly) -->
                        <div class="mb-4">
                            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                                Email
                            </label>
                            <input type="email"
                                   id="email"
                                   name="email"
                                   value="${sessionScope.user.email}"
                                   readonly
                                   disabled
                                   class="w-full px-4 py-2 border border-gray-300 rounded-md bg-gray-50 text-gray-500 cursor-not-allowed">
                            <p class="text-xs text-gray-500 mt-1">Email không thể thay đổi</p>
                        </div>

                        <!-- Phone -->
                        <div class="mb-4">
                            <label for="phone" class="block text-sm font-medium text-gray-700 mb-2">
                                Số điện thoại <span class="text-red-500">*</span>
                            </label>
                            <input type="tel"
                                   id="phone"
                                   name="phone"
                                   value="${sessionScope.user.phone}"
                                   placeholder="Nhập số điện thoại (VD: 0901234567)"
                                   pattern="^(0|\+84)(\s|\\.)?((3[2-9])|(5[689])|(7[06-9])|(8[1-689])|(9[0-46-9]))(\d)(\s|\.)?(\d{3})(\s|\.)?(\d{3})$"
                                   required
                                   class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors">
                            <p id="phone-error" class="text-sm text-red-600 mt-1 hidden"></p>
                        </div>

                        <!-- Address -->
                        <div class="mb-6">
                            <label for="address" class="block text-sm font-medium text-gray-700 mb-2">
                                Địa chỉ
                            </label>
                            <textarea id="address"
                                      name="address"
                                      rows="3"
                                      placeholder="Nhập địa chỉ đầy đủ (số nhà, đường, phường, quận, thành phố)"
                                      class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors">${sessionScope.user.address}</textarea>
                            <p id="address-error" class="text-sm text-red-600 mt-1 hidden"></p>
                        </div>

                        <!-- Submit Button -->
                        <div class="flex items-center justify-between">
                            <button type="submit"
                                    class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors font-medium">
                                Lưu thay đổi
                            </button>
                            <a href="${pageContext.request.contextPath}/"
                               class="text-sm text-gray-600 hover:text-gray-900 transition-colors">
                                Quay lại
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Tab 2: Change Password -->
                <div id="content-change-password" class="tab-content hidden">
                    <form action="${pageContext.request.contextPath}/change-password" method="POST"
                          onsubmit="return validatePasswordForm()" class="max-w-2xl">

                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Đổi mật khẩu</h3>

                        <div class="bg-yellow-50 border border-yellow-200 rounded-md p-4 mb-6">
                            <div class="flex">
                                <svg class="w-5 h-5 text-yellow-600 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                </svg>
                                <div class="ml-3">
                                    <p class="text-sm text-yellow-800">
                                        Vui lòng sử dụng mật khẩu mạnh có ít nhất 6 ký tự để bảo vệ tài khoản của bạn.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- Old Password -->
                        <div class="mb-4">
                            <label for="oldPassword" class="block text-sm font-medium text-gray-700 mb-2">
                                Mật khẩu hiện tại <span class="text-red-500">*</span>
                            </label>
                            <input type="password"
                                   id="oldPassword"
                                   name="oldPassword"
                                   placeholder="Nhập mật khẩu hiện tại"
                                   required
                                   class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors">
                            <p id="oldPassword-error" class="text-sm text-red-600 mt-1 hidden"></p>
                        </div>

                        <!-- New Password -->
                        <div class="mb-4">
                            <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-2">
                                Mật khẩu mới <span class="text-red-500">*</span>
                            </label>
                            <input type="password"
                                   id="newPassword"
                                   name="newPassword"
                                   placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)"
                                   minlength="6"
                                   required
                                   class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors">
                            <p id="newPassword-error" class="text-sm text-red-600 mt-1 hidden"></p>
                        </div>

                        <!-- Confirm Password -->
                        <div class="mb-6">
                            <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-2">
                                Xác nhận mật khẩu mới <span class="text-red-500">*</span>
                            </label>
                            <input type="password"
                                   id="confirmPassword"
                                   name="confirmPassword"
                                   placeholder="Nhập lại mật khẩu mới"
                                   minlength="6"
                                   required
                                   class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors">
                            <p id="confirmPassword-error" class="text-sm text-red-600 mt-1 hidden"></p>
                        </div>

                        <!-- Submit Button -->
                        <div class="flex items-center justify-between">
                            <button type="submit"
                                    class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors font-medium">
                                Đổi mật khẩu
                            </button>
                            <button type="reset"
                                    class="bg-gray-100 text-gray-700 px-6 py-2 rounded-md hover:bg-gray-200 transition-colors font-medium">
                                Hủy
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Tab 3: Orders -->
                <div id="content-orders" class="tab-content hidden">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Đơn hàng của tôi</h3>

                    <div class="bg-blue-50 border border-blue-200 rounded-md p-6 text-center">
                        <svg class="w-12 h-12 text-blue-600 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                        </svg>
                        <p class="text-gray-700 mb-4">Xem và quản lý đơn hàng của bạn</p>
                        <a href="${pageContext.request.contextPath}/orders"
                           class="inline-block bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors font-medium">
                            Xem đơn hàng
                        </a>
                    </div>
                </div>

            </div>
        </div>

    </div>
</main>

<!-- JavaScript for Tabs and Validation -->
<script>
    // Tab Switching
    function switchTab(tabName) {
        // Hide all tab contents
        const tabContents = document.querySelectorAll('.tab-content');
        tabContents.forEach(content => {
            content.classList.add('hidden');
        });

        // Remove active state from all tab buttons
        const tabButtons = document.querySelectorAll('.tab-button');
        tabButtons.forEach(button => {
            button.classList.remove('border-blue-600', 'text-blue-600');
            button.classList.add('border-transparent', 'text-gray-600', 'hover:text-gray-900', 'hover:border-gray-300');
        });

        // Show selected tab content
        const selectedContent = document.getElementById('content-' + tabName);
        if (selectedContent) {
            selectedContent.classList.remove('hidden');
        }

        // Add active state to selected tab button
        const selectedButton = document.getElementById('tab-' + tabName);
        if (selectedButton) {
            selectedButton.classList.add('border-blue-600', 'text-blue-600');
            selectedButton.classList.remove('border-transparent', 'text-gray-600', 'hover:text-gray-900', 'hover:border-gray-300');
        }

        // Update URL hash
        window.location.hash = tabName;
    }

    // Initialize tabs on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Check URL hash
        const hash = window.location.hash.substring(1);
        if (hash && ['profile', 'change-password', 'orders'].includes(hash)) {
            switchTab(hash);
        } else {
            switchTab('profile');
        }

        // Show success/error messages
        <c:if test="${not empty sessionScope.successMessage}">
            Toast.success('${sessionScope.successMessage}');
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            Toast.error('${sessionScope.errorMessage}');
            <c:remove var="errorMessage" scope="session"/>
        </c:if>
    });

    // Validate Profile Form
    function validateProfileForm() {
        let isValid = true;

        // Clear previous errors
        document.querySelectorAll('[id$="-error"]').forEach(el => {
            el.classList.add('hidden');
            el.textContent = '';
        });

        // Validate Full Name
        const fullName = document.getElementById('fullName').value.trim();
        if (fullName === '') {
            showError('fullName', 'Họ tên không được để trống');
            isValid = false;
        } else if (fullName.length < 2 || fullName.length > 100) {
            showError('fullName', 'Họ tên phải có độ dài từ 2 đến 100 ký tự');
            isValid = false;
        } else if (!/^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵýỷỹ\s]+$/.test(fullName)) {
            showError('fullName', 'Họ tên chỉ được chứa chữ cái và khoảng trắng');
            isValid = false;
        }

        // Validate Phone
        const phone = document.getElementById('phone').value.trim();
        const phonePattern = /^(0|\+84)(\s|\\.)?((3[2-9])|(5[689])|(7[06-9])|(8[1-689])|(9[0-46-9]))(\d)(\s|\\.)?(\d{3})(\s|\\.)?(\d{3})$/;
        if (phone === '') {
            showError('phone', 'Số điện thoại không được để trống');
            isValid = false;
        } else if (!phonePattern.test(phone.replace(/[\s.-]/g, ''))) {
            showError('phone', 'Số điện thoại không đúng định dạng (VD: 0901234567)');
            isValid = false;
        }

        // Validate Address (optional)
        const address = document.getElementById('address').value.trim();
        if (address !== '' && (address.length < 5 || address.length > 200)) {
            showError('address', 'Địa chỉ phải có độ dài từ 5 đến 200 ký tự');
            isValid = false;
        }

        if (!isValid) {
            Toast.error('Vui lòng kiểm tra lại thông tin nhập vào');
        }

        return isValid;
    }

    // Validate Password Form
    function validatePasswordForm() {
        let isValid = true;

        // Clear previous errors
        document.querySelectorAll('[id$="-error"]').forEach(el => {
            el.classList.add('hidden');
            el.textContent = '';
        });

        // Validate Old Password
        const oldPassword = document.getElementById('oldPassword').value;
        if (oldPassword === '') {
            showError('oldPassword', 'Vui lòng nhập mật khẩu hiện tại');
            isValid = false;
        }

        // Validate New Password
        const newPassword = document.getElementById('newPassword').value;
        if (newPassword === '') {
            showError('newPassword', 'Vui lòng nhập mật khẩu mới');
            isValid = false;
        } else if (newPassword.length < 6) {
            showError('newPassword', 'Mật khẩu mới phải có ít nhất 6 ký tự');
            isValid = false;
        } else if (oldPassword !== '' && newPassword === oldPassword) {
            showError('newPassword', 'Mật khẩu mới phải khác mật khẩu cũ');
            isValid = false;
        }

        // Validate Confirm Password
        const confirmPassword = document.getElementById('confirmPassword').value;
        if (confirmPassword === '') {
            showError('confirmPassword', 'Vui lòng xác nhận mật khẩu mới');
            isValid = false;
        } else if (confirmPassword !== newPassword) {
            showError('confirmPassword', 'Mật khẩu xác nhận không khớp');
            isValid = false;
        }

        if (!isValid) {
            Toast.error('Vui lòng kiểm tra lại thông tin nhập vào');
        }

        return isValid;
    }

    // Helper function to show error
    function showError(fieldId, message) {
        const errorElement = document.getElementById(fieldId + '-error');
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
        }

        const fieldElement = document.getElementById(fieldId);
        if (fieldElement) {
            fieldElement.classList.add('border-red-500');
            fieldElement.addEventListener('input', function() {
                this.classList.remove('border-red-500');
                const errorEl = document.getElementById(fieldId + '-error');
                if (errorEl) {
                    errorEl.classList.add('hidden');
                }
            }, { once: true });
        }
    }
</script>

<jsp:include page="../common/footer.jsp"/>
