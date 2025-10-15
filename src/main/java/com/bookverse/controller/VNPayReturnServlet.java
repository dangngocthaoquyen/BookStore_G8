package com.bookverse.controller;

import com.bookverse.dao.CartDAO;
import com.bookverse.dao.OrderDAO;
import com.bookverse.model.Order;
import com.bookverse.model.User;
import com.bookverse.util.VNPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet xử lý callback từ VNPay sau khi thanh toán
 * URL: /vnpay-return
 */
@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO cartDAO = new CartDAO();

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

        // Lấy params từ VNPay
        String vnpResponseCode = request.getParameter("vnp_ResponseCode");
        String vnpTxnRef = request.getParameter("vnp_TxnRef"); // orderCode
        String vnpAmount = request.getParameter("vnp_Amount");
        String vnpTransactionNo = request.getParameter("vnp_TransactionNo");
        String vnpBankCode = request.getParameter("vnp_BankCode");
        String vnpPayDate = request.getParameter("vnp_PayDate");

        // Verify secure hash
        boolean isValidSignature = VNPayUtil.verifySecureHash(request);

        if (!isValidSignature) {
            // Signature không hợp lệ - có thể bị giả mạo
            session.setAttribute("error", "Chữ ký thanh toán không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        try {
            // Lấy order từ database bằng orderCode
            Order order = orderDAO.getOrderByOrderCode(vnpTxnRef);

            if (order == null) {
                session.setAttribute("error", "Không tìm thấy đơn hàng!");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Kiểm tra user có phải owner của order không
            if (order.getUserId() != user.getUserId()) {
                session.setAttribute("error", "Bạn không có quyền truy cập đơn hàng này!");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Kiểm tra response code từ VNPay
            if ("00".equals(vnpResponseCode)) {
                // Thanh toán thành công
                // Update payment status
                boolean updateSuccess = orderDAO.updatePaymentStatus(order.getOrderId(), "paid", vnpTransactionNo);

                if (updateSuccess) {
                    // Clear cart sau khi payment thành công
                    cartDAO.clearCart(user.getUserId());

                    // Clear pending order từ session
                    session.removeAttribute("pendingOrderId");
                    session.removeAttribute("pendingOrderCode");

                    // Set success message
                    session.setAttribute("success", "Thanh toán thành công!");

                    // Redirect đến checkout-success
                    response.sendRedirect(request.getContextPath() + "/checkout-success?orderCode=" + vnpTxnRef);
                } else {
                    session.setAttribute("error", "Cập nhật trạng thái thanh toán thất bại!");
                    response.sendRedirect(request.getContextPath() + "/orders");
                }
            } else {
                // Thanh toán thất bại
                // Update payment status thành failed
                orderDAO.updatePaymentStatus(order.getOrderId(), "failed", vnpTransactionNo);

                // Giữ cart (không clear)
                // User có thể thử lại

                // Set error message với mã lỗi
                String errorMessage = getVNPayErrorMessage(vnpResponseCode);
                session.setAttribute("error", "Thanh toán thất bại: " + errorMessage);

                // Redirect về checkout để thử lại
                response.sendRedirect(request.getContextPath() + "/checkout");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }

    /**
     * Chuyển đổi VNPay response code thành message dễ hiểu
     */
    private String getVNPayErrorMessage(String responseCode) {
        switch (responseCode) {
            case "00":
                return "Giao dịch thành công";
            case "07":
                return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường)";
            case "09":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng";
            case "10":
                return "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần";
            case "11":
                return "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch";
            case "12":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa";
            case "13":
                return "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP)";
            case "24":
                return "Giao dịch không thành công do: Khách hàng hủy giao dịch";
            case "51":
                return "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch";
            case "65":
                return "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày";
            case "75":
                return "Ngân hàng thanh toán đang bảo trì";
            case "79":
                return "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định";
            default:
                return "Giao dịch thất bại (Mã lỗi: " + responseCode + ")";
        }
    }
}
