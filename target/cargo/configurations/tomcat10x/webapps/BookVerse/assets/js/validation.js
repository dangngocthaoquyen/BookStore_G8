/**
 * Validation System
 * Hệ thống validation cho forms với real-time feedback
 */

const Validation = {
    /**
     * Validate email format
     * @param {string} email - Email cần validate
     * @returns {boolean} Valid or not
     */
    validateEmail(email) {
        if (!email || typeof email !== 'string') {
            return false;
        }

        // RFC 5322 compliant email regex (simplified)
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email.trim());
    },

    /**
     * Validate số điện thoại Việt Nam
     * @param {string} phone - Số điện thoại
     * @returns {boolean} Valid or not
     */
    validatePhone(phone) {
        if (!phone || typeof phone !== 'string') {
            return false;
        }

        // Remove spaces and special characters
        const cleanPhone = phone.replace(/[\s\-\(\)]/g, '');

        // Vietnamese phone patterns:
        // - 10 digits: 0xxxxxxxxx
        // - With country code: +84xxxxxxxxx or 84xxxxxxxxx
        const phoneRegex = /^(0|\+?84)(3|5|7|8|9)[0-9]{8}$/;

        return phoneRegex.test(cleanPhone);
    },

    /**
     * Validate password strength
     * @param {string} password - Password cần validate
     * @returns {object} {valid: boolean, message: string, strength: 'weak'|'medium'|'strong'}
     */
    validatePassword(password) {
        if (!password || typeof password !== 'string') {
            return {
                valid: false,
                message: 'Mật khẩu không được để trống',
                strength: 'weak'
            };
        }

        const minLength = 8;
        const maxLength = 50;

        // Check length
        if (password.length < minLength) {
            return {
                valid: false,
                message: `Mật khẩu phải có ít nhất ${minLength} ký tự`,
                strength: 'weak'
            };
        }

        if (password.length > maxLength) {
            return {
                valid: false,
                message: `Mật khẩu không được vượt quá ${maxLength} ký tự`,
                strength: 'weak'
            };
        }

        // Check strength
        let strength = 0;
        const checks = {
            lowercase: /[a-z]/.test(password),
            uppercase: /[A-Z]/.test(password),
            number: /[0-9]/.test(password),
            special: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)
        };

        // Calculate strength
        if (checks.lowercase) strength++;
        if (checks.uppercase) strength++;
        if (checks.number) strength++;
        if (checks.special) strength++;

        let strengthLevel = 'weak';
        let message = 'Mật khẩu hợp lệ';

        if (strength >= 4) {
            strengthLevel = 'strong';
            message = 'Mật khẩu mạnh';
        } else if (strength >= 3) {
            strengthLevel = 'medium';
            message = 'Mật khẩu trung bình';
        } else if (strength >= 2) {
            strengthLevel = 'weak';
            message = 'Mật khẩu yếu - nên thêm chữ hoa, số và ký tự đặc biệt';
        } else {
            return {
                valid: false,
                message: 'Mật khẩu quá yếu - cần có chữ thường, chữ hoa, số và ký tự đặc biệt',
                strength: 'weak'
            };
        }

        return {
            valid: true,
            message: message,
            strength: strengthLevel
        };
    },

    /**
     * Validate trường bắt buộc
     * @param {string} value - Giá trị cần validate
     * @returns {boolean} Valid or not
     */
    validateRequired(value) {
        if (value === null || value === undefined) {
            return false;
        }

        if (typeof value === 'string') {
            return value.trim().length > 0;
        }

        if (typeof value === 'number') {
            return !isNaN(value);
        }

        if (Array.isArray(value)) {
            return value.length > 0;
        }

        return true;
    },

    /**
     * Validate độ dài chuỗi
     * @param {string} value - Giá trị cần validate
     * @param {number} min - Độ dài tối thiểu
     * @param {number} max - Độ dài tối đa
     * @returns {object} {valid: boolean, message: string}
     */
    validateLength(value, min = 0, max = Infinity) {
        if (!value || typeof value !== 'string') {
            return {
                valid: false,
                message: 'Giá trị không hợp lệ'
            };
        }

        const length = value.trim().length;

        if (length < min) {
            return {
                valid: false,
                message: `Độ dài tối thiểu là ${min} ký tự`
            };
        }

        if (length > max) {
            return {
                valid: false,
                message: `Độ dài tối đa là ${max} ký tự`
            };
        }

        return {
            valid: true,
            message: 'Độ dài hợp lệ'
        };
    },

    /**
     * Validate số trong khoảng
     * @param {string|number} value - Giá trị cần validate
     * @param {number} min - Giá trị tối thiểu
     * @param {number} max - Giá trị tối đa
     * @returns {object} {valid: boolean, message: string}
     */
    validateNumber(value, min = -Infinity, max = Infinity) {
        const num = parseFloat(value);

        if (isNaN(num)) {
            return {
                valid: false,
                message: 'Giá trị phải là số'
            };
        }

        if (num < min) {
            return {
                valid: false,
                message: `Giá trị tối thiểu là ${min}`
            };
        }

        if (num > max) {
            return {
                valid: false,
                message: `Giá trị tối đa là ${max}`
            };
        }

        return {
            valid: true,
            message: 'Giá trị hợp lệ'
        };
    },

    /**
     * Hiển thị error message bên dưới field
     * @param {string} fieldId - ID của field
     * @param {string} message - Error message
     */
    showFieldError(fieldId, message) {
        const field = document.getElementById(fieldId);

        if (!field) {
            console.warn(`Field ${fieldId} not found`);
            return;
        }

        // Clear existing error
        this.clearFieldError(fieldId);

        // Add error class to field
        field.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
        field.classList.remove('border-gray-300', 'focus:border-blue-500', 'focus:ring-blue-500');

        // Create error message element
        const errorElement = document.createElement('p');
        errorElement.id = `${fieldId}-error`;
        errorElement.className = 'mt-1 text-sm text-red-600';
        errorElement.textContent = message;

        // Insert after field
        field.parentElement.appendChild(errorElement);

        // Add shake animation
        field.style.animation = 'shake 0.3s';
        setTimeout(() => {
            field.style.animation = '';
        }, 300);
    },

    /**
     * Xóa error message của field
     * @param {string} fieldId - ID của field
     */
    clearFieldError(fieldId) {
        const field = document.getElementById(fieldId);

        if (!field) {
            return;
        }

        // Remove error class
        field.classList.remove('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
        field.classList.add('border-gray-300', 'focus:border-blue-500', 'focus:ring-blue-500');

        // Remove error message
        const errorElement = document.getElementById(`${fieldId}-error`);
        if (errorElement) {
            errorElement.remove();
        }
    },

    /**
     * Validate tất cả fields trong form
     * @param {string} formId - ID của form
     * @returns {boolean} Valid or not
     */
    validateFormFields(formId) {
        const form = document.getElementById(formId);

        if (!form) {
            console.warn(`Form ${formId} not found`);
            return false;
        }

        let isValid = true;
        const fields = form.querySelectorAll('input, select, textarea');

        fields.forEach(field => {
            if (!this.validateField(field)) {
                isValid = false;
            }
        });

        return isValid;
    },

    /**
     * Validate một field dựa vào attributes
     * @param {HTMLElement} field - Field element
     * @returns {boolean} Valid or not
     */
    validateField(field) {
        const fieldId = field.id;
        const fieldValue = field.value;
        const fieldType = field.type;

        // Clear previous error
        this.clearFieldError(fieldId);

        // Required validation
        if (field.hasAttribute('required')) {
            if (!this.validateRequired(fieldValue)) {
                this.showFieldError(fieldId, 'Trường này là bắt buộc');
                return false;
            }
        }

        // Email validation
        if (fieldType === 'email' || field.hasAttribute('data-validate-email')) {
            if (fieldValue && !this.validateEmail(fieldValue)) {
                this.showFieldError(fieldId, 'Email không hợp lệ');
                return false;
            }
        }

        // Phone validation
        if (fieldType === 'tel' || field.hasAttribute('data-validate-phone')) {
            if (fieldValue && !this.validatePhone(fieldValue)) {
                this.showFieldError(fieldId, 'Số điện thoại không hợp lệ');
                return false;
            }
        }

        // Password validation
        if (fieldType === 'password' || field.hasAttribute('data-validate-password')) {
            if (fieldValue) {
                const result = this.validatePassword(fieldValue);
                if (!result.valid) {
                    this.showFieldError(fieldId, result.message);
                    return false;
                }

                // Show password strength indicator
                this.showPasswordStrength(fieldId, result.strength);
            }
        }

        // Length validation
        const minLength = field.getAttribute('minlength');
        const maxLength = field.getAttribute('maxlength');

        if (fieldValue && (minLength || maxLength)) {
            const result = this.validateLength(
                fieldValue,
                minLength ? parseInt(minLength) : 0,
                maxLength ? parseInt(maxLength) : Infinity
            );

            if (!result.valid) {
                this.showFieldError(fieldId, result.message);
                return false;
            }
        }

        // Number validation
        if (fieldType === 'number') {
            const min = field.getAttribute('min');
            const max = field.getAttribute('max');

            if (fieldValue) {
                const result = this.validateNumber(
                    fieldValue,
                    min ? parseFloat(min) : -Infinity,
                    max ? parseFloat(max) : Infinity
                );

                if (!result.valid) {
                    this.showFieldError(fieldId, result.message);
                    return false;
                }
            }
        }

        // Confirm password validation
        if (field.hasAttribute('data-confirm-password')) {
            const passwordFieldId = field.getAttribute('data-confirm-password');
            const passwordField = document.getElementById(passwordFieldId);

            if (passwordField && fieldValue !== passwordField.value) {
                this.showFieldError(fieldId, 'Mật khẩu xác nhận không khớp');
                return false;
            }
        }

        return true;
    },

    /**
     * Hiển thị password strength indicator
     * @param {string} fieldId - ID của password field
     * @param {string} strength - 'weak', 'medium', 'strong'
     */
    showPasswordStrength(fieldId, strength) {
        const field = document.getElementById(fieldId);

        if (!field) {
            return;
        }

        // Remove existing indicator
        let indicator = document.getElementById(`${fieldId}-strength`);

        if (!indicator) {
            indicator = document.createElement('div');
            indicator.id = `${fieldId}-strength`;
            indicator.className = 'mt-2';
            field.parentElement.appendChild(indicator);
        }

        const colors = {
            weak: 'bg-red-500',
            medium: 'bg-yellow-500',
            strong: 'bg-green-500'
        };

        const labels = {
            weak: 'Yếu',
            medium: 'Trung bình',
            strong: 'Mạnh'
        };

        const widths = {
            weak: 'w-1/3',
            medium: 'w-2/3',
            strong: 'w-full'
        };

        indicator.innerHTML = `
            <div class="flex items-center gap-2">
                <div class="flex-1 h-2 bg-gray-200 rounded-full overflow-hidden">
                    <div class="${colors[strength]} ${widths[strength]} h-full transition-all duration-300"></div>
                </div>
                <span class="text-xs font-medium ${colors[strength].replace('bg-', 'text-')}">${labels[strength]}</span>
            </div>
        `;
    },

    /**
     * Setup real-time validation cho form
     * @param {string} formId - ID của form
     */
    setupRealTimeValidation(formId) {
        const form = document.getElementById(formId);

        if (!form) {
            console.warn(`Form ${formId} not found`);
            return;
        }

        const fields = form.querySelectorAll('input, select, textarea');

        fields.forEach(field => {
            // Validate on blur
            field.addEventListener('blur', () => {
                if (field.value) {
                    this.validateField(field);
                }
            });

            // Clear error on focus
            field.addEventListener('focus', () => {
                if (field.id) {
                    this.clearFieldError(field.id);
                }
            });

            // Real-time validation for certain fields
            if (field.type === 'email' || field.type === 'password' || field.hasAttribute('data-validate-phone')) {
                field.addEventListener('input', () => {
                    if (field.value) {
                        // Debounce validation
                        clearTimeout(field.validationTimeout);
                        field.validationTimeout = setTimeout(() => {
                            this.validateField(field);
                        }, 500);
                    } else {
                        this.clearFieldError(field.id);
                    }
                });
            }
        });

        // Validate on submit
        form.addEventListener('submit', (e) => {
            if (!this.validateFormFields(formId)) {
                e.preventDefault();
                Toast.error('Vui lòng kiểm tra lại thông tin đã nhập');
            }
        });
    }
};

// Expose to global scope
window.Validation = Validation;

// Add shake animation CSS
if (!document.getElementById('validation-styles')) {
    const style = document.createElement('style');
    style.id = 'validation-styles';
    style.textContent = `
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
    `;
    document.head.appendChild(style);
}

// Auto-setup validation for forms with data-validate attribute
document.addEventListener('DOMContentLoaded', () => {
    const formsToValidate = document.querySelectorAll('form[data-validate]');

    formsToValidate.forEach(form => {
        if (form.id) {
            Validation.setupRealTimeValidation(form.id);
        }
    });
});
