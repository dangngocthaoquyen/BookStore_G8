package com.bookverse.controller;

import com.bookverse.dao.CartDAO;
import com.bookverse.dao.OrderDAO;
import com.bookverse.model.Cart;
import com.bookverse.model.Order;
import com.bookverse.model.OrderItem;
import com.bookverse.model.User;
import com.bookverse.util.VNPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet xử lý checkout và tạo đơn hàng
 * GET: Hiển thị form checkout
 * POST: Xử lý đặt hàng
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy cart items
            List<Cart> cartItems = cartDAO.getCartByUserId(user.getUserId());

            // Kiểm tra giỏ hàng rỗng
            if (cartItems == null || cartItems.isEmpty()) {
                session.setAttribute("error", "Giỏ hàng của bạn đang trống!");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Tính tổng tiền
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (Cart item : cartItems) {
                totalAmount = totalAmount.add(item.getSubtotal());
            }

            // Pre-fill thông tin user
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("shippingName", user.getFullName());
            request.setAttribute("shippingPhone", user.getPhone());
            request.setAttribute("shippingAddress", user.getAddress());

            // Forward đến checkout.jsp
            request.getRequestDispatcher("/views/user/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Send error details to JSP
            request.setAttribute("errorMessage", "ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            request.setAttribute("errorStackTrace", getStackTraceAsString(e));
            request.getRequestDispatcher("/views/user/checkout.jsp").forward(request, response);
        }
    }

    private String getStackTraceAsString(Exception e) {
        StringBuilder sb = new StringBuilder();
        sb.append(e.toString()).append("\n");
        for (StackTraceElement element : e.getStackTrace()) {
            sb.append("\tat ").append(element.toString()).append("\n");
        }
        if (e.getCause() != null) {
            sb.append("Caused by: ").append(e.getCause().toString()).append("\n");
            for (StackTraceElement element : e.getCause().getStackTrace()) {
                sb.append("\tat ").append(element.toString()).append("\n");
            }
        }
        return sb.toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy form data
        String shippingName = request.getParameter("shippingName");
        String shippingPhone = request.getParameter("shippingPhone");
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        String notes = request.getParameter("notes");

        // Validate đầy đủ
        List<String> errors = new ArrayList<>();

        if (shippingName == null || shippingName.trim().isEmpty()) {
            errors.add("Vui lòng nhập tên người nhận");
        }

        if (shippingPhone == null || shippingPhone.trim().isEmpty()) {
            errors.add("Vui lòng nhập số điện thoại");
        } else if (!shippingPhone.matches("^(0|\\+84)[3|5|7|8|9][0-9]{8}$")) {
            errors.add("Số điện thoại không hợp lệ");
        }

        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            errors.add("Vui lòng nhập địa chỉ giao hàng");
        }

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            errors.add("Vui lòng chọn phương thức thanh toán");
        } else if (!paymentMethod.equals("cod") && !paymentMethod.equals("vnpay")) {
            errors.add("Phương thức thanh toán không hợp lệ");
        }

        // Nếu có lỗi validation
        if (!errors.isEmpty()) {
            session.setAttribute("error", String.join(", ", errors));
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        try {
            // Lấy cart items
            List<Cart> cartItems = cartDAO.getCartByUserId(user.getUserId());

            // Kiểm tra giỏ hàng rỗng
            if (cartItems == null || cartItems.isEmpty()) {
                session.setAttribute("error", "Giỏ hàng của bạn đang trống!");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Tính total amount
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (Cart item : cartItems) {
                totalAmount = totalAmount.add(item.getSubtotal());
            }

            // Tạo order code
            String orderCode = "OD" + System.currentTimeMillis();

            // Tạo Order object
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setOrderCode(orderCode);
            order.setTotalAmount(totalAmount);
            order.setShippingName(shippingName.trim());
            order.setShippingPhone(shippingPhone.trim());
            order.setShippingAddress(shippingAddress.trim());
            // VNPay sẽ được lưu dưới dạng credit_card trong DB
            order.setPaymentMethod(paymentMethod.equals("vnpay") ? "credit_card" : paymentMethod);
            order.setPaymentStatus("pending");
            order.setOrderStatus("pending");
            order.setNotes(notes != null ? notes.trim() : "");

            // Tạo List<OrderItem> từ cart
            List<OrderItem> orderItems = new ArrayList<>();
            for (Cart cart : cartItems) {
                OrderItem item = new OrderItem();
                item.setBookId(cart.getBookId());
                item.setBookTitle(cart.getBookTitle());
                item.setBookPrice(cart.getBookPrice());
                item.setQuantity(cart.getQuantity());
                item.setSubtotal(cart.getSubtotal());
                orderItems.add(item);
            }

            // Call OrderDAO.createOrder() với transaction
            int orderId = orderDAO.createOrder(order, orderItems);

            if (orderId > 0) {
                // Phân biệt xử lý theo payment method
                System.out.println("DEBUG: Payment method = " + paymentMethod);

                if (paymentMethod.equals("vnpay")) {
                    // VNPay: Redirect đến VNPay payment gateway
                    // KHÔNG clear cart ngay (chờ payment success từ VNPay callback)

                    // Lưu orderId vào session để verify sau khi payment
                    session.setAttribute("pendingOrderId", orderId);
                    session.setAttribute("pendingOrderCode", orderCode);

                    // Tạo VNPay payment URL
                    String ipAddress = VNPayUtil.getIpAddress(request);
                    String orderInfo = "Thanh toan don hang " + orderCode;
                    long amount = totalAmount.longValue(); // VNPay amount in VND

                    System.out.println("DEBUG: Creating VNPay URL with orderCode=" + orderCode + ", amount=" + amount + ", IP=" + ipAddress);

                    String vnpayUrl = VNPayUtil.createPaymentUrl(orderCode, amount, orderInfo, ipAddress);

                    System.out.println("DEBUG: VNPay URL = " + vnpayUrl);

                    if (vnpayUrl != null && !vnpayUrl.isEmpty()) {
                        // Redirect đến VNPay
                        System.out.println("DEBUG: Redirecting to VNPay...");
                        response.sendRedirect(vnpayUrl);
                        return; // Important: stop execution after redirect
                    } else {
                        // Lỗi tạo payment URL
                        System.err.println("ERROR: VNPay URL is null or empty!");
                        session.setAttribute("error", "Không thể kết nối đến cổng thanh toán. Vui lòng thử lại!");
                        response.sendRedirect(request.getContextPath() + "/checkout");
                    }
                } else {
                    // COD: Flow cũ - clear cart và redirect đến success page
                    cartDAO.clearCart(user.getUserId());
                    session.setAttribute("success", "Đặt hàng thành công!");
                    response.sendRedirect(request.getContextPath() + "/checkout-success?orderCode=" + orderCode);
                }
            } else {
                // Fail: show error
                session.setAttribute("error", "Đặt hàng thất bại, vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/checkout");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}
