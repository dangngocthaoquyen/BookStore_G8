/**
 * Cart Management System
 * Quản lý giỏ hàng với AJAX và Toast notifications
 */

const Cart = {
    /**
     * Cập nhật số lượng badge giỏ hàng
     * Lấy cart count từ server và update UI
     */
    async updateCartCount() {
        try {
            const response = await fetch('/BookVerse/cart-count', {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                throw new Error('Không thể lấy số lượng giỏ hàng');
            }

            const data = await response.json();

            // Update cart badge
            const cartBadge = document.querySelector('.cart-badge');
            const cartCount = document.querySelector('.cart-count');

            if (data.count > 0) {
                if (cartBadge) {
                    cartBadge.textContent = data.count;
                    cartBadge.classList.remove('hidden');
                }
                if (cartCount) {
                    cartCount.textContent = data.count;
                }
            } else {
                if (cartBadge) {
                    cartBadge.classList.add('hidden');
                }
                if (cartCount) {
                    cartCount.textContent = '0';
                }
            }

            return data.count;
        } catch (error) {
            console.error('Error updating cart count:', error);
            return 0;
        }
    },

    /**
     * Thêm sách vào giỏ hàng
     * @param {number} bookId - ID của sách
     * @param {number} quantity - Số lượng
     * @returns {Promise<object>} Response data
     */
    async addToCart(bookId, quantity = 1) {
        try {
            // Validate input
            if (!bookId || bookId <= 0) {
                Toast.error('ID sách không hợp lệ');
                return { success: false };
            }

            if (!quantity || quantity <= 0) {
                Toast.error('Số lượng phải lớn hơn 0');
                return { success: false };
            }

            // Show loading toast
            const loadingToast = Toast.info('Đang thêm vào giỏ hàng...', 0);

            const response = await fetch('/BookVerse/add-to-cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    bookId: bookId.toString(),
                    quantity: quantity.toString()
                })
            });

            // Remove loading toast
            if (loadingToast) {
                loadingToast.remove();
            }

            const data = await response.json();

            if (response.ok && data.success) {
                Toast.success(data.message || 'Đã thêm vào giỏ hàng thành công');

                // Update cart count badge
                await this.updateCartCount();

                return data;
            } else {
                Toast.error(data.message || 'Không thể thêm vào giỏ hàng');
                return { success: false, message: data.message };
            }

        } catch (error) {
            console.error('Error adding to cart:', error);
            Toast.error('Có lỗi xảy ra khi thêm vào giỏ hàng');
            return { success: false, error: error.message };
        }
    },

    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     * @param {number} cartId - ID của cart item
     * @param {number} quantity - Số lượng mới
     * @returns {Promise<object>} Response data
     */
    async updateCartItem(cartId, quantity) {
        try {
            // Validate input
            if (!cartId || cartId <= 0) {
                Toast.error('ID giỏ hàng không hợp lệ');
                return { success: false };
            }

            if (!quantity || quantity < 0) {
                Toast.error('Số lượng không hợp lệ');
                return { success: false };
            }

            // Nếu quantity = 0, xóa item
            if (quantity === 0) {
                return await this.removeCartItem(cartId);
            }

            // Show loading state
            const cartRow = document.querySelector(`[data-cart-id="${cartId}"]`);
            if (cartRow) {
                cartRow.classList.add('opacity-50', 'pointer-events-none');
            }

            const response = await fetch('/BookVerse/update-cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    cartId: cartId.toString(),
                    quantity: quantity.toString()
                })
            });

            const data = await response.json();

            // Remove loading state
            if (cartRow) {
                cartRow.classList.remove('opacity-50', 'pointer-events-none');
            }

            if (response.ok && data.success) {
                // Update subtotal in UI
                if (cartRow && data.subtotal) {
                    const subtotalElement = cartRow.querySelector('.item-subtotal');
                    if (subtotalElement) {
                        subtotalElement.textContent = this.formatCurrency(data.subtotal);
                    }
                }

                // Update total price
                if (data.totalPrice) {
                    const totalElement = document.querySelector('.total-price');
                    if (totalElement) {
                        totalElement.textContent = this.formatCurrency(data.totalPrice);
                    }
                }

                Toast.success('Đã cập nhật giỏ hàng');

                // Update cart count
                await this.updateCartCount();

                return data;
            } else {
                Toast.error(data.message || 'Không thể cập nhật giỏ hàng');
                return { success: false, message: data.message };
            }

        } catch (error) {
            console.error('Error updating cart:', error);
            Toast.error('Có lỗi xảy ra khi cập nhật giỏ hàng');

            // Remove loading state on error
            const cartRow = document.querySelector(`[data-cart-id="${cartId}"]`);
            if (cartRow) {
                cartRow.classList.remove('opacity-50', 'pointer-events-none');
            }

            return { success: false, error: error.message };
        }
    },

    /**
     * Xóa sản phẩm khỏi giỏ hàng
     * @param {number} cartId - ID của cart item
     * @returns {Promise<object>} Response data
     */
    async removeCartItem(cartId) {
        try {
            // Validate input
            if (!cartId || cartId <= 0) {
                Toast.error('ID giỏ hàng không hợp lệ');
                return { success: false };
            }

            // Confirm dialog
            const confirmed = await this.confirmRemove();
            if (!confirmed) {
                return { success: false, cancelled: true };
            }

            const response = await fetch('/BookVerse/remove-from-cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    cartId: cartId.toString()
                })
            });

            const data = await response.json();

            if (response.ok && data.success) {
                // Remove from DOM with animation
                const cartRow = document.querySelector(`[data-cart-id="${cartId}"]`);
                if (cartRow) {
                    cartRow.style.transition = 'all 0.3s ease';
                    cartRow.style.opacity = '0';
                    cartRow.style.transform = 'translateX(100px)';

                    setTimeout(() => {
                        cartRow.remove();

                        // Check if cart is empty
                        this.checkEmptyCart();
                    }, 300);
                }

                // Recalculate total
                if (data.totalPrice !== undefined) {
                    const totalElement = document.querySelector('.total-price');
                    if (totalElement) {
                        totalElement.textContent = this.formatCurrency(data.totalPrice);
                    }
                }

                Toast.success('Đã xóa sản phẩm khỏi giỏ hàng');

                // Update cart count
                await this.updateCartCount();

                return data;
            } else {
                Toast.error(data.message || 'Không thể xóa sản phẩm');
                return { success: false, message: data.message };
            }

        } catch (error) {
            console.error('Error removing cart item:', error);
            Toast.error('Có lỗi xảy ra khi xóa sản phẩm');
            return { success: false, error: error.message };
        }
    },

    /**
     * Hiển thị confirm dialog khi xóa
     * @returns {Promise<boolean>} User's confirmation
     */
    confirmRemove() {
        return new Promise((resolve) => {
            // Tạo custom modal confirm (không dùng alert)
            const modal = document.createElement('div');
            modal.className = 'fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50';
            modal.innerHTML = `
                <div class="bg-white rounded-lg shadow-lg p-6 max-w-md w-full mx-4 transform transition-all">
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Xác nhận xóa</h3>
                    <p class="text-sm text-gray-600 mb-6">Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?</p>
                    <div class="flex items-center justify-end gap-3">
                        <button class="btn-cancel px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200 transition-colors">
                            Hủy
                        </button>
                        <button class="btn-confirm px-4 py-2 text-sm font-medium text-white bg-red-500 rounded-md hover:bg-red-600 transition-colors">
                            Xóa
                        </button>
                    </div>
                </div>
            `;

            document.body.appendChild(modal);

            // Animation
            setTimeout(() => {
                modal.style.opacity = '1';
            }, 10);

            // Event listeners
            const btnCancel = modal.querySelector('.btn-cancel');
            const btnConfirm = modal.querySelector('.btn-confirm');

            const cleanup = (result) => {
                modal.style.opacity = '0';
                setTimeout(() => {
                    modal.remove();
                }, 200);
                resolve(result);
            };

            btnCancel.addEventListener('click', () => cleanup(false));
            btnConfirm.addEventListener('click', () => cleanup(true));
            modal.addEventListener('click', (e) => {
                if (e.target === modal) cleanup(false);
            });
        });
    },

    /**
     * Kiểm tra và hiển thị thông báo nếu giỏ hàng trống
     */
    checkEmptyCart() {
        const cartItems = document.querySelectorAll('[data-cart-id]');

        if (cartItems.length === 0) {
            const cartContainer = document.querySelector('.cart-items-container');
            if (cartContainer) {
                cartContainer.innerHTML = `
                    <div class="text-center py-12">
                        <svg class="w-24 h-24 mx-auto text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path>
                        </svg>
                        <p class="text-lg font-medium text-gray-900 mb-2">Giỏ hàng trống</p>
                        <p class="text-sm text-gray-600 mb-6">Bạn chưa có sản phẩm nào trong giỏ hàng</p>
                        <a href="/BookVerse/books" class="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700 transition-colors">
                            Tiếp tục mua sắm
                        </a>
                    </div>
                `;
            }

            // Hide checkout section
            const checkoutSection = document.querySelector('.checkout-section');
            if (checkoutSection) {
                checkoutSection.classList.add('hidden');
            }
        }
    },

    /**
     * Format số tiền theo VND
     * @param {number} amount - Số tiền
     * @returns {string} Formatted currency string
     */
    formatCurrency(amount) {
        if (amount === null || amount === undefined || isNaN(amount)) {
            return '0₫';
        }

        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND',
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(amount);
    }
};

// Expose to global scope
window.Cart = Cart;

// Initialize cart count on page load
document.addEventListener('DOMContentLoaded', () => {
    Cart.updateCartCount();
});
