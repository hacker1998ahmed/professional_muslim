/**
 * Utility Functions for Professional Muslim Web App
 * Author: Ahmed Mostafa Ibrahim
 */

class Utils {
    constructor() {
        this.arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
        this.englishNumerals = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    }

    // Date and Time Utilities
    formatArabicDate(date = new Date()) {
        return date.toLocaleDateString('ar-SA', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    }

    formatArabicTime(date = new Date(), format24 = false) {
        return date.toLocaleTimeString('ar-SA', {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: !format24
        });
    }

    getHijriDate(date = new Date()) {
        // Simplified Hijri date calculation
        // In a real app, you'd use a proper Hijri calendar library
        const hijriMonths = [
            'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
            'جمادى الأولى', 'جمادى الثانية', 'رجب', 'شعبان',
            'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
        ];
        
        // This is a placeholder - use a proper Hijri calendar library
        const hijriYear = 1445;
        const hijriMonth = Math.floor(Math.random() * 12);
        const hijriDay = Math.floor(Math.random() * 29) + 1;
        
        return `${hijriDay} ${hijriMonths[hijriMonth]} ${hijriYear}`;
    }

    // Number Utilities
    toArabicNumerals(text) {
        return text.toString().replace(/[0-9]/g, (match) => {
            return this.arabicNumerals[parseInt(match)];
        });
    }

    toEnglishNumerals(text) {
        return text.toString().replace(/[٠-٩]/g, (match) => {
            return this.englishNumerals[this.arabicNumerals.indexOf(match)];
        });
    }

    formatNumber(number, locale = 'ar-SA') {
        return new Intl.NumberFormat(locale).format(number);
    }

    // String Utilities
    removeArabicDiacritics(text) {
        return text.replace(/[\u064B-\u0652\u0670\u0640]/g, '');
    }

    normalizeArabicText(text) {
        return text
            .replace(/[أإآ]/g, 'ا')
            .replace(/[ة]/g, 'ه')
            .replace(/[ي]/g, 'ى')
            .trim();
    }

    highlightSearchTerm(text, searchTerm) {
        if (!searchTerm) return text;
        
        const regex = new RegExp(`(${searchTerm})`, 'gi');
        return text.replace(regex, '<mark>$1</mark>');
    }

    // Storage Utilities
    saveToLocalStorage(key, data) {
        try {
            localStorage.setItem(key, JSON.stringify(data));
            return true;
        } catch (error) {
            console.error('Error saving to localStorage:', error);
            return false;
        }
    }

    loadFromLocalStorage(key, defaultValue = null) {
        try {
            const data = localStorage.getItem(key);
            return data ? JSON.parse(data) : defaultValue;
        } catch (error) {
            console.error('Error loading from localStorage:', error);
            return defaultValue;
        }
    }

    clearLocalStorage(key) {
        try {
            localStorage.removeItem(key);
            return true;
        } catch (error) {
            console.error('Error clearing localStorage:', error);
            return false;
        }
    }

    // Geolocation Utilities
    async getCurrentLocation() {
        return new Promise((resolve, reject) => {
            if (!navigator.geolocation) {
                reject(new Error('Geolocation is not supported'));
                return;
            }

            navigator.geolocation.getCurrentPosition(
                (position) => {
                    resolve({
                        latitude: position.coords.latitude,
                        longitude: position.coords.longitude,
                        accuracy: position.coords.accuracy
                    });
                },
                (error) => {
                    reject(error);
                },
                {
                    enableHighAccuracy: true,
                    timeout: 10000,
                    maximumAge: 300000 // 5 minutes
                }
            );
        });
    }

    calculateDistance(lat1, lon1, lat2, lon2) {
        const R = 6371; // Earth's radius in kilometers
        const dLat = this.toRadians(lat2 - lat1);
        const dLon = this.toRadians(lon2 - lon1);
        
        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                  Math.cos(this.toRadians(lat1)) * Math.cos(this.toRadians(lat2)) *
                  Math.sin(dLon / 2) * Math.sin(dLon / 2);
        
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    toRadians(degrees) {
        return degrees * (Math.PI / 180);
    }

    // Prayer Time Utilities
    calculateQiblaDirection(latitude, longitude) {
        // Kaaba coordinates
        const kaabaLat = 21.4225;
        const kaabaLon = 39.8262;
        
        const dLon = this.toRadians(kaabaLon - longitude);
        const lat1 = this.toRadians(latitude);
        const lat2 = this.toRadians(kaabaLat);
        
        const y = Math.sin(dLon) * Math.cos(lat2);
        const x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);
        
        let bearing = Math.atan2(y, x);
        bearing = (bearing * 180 / Math.PI + 360) % 360;
        
        return Math.round(bearing);
    }

    getNextPrayerTime(prayerTimes) {
        const now = new Date();
        const currentTime = now.getHours() * 60 + now.getMinutes();
        
        const prayers = [
            { name: 'الفجر', time: prayerTimes.fajr },
            { name: 'الظهر', time: prayerTimes.dhuhr },
            { name: 'العصر', time: prayerTimes.asr },
            { name: 'المغرب', time: prayerTimes.maghrib },
            { name: 'العشاء', time: prayerTimes.isha }
        ];
        
        for (let prayer of prayers) {
            const [hours, minutes] = prayer.time.split(':').map(Number);
            const prayerTime = hours * 60 + minutes;
            
            if (prayerTime > currentTime) {
                return {
                    name: prayer.name,
                    time: prayer.time,
                    remaining: this.calculateTimeRemaining(prayerTime - currentTime)
                };
            }
        }
        
        // If no prayer found today, return Fajr of next day
        return {
            name: 'الفجر',
            time: prayerTimes.fajr,
            remaining: this.calculateTimeRemaining((24 * 60) - currentTime + this.timeToMinutes(prayerTimes.fajr))
        };
    }

    timeToMinutes(timeString) {
        const [hours, minutes] = timeString.split(':').map(Number);
        return hours * 60 + minutes;
    }

    calculateTimeRemaining(minutes) {
        const hours = Math.floor(minutes / 60);
        const mins = minutes % 60;
        return `${hours}:${mins.toString().padStart(2, '0')}`;
    }

    // Validation Utilities
    isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    isValidPhoneNumber(phone) {
        const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/;
        return phoneRegex.test(phone.replace(/\s/g, ''));
    }

    isValidArabicText(text) {
        const arabicRegex = /^[\u0600-\u06FF\s\d\.\,\!\?\-\(\)]+$/;
        return arabicRegex.test(text);
    }

    // Animation Utilities
    animateNumber(element, start, end, duration = 1000) {
        const startTime = performance.now();
        const difference = end - start;
        
        const animate = (currentTime) => {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            
            const current = start + (difference * this.easeOutQuart(progress));
            element.textContent = Math.round(current);
            
            if (progress < 1) {
                requestAnimationFrame(animate);
            }
        };
        
        requestAnimationFrame(animate);
    }

    easeOutQuart(t) {
        return 1 - (--t) * t * t * t;
    }

    // Device Utilities
    isMobile() {
        return window.innerWidth <= 768;
    }

    isTablet() {
        return window.innerWidth > 768 && window.innerWidth <= 1024;
    }

    isDesktop() {
        return window.innerWidth > 1024;
    }

    supportsNotifications() {
        return 'Notification' in window;
    }

    supportsServiceWorker() {
        return 'serviceWorker' in navigator;
    }

    supportsGeolocation() {
        return 'geolocation' in navigator;
    }

    // Performance Utilities
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    }

    // Color Utilities
    hexToRgb(hex) {
        const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        return result ? {
            r: parseInt(result[1], 16),
            g: parseInt(result[2], 16),
            b: parseInt(result[3], 16)
        } : null;
    }

    rgbToHex(r, g, b) {
        return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
    }

    // URL Utilities
    getQueryParam(param) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(param);
    }

    setQueryParam(param, value) {
        const url = new URL(window.location);
        url.searchParams.set(param, value);
        window.history.pushState({}, '', url);
    }

    // Copy to Clipboard
    async copyToClipboard(text) {
        try {
            await navigator.clipboard.writeText(text);
            return true;
        } catch (error) {
            // Fallback for older browsers
            const textArea = document.createElement('textarea');
            textArea.value = text;
            document.body.appendChild(textArea);
            textArea.select();
            const success = document.execCommand('copy');
            document.body.removeChild(textArea);
            return success;
        }
    }

    // Random Utilities
    generateUUID() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            const r = Math.random() * 16 | 0;
            const v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    getRandomElement(array) {
        return array[Math.floor(Math.random() * array.length)];
    }

    shuffleArray(array) {
        const shuffled = [...array];
        for (let i = shuffled.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
        }
        return shuffled;
    }
}

// Initialize global utils
window.utils = new Utils();

// Export for module systems
if (typeof module !== 'undefined' && module.exports) {
    module.exports = Utils;
}
