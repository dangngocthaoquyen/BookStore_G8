/**
 * Admin Management System
 * Quản lý các chức năng admin: delete confirmation, sidebar, table operations
 */

const Admin = {
    /**
     * Xác nhận xóa với custom modal
     * @param {string} type - Loại item: 'book', 'category', 'order', 'user'
     * @param {number} id - ID của item
     * @param {string} name - Tên của item để hiển thị
     * @returns {Promise<boolean>} User's confirmation
     */
    confirmDelete(type, id, name) {
        return new Promise((resolve) => {
            // Map type to Vietnamese
            const typeNames = {
                'book': 'sách',
                'category': 'danh mục',
                'order': 'đơn hàng',
                'user': 'người dùng',
                'author': 'tác giả',
                'publisher': 'nhà xuất bản'
            };

            const typeName = typeNames[type] || 'mục';

            // Tạo custom modal
            const modal = document.createElement('div');
            modal.className = 'fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50';
            modal.innerHTML = `
                <div class="bg-white rounded-lg shadow-lg p-6 max-w-md w-full mx-4 transform transition-all scale-95 opacity-0" id="delete-modal-content">
                    <div class="flex items-start gap-4">
                        <div class="flex-shrink-0">
                            <svg class="w-12 h-12 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
                            </svg>
                        </div>
                        <div class="flex-1">
                            <h3 class="text-lg font-semibold text-gray-900 mb-2">Xác nhận xóa ${typeName}</h3>
                            <p class="text-sm text-gray-600 mb-4">
                                Bạn có chắc chắn muốn xóa ${typeName} <strong class="text-gray-900">"${name}"</strong> không?
                            </p>
                            <p class="text-sm text-red-600 font-medium">
                                Hành động này không thể hoàn tác!
                            </p>
                        </div>
                    </div>

                    <div class="flex items-center justify-end gap-3 mt-6">
                        <button class="btn-cancel px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200 transition-colors">
                            Hủy
                        </button>
                        <button class="btn-confirm px-4 py-2 text-sm font-medium text-white bg-red-500 rounded-md hover:bg-red-600 transition-colors">
                            Xóa ${typeName}
                        </button>
                    </div>
                </div>
            `;

            document.body.appendChild(modal);

            // Animation
            setTimeout(() => {
                const content = modal.querySelector('#delete-modal-content');
                if (content) {
                    content.style.opacity = '1';
                    content.style.transform = 'scale(1)';
                }
            }, 10);

            // Event listeners
            const btnCancel = modal.querySelector('.btn-cancel');
            const btnConfirm = modal.querySelector('.btn-confirm');

            const cleanup = (result) => {
                const content = modal.querySelector('#delete-modal-content');
                if (content) {
                    content.style.opacity = '0';
                    content.style.transform = 'scale(0.95)';
                }

                setTimeout(() => {
                    modal.remove();
                }, 200);

                resolve(result);
            };

            btnCancel.addEventListener('click', () => cleanup(false));
            btnConfirm.addEventListener('click', () => cleanup(true));

            // Click outside to close
            modal.addEventListener('click', (e) => {
                if (e.target === modal) cleanup(false);
            });

            // ESC key to close
            const escHandler = (e) => {
                if (e.key === 'Escape') {
                    cleanup(false);
                    document.removeEventListener('keydown', escHandler);
                }
            };
            document.addEventListener('keydown', escHandler);
        });
    },

    /**
     * Toggle sidebar trên mobile
     * Show/hide sidebar with animation
     */
    toggleSidebar() {
        const sidebar = document.querySelector('.sidebar');
        const overlay = document.querySelector('.sidebar-overlay');

        if (!sidebar) {
            console.warn('Sidebar not found');
            return;
        }

        const isOpen = sidebar.classList.contains('open');

        if (isOpen) {
            // Close sidebar
            sidebar.classList.remove('open');

            if (overlay) {
                overlay.classList.remove('active');
            }
        } else {
            // Open sidebar
            sidebar.classList.add('open');

            // Create overlay if not exists
            if (!overlay) {
                const newOverlay = document.createElement('div');
                newOverlay.className = 'sidebar-overlay fixed inset-0 bg-black bg-opacity-50 z-40 lg:hidden';
                newOverlay.addEventListener('click', () => this.toggleSidebar());
                document.body.appendChild(newOverlay);

                setTimeout(() => {
                    newOverlay.classList.add('active');
                }, 10);
            } else {
                overlay.classList.add('active');
            }
        }
    },

    /**
     * Filter table theo input search
     * Client-side table filtering
     * @param {string} inputId - ID của input search
     * @param {string} tableId - ID của table
     */
    filterTable(inputId, tableId) {
        const input = document.getElementById(inputId);
        const table = document.getElementById(tableId);

        if (!input || !table) {
            console.warn('Input or table not found');
            return;
        }

        const filter = input.value.toLowerCase().trim();
        const rows = table.querySelectorAll('tbody tr');

        let visibleCount = 0;

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();

            if (text.includes(filter)) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        // Show "No results" message
        this.showNoResultsMessage(table, visibleCount === 0, filter);
    },

    /**
     * Hiển thị thông báo không tìm thấy kết quả
     */
    showNoResultsMessage(table, show, query) {
        let noResultsRow = table.querySelector('.no-results-row');

        if (show) {
            if (!noResultsRow) {
                const tbody = table.querySelector('tbody');
                const colCount = table.querySelectorAll('thead th').length;

                noResultsRow = document.createElement('tr');
                noResultsRow.className = 'no-results-row';
                noResultsRow.innerHTML = `
                    <td colspan="${colCount}" class="px-6 py-12 text-center">
                        <svg class="w-16 h-16 mx-auto text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <p class="text-base font-medium text-gray-900 mb-1">Không tìm thấy kết quả</p>
                        <p class="text-sm text-gray-600">Không có dữ liệu nào khớp với từ khóa "${query}"</p>
                    </td>
                `;
                tbody.appendChild(noResultsRow);
            }
        } else {
            if (noResultsRow) {
                noResultsRow.remove();
            }
        }
    },

    /**
     * Sort table theo column
     * @param {number} columnIndex - Index của column cần sort (0-based)
     * @param {string} tableId - ID của table
     * @param {string} order - 'asc' hoặc 'desc' (optional, auto toggle nếu không truyền)
     */
    sortTable(columnIndex, tableId, order = null) {
        const table = document.getElementById(tableId);

        if (!table) {
            console.warn('Table not found');
            return;
        }

        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr:not(.no-results-row)'));

        // Get current sort order from header
        const headers = table.querySelectorAll('thead th');
        const currentHeader = headers[columnIndex];

        if (!order) {
            // Auto toggle
            if (currentHeader.classList.contains('sort-asc')) {
                order = 'desc';
            } else {
                order = 'asc';
            }
        }

        // Remove sort classes from all headers
        headers.forEach(header => {
            header.classList.remove('sort-asc', 'sort-desc');
        });

        // Add sort class to current header
        currentHeader.classList.add(`sort-${order}`);

        // Sort rows
        rows.sort((a, b) => {
            const aValue = a.cells[columnIndex]?.textContent.trim() || '';
            const bValue = b.cells[columnIndex]?.textContent.trim() || '';

            // Try to parse as number
            const aNum = parseFloat(aValue.replace(/[^\d.-]/g, ''));
            const bNum = parseFloat(bValue.replace(/[^\d.-]/g, ''));

            if (!isNaN(aNum) && !isNaN(bNum)) {
                // Sort as numbers
                return order === 'asc' ? aNum - bNum : bNum - aNum;
            } else {
                // Sort as strings
                return order === 'asc'
                    ? aValue.localeCompare(bValue, 'vi')
                    : bValue.localeCompare(aValue, 'vi');
            }
        });

        // Re-append sorted rows
        rows.forEach(row => tbody.appendChild(row));

        Toast.info(`Đã sắp xếp ${order === 'asc' ? 'tăng dần' : 'giảm dần'}`, 2000);
    },

    /**
     * Preview ảnh upload
     * @param {HTMLInputElement} input - Input file element
     * @param {string} previewId - ID của element preview (optional)
     */
    previewImage(input, previewId = 'image-preview') {
        if (!input.files || !input.files[0]) {
            return;
        }

        const file = input.files[0];

        // Validate file type
        if (!file.type.startsWith('image/')) {
            Toast.error('Vui lòng chọn file ảnh hợp lệ');
            input.value = '';
            return;
        }

        // Validate file size (max 5MB)
        if (file.size > 5 * 1024 * 1024) {
            Toast.error('Kích thước ảnh không được vượt quá 5MB');
            input.value = '';
            return;
        }

        const reader = new FileReader();

        reader.onload = (e) => {
            let preview = document.getElementById(previewId);

            if (!preview) {
                // Create preview element
                preview = document.createElement('div');
                preview.id = previewId;
                preview.className = 'mt-4';
                input.parentElement.appendChild(preview);
            }

            preview.innerHTML = `
                <div class="relative inline-block">
                    <img src="${e.target.result}" alt="Preview" class="w-48 h-48 object-cover rounded-lg border border-gray-200 shadow-sm">
                    <button type="button" class="absolute top-2 right-2 p-1 bg-red-500 text-white rounded-full hover:bg-red-600 transition-colors" onclick="Admin.removePreview('${previewId}', '${input.id}')">
                        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                        </svg>
                    </button>
                </div>
            `;

            Toast.success('Đã tải ảnh thành công');
        };

        reader.onerror = () => {
            Toast.error('Không thể đọc file ảnh');
        };

        reader.readAsDataURL(file);
    },

    /**
     * Remove image preview
     */
    removePreview(previewId, inputId) {
        const preview = document.getElementById(previewId);
        const input = document.getElementById(inputId);

        if (preview) {
            preview.remove();
        }

        if (input) {
            input.value = '';
        }

        Toast.info('Đã xóa ảnh preview');
    },

    /**
     * Validate form trước khi submit
     * @param {string} formId - ID của form
     * @returns {boolean} Valid or not
     */
    validateForm(formId) {
        const form = document.getElementById(formId);

        if (!form) {
            console.warn('Form not found');
            return false;
        }

        let isValid = true;
        const requiredFields = form.querySelectorAll('[required]');

        requiredFields.forEach(field => {
            // Clear previous errors
            if (window.Validation && typeof window.Validation.clearFieldError === 'function') {
                window.Validation.clearFieldError(field.id);
            }

            // Validate field
            if (!field.value.trim()) {
                isValid = false;

                if (window.Validation && typeof window.Validation.showFieldError === 'function') {
                    window.Validation.showFieldError(field.id, 'Trường này là bắt buộc');
                }
            }
        });

        // Use Validation.js if available
        if (window.Validation && typeof window.Validation.validateFormFields === 'function') {
            const validationResult = window.Validation.validateFormFields(formId);
            isValid = isValid && validationResult;
        }

        if (!isValid) {
            Toast.error('Vui lòng điền đầy đủ thông tin hợp lệ');
        }

        return isValid;
    },

    /**
     * Show loading state cho button
     */
    showButtonLoading(button, text = 'Đang xử lý...') {
        if (!button) return;

        button.dataset.originalText = button.innerHTML;
        button.disabled = true;
        button.innerHTML = `
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white inline-block" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            ${text}
        `;
    },

    /**
     * Hide loading state cho button
     */
    hideButtonLoading(button) {
        if (!button) return;

        button.disabled = false;

        if (button.dataset.originalText) {
            button.innerHTML = button.dataset.originalText;
            delete button.dataset.originalText;
        }
    }
};

// Expose to global scope
window.Admin = Admin;

// Auto-setup event listeners on page load
document.addEventListener('DOMContentLoaded', () => {
    // Setup mobile menu toggle
    const menuToggle = document.querySelector('[data-toggle="sidebar"]');
    if (menuToggle) {
        menuToggle.addEventListener('click', () => Admin.toggleSidebar());
    }

    // Setup search inputs
    const searchInputs = document.querySelectorAll('[data-table-search]');
    searchInputs.forEach(input => {
        const tableId = input.dataset.tableSearch;
        input.addEventListener('input', () => Admin.filterTable(input.id, tableId));
    });

    // Setup sortable headers
    const sortableHeaders = document.querySelectorAll('[data-sortable]');
    sortableHeaders.forEach((header, index) => {
        const tableId = header.closest('table').id;
        header.style.cursor = 'pointer';
        header.addEventListener('click', () => Admin.sortTable(index, tableId));
    });
});
