-- ===================================
-- SAMPLE DATA FOR BOOKVERSE
-- Dữ liệu mẫu để test hệ thống
-- ===================================
--
-- CÁCH SỬ DỤNG:
-- 1. Chạy schema.sql trước
-- 2. Sau đó chạy file này: source sample_data.sql
--
-- LƯU Ý: File này chỉ dùng để test, KHÔNG tự động chạy
-- ===================================

USE bookverse;

-- ===================================
-- 1. USERS (Người dùng)
-- ===================================

-- Admin account
-- Email: admin@bookverse.com
-- Password: Admin123
INSERT INTO users (full_name, email, password, phone, address, role, status) VALUES
('Administrator', 'admin@bookverse.com', 'mK8vX2pL9qR4tY6w:8f3e2d1c5b7a9f4e6d8c2b5a7f9e1d3c4b6a8f2e5d7c9b1a3f5e7d9c2b4a6f8e', '0901234567', '123 Nguyễn Huệ, Quận 1, TP.HCM', 'admin', 'active');

-- Regular users for testing
-- All passwords are: User123
INSERT INTO users (full_name, email, password, phone, address, role, status) VALUES
('Nguyễn Văn An', 'nguyenvanan@gmail.com', 'pL5mN9rT3wY7xZ2q:7c4f1e8d2b6a9f3e5d7c1b4a8f2e6d9c3b5a7f1e4d8c2b6a9f3e5d7c1b4a8f2e', '0912345678', '456 Lê Lợi, Quận 3, TP.HCM', 'user', 'active'),
('Trần Thị Bình', 'tranthib@gmail.com', 'pL5mN9rT3wY7xZ2q:7c4f1e8d2b6a9f3e5d7c1b4a8f2e6d9c3b5a7f1e4d8c2b6a9f3e5d7c1b4a8f2e', '0923456789', '789 Trần Hưng Đạo, Quận 5, TP.HCM', 'user', 'active'),
('Lê Hoàng Cường', 'lehoangcuong@gmail.com', 'pL5mN9rT3wY7xZ2q:7c4f1e8d2b6a9f3e5d7c1b4a8f2e6d9c3b5a7f1e4d8c2b6a9f3e5d7c1b4a8f2e', '0934567890', '321 Võ Văn Tần, Quận 3, TP.HCM', 'user', 'active'),
('Phạm Thu Dung', 'phamthudung@gmail.com', 'pL5mN9rT3wY7xZ2q:7c4f1e8d2b6a9f3e5d7c1b4a8f2e6d9c3b5a7f1e4d8c2b6a9f3e5d7c1b4a8f2e', '0945678901', '654 Nguyễn Thị Minh Khai, Quận 1, TP.HCM', 'user', 'active');

-- ===================================
-- 2. CATEGORIES (Danh mục)
-- ===================================

INSERT INTO categories (category_name, description, status) VALUES
('Văn học Việt Nam', 'Sách văn học trong nước, tiểu thuyết, truyện ngắn, thơ ca', 'active'),
('Văn học nước ngoài', 'Sách văn học dịch từ các nước trên thế giới', 'active'),
('Kinh tế - Kinh doanh', 'Sách về kinh tế, quản trị, khởi nghiệp, marketing', 'active'),
('Kỹ năng sống', 'Sách phát triển bản thân, tư duy, giao tiếp, lãnh đạo', 'active'),
('Công nghệ thông tin', 'Sách về lập trình, mạng máy tính, AI, blockchain', 'active'),
('Thiếu nhi', 'Sách dành cho trẻ em, truyện tranh, sách tô màu', 'active'),
('Tâm lý - Tâm linh', 'Sách về tâm lý học, triết học, tôn giáo, thiền', 'active'),
('Lịch sử - Địa lý', 'Sách về lịch sử Việt Nam và thế giới, địa lý, du lịch', 'active'),
('Khoa học - Kỹ thuật', 'Sách về khoa học tự nhiên, vật lý, hóa học, sinh học', 'active'),
('Sức khỏe - Làm đẹp', 'Sách về y học, dinh dưỡng, yoga, thể dục, chăm sóc sắc đẹp', 'active');

-- ===================================
-- 3. BOOKS (Sách)
-- ===================================

INSERT INTO books (title, author, category_id, description, price, stock_quantity, image_url, isbn, publisher, publish_year, status) VALUES
-- Văn học Việt Nam
('Số Đỏ', 'Vũ Trọng Phụng', 1, 'Tiểu thuyết nổi tiếng của Vũ Trọng Phụng, phê phán hiện thực xã hội đầu thế kỷ 20', 85000, 50, 'https://via.placeholder.com/300x400?text=Số+Đỏ', '978-604-1-00001-1', 'NXB Văn học', 2020, 'available'),
('Vợ Nhặt', 'Kim Lân', 1, 'Truyện ngắn cảm động về tình người trong đói khát', 45000, 75, 'https://via.placeholder.com/300x400?text=Vợ+Nhặt', '978-604-1-00002-8', 'NXB Văn học', 2021, 'available'),
('Tắt Đèn', 'Ngô Tất Tố', 1, 'Tác phẩm văn học hiện thực phê phán nổi tiếng', 95000, 40, 'https://via.placeholder.com/300x400?text=Tắt+Đèn', '978-604-1-00003-5', 'NXB Văn học', 2020, 'available'),
('Chí Phèo', 'Nam Cao', 1, 'Truyện ngắn nổi tiếng về số phận con người', 55000, 60, 'https://via.placeholder.com/300x400?text=Chí+Phèo', '978-604-1-00004-2', 'NXB Văn học', 2021, 'available'),

-- Văn học nước ngoài
('Nhà Giả Kim', 'Paulo Coelho', 2, 'Câu chuyện về hành trình tìm kiếm kho báu và chính mình', 95000, 100, 'https://via.placeholder.com/300x400?text=Nhà+Giả+Kim', '978-604-2-00001-9', 'NXB Hội Nhà Văn', 2019, 'available'),
('Đắc Nhân Tâm', 'Dale Carnegie', 2, 'Nghệ thuật thu phục lòng người và giao tiếp hiệu quả', 120000, 150, 'https://via.placeholder.com/300x400?text=Đắc+Nhân+Tâm', '978-604-2-00002-6', 'NXB Tổng hợp', 2018, 'available'),
('Cà Phê Cùng Tony', 'Tony Buổi Sáng', 2, 'Những chia sẻ về cuộc sống và suy ngẫm triết lý', 75000, 80, 'https://via.placeholder.com/300x400?text=Cà+Phê+Tony', '978-604-2-00003-3', 'NXB Trẻ', 2020, 'available'),
('Tuổi Trẻ Đáng Giá Bao Nhiêu', 'Rosie Nguyễn', 2, 'Sách về phát triển bản thân dành cho giới trẻ', 85000, 90, 'https://via.placeholder.com/300x400?text=Tuổi+Trẻ', '978-604-2-00004-0', 'NXB Hội Nhà Văn', 2019, 'available'),

-- Kinh tế - Kinh doanh
('Khởi Nghiệp Tinh Gọn', 'Eric Ries', 3, 'Phương pháp khởi nghiệp hiệu quả cho startup', 180000, 45, 'https://via.placeholder.com/300x400?text=Lean+Startup', '978-604-3-00001-7', 'NXB Trẻ', 2021, 'available'),
('Tư Duy Nhanh Và Chậm', 'Daniel Kahneman', 3, 'Nghiên cứu về hai hệ thống tư duy của con người', 210000, 35, 'https://via.placeholder.com/300x400?text=Thinking', '978-604-3-00002-4', 'NXB Thế Giới', 2020, 'available'),
('Từ Tốt Đến Vĩ Đại', 'Jim Collins', 3, 'Bí quyết xây dựng công ty vĩ đại bền vững', 195000, 50, 'https://via.placeholder.com/300x400?text=Good+To+Great', '978-604-3-00003-1', 'NXB Trẻ', 2019, 'available'),
('Nghệ Thuật Bán Hàng', 'Zig Ziglar', 3, 'Kỹ năng bán hàng chuyên nghiệp', 145000, 60, 'https://via.placeholder.com/300x400?text=Sales+Art', '978-604-3-00004-8', 'NXB Lao Động', 2020, 'available'),

-- Kỹ năng sống
('7 Thói Quen Hiệu Quả', 'Stephen Covey', 4, 'Bảy thói quen của người thành đạt', 165000, 70, 'https://via.placeholder.com/300x400?text=7+Habits', '978-604-4-00001-5', 'NXB Trẻ', 2018, 'available'),
('Đời Ngắn Đừng Ngủ Dài', 'Robin Sharma', 4, 'Sách truyền cảm hứng về cuộc sống', 95000, 85, 'https://via.placeholder.com/300x400?text=Short+Life', '978-604-4-00002-2', 'NXB Thanh Niên', 2019, 'available'),
('Nghĩ Giàu Làm Giàu', 'Napoleon Hill', 4, '13 nguyên tắc nghĩ giàu làm giàu', 125000, 65, 'https://via.placeholder.com/300x400?text=Think+Rich', '978-604-4-00003-9', 'NXB Lao Động', 2020, 'available'),
('Quẳng Gánh Lo Đi Và Vui Sống', 'Dale Carnegie', 4, 'Nghệ thuật sống hạnh phúc không lo lắng', 115000, 75, 'https://via.placeholder.com/300x400?text=Stop+Worry', '978-604-4-00004-6', 'NXB Tổng hợp', 2019, 'available'),

-- Công nghệ thông tin
('Clean Code', 'Robert C. Martin', 5, 'Cẩm nang viết code sạch và bảo trì tốt', 280000, 30, 'https://via.placeholder.com/300x400?text=Clean+Code', '978-604-5-00001-3', 'NXB Thông tin và Truyền thông', 2021, 'available'),
('Lập Trình Java Cơ Bản', 'Phạm Hữu Khang', 5, 'Giáo trình Java cho người mới bắt đầu', 195000, 40, 'https://via.placeholder.com/300x400?text=Java+Basic', '978-604-5-00002-0', 'NXB Lao Động', 2022, 'available'),
('JavaScript: The Good Parts', 'Douglas Crockford', 5, 'Những phần hay nhất của JavaScript', 165000, 35, 'https://via.placeholder.com/300x400?text=JavaScript', '978-604-5-00003-7', 'NXB Thông tin', 2021, 'available'),
('Design Patterns', 'Gang of Four', 5, 'Các mẫu thiết kế phần mềm kinh điển', 295000, 25, 'https://via.placeholder.com/300x400?text=Design+Patterns', '978-604-5-00004-4', 'NXB Thông tin', 2020, 'available'),

-- Thiếu nhi
('Dế Mèn Phiêu Lưu Ký', 'Tô Hoài', 6, 'Truyện thiếu nhi kinh điển Việt Nam', 65000, 120, 'https://via.placeholder.com/300x400?text=Dế+Mèn', '978-604-6-00001-1', 'NXB Kim Đồng', 2020, 'available'),
('Doraemon Tập 1', 'Fujiko F. Fujio', 6, 'Truyện tranh nổi tiếng về chú mèo máy', 25000, 200, 'https://via.placeholder.com/300x400?text=Doraemon', '978-604-6-00002-8', 'NXB Kim Đồng', 2022, 'available'),
('Conan Thám Tử Lừng Danh', 'Aoyama Gosho', 6, 'Truyện trinh thám hấp dẫn', 30000, 180, 'https://via.placeholder.com/300x400?text=Conan', '978-604-6-00003-5', 'NXB Kim Đồng', 2022, 'available'),
('Harry Potter Và Hòn Đá Phù Thủy', 'J.K. Rowling', 6, 'Cuốn đầu tiên của series Harry Potter', 145000, 95, 'https://via.placeholder.com/300x400?text=Harry+Potter', '978-604-6-00004-2', 'NXB Trẻ', 2021, 'available'),

-- Tâm lý - Tâm linh
('Đừng Chạy Theo Số Đông', 'Kiên Trần', 7, 'Sách về tư duy độc lập và khác biệt', 95000, 70, 'https://via.placeholder.com/300x400?text=Be+Different', '978-604-7-00001-9', 'NXB Thế Giới', 2020, 'available'),
('Nghệ Thuật Sống', 'Thích Nhất Hạnh', 7, 'Triết lý sống an nhiên hạnh phúc', 85000, 80, 'https://via.placeholder.com/300x400?text=Art+Living', '978-604-7-00002-6', 'NXB Tôn Giáo', 2019, 'available'),
('Tâm Lý Học Về Tiền', 'Morgan Housel', 7, 'Hiểu về mối quan hệ giữa con người và tiền bạc', 155000, 55, 'https://via.placeholder.com/300x400?text=Money+Psychology', '978-604-7-00003-3', 'NXB Thế Giới', 2021, 'available'),
('Tuổi Trẻ Đáng Giá Bao Nhiêu', 'Rosie Nguyễn', 7, 'Những câu chuyện truyền cảm hứng', 85000, 90, 'https://via.placeholder.com/300x400?text=Young+Value', '978-604-7-00004-0', 'NXB Hội Nhà Văn', 2020, 'available'),

-- Lịch sử - Địa lý
('Lịch Sử Việt Nam', 'Trần Trọng Kim', 8, 'Tổng quan lịch sử dân tộc Việt Nam', 165000, 45, 'https://via.placeholder.com/300x400?text=VN+History', '978-604-8-00001-7', 'NXB Văn hóa - Văn nghệ', 2020, 'available'),
('Sapiens: Lược Sử Loài Người', 'Yuval Noah Harari', 8, 'Câu chuyện tiến hóa của loài người', 195000, 60, 'https://via.placeholder.com/300x400?text=Sapiens', '978-604-8-00002-4', 'NXB Trẻ', 2019, 'available'),
('Việt Nam Phong Tục', 'Phan Kế Bính', 8, 'Tìm hiểu phong tục tập quán Việt Nam', 115000, 50, 'https://via.placeholder.com/300x400?text=VN+Custom', '978-604-8-00003-1', 'NXB Văn hóa', 2021, 'available'),
('Đất Nước Con Người Việt Nam', 'Nhiều tác giả', 8, 'Khám phá đất nước Việt Nam', 125000, 55, 'https://via.placeholder.com/300x400?text=VN+Country', '978-604-8-00004-8', 'NXB Chính trị', 2020, 'available'),

-- Khoa học - Kỹ thuật
('Vũ Trụ Trong Vỏ Hạt Dẻ', 'Stephen Hawking', 9, 'Khám phá bí ẩn vũ trụ', 145000, 40, 'https://via.placeholder.com/300x400?text=Universe', '978-604-9-00001-5', 'NXB Trẻ', 2020, 'available'),
('Bản Chất Của Vật Lý', 'Richard Feynman', 9, 'Giới thiệu vật lý học hiện đại', 165000, 35, 'https://via.placeholder.com/300x400?text=Physics', '978-604-9-00002-2', 'NXB Thế Giới', 2021, 'available'),
('AI Siêu Việt', 'Nick Bostrom', 9, 'Tương lai của trí tuệ nhân tạo', 185000, 30, 'https://via.placeholder.com/300x400?text=Super+AI', '978-604-9-00003-9', 'NXB Trẻ', 2020, 'available'),
('Khoa Học Dữ Liệu', 'Joel Grus', 9, 'Nhập môn khoa học dữ liệu', 225000, 25, 'https://via.placeholder.com/300x400?text=Data+Science', '978-604-9-00004-6', 'NXB Thông tin', 2021, 'available'),

-- Sức khỏe - Làm đẹp
('Dinh Dưỡng Cho Sức Khỏe', 'BS. Nguyễn Thị Lâm', 10, 'Hướng dẫn dinh dưỡng khoa học', 95000, 60, 'https://via.placeholder.com/300x400?text=Nutrition', '978-604-10-00001-3', 'NXB Y học', 2021, 'available'),
('Yoga Cơ Bản', 'Trần Thu Hà', 10, 'Bài tập yoga cho người mới bắt đầu', 85000, 70, 'https://via.placeholder.com/300x400?text=Yoga', '978-604-10-00002-0', 'NXB Thể dục thể thao', 2020, 'available'),
('Bí Quyết Sống Thọ', 'BS. Trần Quốc Khánh', 10, 'Cách chăm sóc sức khỏe để sống lâu', 105000, 55, 'https://via.placeholder.com/300x400?text=Long+Life', '978-604-10-00003-7', 'NXB Y học', 2020, 'available'),
('Làm Đẹp Tự Nhiên', 'Lê Thanh Hương', 10, 'Phương pháp làm đẹp an toàn', 75000, 80, 'https://via.placeholder.com/300x400?text=Natural+Beauty', '978-604-10-00004-4', 'NXB Phụ nữ', 2021, 'available');

-- ===================================
-- KẾT THÚC SAMPLE DATA
-- ===================================

-- Hiển thị thống kê sau khi import
SELECT 'SAMPLE DATA IMPORTED SUCCESSFULLY!' as message;
SELECT CONCAT('Total Users: ', COUNT(*)) as info FROM users;
SELECT CONCAT('Total Categories: ', COUNT(*)) as info FROM categories;
SELECT CONCAT('Total Books: ', COUNT(*)) as info FROM books;
SELECT '----------------------------------------' as separator;
SELECT 'ADMIN LOGIN INFO:' as message;
SELECT 'Email: admin@bookverse.com' as info;
SELECT 'Password: Admin123' as info;
SELECT '----------------------------------------' as separator;
SELECT 'USER LOGIN INFO (all users):' as message;
SELECT 'Password: User123' as info;
SELECT '----------------------------------------' as separator;
