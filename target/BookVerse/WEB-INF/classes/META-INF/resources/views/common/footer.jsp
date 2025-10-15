<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Footer -->
<footer class="bg-white border-t border-gray-200 mt-12">
    <div class="max-w-7xl mx-auto px-4 py-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <!-- About -->
            <div>
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Về BookVerse</h3>
                <p class="text-sm text-gray-600 leading-relaxed">
                    Hệ thống quản lý bán sách trực tuyến với đầy đủ tính năng quản lý sách, đơn hàng và khách hàng.
                </p>
            </div>

            <!-- Quick Links -->
            <div>
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Liên kết nhanh</h3>
                <ul class="space-y-2 text-sm text-gray-600">
                    <li><a href="${pageContext.request.contextPath}/" class="hover:text-blue-600 transition-colors">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/books" class="hover:text-blue-600 transition-colors">Danh sách sách</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart" class="hover:text-blue-600 transition-colors">Giỏ hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders" class="hover:text-blue-600 transition-colors">Đơn hàng</a></li>
                </ul>
            </div>

            <!-- Support -->
            <div>
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Hỗ trợ</h3>
                <ul class="space-y-2 text-sm text-gray-600">
                    <li><a href="#" class="hover:text-blue-600 transition-colors">Hướng dẫn đặt hàng</a></li>
                    <li><a href="#" class="hover:text-blue-600 transition-colors">Chính sách đổi trả</a></li>
                    <li><a href="#" class="hover:text-blue-600 transition-colors">Điều khoản sử dụng</a></li>
                    <li><a href="#" class="hover:text-blue-600 transition-colors">Liên hệ</a></li>
                </ul>
            </div>

            <!-- Contact -->
            <div>
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Liên hệ</h3>
                <ul class="space-y-2 text-sm text-gray-600">
                    <li>Email: support@bookverse.com</li>
                    <li>Hotline: 1900 xxxx</li>
                    <li>Địa chỉ: Hà Nội, Việt Nam</li>
                </ul>
            </div>
        </div>

        <!-- Copyright -->
        <div class="border-t border-gray-200 mt-8 pt-6 text-center text-sm text-gray-500">
            <p>&copy; 2025 BookVerse. Tất cả quyền được bảo lưu.</p>
        </div>
    </div>
</footer>

</body>
</html>
