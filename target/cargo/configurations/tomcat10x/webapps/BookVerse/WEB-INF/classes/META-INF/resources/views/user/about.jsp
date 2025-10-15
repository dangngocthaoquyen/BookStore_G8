<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Giới thiệu" scope="request" />
<%@ include file="/views/common/header.jsp" %>

<!-- Main Content -->
<main class="min-h-screen bg-gray-50 py-12">
    <div class="max-w-5xl mx-auto px-4">

        <!-- Hero Section -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8 mb-8">
            <div class="text-center mb-8">
                <div class="flex justify-center mb-4">
                    <svg class="w-20 h-20 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M9 4.804A7.968 7.968 0 005.5 4c-1.255 0-2.443.29-3.5.804v10A7.969 7.969 0 015.5 14c1.669 0 3.218.51 4.5 1.385A7.962 7.962 0 0114.5 14c1.255 0 2.443.29 3.5.804v-10A7.968 7.968 0 0014.5 4c-1.255 0-2.443.29-3.5.804V12a1 1 0 11-2 0V4.804z"/>
                    </svg>
                </div>
                <h1 class="text-4xl font-bold text-gray-900 mb-4">Về BookVerse</h1>
                <p class="text-lg text-gray-600 max-w-2xl mx-auto">
                    Nền tảng mua sách trực tuyến hàng đầu, mang đến cho bạn trải nghiệm đọc sách tuyệt vời
                </p>
            </div>
        </div>

        <!-- Story Section -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8 mb-8">
            <h2 class="text-2xl font-semibold text-gray-900 mb-4">Câu chuyện của chúng tôi</h2>
            <div class="prose prose-lg max-w-none text-gray-600">
                <p class="mb-4">
                    BookVerse được thành lập với sứ mệnh lan tỏa văn hóa đọc và giúp mọi người dễ dàng tiếp cận
                    với kho tàng tri thức phong phú từ sách. Chúng tôi tin rằng sách là cầu nối giữa con người
                    với tri thức, giữa quá khứ với tương lai.
                </p>
                <p class="mb-4">
                    Với bộ sưu tập hàng nghìn đầu sách từ nhiều thể loại khác nhau - văn học, kinh doanh,
                    kỹ năng sống, khoa học, công nghệ đến sách thiếu nhi - BookVerse cam kết mang đến
                    cho độc giả những cuốn sách chất lượng với giá cả hợp lý nhất.
                </p>
                <p>
                    Chúng tôi không chỉ là một cửa hàng bán sách, mà còn là một cộng đồng yêu sách,
                    nơi mọi người có thể chia sẻ đam mê và khám phá những cuốn sách tuyệt vời.
                </p>
            </div>
        </div>

        <!-- Values Section -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8 mb-8">
            <h2 class="text-2xl font-semibold text-gray-900 mb-6">Giá trị cốt lõi</h2>
            <div class="grid md:grid-cols-2 gap-6">

                <!-- Value 1 -->
                <div class="flex items-start space-x-4">
                    <div class="flex-shrink-0">
                        <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                            <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-2">Chất lượng</h3>
                        <p class="text-gray-600">
                            Cam kết cung cấp sách chính hãng, chất lượng tốt nhất với giá cả hợp lý
                        </p>
                    </div>
                </div>

                <!-- Value 2 -->
                <div class="flex items-start space-x-4">
                    <div class="flex-shrink-0">
                        <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                            <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                            </svg>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-2">Nhanh chóng</h3>
                        <p class="text-gray-600">
                            Giao hàng nhanh chóng, đảm bảo sách đến tay bạn trong thời gian sớm nhất
                        </p>
                    </div>
                </div>

                <!-- Value 3 -->
                <div class="flex items-start space-x-4">
                    <div class="flex-shrink-0">
                        <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                            <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                            </svg>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-2">Cộng đồng</h3>
                        <p class="text-gray-600">
                            Xây dựng cộng đồng yêu sách, nơi mọi người chia sẻ và kết nối
                        </p>
                    </div>
                </div>

                <!-- Value 4 -->
                <div class="flex items-start space-x-4">
                    <div class="flex-shrink-0">
                        <div class="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center">
                            <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                            </svg>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-2">Đa dạng</h3>
                        <p class="text-gray-600">
                            Hàng nghìn đầu sách từ nhiều thể loại, đáp ứng mọi nhu cầu đọc
                        </p>
                    </div>
                </div>

            </div>
        </div>

        <!-- Stats Section -->
        <div class="bg-gradient-to-r from-blue-600 to-blue-700 rounded-lg shadow-sm p-8 mb-8 text-white">
            <div class="grid md:grid-cols-4 gap-6 text-center">
                <div>
                    <div class="text-4xl font-bold mb-2">10,000+</div>
                    <div class="text-blue-100">Đầu sách</div>
                </div>
                <div>
                    <div class="text-4xl font-bold mb-2">50,000+</div>
                    <div class="text-blue-100">Khách hàng</div>
                </div>
                <div>
                    <div class="text-4xl font-bold mb-2">100,000+</div>
                    <div class="text-blue-100">Đơn hàng</div>
                </div>
                <div>
                    <div class="text-4xl font-bold mb-2">99%</div>
                    <div class="text-blue-100">Hài lòng</div>
                </div>
            </div>
        </div>

        <!-- CTA Section -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8 text-center">
            <h2 class="text-2xl font-semibold text-gray-900 mb-4">Tham gia cùng chúng tôi</h2>
            <p class="text-gray-600 mb-6 max-w-2xl mx-auto">
                Khám phá thế giới sách phong phú và tìm kiếm cuốn sách tiếp theo của bạn ngay hôm nay
            </p>
            <div class="flex justify-center gap-4">
                <a href="${pageContext.request.contextPath}/books"
                   class="bg-blue-600 text-white px-6 py-3 rounded-md hover:bg-blue-700 transition-colors font-medium">
                    Khám phá sách
                </a>
                <a href="${pageContext.request.contextPath}/contact"
                   class="bg-white border-2 border-blue-600 text-blue-600 px-6 py-3 rounded-md hover:bg-blue-50 transition-colors font-medium">
                    Liên hệ
                </a>
            </div>
        </div>

    </div>
</main>

<%@ include file="/views/common/footer.jsp" %>
