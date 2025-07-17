/**
 * Reusable Components for Professional Muslim Web App
 * Author: Ahmed Mostafa Ibrahim
 */

class UIComponents {
    constructor() {
        this.notifications = [];
        this.modals = new Map();
    }

    // Notification System
    showNotification(message, type = 'info', duration = 5000) {
        const notification = this.createNotification(message, type);
        document.body.appendChild(notification);
        
        // Auto remove after duration
        setTimeout(() => {
            this.removeNotification(notification);
        }, duration);
        
        return notification;
    }

    createNotification(message, type) {
        const notification = document.createElement('div');
        notification.className = `alert alert-${type} alert-dismissible fade show notification`;
        notification.innerHTML = `
            <div class="d-flex align-items-center">
                <i class="fas ${this.getNotificationIcon(type)} me-2"></i>
                <span>${message}</span>
            </div>
            <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
        `;
        
        // Add to notifications array
        this.notifications.push(notification);
        
        return notification;
    }

    getNotificationIcon(type) {
        const icons = {
            success: 'fa-check-circle',
            error: 'fa-exclamation-circle',
            warning: 'fa-exclamation-triangle',
            info: 'fa-info-circle'
        };
        return icons[type] || icons.info;
    }

    removeNotification(notification) {
        if (notification && notification.parentElement) {
            notification.classList.add('fade-out');
            setTimeout(() => {
                notification.remove();
                this.notifications = this.notifications.filter(n => n !== notification);
            }, 300);
        }
    }

    // Modal System
    createModal(id, title, content, options = {}) {
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.id = id;
        modal.setAttribute('tabindex', '-1');
        modal.innerHTML = `
            <div class="modal-dialog ${options.size || ''}">
                <div class="modal-content">
                    <div class="modal-header bg-islamic text-white">
                        <h5 class="modal-title">${title}</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        ${content}
                    </div>
                    ${options.footer ? `<div class="modal-footer">${options.footer}</div>` : ''}
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        this.modals.set(id, modal);
        
        return modal;
    }

    showModal(id) {
        const modal = this.modals.get(id);
        if (modal) {
            const bsModal = new bootstrap.Modal(modal);
            bsModal.show();
        }
    }

    hideModal(id) {
        const modal = this.modals.get(id);
        if (modal) {
            const bsModal = bootstrap.Modal.getInstance(modal);
            if (bsModal) {
                bsModal.hide();
            }
        }
    }

    // Loading Spinner
    showLoading(container, message = 'جاري التحميل...') {
        const loading = document.createElement('div');
        loading.className = 'text-center py-5 loading-container';
        loading.innerHTML = `
            <div class="spinner-border text-islamic mb-3" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="text-muted">${message}</p>
        `;
        
        if (typeof container === 'string') {
            container = document.getElementById(container);
        }
        
        container.innerHTML = '';
        container.appendChild(loading);
        
        return loading;
    }

    hideLoading(container) {
        if (typeof container === 'string') {
            container = document.getElementById(container);
        }
        
        const loading = container.querySelector('.loading-container');
        if (loading) {
            loading.remove();
        }
    }

    // Skeleton Loader
    createSkeleton(lines = 3, container) {
        const skeleton = document.createElement('div');
        skeleton.className = 'skeleton-container';
        
        for (let i = 0; i < lines; i++) {
            const line = document.createElement('div');
            line.className = `loading-skeleton ${i % 2 === 0 ? 'wide' : 'medium'}`;
            skeleton.appendChild(line);
        }
        
        if (container) {
            if (typeof container === 'string') {
                container = document.getElementById(container);
            }
            container.appendChild(skeleton);
        }
        
        return skeleton;
    }

    // Confirmation Dialog
    showConfirmDialog(message, onConfirm, onCancel = null) {
        const modalId = 'confirm-modal-' + Date.now();
        const modal = this.createModal(modalId, 'تأكيد', `
            <p class="mb-4">${message}</p>
        `, {
            footer: `
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
                <button type="button" class="btn btn-islamic" id="confirm-btn">تأكيد</button>
            `
        });
        
        // Add event listeners
        modal.querySelector('#confirm-btn').addEventListener('click', () => {
            if (onConfirm) onConfirm();
            this.hideModal(modalId);
        });
        
        modal.addEventListener('hidden.bs.modal', () => {
            if (onCancel) onCancel();
            modal.remove();
            this.modals.delete(modalId);
        });
        
        this.showModal(modalId);
    }

    // Progress Bar
    createProgressBar(container, value = 0, max = 100) {
        const progressContainer = document.createElement('div');
        progressContainer.className = 'progress mb-3';
        progressContainer.innerHTML = `
            <div class="progress-bar bg-islamic" role="progressbar" 
                 style="width: ${(value / max) * 100}%" 
                 aria-valuenow="${value}" 
                 aria-valuemin="0" 
                 aria-valuemax="${max}">
                ${Math.round((value / max) * 100)}%
            </div>
        `;
        
        if (container) {
            if (typeof container === 'string') {
                container = document.getElementById(container);
            }
            container.appendChild(progressContainer);
        }
        
        return progressContainer;
    }

    updateProgressBar(progressBar, value, max = 100) {
        const bar = progressBar.querySelector('.progress-bar');
        const percentage = Math.round((value / max) * 100);
        
        bar.style.width = `${percentage}%`;
        bar.setAttribute('aria-valuenow', value);
        bar.textContent = `${percentage}%`;
    }

    // Tooltip System
    initializeTooltips() {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }

    // Card Component
    createCard(title, content, options = {}) {
        const card = document.createElement('div');
        card.className = `card card-islamic ${options.className || ''}`;
        
        let cardHTML = '';
        
        if (title) {
            cardHTML += `
                <div class="card-header-islamic">
                    <h5 class="mb-0">
                        ${options.icon ? `<i class="${options.icon} me-2"></i>` : ''}
                        ${title}
                    </h5>
                </div>
            `;
        }
        
        cardHTML += `<div class="card-body">${content}</div>`;
        
        if (options.footer) {
            cardHTML += `<div class="card-footer">${options.footer}</div>`;
        }
        
        card.innerHTML = cardHTML;
        return card;
    }

    // Badge Component
    createBadge(text, type = 'primary') {
        const badge = document.createElement('span');
        badge.className = `badge bg-${type}`;
        badge.textContent = text;
        return badge;
    }

    // Button Component
    createButton(text, onClick, options = {}) {
        const button = document.createElement('button');
        button.className = `btn ${options.variant || 'btn-islamic'} ${options.size || ''} ${options.className || ''}`;
        button.innerHTML = `
            ${options.icon ? `<i class="${options.icon} me-2"></i>` : ''}
            ${text}
        `;
        
        if (onClick) {
            button.addEventListener('click', onClick);
        }
        
        if (options.disabled) {
            button.disabled = true;
        }
        
        return button;
    }

    // Input Group Component
    createInputGroup(label, inputType = 'text', options = {}) {
        const group = document.createElement('div');
        group.className = 'mb-3';
        
        group.innerHTML = `
            <label class="form-label">${label}</label>
            <div class="input-group">
                ${options.prepend ? `<span class="input-group-text">${options.prepend}</span>` : ''}
                <input type="${inputType}" class="form-control" 
                       placeholder="${options.placeholder || ''}"
                       ${options.required ? 'required' : ''}
                       ${options.id ? `id="${options.id}"` : ''}>
                ${options.append ? `<span class="input-group-text">${options.append}</span>` : ''}
            </div>
        `;
        
        return group;
    }

    // Alert Component
    createAlert(message, type = 'info', dismissible = true) {
        const alert = document.createElement('div');
        alert.className = `alert alert-${type} ${dismissible ? 'alert-dismissible fade show' : ''}`;
        alert.innerHTML = `
            <i class="fas ${this.getNotificationIcon(type)} me-2"></i>
            ${message}
            ${dismissible ? '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' : ''}
        `;
        
        return alert;
    }

    // Accordion Component
    createAccordion(items, id = 'accordion-' + Date.now()) {
        const accordion = document.createElement('div');
        accordion.className = 'accordion';
        accordion.id = id;
        
        items.forEach((item, index) => {
            const itemId = `${id}-item-${index}`;
            const collapseId = `${id}-collapse-${index}`;
            
            const accordionItem = document.createElement('div');
            accordionItem.className = 'accordion-item';
            accordionItem.innerHTML = `
                <h2 class="accordion-header" id="${itemId}">
                    <button class="accordion-button ${index === 0 ? '' : 'collapsed'}" 
                            type="button" 
                            data-bs-toggle="collapse" 
                            data-bs-target="#${collapseId}">
                        ${item.title}
                    </button>
                </h2>
                <div id="${collapseId}" 
                     class="accordion-collapse collapse ${index === 0 ? 'show' : ''}" 
                     data-bs-parent="#${id}">
                    <div class="accordion-body">
                        ${item.content}
                    </div>
                </div>
            `;
            
            accordion.appendChild(accordionItem);
        });
        
        return accordion;
    }

    // Utility Methods
    fadeIn(element, duration = 300) {
        element.style.opacity = '0';
        element.style.display = 'block';
        
        let start = null;
        const animate = (timestamp) => {
            if (!start) start = timestamp;
            const progress = timestamp - start;
            
            element.style.opacity = Math.min(progress / duration, 1);
            
            if (progress < duration) {
                requestAnimationFrame(animate);
            }
        };
        
        requestAnimationFrame(animate);
    }

    fadeOut(element, duration = 300) {
        let start = null;
        const animate = (timestamp) => {
            if (!start) start = timestamp;
            const progress = timestamp - start;
            
            element.style.opacity = Math.max(1 - (progress / duration), 0);
            
            if (progress < duration) {
                requestAnimationFrame(animate);
            } else {
                element.style.display = 'none';
            }
        };
        
        requestAnimationFrame(animate);
    }

    // Cleanup method
    cleanup() {
        // Remove all notifications
        this.notifications.forEach(notification => {
            if (notification.parentElement) {
                notification.remove();
            }
        });
        this.notifications = [];
        
        // Remove all modals
        this.modals.forEach((modal, id) => {
            modal.remove();
        });
        this.modals.clear();
    }
}

// Initialize global UI components
window.UI = new UIComponents();

// Initialize tooltips when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.UI.initializeTooltips();
});
