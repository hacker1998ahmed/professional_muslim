/**
 * Professional Muslim Web App - Main Application
 * Author: Ahmed Mostafa Ibrahim
 * Email: gogom8870@gmail.com
 */

class ProfessionalMuslimApp {
    constructor() {
        this.currentPage = 'home';
        this.theme = localStorage.getItem('theme') || 'light';
        this.settings = this.loadSettings();
        this.prayerTimes = {};
        this.currentLocation = null;
        
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.initializeTheme();
        this.hideLoadingScreen();
        this.loadHomePage();
        this.updateTime();
        this.requestLocationPermission();
        
        // Update time every second
        setInterval(() => this.updateTime(), 1000);
        
        // Update prayer times every hour
        setInterval(() => this.updatePrayerTimes(), 3600000);
    }

    setupEventListeners() {
        // Navigation links
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const page = e.target.getAttribute('href').substring(1);
                this.navigateTo(page);
            });
        });

        // Theme toggle
        const themeToggle = document.getElementById('theme-toggle');
        if (themeToggle) {
            themeToggle.addEventListener('click', () => this.toggleTheme());
        }

        // Keyboard navigation
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey || e.metaKey) {
                switch(e.key) {
                    case '1': this.navigateTo('home'); break;
                    case '2': this.navigateTo('azkar'); break;
                    case '3': this.navigateTo('prayer-times'); break;
                    case '4': this.navigateTo('tasbih'); break;
                    case '5': this.navigateTo('quran'); break;
                }
            }
        });

        // Service Worker messages
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.addEventListener('message', (event) => {
                if (event.data.type === 'PRAYER_TIME_NOTIFICATION') {
                    this.showPrayerNotification(event.data.prayer);
                }
            });
        }
    }

    navigateTo(page) {
        // Update active nav link
        document.querySelectorAll('.nav-link').forEach(link => {
            link.classList.remove('active');
        });
        
        const activeLink = document.querySelector(`[href="#${page}"]`);
        if (activeLink) {
            activeLink.classList.add('active');
        }

        // Load page content
        this.currentPage = page;
        this.loadPage(page);
        
        // Update URL without page reload
        history.pushState({page}, '', `#${page}`);
    }

    loadPage(page) {
        const mainContent = document.getElementById('main-content');
        
        // Add page transition
        mainContent.style.opacity = '0';
        mainContent.style.transform = 'translateX(20px)';
        
        setTimeout(() => {
            switch(page) {
                case 'home':
                    this.loadHomePage();
                    break;
                case 'azkar':
                    this.loadAzkarPage();
                    break;
                case 'prayer-times':
                    this.loadPrayerTimesPage();
                    break;
                case 'tasbih':
                    this.loadTasbihPage();
                    break;
                case 'quran':
                    this.loadQuranPage();
                    break;
                case 'zakat':
                    this.loadZakatPage();
                    break;
                case 'settings':
                    this.loadSettingsPage();
                    break;
                default:
                    this.loadHomePage();
            }
            
            // Animate page in
            mainContent.style.opacity = '1';
            mainContent.style.transform = 'translateX(0)';
        }, 150);
    }

    loadHomePage() {
        const content = `
            <div class="container py-5">
                <!-- Hero Section -->
                <section class="hero-section text-center mb-5">
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="hero-content fade-in-up">
                                <div class="hero-icon mb-4">
                                    <i class="fas fa-mosque text-islamic" style="font-size: 4rem;"></i>
                                </div>
                                <h1 class="hero-title mb-3" style="font-family: var(--font-arabic);">
                                    أذكار المسلم المحترف
                                </h1>
                                <p class="hero-subtitle mb-4 text-muted">
                                    رفيقك في رحلة الإيمان - تطبيق شامل للأذكار والعبادات الإسلامية
                                </p>
                                <div class="current-time-display mb-4">
                                    <div class="card card-islamic">
                                        <div class="card-body text-center">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <h3 id="current-time" class="text-islamic mb-0"></h3>
                                                    <small class="text-muted">الوقت الحالي</small>
                                                </div>
                                                <div class="col-md-6">
                                                    <h5 id="current-date" class="mb-0"></h5>
                                                    <small id="hijri-date" class="text-muted"></small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Quick Actions -->
                <section class="quick-actions mb-5">
                    <div class="row g-4">
                        <div class="col-md-3 col-sm-6">
                            <div class="card card-islamic h-100 hover-lift">
                                <div class="card-body text-center">
                                    <i class="fas fa-sun text-warning mb-3" style="font-size: 2.5rem;"></i>
                                    <h5>أذكار الصباح</h5>
                                    <p class="text-muted">ابدأ يومك بالذكر والدعاء</p>
                                    <button class="btn btn-islamic" onclick="app.navigateTo('azkar')">
                                        ابدأ الآن
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="card card-islamic h-100 hover-lift">
                                <div class="card-body text-center">
                                    <i class="fas fa-moon text-primary mb-3" style="font-size: 2.5rem;"></i>
                                    <h5>أذكار المساء</h5>
                                    <p class="text-muted">اختتم يومك بالذكر والاستغفار</p>
                                    <button class="btn btn-islamic" onclick="app.navigateTo('azkar')">
                                        ابدأ الآن
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="card card-islamic h-100 hover-lift">
                                <div class="card-body text-center">
                                    <i class="fas fa-clock text-islamic mb-3" style="font-size: 2.5rem;"></i>
                                    <h5>مواقيت الصلاة</h5>
                                    <p class="text-muted">تعرف على أوقات الصلاة</p>
                                    <button class="btn btn-islamic" onclick="app.navigateTo('prayer-times')">
                                        عرض المواقيت
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="card card-islamic h-100 hover-lift">
                                <div class="card-body text-center">
                                    <i class="fas fa-hand-paper text-success mb-3" style="font-size: 2.5rem;"></i>
                                    <h5>السبحة الرقمية</h5>
                                    <p class="text-muted">سبح الله في أي وقت</p>
                                    <button class="btn btn-islamic" onclick="app.navigateTo('tasbih')">
                                        ابدأ التسبيح
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Next Prayer Info -->
                <section class="next-prayer-info mb-5">
                    <div class="card card-islamic">
                        <div class="card-header-islamic">
                            <h4 class="mb-0">
                                <i class="fas fa-clock me-2"></i>
                                الصلاة القادمة
                            </h4>
                        </div>
                        <div class="card-body">
                            <div id="next-prayer-info" class="text-center">
                                <div class="spinner-border text-islamic" role="status">
                                    <span class="visually-hidden">جاري التحميل...</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Features Grid -->
                <section class="features-grid">
                    <div class="row g-4">
                        <div class="col-lg-4 col-md-6">
                            <div class="card card-islamic h-100">
                                <div class="card-body">
                                    <div class="d-flex align-items-center mb-3">
                                        <i class="fas fa-quran text-islamic me-3" style="font-size: 2rem;"></i>
                                        <h5 class="mb-0">القرآن الكريم</h5>
                                    </div>
                                    <p class="text-muted">اقرأ القرآن الكريم مع التشكيل والترجمة</p>
                                    <button class="btn btn-outline-islamic" onclick="app.navigateTo('quran')">
                                        اقرأ الآن
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-6">
                            <div class="card card-islamic h-100">
                                <div class="card-body">
                                    <div class="d-flex align-items-center mb-3">
                                        <i class="fas fa-coins text-islamic me-3" style="font-size: 2rem;"></i>
                                        <h5 class="mb-0">حاسبة الزكاة</h5>
                                    </div>
                                    <p class="text-muted">احسب زكاة أموالك بسهولة ودقة</p>
                                    <button class="btn btn-outline-islamic" onclick="app.navigateTo('zakat')">
                                        احسب الزكاة
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-6">
                            <div class="card card-islamic h-100">
                                <div class="card-body">
                                    <div class="d-flex align-items-center mb-3">
                                        <i class="fas fa-cog text-islamic me-3" style="font-size: 2rem;"></i>
                                        <h5 class="mb-0">الإعدادات</h5>
                                    </div>
                                    <p class="text-muted">خصص التطبيق حسب احتياجاتك</p>
                                    <button class="btn btn-outline-islamic" onclick="app.navigateTo('settings')">
                                        الإعدادات
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        `;
        
        document.getElementById('main-content').innerHTML = content;
        this.updateNextPrayerInfo();
    }

    updateTime() {
        const now = new Date();
        const timeElement = document.getElementById('current-time');
        const dateElement = document.getElementById('current-date');
        const hijriElement = document.getElementById('hijri-date');
        
        if (timeElement) {
            const timeString = now.toLocaleTimeString('ar-SA', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: true
            });
            timeElement.textContent = timeString;
        }
        
        if (dateElement) {
            const dateString = now.toLocaleDateString('ar-SA', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            dateElement.textContent = dateString;
        }
        
        if (hijriElement) {
            // This would need a proper Hijri date library
            hijriElement.textContent = 'التاريخ الهجري';
        }
    }

    toggleTheme() {
        this.theme = this.theme === 'light' ? 'dark' : 'light';
        this.applyTheme();
        localStorage.setItem('theme', this.theme);
    }

    initializeTheme() {
        this.applyTheme();
    }

    applyTheme() {
        const body = document.body;
        const themeToggle = document.getElementById('theme-toggle');
        
        if (this.theme === 'dark') {
            body.classList.add('dark-theme');
            if (themeToggle) {
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            }
        } else {
            body.classList.remove('dark-theme');
            if (themeToggle) {
                themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
            }
        }
    }

    hideLoadingScreen() {
        setTimeout(() => {
            const loadingScreen = document.getElementById('loading-screen');
            if (loadingScreen) {
                loadingScreen.classList.add('hidden');
                setTimeout(() => {
                    loadingScreen.style.display = 'none';
                }, 500);
            }
        }, 2000);
    }

    loadSettings() {
        const defaultSettings = {
            language: 'ar',
            notifications: true,
            soundEnabled: true,
            vibrationEnabled: true,
            fontSize: 16,
            theme: 'light'
        };
        
        const saved = localStorage.getItem('muslim-app-settings');
        return saved ? {...defaultSettings, ...JSON.parse(saved)} : defaultSettings;
    }

    saveSettings() {
        localStorage.setItem('muslim-app-settings', JSON.stringify(this.settings));
    }

    requestLocationPermission() {
        if ('geolocation' in navigator) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    this.currentLocation = {
                        latitude: position.coords.latitude,
                        longitude: position.coords.longitude
                    };
                    this.updatePrayerTimes();
                },
                (error) => {
                    console.log('Location access denied:', error);
                    // Use default location (Mecca)
                    this.currentLocation = {
                        latitude: 21.4225,
                        longitude: 39.8262
                    };
                    this.updatePrayerTimes();
                }
            );
        }
    }

    updatePrayerTimes() {
        // This would integrate with a prayer times API
        // For now, using mock data
        this.prayerTimes = {
            fajr: '05:30',
            sunrise: '06:45',
            dhuhr: '12:30',
            asr: '15:45',
            maghrib: '18:20',
            isha: '19:45'
        };
        
        this.updateNextPrayerInfo();
    }

    updateNextPrayerInfo() {
        const nextPrayerElement = document.getElementById('next-prayer-info');
        if (!nextPrayerElement) return;
        
        const now = new Date();
        const currentTime = now.getHours() * 60 + now.getMinutes();
        
        const prayers = [
            {name: 'الفجر', time: '05:30'},
            {name: 'الظهر', time: '12:30'},
            {name: 'العصر', time: '15:45'},
            {name: 'المغرب', time: '18:20'},
            {name: 'العشاء', time: '19:45'}
        ];
        
        let nextPrayer = prayers[0]; // Default to Fajr
        
        for (let prayer of prayers) {
            const [hours, minutes] = prayer.time.split(':').map(Number);
            const prayerTime = hours * 60 + minutes;
            
            if (prayerTime > currentTime) {
                nextPrayer = prayer;
                break;
            }
        }
        
        nextPrayerElement.innerHTML = `
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h3 class="text-islamic mb-0">${nextPrayer.name}</h3>
                    <p class="text-muted mb-0">الصلاة القادمة</p>
                </div>
                <div class="col-md-6">
                    <h2 class="mb-0">${nextPrayer.time}</h2>
                    <small class="text-muted">متبقي: حساب الوقت المتبقي</small>
                </div>
            </div>
        `;
    }

    showPrayerNotification(prayerName) {
        if ('Notification' in window && Notification.permission === 'granted') {
            new Notification(`حان وقت صلاة ${prayerName}`, {
                body: 'حان الآن وقت الصلاة',
                icon: 'assets/images/icon-192.png',
                badge: 'assets/images/badge-72.png'
            });
        }
    }

    // Azkar Page Implementation
    loadAzkarPage() {
        const content = `
            <div class="container py-5">
                <div class="row">
                    <div class="col-lg-3">
                        <!-- Azkar Categories Sidebar -->
                        <div class="card card-islamic mb-4">
                            <div class="card-header-islamic">
                                <h5 class="mb-0">
                                    <i class="fas fa-list me-2"></i>
                                    فئات الأذكار
                                </h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="list-group list-group-flush">
                                    <a href="#" class="list-group-item list-group-item-action active" data-category="morning">
                                        <i class="fas fa-sun me-2"></i>أذكار الصباح
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action" data-category="evening">
                                        <i class="fas fa-moon me-2"></i>أذكار المساء
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action" data-category="sleep">
                                        <i class="fas fa-bed me-2"></i>أذكار النوم
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action" data-category="prayer">
                                        <i class="fas fa-pray me-2"></i>أذكار بعد الصلاة
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action" data-category="general">
                                        <i class="fas fa-heart me-2"></i>أذكار عامة
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Progress Card -->
                        <div class="card card-islamic">
                            <div class="card-body">
                                <h6 class="card-title">
                                    <i class="fas fa-chart-pie me-2"></i>
                                    تقدمك اليوم
                                </h6>
                                <div class="progress mb-2">
                                    <div class="progress-bar bg-islamic" role="progressbar" style="width: 65%"></div>
                                </div>
                                <small class="text-muted">13 من 20 ذكر مكتمل</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-9">
                        <!-- Search and Filter -->
                        <div class="card card-islamic mb-4">
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-search"></i>
                                            </span>
                                            <input type="text" class="form-control" placeholder="ابحث في الأذكار..." id="azkar-search">
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" id="azkar-sort">
                                            <option value="default">الترتيب الافتراضي</option>
                                            <option value="alphabetical">أبجدي</option>
                                            <option value="length">حسب الطول</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <button class="btn btn-islamic w-100" id="play-all-btn">
                                            <i class="fas fa-play me-2"></i>تشغيل الكل
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Azkar Content -->
                        <div id="azkar-content">
                            <!-- Content will be loaded dynamically -->
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.getElementById('main-content').innerHTML = content;
        this.loadAzkarContent('morning');
        this.setupAzkarEventListeners();
    }

    loadAzkarContent(category) {
        const azkarData = this.getAzkarData(category);
        const contentElement = document.getElementById('azkar-content');

        let html = `<div class="row g-4">`;

        azkarData.forEach((zikr, index) => {
            html += `
                <div class="col-12">
                    <div class="card card-islamic azkar-card fade-in-up" style="animation-delay: ${index * 0.1}s">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="azkar-number">
                                    <span class="badge bg-islamic">${index + 1}</span>
                                </div>
                                <div class="azkar-actions">
                                    <button class="btn btn-sm btn-outline-islamic me-2" onclick="app.playAzkar(${index})">
                                        <i class="fas fa-play"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-islamic me-2" onclick="app.shareAzkar(${index})">
                                        <i class="fas fa-share"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-islamic" onclick="app.favoriteAzkar(${index})">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="azkar-text arabic-text mb-3">
                                ${zikr.text}
                            </div>

                            ${zikr.translation ? `
                                <div class="azkar-translation mb-3">
                                    <small class="text-muted">المعنى: ${zikr.translation}</small>
                                </div>
                            ` : ''}

                            <div class="azkar-footer">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <div class="azkar-counter">
                                            <button class="btn btn-sm btn-islamic me-2" onclick="app.decrementCounter(${index})">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <span class="counter-display mx-2" id="counter-${index}">
                                                ${zikr.count} / ${zikr.totalCount}
                                            </span>
                                            <button class="btn btn-sm btn-islamic" onclick="app.incrementCounter(${index})">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-md-6 text-md-end">
                                        ${zikr.reference ? `
                                            <small class="text-muted">
                                                <i class="fas fa-book me-1"></i>
                                                ${zikr.reference}
                                            </small>
                                        ` : ''}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        });

        html += `</div>`;
        contentElement.innerHTML = html;
    }

    setupAzkarEventListeners() {
        // Category selection
        document.querySelectorAll('[data-category]').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();

                // Update active category
                document.querySelectorAll('[data-category]').forEach(l => l.classList.remove('active'));
                e.target.classList.add('active');

                // Load category content
                const category = e.target.getAttribute('data-category');
                this.loadAzkarContent(category);
            });
        });

        // Search functionality
        const searchInput = document.getElementById('azkar-search');
        if (searchInput) {
            searchInput.addEventListener('input', (e) => {
                this.searchAzkar(e.target.value);
            });
        }

        // Sort functionality
        const sortSelect = document.getElementById('azkar-sort');
        if (sortSelect) {
            sortSelect.addEventListener('change', (e) => {
                this.sortAzkar(e.target.value);
            });
        }
    }

    getAzkarData(category) {
        // Mock data - in real app, this would come from a database or API
        const azkarDatabase = {
            morning: [
                {
                    text: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
                    translation: 'أعوذ بالله من الشيطان الرجيم',
                    reference: 'القرآن الكريم',
                    count: 0,
                    totalCount: 1
                },
                {
                    text: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                    translation: 'بسم الله الرحمن الرحيم',
                    reference: 'القرآن الكريم',
                    count: 0,
                    totalCount: 1
                },
                {
                    text: 'قُلْ هُوَ اللَّهُ أَحَدٌ * اللَّهُ الصَّمَدُ * لَمْ يَلِدْ وَلَمْ يُولَدْ * وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
                    translation: 'قل هو الله أحد، الله الصمد، لم يلد ولم يولد، ولم يكن له كفواً أحد',
                    reference: 'سورة الإخلاص',
                    count: 0,
                    totalCount: 3
                }
            ],
            evening: [
                {
                    text: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ',
                    translation: 'أمسينا وأمسى الملك لله، والحمد لله',
                    reference: 'صحيح مسلم',
                    count: 0,
                    totalCount: 1
                }
            ]
        };

        return azkarDatabase[category] || [];
    }

    incrementCounter(index) {
        const counterElement = document.getElementById(`counter-${index}`);
        if (counterElement) {
            // Add animation
            counterElement.parentElement.classList.add('azkar-counter-pulse');
            setTimeout(() => {
                counterElement.parentElement.classList.remove('azkar-counter-pulse');
            }, 300);

            // Update counter logic would go here
        }
    }

    decrementCounter(index) {
        // Decrement counter logic
    }

    playAzkar(index) {
        // Text-to-speech functionality
        if ('speechSynthesis' in window) {
            const utterance = new SpeechSynthesisUtterance();
            utterance.lang = 'ar-SA';
            utterance.rate = 0.8;
            // utterance.text would be set to the azkar text
            speechSynthesis.speak(utterance);
        }
    }

    shareAzkar(index) {
        if (navigator.share) {
            navigator.share({
                title: 'ذكر من أذكار المسلم',
                text: 'نص الذكر هنا',
                url: window.location.href
            });
        }
    }

    favoriteAzkar(index) {
        // Add to favorites functionality
    }

    searchAzkar(query) {
        // Search functionality
    }

    sortAzkar(sortType) {
        // Sort functionality
    }

    // Prayer Times Page Implementation
    loadPrayerTimesPage() {
        const content = `
            <div class="container py-5">
                <!-- Location and Date Header -->
                <div class="row mb-4">
                    <div class="col-lg-8">
                        <div class="card card-islamic">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <h4 class="mb-1">
                                            <i class="fas fa-map-marker-alt text-islamic me-2"></i>
                                            <span id="current-location">جاري تحديد الموقع...</span>
                                        </h4>
                                        <p class="text-muted mb-0" id="current-date-prayer"></p>
                                    </div>
                                    <div class="col-md-6 text-md-end">
                                        <button class="btn btn-outline-islamic me-2" onclick="app.changeLocation()">
                                            <i class="fas fa-edit me-1"></i>تغيير الموقع
                                        </button>
                                        <button class="btn btn-islamic" onclick="app.refreshPrayerTimes()">
                                            <i class="fas fa-sync-alt me-1"></i>تحديث
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="card card-islamic">
                            <div class="card-body text-center">
                                <h5 class="text-islamic mb-1">الصلاة القادمة</h5>
                                <h3 class="mb-1" id="next-prayer-name">الظهر</h3>
                                <p class="text-muted mb-0">
                                    <span id="time-remaining">متبقي: 2:30:15</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Prayer Times Grid -->
                <div class="row g-4 mb-5">
                    <div class="col-lg-2 col-md-4 col-sm-6">
                        <div class="card card-islamic prayer-time-card h-100">
                            <div class="card-body text-center">
                                <div class="prayer-icon mb-3">
                                    <i class="fas fa-sun text-warning" style="font-size: 2.5rem;"></i>
                                </div>
                                <h5 class="prayer-name mb-2">الفجر</h5>
                                <h3 class="prayer-time text-islamic mb-2">05:30</h3>
                                <small class="text-muted">صباحاً</small>
                                <div class="prayer-status mt-2">
                                    <span class="badge bg-success">مكتملة</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-2 col-md-4 col-sm-6">
                        <div class="card card-islamic prayer-time-card h-100">
                            <div class="card-body text-center">
                                <div class="prayer-icon mb-3">
                                    <i class="fas fa-sun text-orange" style="font-size: 2.5rem;"></i>
                                </div>
                                <h5 class="prayer-name mb-2">الشروق</h5>
                                <h3 class="prayer-time text-islamic mb-2">06:45</h3>
                                <small class="text-muted">صباحاً</small>
                                <div class="prayer-status mt-2">
                                    <span class="badge bg-secondary">انتهت</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-2 col-md-4 col-sm-6">
                        <div class="card card-islamic prayer-time-card h-100 current-prayer">
                            <div class="card-body text-center">
                                <div class="prayer-icon mb-3">
                                    <i class="fas fa-sun text-warning" style="font-size: 2.5rem;"></i>
                                </div>
                                <h5 class="prayer-name mb-2">الظهر</h5>
                                <h3 class="prayer-time text-islamic mb-2">12:30</h3>
                                <small class="text-muted">ظهراً</small>
                                <div class="prayer-status mt-2">
                                    <span class="badge bg-primary">القادمة</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-2 col-md-4 col-sm-6">
                        <div class="card card-islamic prayer-time-card h-100">
                            <div class="card-body text-center">
                                <div class="prayer-icon mb-3">
                                    <i class="fas fa-cloud-sun text-info" style="font-size: 2.5rem;"></i>
                                </div>
                                <h5 class="prayer-name mb-2">العصر</h5>
                                <h3 class="prayer-time text-islamic mb-2">15:45</h3>
                                <small class="text-muted">عصراً</small>
                                <div class="prayer-status mt-2">
                                    <span class="badge bg-light text-dark">قادمة</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-2 col-md-4 col-sm-6">
                        <div class="card card-islamic prayer-time-card h-100">
                            <div class="card-body text-center">
                                <div class="prayer-icon mb-3">
                                    <i class="fas fa-moon text-danger" style="font-size: 2.5rem;"></i>
                                </div>
                                <h5 class="prayer-name mb-2">المغرب</h5>
                                <h3 class="prayer-time text-islamic mb-2">18:20</h3>
                                <small class="text-muted">مساءً</small>
                                <div class="prayer-status mt-2">
                                    <span class="badge bg-light text-dark">قادمة</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-2 col-md-4 col-sm-6">
                        <div class="card card-islamic prayer-time-card h-100">
                            <div class="card-body text-center">
                                <div class="prayer-icon mb-3">
                                    <i class="fas fa-moon text-dark" style="font-size: 2.5rem;"></i>
                                </div>
                                <h5 class="prayer-name mb-2">العشاء</h5>
                                <h3 class="prayer-time text-islamic mb-2">19:45</h3>
                                <small class="text-muted">مساءً</small>
                                <div class="prayer-status mt-2">
                                    <span class="badge bg-light text-dark">قادمة</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Additional Information -->
                <div class="row g-4">
                    <div class="col-lg-6">
                        <div class="card card-islamic">
                            <div class="card-header-islamic">
                                <h5 class="mb-0">
                                    <i class="fas fa-info-circle me-2"></i>
                                    معلومات إضافية
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-6">
                                        <div class="text-center">
                                            <i class="fas fa-compass text-islamic mb-2" style="font-size: 1.5rem;"></i>
                                            <h6>اتجاه القبلة</h6>
                                            <p class="text-muted mb-0">45° شمال شرق</p>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="text-center">
                                            <i class="fas fa-calendar text-islamic mb-2" style="font-size: 1.5rem;"></i>
                                            <h6>التاريخ الهجري</h6>
                                            <p class="text-muted mb-0">15 رجب 1445</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="card card-islamic">
                            <div class="card-header-islamic">
                                <h5 class="mb-0">
                                    <i class="fas fa-cog me-2"></i>
                                    إعدادات المواقيت
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label">طريقة الحساب</label>
                                    <select class="form-select">
                                        <option>الهيئة المصرية العامة للمساحة</option>
                                        <option>رابطة العالم الإسلامي</option>
                                        <option>جامعة أم القرى</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">المذهب الفقهي</label>
                                    <select class="form-select">
                                        <option>شافعي</option>
                                        <option>حنفي</option>
                                        <option>مالكي</option>
                                        <option>حنبلي</option>
                                    </select>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="notifications">
                                    <label class="form-check-label" for="notifications">
                                        تفعيل إشعارات الصلاة
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Monthly Calendar -->
                <div class="row mt-5">
                    <div class="col-12">
                        <div class="card card-islamic">
                            <div class="card-header-islamic">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">
                                        <i class="fas fa-calendar-alt me-2"></i>
                                        مواقيت الشهر
                                    </h5>
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-outline-light" onclick="app.previousMonth()">
                                            <i class="fas fa-chevron-right"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-light" onclick="app.nextMonth()">
                                            <i class="fas fa-chevron-left"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>التاريخ</th>
                                                <th>الفجر</th>
                                                <th>الشروق</th>
                                                <th>الظهر</th>
                                                <th>العصر</th>
                                                <th>المغرب</th>
                                                <th>العشاء</th>
                                            </tr>
                                        </thead>
                                        <tbody id="monthly-prayer-times">
                                            <!-- Monthly data will be loaded here -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.getElementById('main-content').innerHTML = content;
        this.updatePrayerTimesDisplay();
        this.loadMonthlyPrayerTimes();
    }

    updatePrayerTimesDisplay() {
        // Update current location
        const locationElement = document.getElementById('current-location');
        if (locationElement) {
            locationElement.textContent = 'القاهرة, مصر';
        }

        // Update current date
        const dateElement = document.getElementById('current-date-prayer');
        if (dateElement) {
            const now = new Date();
            dateElement.textContent = now.toLocaleDateString('ar-SA', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
        }

        // Update time remaining
        this.updateTimeRemaining();
        setInterval(() => this.updateTimeRemaining(), 1000);
    }

    updateTimeRemaining() {
        const now = new Date();
        const nextPrayerTime = new Date();
        nextPrayerTime.setHours(12, 30, 0, 0); // Example: Dhuhr at 12:30

        if (nextPrayerTime < now) {
            nextPrayerTime.setDate(nextPrayerTime.getDate() + 1);
        }

        const diff = nextPrayerTime - now;
        const hours = Math.floor(diff / (1000 * 60 * 60));
        const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((diff % (1000 * 60)) / 1000);

        const timeRemainingElement = document.getElementById('time-remaining');
        if (timeRemainingElement) {
            timeRemainingElement.textContent = `متبقي: ${hours}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        }
    }

    loadMonthlyPrayerTimes() {
        const tbody = document.getElementById('monthly-prayer-times');
        if (!tbody) return;

        let html = '';
        for (let day = 1; day <= 30; day++) {
            const isToday = day === new Date().getDate();
            const rowClass = isToday ? 'table-primary' : '';

            html += `
                <tr class="${rowClass}">
                    <td>${day} يناير</td>
                    <td>05:30</td>
                    <td>06:45</td>
                    <td>12:30</td>
                    <td>15:45</td>
                    <td>18:20</td>
                    <td>19:45</td>
                </tr>
            `;
        }

        tbody.innerHTML = html;
    }

    changeLocation() {
        // Location change functionality
        const newLocation = prompt('أدخل اسم المدينة:');
        if (newLocation) {
            // Update location and recalculate prayer times
            document.getElementById('current-location').textContent = newLocation;
            this.updatePrayerTimes();
        }
    }

    refreshPrayerTimes() {
        // Refresh prayer times
        this.updatePrayerTimes();

        // Show success message
        this.showNotification('تم تحديث مواقيت الصلاة', 'success');
    }

    previousMonth() {
        // Navigate to previous month
        this.loadMonthlyPrayerTimes();
    }

    nextMonth() {
        // Navigate to next month
        this.loadMonthlyPrayerTimes();
    }

    showNotification(message, type = 'info') {
        // Create and show notification
        const notification = document.createElement('div');
        notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
        notification.style.cssText = 'top: 100px; left: 20px; z-index: 1050; min-width: 300px;';
        notification.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.remove();
        }, 5000);
    }
    loadTasbihPage() {
        const content = `
            <div class="container py-5">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <!-- Tasbih Header -->
                        <div class="text-center mb-5">
                            <h1 class="mb-3" style="font-family: var(--font-arabic);">السبحة الرقمية</h1>
                            <p class="text-muted">سبح الله واذكره في أي وقت ومكان</p>
                        </div>

                        <!-- Current Tasbih Display -->
                        <div class="card card-islamic mb-4">
                            <div class="card-body text-center py-5">
                                <div class="current-tasbih mb-4">
                                    <h2 class="arabic-text mb-3" id="current-tasbih-text">
                                        سُبْحَانَ اللَّهِ
                                    </h2>
                                    <p class="text-muted" id="current-tasbih-meaning">
                                        تنزيه الله عن كل نقص
                                    </p>
                                </div>

                                <!-- Counter Circle -->
                                <div class="tasbih-counter-container mb-4">
                                    <div class="tasbih-counter mx-auto" onclick="app.incrementTasbih()">
                                        <div class="counter-inner">
                                            <div class="counter-number" id="tasbih-count">0</div>
                                            <div class="counter-label">اضغط للتسبيح</div>
                                        </div>
                                        <div class="counter-ring"></div>
                                    </div>
                                </div>

                                <!-- Progress Bar -->
                                <div class="progress mb-3" style="height: 8px;">
                                    <div class="progress-bar bg-islamic" role="progressbar"
                                         style="width: 0%" id="tasbih-progress"></div>
                                </div>
                                <small class="text-muted">
                                    <span id="progress-text">0 من 33</span>
                                </small>
                            </div>
                        </div>

                        <!-- Tasbih Controls -->
                        <div class="row g-3 mb-4">
                            <div class="col-md-3">
                                <button class="btn btn-islamic w-100" onclick="app.resetTasbih()">
                                    <i class="fas fa-redo me-2"></i>إعادة تعيين
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-outline-islamic w-100" onclick="app.toggleSound()">
                                    <i class="fas fa-volume-up me-2" id="sound-icon"></i>
                                    <span id="sound-text">الصوت</span>
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-outline-islamic w-100" onclick="app.toggleVibration()">
                                    <i class="fas fa-mobile-alt me-2"></i>الاهتزاز
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-outline-islamic w-100" onclick="app.shareTasbih()">
                                    <i class="fas fa-share me-2"></i>مشاركة
                                </button>
                            </div>
                        </div>

                        <!-- Tasbih Types -->
                        <div class="card card-islamic mb-4">
                            <div class="card-header-islamic">
                                <h5 class="mb-0">
                                    <i class="fas fa-list me-2"></i>
                                    أنواع التسبيح
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <div class="tasbih-type-card active" data-type="subhan" onclick="app.selectTasbihType('subhan')">
                                            <div class="card-body text-center">
                                                <h6 class="arabic-text">سُبْحَانَ اللَّهِ</h6>
                                                <small class="text-muted">33 مرة</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="tasbih-type-card" data-type="hamd" onclick="app.selectTasbihType('hamd')">
                                            <div class="card-body text-center">
                                                <h6 class="arabic-text">الْحَمْدُ لِلَّهِ</h6>
                                                <small class="text-muted">33 مرة</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="tasbih-type-card" data-type="takbir" onclick="app.selectTasbihType('takbir')">
                                            <div class="card-body text-center">
                                                <h6 class="arabic-text">اللَّهُ أَكْبَرُ</h6>
                                                <small class="text-muted">34 مرة</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="tasbih-type-card" data-type="tahlil" onclick="app.selectTasbihType('tahlil')">
                                            <div class="card-body text-center">
                                                <h6 class="arabic-text">لا إِلَهَ إِلا اللَّهُ</h6>
                                                <small class="text-muted">100 مرة</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="tasbih-type-card" data-type="istighfar" onclick="app.selectTasbihType('istighfar')">
                                            <div class="card-body text-center">
                                                <h6 class="arabic-text">أَسْتَغْفِرُ اللَّهَ</h6>
                                                <small class="text-muted">100 مرة</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="tasbih-type-card" data-type="salawat" onclick="app.selectTasbihType('salawat')">
                                            <div class="card-body text-center">
                                                <h6 class="arabic-text">صلى الله عليه وسلم</h6>
                                                <small class="text-muted">100 مرة</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Statistics -->
                        <div class="row g-4">
                            <div class="col-md-6">
                                <div class="card card-islamic">
                                    <div class="card-header-islamic">
                                        <h6 class="mb-0">
                                            <i class="fas fa-chart-bar me-2"></i>
                                            إحصائيات اليوم
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row text-center">
                                            <div class="col-6">
                                                <h4 class="text-islamic mb-1" id="today-count">245</h4>
                                                <small class="text-muted">إجمالي اليوم</small>
                                            </div>
                                            <div class="col-6">
                                                <h4 class="text-islamic mb-1" id="session-count">33</h4>
                                                <small class="text-muted">الجلسة الحالية</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="card card-islamic">
                                    <div class="card-header-islamic">
                                        <h6 class="mb-0">
                                            <i class="fas fa-trophy me-2"></i>
                                            الإنجازات
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="achievement-item mb-2">
                                            <i class="fas fa-star text-warning me-2"></i>
                                            <span>100 تسبيحة متتالية</span>
                                        </div>
                                        <div class="achievement-item mb-2">
                                            <i class="fas fa-calendar text-success me-2"></i>
                                            <span>7 أيام متتالية</span>
                                        </div>
                                        <div class="achievement-item">
                                            <i class="fas fa-fire text-danger me-2"></i>
                                            <span>سلسلة 15 يوم</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.getElementById('main-content').innerHTML = content;
        this.initializeTasbih();
    }

    initializeTasbih() {
        this.tasbihData = {
            currentType: 'subhan',
            count: 0,
            target: 33,
            soundEnabled: true,
            vibrationEnabled: true,
            types: {
                subhan: { text: 'سُبْحَانَ اللَّهِ', meaning: 'تنزيه الله عن كل نقص', target: 33 },
                hamd: { text: 'الْحَمْدُ لِلَّهِ', meaning: 'الثناء والشكر لله', target: 33 },
                takbir: { text: 'اللَّهُ أَكْبَرُ', meaning: 'الله أعظم من كل شيء', target: 34 },
                tahlil: { text: 'لا إِلَهَ إِلا اللَّهُ', meaning: 'لا معبود بحق إلا الله', target: 100 },
                istighfar: { text: 'أَسْتَغْفِرُ اللَّهَ', meaning: 'طلب المغفرة من الله', target: 100 },
                salawat: { text: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ', meaning: 'الصلاة على النبي محمد', target: 100 }
            }
        };

        this.updateTasbihDisplay();
    }

    incrementTasbih() {
        this.tasbihData.count++;

        // Update display
        this.updateTasbihDisplay();

        // Add animation
        const counter = document.querySelector('.tasbih-counter');
        if (counter) {
            counter.classList.add('tasbih-click');
            setTimeout(() => counter.classList.remove('tasbih-click'), 200);
        }

        // Play sound if enabled
        if (this.tasbihData.soundEnabled) {
            this.playTasbihSound();
        }

        // Vibrate if enabled and supported
        if (this.tasbihData.vibrationEnabled && 'vibrate' in navigator) {
            navigator.vibrate(50);
        }

        // Check if target reached
        if (this.tasbihData.count >= this.tasbihData.target) {
            this.onTasbihComplete();
        }
    }

    updateTasbihDisplay() {
        const currentType = this.tasbihData.types[this.tasbihData.currentType];

        // Update text and meaning
        document.getElementById('current-tasbih-text').textContent = currentType.text;
        document.getElementById('current-tasbih-meaning').textContent = currentType.meaning;

        // Update counter
        document.getElementById('tasbih-count').textContent = this.tasbihData.count;

        // Update progress
        const progress = (this.tasbihData.count / this.tasbihData.target) * 100;
        document.getElementById('tasbih-progress').style.width = `${Math.min(progress, 100)}%`;
        document.getElementById('progress-text').textContent = `${this.tasbihData.count} من ${this.tasbihData.target}`;
    }

    selectTasbihType(type) {
        // Update active type
        document.querySelectorAll('.tasbih-type-card').forEach(card => {
            card.classList.remove('active');
        });
        document.querySelector(`[data-type="${type}"]`).classList.add('active');

        // Reset counter and update type
        this.tasbihData.currentType = type;
        this.tasbihData.target = this.tasbihData.types[type].target;
        this.tasbihData.count = 0;

        this.updateTasbihDisplay();
    }

    resetTasbih() {
        this.tasbihData.count = 0;
        this.updateTasbihDisplay();

        // Show reset animation
        const counter = document.querySelector('.tasbih-counter');
        if (counter) {
            counter.style.transform = 'scale(0.9)';
            setTimeout(() => {
                counter.style.transform = 'scale(1)';
            }, 150);
        }
    }

    toggleSound() {
        this.tasbihData.soundEnabled = !this.tasbihData.soundEnabled;

        const icon = document.getElementById('sound-icon');
        const text = document.getElementById('sound-text');

        if (this.tasbihData.soundEnabled) {
            icon.className = 'fas fa-volume-up me-2';
            text.textContent = 'الصوت';
        } else {
            icon.className = 'fas fa-volume-mute me-2';
            text.textContent = 'صامت';
        }
    }

    toggleVibration() {
        this.tasbihData.vibrationEnabled = !this.tasbihData.vibrationEnabled;
        this.showNotification(
            this.tasbihData.vibrationEnabled ? 'تم تفعيل الاهتزاز' : 'تم إلغاء الاهتزاز',
            'info'
        );
    }

    playTasbihSound() {
        // Create a simple beep sound
        const audioContext = new (window.AudioContext || window.webkitAudioContext)();
        const oscillator = audioContext.createOscillator();
        const gainNode = audioContext.createGain();

        oscillator.connect(gainNode);
        gainNode.connect(audioContext.destination);

        oscillator.frequency.value = 800;
        oscillator.type = 'sine';

        gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.1);

        oscillator.start(audioContext.currentTime);
        oscillator.stop(audioContext.currentTime + 0.1);
    }

    onTasbihComplete() {
        // Show completion message
        this.showNotification('مبروك! لقد أكملت التسبيح', 'success');

        // Add glow effect
        const counter = document.querySelector('.tasbih-counter');
        if (counter) {
            counter.classList.add('glow');
            setTimeout(() => counter.classList.remove('glow'), 2000);
        }

        // Play completion sound
        if (this.tasbihData.soundEnabled) {
            this.playCompletionSound();
        }

        // Vibrate for completion
        if (this.tasbihData.vibrationEnabled && 'vibrate' in navigator) {
            navigator.vibrate([100, 50, 100, 50, 100]);
        }
    }

    playCompletionSound() {
        // Play a more elaborate completion sound
        const audioContext = new (window.AudioContext || window.webkitAudioContext)();

        [523, 659, 784].forEach((freq, index) => {
            const oscillator = audioContext.createOscillator();
            const gainNode = audioContext.createGain();

            oscillator.connect(gainNode);
            gainNode.connect(audioContext.destination);

            oscillator.frequency.value = freq;
            oscillator.type = 'sine';

            const startTime = audioContext.currentTime + (index * 0.15);
            gainNode.gain.setValueAtTime(0.3, startTime);
            gainNode.gain.exponentialRampToValueAtTime(0.01, startTime + 0.2);

            oscillator.start(startTime);
            oscillator.stop(startTime + 0.2);
        });
    }

    shareTasbih() {
        const currentType = this.tasbihData.types[this.tasbihData.currentType];
        const shareText = `لقد أكملت ${this.tasbihData.count} من تسبيح "${currentType.text}" في تطبيق أذكار المسلم المحترف`;

        if (navigator.share) {
            navigator.share({
                title: 'تسبيح مكتمل',
                text: shareText,
                url: window.location.href
            });
        } else {
            // Fallback: copy to clipboard
            navigator.clipboard.writeText(shareText).then(() => {
                this.showNotification('تم نسخ النص للحافظة', 'success');
            });
        }
    }
    loadQuranPage() {
        const content = `
            <div class="container py-5">
                <div class="row">
                    <!-- Sidebar -->
                    <div class="col-lg-3">
                        <!-- Surah List -->
                        <div class="card card-islamic mb-4">
                            <div class="card-header-islamic">
                                <h5 class="mb-0">
                                    <i class="fas fa-list me-2"></i>
                                    فهرس السور
                                </h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="search-box p-3 border-bottom">
                                    <input type="text" class="form-control" placeholder="ابحث عن سورة..." id="surah-search">
                                </div>
                                <div class="surah-list" style="max-height: 400px; overflow-y: auto;">
                                    <div class="list-group list-group-flush" id="surah-list">
                                        <!-- Surah list will be loaded here -->
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Reading Settings -->
                        <div class="card card-islamic">
                            <div class="card-header-islamic">
                                <h6 class="mb-0">
                                    <i class="fas fa-cog me-2"></i>
                                    إعدادات القراءة
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label">حجم الخط</label>
                                    <input type="range" class="form-range" min="14" max="24" value="18" id="font-size-slider">
                                    <div class="d-flex justify-content-between">
                                        <small>صغير</small>
                                        <small>كبير</small>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="show-translation" checked>
                                        <label class="form-check-label" for="show-translation">
                                            إظهار الترجمة
                                        </label>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="show-tafsir">
                                        <label class="form-check-label" for="show-tafsir">
                                            إظهار التفسير
                                        </label>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">القارئ</label>
                                    <select class="form-select" id="reciter-select">
                                        <option value="mishary">مشاري العفاسي</option>
                                        <option value="sudais">عبد الرحمن السديس</option>
                                        <option value="shuraim">سعود الشريم</option>
                                        <option value="husary">محمود خليل الحصري</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Main Content -->
                    <div class="col-lg-9">
                        <!-- Surah Header -->
                        <div class="card card-islamic mb-4">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <h3 class="mb-1" id="surah-name">سورة الفاتحة</h3>
                                        <p class="text-muted mb-0">
                                            <span id="surah-info">مكية • 7 آيات</span>
                                        </p>
                                    </div>
                                    <div class="col-md-6 text-md-end">
                                        <button class="btn btn-islamic me-2" onclick="app.playCurrentSurah()">
                                            <i class="fas fa-play me-1"></i>تشغيل
                                        </button>
                                        <button class="btn btn-outline-islamic me-2" onclick="app.bookmarkSurah()">
                                            <i class="fas fa-bookmark me-1"></i>حفظ
                                        </button>
                                        <button class="btn btn-outline-islamic" onclick="app.shareSurah()">
                                            <i class="fas fa-share me-1"></i>مشاركة
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Bismillah -->
                        <div class="card card-islamic mb-4" id="bismillah-card">
                            <div class="card-body text-center py-4">
                                <h2 class="arabic-text mb-0" style="font-size: 2rem;">
                                    بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ
                                </h2>
                            </div>
                        </div>

                        <!-- Verses -->
                        <div id="verses-container">
                            <!-- Verses will be loaded here -->
                        </div>

                        <!-- Navigation -->
                        <div class="card card-islamic mt-4">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-4">
                                        <button class="btn btn-outline-islamic" onclick="app.previousSurah()">
                                            <i class="fas fa-chevron-right me-1"></i>السورة السابقة
                                        </button>
                                    </div>
                                    <div class="col-md-4 text-center">
                                        <span class="text-muted">صفحة <span id="current-page">1</span> من <span id="total-pages">604</span></span>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <button class="btn btn-outline-islamic" onclick="app.nextSurah()">
                                            السورة التالية<i class="fas fa-chevron-left ms-1"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.getElementById('main-content').innerHTML = content;
        this.initializeQuranPage();
    }

    initializeQuranPage() {
        this.quranData = {
            currentSurah: 1,
            currentVerse: 1,
            fontSize: 18,
            showTranslation: true,
            showTafsir: false,
            reciter: 'mishary'
        };

        this.loadSurahList();
        this.loadCurrentSurah();
        this.setupQuranEventListeners();
    }

    loadSurahList() {
        const surahList = [
            { number: 1, name: 'الفاتحة', englishName: 'Al-Fatihah', verses: 7, type: 'مكية' },
            { number: 2, name: 'البقرة', englishName: 'Al-Baqarah', verses: 286, type: 'مدنية' },
            { number: 3, name: 'آل عمران', englishName: 'Aal-E-Imran', verses: 200, type: 'مدنية' },
            { number: 4, name: 'النساء', englishName: 'An-Nisa', verses: 176, type: 'مدنية' },
            { number: 5, name: 'المائدة', englishName: 'Al-Maidah', verses: 120, type: 'مدنية' },
            // Add more surahs...
        ];

        const listContainer = document.getElementById('surah-list');
        let html = '';

        surahList.forEach(surah => {
            const isActive = surah.number === this.quranData.currentSurah ? 'active' : '';
            html += `
                <a href="#" class="list-group-item list-group-item-action ${isActive}"
                   onclick="app.selectSurah(${surah.number})">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="mb-1">${surah.name}</h6>
                            <small class="text-muted">${surah.englishName}</small>
                        </div>
                        <div class="text-end">
                            <span class="badge bg-islamic">${surah.number}</span>
                            <br>
                            <small class="text-muted">${surah.verses} آية</small>
                        </div>
                    </div>
                </a>
            `;
        });

        listContainer.innerHTML = html;
    }

    loadCurrentSurah() {
        // Mock data for Al-Fatihah
        const verses = [
            {
                number: 1,
                arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
                translation: 'الحمد لله رب العالمين',
                tafsir: 'الثناء على الله بصفاته الجميلة وأفعاله الحميدة'
            },
            {
                number: 2,
                arabic: 'الرَّحْمَنِ الرَّحِيمِ',
                translation: 'الرحمن الرحيم',
                tafsir: 'الرحمن في الدنيا والآخرة، الرحيم بالمؤمنين خاصة'
            },
            {
                number: 3,
                arabic: 'مَالِكِ يَوْمِ الدِّينِ',
                translation: 'مالك يوم الدين',
                tafsir: 'المالك المتصرف في يوم الجزاء والحساب'
            },
            {
                number: 4,
                arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
                translation: 'إياك نعبد وإياك نستعين',
                tafsir: 'إقرار بالعبودية لله وحده والاستعانة به'
            },
            {
                number: 5,
                arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
                translation: 'اهدنا الصراط المستقيم',
                tafsir: 'دعاء بالهداية إلى الطريق المستقيم'
            },
            {
                number: 6,
                arabic: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
                translation: 'صراط الذين أنعمت عليهم غير المغضوب عليهم ولا الضالين',
                tafsir: 'طريق الأنبياء والصديقين، ليس طريق اليهود والنصارى'
            }
        ];

        const container = document.getElementById('verses-container');
        let html = '';

        verses.forEach(verse => {
            html += `
                <div class="card card-islamic mb-3 verse-card" data-verse="${verse.number}">
                    <div class="card-body">
                        <div class="verse-header mb-3">
                            <span class="verse-number badge bg-islamic">${verse.number}</span>
                            <button class="btn btn-sm btn-outline-islamic float-end" onclick="app.playVerse(${verse.number})">
                                <i class="fas fa-play"></i>
                            </button>
                        </div>

                        <div class="verse-arabic arabic-text mb-3" style="font-size: ${this.quranData.fontSize}px;">
                            ${verse.arabic}
                        </div>

                        ${this.quranData.showTranslation ? `
                            <div class="verse-translation text-muted mb-2">
                                <strong>المعنى:</strong> ${verse.translation}
                            </div>
                        ` : ''}

                        ${this.quranData.showTafsir ? `
                            <div class="verse-tafsir">
                                <strong>التفسير:</strong> ${verse.tafsir}
                            </div>
                        ` : ''}
                    </div>
                </div>
            `;
        });

        container.innerHTML = html;
    }

    setupQuranEventListeners() {
        // Font size slider
        const fontSlider = document.getElementById('font-size-slider');
        if (fontSlider) {
            fontSlider.addEventListener('input', (e) => {
                this.quranData.fontSize = parseInt(e.target.value);
                document.querySelectorAll('.verse-arabic').forEach(verse => {
                    verse.style.fontSize = `${this.quranData.fontSize}px`;
                });
            });
        }

        // Translation toggle
        const translationToggle = document.getElementById('show-translation');
        if (translationToggle) {
            translationToggle.addEventListener('change', (e) => {
                this.quranData.showTranslation = e.target.checked;
                this.loadCurrentSurah();
            });
        }

        // Tafsir toggle
        const tafsirToggle = document.getElementById('show-tafsir');
        if (tafsirToggle) {
            tafsirToggle.addEventListener('change', (e) => {
                this.quranData.showTafsir = e.target.checked;
                this.loadCurrentSurah();
            });
        }

        // Surah search
        const searchInput = document.getElementById('surah-search');
        if (searchInput) {
            searchInput.addEventListener('input', (e) => {
                this.searchSurah(e.target.value);
            });
        }
    }

    selectSurah(surahNumber) {
        this.quranData.currentSurah = surahNumber;

        // Update active surah in list
        document.querySelectorAll('#surah-list .list-group-item').forEach(item => {
            item.classList.remove('active');
        });

        // Update surah info
        document.getElementById('surah-name').textContent = `سورة الفاتحة`; // Would be dynamic
        document.getElementById('surah-info').textContent = `مكية • 7 آيات`;

        this.loadCurrentSurah();
    }

    playCurrentSurah() {
        this.showNotification('جاري تشغيل السورة...', 'info');
        // Audio playback would be implemented here
    }

    playVerse(verseNumber) {
        this.showNotification(`جاري تشغيل الآية ${verseNumber}...`, 'info');
        // Verse audio playback would be implemented here
    }

    bookmarkSurah() {
        this.showNotification('تم حفظ السورة في المفضلة', 'success');
    }

    shareSurah() {
        const shareText = `سورة الفاتحة من القرآن الكريم - تطبيق أذكار المسلم المحترف`;

        if (navigator.share) {
            navigator.share({
                title: 'سورة من القرآن الكريم',
                text: shareText,
                url: window.location.href
            });
        } else {
            navigator.clipboard.writeText(shareText).then(() => {
                this.showNotification('تم نسخ الرابط للحافظة', 'success');
            });
        }
    }

    previousSurah() {
        if (this.quranData.currentSurah > 1) {
            this.selectSurah(this.quranData.currentSurah - 1);
        }
    }

    nextSurah() {
        if (this.quranData.currentSurah < 114) {
            this.selectSurah(this.quranData.currentSurah + 1);
        }
    }

    searchSurah(query) {
        const items = document.querySelectorAll('#surah-list .list-group-item');
        items.forEach(item => {
            const text = item.textContent.toLowerCase();
            if (text.includes(query.toLowerCase())) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    }
    loadZakatPage() {
        const content = `
            <div class="container py-5">
                <!-- Header -->
                <div class="text-center mb-5">
                    <h1 class="mb-3" style="font-family: var(--font-arabic);">حاسبة الزكاة</h1>
                    <p class="text-muted">احسب زكاة أموالك بسهولة ودقة وفقاً للشريعة الإسلامية</p>
                </div>

                <div class="row">
                    <!-- Zakat Types -->
                    <div class="col-lg-3">
                        <div class="card card-islamic mb-4">
                            <div class="card-header-islamic">
                                <h5 class="mb-0">
                                    <i class="fas fa-list me-2"></i>
                                    أنواع الزكاة
                                </h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="list-group list-group-flush">
                                    <a href="#" class="list-group-item list-group-item-action active"
                                       data-zakat-type="money" onclick="app.selectZakatType('money')">
                                        <i class="fas fa-coins me-2"></i>زكاة المال
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-zakat-type="gold" onclick="app.selectZakatType('gold')">
                                        <i class="fas fa-gem me-2"></i>زكاة الذهب
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-zakat-type="silver" onclick="app.selectZakatType('silver')">
                                        <i class="fas fa-ring me-2"></i>زكاة الفضة
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-zakat-type="trade" onclick="app.selectZakatType('trade')">
                                        <i class="fas fa-store me-2"></i>زكاة التجارة
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-zakat-type="crops" onclick="app.selectZakatType('crops')">
                                        <i class="fas fa-seedling me-2"></i>زكاة الزروع
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-zakat-type="livestock" onclick="app.selectZakatType('livestock')">
                                        <i class="fas fa-horse me-2"></i>زكاة الأنعام
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Zakat Info -->
                        <div class="card card-islamic">
                            <div class="card-header-islamic">
                                <h6 class="mb-0">
                                    <i class="fas fa-info-circle me-2"></i>
                                    معلومات مهمة
                                </h6>
                            </div>
                            <div class="card-body">
                                <div id="zakat-info">
                                    <p class="small mb-2"><strong>النصاب:</strong> <span id="nisab-amount">85 جرام ذهب</span></p>
                                    <p class="small mb-2"><strong>المعدل:</strong> <span id="zakat-rate">2.5%</span></p>
                                    <p class="small mb-0"><strong>الحول:</strong> <span id="hawl-period">سنة هجرية</span></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Calculator -->
                    <div class="col-lg-9">
                        <div class="card card-islamic">
                            <div class="card-header-islamic">
                                <h5 class="mb-0" id="calculator-title">
                                    <i class="fas fa-calculator me-2"></i>
                                    حاسبة زكاة المال
                                </h5>
                            </div>
                            <div class="card-body">
                                <div id="calculator-content">
                                    <!-- Calculator content will be loaded here -->
                                </div>
                            </div>
                        </div>

                        <!-- Results -->
                        <div class="card card-islamic mt-4" id="results-card" style="display: none;">
                            <div class="card-header-islamic">
                                <h5 class="mb-0">
                                    <i class="fas fa-chart-pie me-2"></i>
                                    نتائج الحساب
                                </h5>
                            </div>
                            <div class="card-body">
                                <div id="calculation-results">
                                    <!-- Results will be displayed here -->
                                </div>
                            </div>
                        </div>

                        <!-- Zakat Distribution -->
                        <div class="card card-islamic mt-4">
                            <div class="card-header-islamic">
                                <h5 class="mb-0">
                                    <i class="fas fa-hand-holding-heart me-2"></i>
                                    مصارف الزكاة
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="zakat-category">
                                            <div class="category-icon mb-2">
                                                <i class="fas fa-user-friends text-islamic"></i>
                                            </div>
                                            <h6>الفقراء</h6>
                                            <p class="small text-muted">الذين لا يجدون كفايتهم</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6 col-lg-4">
                                        <div class="zakat-category">
                                            <div class="category-icon mb-2">
                                                <i class="fas fa-hands-helping text-islamic"></i>
                                            </div>
                                            <h6>المساكين</h6>
                                            <p class="small text-muted">الذين يجدون بعض كفايتهم</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6 col-lg-4">
                                        <div class="zakat-category">
                                            <div class="category-icon mb-2">
                                                <i class="fas fa-users text-islamic"></i>
                                            </div>
                                            <h6>العاملين عليها</h6>
                                            <p class="small text-muted">جباة الزكاة</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6 col-lg-4">
                                        <div class="zakat-category">
                                            <div class="category-icon mb-2">
                                                <i class="fas fa-heart text-islamic"></i>
                                            </div>
                                            <h6>المؤلفة قلوبهم</h6>
                                            <p class="small text-muted">الذين يُرجى إسلامهم</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6 col-lg-4">
                                        <div class="zakat-category">
                                            <div class="category-icon mb-2">
                                                <i class="fas fa-unlock text-islamic"></i>
                                            </div>
                                            <h6>في الرقاب</h6>
                                            <p class="small text-muted">تحرير العبيد</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6 col-lg-4">
                                        <div class="zakat-category">
                                            <div class="category-icon mb-2">
                                                <i class="fas fa-credit-card text-islamic"></i>
                                            </div>
                                            <h6>الغارمين</h6>
                                            <p class="small text-muted">المدينون العاجزون</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6 col-lg-4">
                                        <div class="zakat-category">
                                            <div class="category-icon mb-2">
                                                <i class="fas fa-mosque text-islamic"></i>
                                            </div>
                                            <h6>في سبيل الله</h6>
                                            <p class="small text-muted">الجهاد والدعوة</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6 col-lg-4">
                                        <div class="zakat-category">
                                            <div class="category-icon mb-2">
                                                <i class="fas fa-route text-islamic"></i>
                                            </div>
                                            <h6>ابن السبيل</h6>
                                            <p class="small text-muted">المسافر المنقطع</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.getElementById('main-content').innerHTML = content;
        this.initializeZakatCalculator();
    }

    initializeZakatCalculator() {
        this.zakatData = {
            currentType: 'money',
            nisabRates: {
                money: { nisab: 85, rate: 2.5, unit: 'جرام ذهب' },
                gold: { nisab: 85, rate: 2.5, unit: 'جرام' },
                silver: { nisab: 595, rate: 2.5, unit: 'جرام' },
                trade: { nisab: 85, rate: 2.5, unit: 'جرام ذهب' },
                crops: { nisab: 653, rate: 10, unit: 'كيلو' },
                livestock: { nisab: 40, rate: 1, unit: 'رأس' }
            }
        };

        this.loadZakatCalculator('money');
    }

    selectZakatType(type) {
        // Update active type
        document.querySelectorAll('[data-zakat-type]').forEach(item => {
            item.classList.remove('active');
        });
        document.querySelector(`[data-zakat-type="${type}"]`).classList.add('active');

        this.zakatData.currentType = type;
        this.loadZakatCalculator(type);
        this.updateZakatInfo(type);
    }

    loadZakatCalculator(type) {
        const calculatorContent = document.getElementById('calculator-content');
        const calculatorTitle = document.getElementById('calculator-title');

        const titles = {
            money: 'حاسبة زكاة المال',
            gold: 'حاسبة زكاة الذهب',
            silver: 'حاسبة زكاة الفضة',
            trade: 'حاسبة زكاة التجارة',
            crops: 'حاسبة زكاة الزروع',
            livestock: 'حاسبة زكاة الأنعام'
        };

        calculatorTitle.innerHTML = `<i class="fas fa-calculator me-2"></i>${titles[type]}`;

        let html = '';

        switch(type) {
            case 'money':
                html = this.getMoneyCalculatorHTML();
                break;
            case 'gold':
                html = this.getGoldCalculatorHTML();
                break;
            case 'silver':
                html = this.getSilverCalculatorHTML();
                break;
            case 'trade':
                html = this.getTradeCalculatorHTML();
                break;
            case 'crops':
                html = this.getCropsCalculatorHTML();
                break;
            case 'livestock':
                html = this.getLivestockCalculatorHTML();
                break;
        }

        calculatorContent.innerHTML = html;
    }

    getMoneyCalculatorHTML() {
        return `
            <form id="money-zakat-form">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">النقد المتوفر (بالعملة المحلية)</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="cash-amount" placeholder="0">
                            <span class="input-group-text">جنيه</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">الودائع البنكية</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="bank-deposits" placeholder="0">
                            <span class="input-group-text">جنيه</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">الاستثمارات</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="investments" placeholder="0">
                            <span class="input-group-text">جنيه</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">الديون المستحقة لك</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="receivables" placeholder="0">
                            <span class="input-group-text">جنيه</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">الديون عليك</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="debts" placeholder="0">
                            <span class="input-group-text">جنيه</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">سعر جرام الذهب الحالي</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="gold-price" value="3500" placeholder="3500">
                            <span class="input-group-text">جنيه</span>
                        </div>
                    </div>
                    <div class="col-12">
                        <button type="button" class="btn btn-islamic" onclick="app.calculateZakat()">
                            <i class="fas fa-calculator me-2"></i>احسب الزكاة
                        </button>
                        <button type="button" class="btn btn-outline-islamic ms-2" onclick="app.resetCalculator()">
                            <i class="fas fa-redo me-2"></i>إعادة تعيين
                        </button>
                    </div>
                </div>
            </form>
        `;
    }

    getGoldCalculatorHTML() {
        return `
            <form id="gold-zakat-form">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">وزن الذهب (بالجرام)</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="gold-weight" placeholder="0">
                            <span class="input-group-text">جرام</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">عيار الذهب</label>
                        <select class="form-select" id="gold-karat">
                            <option value="24">24 قيراط (ذهب خالص)</option>
                            <option value="22">22 قيراط</option>
                            <option value="21" selected>21 قيراط</option>
                            <option value="18">18 قيراط</option>
                            <option value="14">14 قيراط</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            نصاب الذهب هو 85 جرام من الذهب الخالص (24 قيراط)
                        </div>
                    </div>
                    <div class="col-12">
                        <button type="button" class="btn btn-islamic" onclick="app.calculateZakat()">
                            <i class="fas fa-calculator me-2"></i>احسب الزكاة
                        </button>
                        <button type="button" class="btn btn-outline-islamic ms-2" onclick="app.resetCalculator()">
                            <i class="fas fa-redo me-2"></i>إعادة تعيين
                        </button>
                    </div>
                </div>
            </form>
        `;
    }

    getSilverCalculatorHTML() {
        return `
            <form id="silver-zakat-form">
                <div class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">وزن الفضة (بالجرام)</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="silver-weight" placeholder="0">
                            <span class="input-group-text">جرام</span>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            نصاب الفضة هو 595 جرام من الفضة الخالصة
                        </div>
                    </div>
                    <div class="col-12">
                        <button type="button" class="btn btn-islamic" onclick="app.calculateZakat()">
                            <i class="fas fa-calculator me-2"></i>احسب الزكاة
                        </button>
                        <button type="button" class="btn btn-outline-islamic ms-2" onclick="app.resetCalculator()">
                            <i class="fas fa-redo me-2"></i>إعادة تعيين
                        </button>
                    </div>
                </div>
            </form>
        `;
    }

    getTradeCalculatorHTML() {
        return `
            <form id="trade-zakat-form">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">قيمة البضائع</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="goods-value" placeholder="0">
                            <span class="input-group-text">جنيه</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">النقد في التجارة</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="trade-cash" placeholder="0">
                            <span class="input-group-text">جنيه</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">الديون التجارية المستحقة</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="trade-receivables" placeholder="0">
                            <span class="input-group-text">جنيه</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">الديون التجارية عليك</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="trade-debts" placeholder="0">
                            <span class="input-group-text">جنيه</span>
                        </div>
                    </div>
                    <div class="col-12">
                        <button type="button" class="btn btn-islamic" onclick="app.calculateZakat()">
                            <i class="fas fa-calculator me-2"></i>احسب الزكاة
                        </button>
                        <button type="button" class="btn btn-outline-islamic ms-2" onclick="app.resetCalculator()">
                            <i class="fas fa-redo me-2"></i>إعادة تعيين
                        </button>
                    </div>
                </div>
            </form>
        `;
    }

    getCropsCalculatorHTML() {
        return `
            <form id="crops-zakat-form">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">نوع المحصول</label>
                        <select class="form-select" id="crop-type">
                            <option value="wheat">قمح</option>
                            <option value="rice">أرز</option>
                            <option value="barley">شعير</option>
                            <option value="dates">تمر</option>
                            <option value="other">أخرى</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">كمية المحصول (بالكيلو)</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="crop-amount" placeholder="0">
                            <span class="input-group-text">كيلو</span>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label">طريقة الري</label>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="irrigation" id="rain-irrigation" value="rain" checked>
                            <label class="form-check-label" for="rain-irrigation">
                                بالمطر أو الأنهار (العشر - 10%)
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="irrigation" id="artificial-irrigation" value="artificial">
                            <label class="form-check-label" for="artificial-irrigation">
                                بالري الصناعي (نصف العشر - 5%)
                            </label>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            نصاب الزروع هو 653 كيلو جرام
                        </div>
                    </div>
                    <div class="col-12">
                        <button type="button" class="btn btn-islamic" onclick="app.calculateZakat()">
                            <i class="fas fa-calculator me-2"></i>احسب الزكاة
                        </button>
                        <button type="button" class="btn btn-outline-islamic ms-2" onclick="app.resetCalculator()">
                            <i class="fas fa-redo me-2"></i>إعادة تعيين
                        </button>
                    </div>
                </div>
            </form>
        `;
    }

    getLivestockCalculatorHTML() {
        return `
            <form id="livestock-zakat-form">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">الإبل</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="camels-count" placeholder="0">
                            <span class="input-group-text">رأس</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">البقر</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="cattle-count" placeholder="0">
                            <span class="input-group-text">رأس</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">الغنم والماعز</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="sheep-count" placeholder="0">
                            <span class="input-group-text">رأس</span>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            يشترط أن تكون الأنعام سائمة (ترعى) معظم السنة
                        </div>
                    </div>
                    <div class="col-12">
                        <button type="button" class="btn btn-islamic" onclick="app.calculateZakat()">
                            <i class="fas fa-calculator me-2"></i>احسب الزكاة
                        </button>
                        <button type="button" class="btn btn-outline-islamic ms-2" onclick="app.resetCalculator()">
                            <i class="fas fa-redo me-2"></i>إعادة تعيين
                        </button>
                    </div>
                </div>
            </form>
        `;
    }

    updateZakatInfo(type) {
        const info = this.zakatData.nisabRates[type];
        document.getElementById('nisab-amount').textContent = `${info.nisab} ${info.unit}`;
        document.getElementById('zakat-rate').textContent = `${info.rate}%`;

        const hawlPeriods = {
            money: 'سنة هجرية',
            gold: 'سنة هجرية',
            silver: 'سنة هجرية',
            trade: 'سنة هجرية',
            crops: 'عند الحصاد',
            livestock: 'سنة هجرية'
        };

        document.getElementById('hawl-period').textContent = hawlPeriods[type];
    }

    calculateZakat() {
        const type = this.zakatData.currentType;
        let result = {};

        switch(type) {
            case 'money':
                result = this.calculateMoneyZakat();
                break;
            case 'gold':
                result = this.calculateGoldZakat();
                break;
            case 'silver':
                result = this.calculateSilverZakat();
                break;
            case 'trade':
                result = this.calculateTradeZakat();
                break;
            case 'crops':
                result = this.calculateCropsZakat();
                break;
            case 'livestock':
                result = this.calculateLivestockZakat();
                break;
        }

        this.displayZakatResults(result);
    }

    calculateMoneyZakat() {
        const cash = parseFloat(document.getElementById('cash-amount').value) || 0;
        const deposits = parseFloat(document.getElementById('bank-deposits').value) || 0;
        const investments = parseFloat(document.getElementById('investments').value) || 0;
        const receivables = parseFloat(document.getElementById('receivables').value) || 0;
        const debts = parseFloat(document.getElementById('debts').value) || 0;
        const goldPrice = parseFloat(document.getElementById('gold-price').value) || 3500;

        const totalWealth = cash + deposits + investments + receivables - debts;
        const nisabValue = 85 * goldPrice; // 85 grams of gold

        const isZakatDue = totalWealth >= nisabValue;
        const zakatAmount = isZakatDue ? totalWealth * 0.025 : 0;

        return {
            totalWealth,
            nisabValue,
            isZakatDue,
            zakatAmount,
            type: 'money'
        };
    }

    calculateGoldZakat() {
        const weight = parseFloat(document.getElementById('gold-weight').value) || 0;
        const karat = parseFloat(document.getElementById('gold-karat').value) || 21;

        const pureGoldWeight = (weight * karat) / 24;
        const nisab = 85; // grams

        const isZakatDue = pureGoldWeight >= nisab;
        const zakatAmount = isZakatDue ? pureGoldWeight * 0.025 : 0;

        return {
            totalWeight: weight,
            pureGoldWeight,
            nisab,
            isZakatDue,
            zakatAmount,
            type: 'gold'
        };
    }

    calculateSilverZakat() {
        const weight = parseFloat(document.getElementById('silver-weight').value) || 0;
        const nisab = 595; // grams

        const isZakatDue = weight >= nisab;
        const zakatAmount = isZakatDue ? weight * 0.025 : 0;

        return {
            totalWeight: weight,
            nisab,
            isZakatDue,
            zakatAmount,
            type: 'silver'
        };
    }

    calculateTradeZakat() {
        const goodsValue = parseFloat(document.getElementById('goods-value').value) || 0;
        const tradeCash = parseFloat(document.getElementById('trade-cash').value) || 0;
        const receivables = parseFloat(document.getElementById('trade-receivables').value) || 0;
        const debts = parseFloat(document.getElementById('trade-debts').value) || 0;

        const totalTradeWealth = goodsValue + tradeCash + receivables - debts;
        const nisabValue = 85 * 3500; // Assuming gold price

        const isZakatDue = totalTradeWealth >= nisabValue;
        const zakatAmount = isZakatDue ? totalTradeWealth * 0.025 : 0;

        return {
            totalTradeWealth,
            nisabValue,
            isZakatDue,
            zakatAmount,
            type: 'trade'
        };
    }

    calculateCropsZakat() {
        const amount = parseFloat(document.getElementById('crop-amount').value) || 0;
        const irrigation = document.querySelector('input[name="irrigation"]:checked').value;
        const nisab = 653; // kg

        const isZakatDue = amount >= nisab;
        const rate = irrigation === 'rain' ? 0.1 : 0.05;
        const zakatAmount = isZakatDue ? amount * rate : 0;

        return {
            totalAmount: amount,
            nisab,
            isZakatDue,
            zakatAmount,
            irrigationType: irrigation,
            rate: rate * 100,
            type: 'crops'
        };
    }

    calculateLivestockZakat() {
        const camels = parseInt(document.getElementById('camels-count').value) || 0;
        const cattle = parseInt(document.getElementById('cattle-count').value) || 0;
        const sheep = parseInt(document.getElementById('sheep-count').value) || 0;

        let zakatDetails = [];

        // Camel zakat calculation (simplified)
        if (camels >= 5) {
            const zakatCamels = Math.floor(camels / 5);
            zakatDetails.push({ animal: 'الإبل', count: camels, zakat: `${zakatCamels} شاة` });
        }

        // Cattle zakat calculation (simplified)
        if (cattle >= 30) {
            const zakatCattle = Math.floor(cattle / 30);
            zakatDetails.push({ animal: 'البقر', count: cattle, zakat: `${zakatCattle} تبيع` });
        }

        // Sheep zakat calculation (simplified)
        if (sheep >= 40) {
            const zakatSheep = Math.floor(sheep / 40);
            zakatDetails.push({ animal: 'الغنم', count: sheep, zakat: `${zakatSheep} شاة` });
        }

        return {
            zakatDetails,
            isZakatDue: zakatDetails.length > 0,
            type: 'livestock'
        };
    }

    displayZakatResults(result) {
        const resultsCard = document.getElementById('results-card');
        const resultsContent = document.getElementById('calculation-results');

        let html = '';

        if (result.type === 'livestock') {
            if (result.isZakatDue) {
                html = `
                    <div class="alert alert-success">
                        <h5><i class="fas fa-check-circle me-2"></i>الزكاة واجبة</h5>
                    </div>
                    <div class="row g-3">
                `;

                result.zakatDetails.forEach(detail => {
                    html += `
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-body text-center">
                                    <h6>${detail.animal}</h6>
                                    <p class="mb-1">العدد: ${detail.count}</p>
                                    <p class="text-islamic mb-0">الزكاة: ${detail.zakat}</p>
                                </div>
                            </div>
                        </div>
                    `;
                });

                html += `</div>`;
            } else {
                html = `
                    <div class="alert alert-warning">
                        <h5><i class="fas fa-exclamation-triangle me-2"></i>الزكاة غير واجبة</h5>
                        <p class="mb-0">لم تبلغ الأنعام النصاب المطلوب</p>
                    </div>
                `;
            }
        } else {
            if (result.isZakatDue) {
                html = `
                    <div class="alert alert-success">
                        <h5><i class="fas fa-check-circle me-2"></i>الزكاة واجبة</h5>
                    </div>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body text-center">
                                    <h5 class="text-muted">إجمالي المال</h5>
                                    <h3 class="text-dark">${result.totalWealth || result.totalWeight || result.totalAmount || result.totalTradeWealth} ${this.getUnit(result.type)}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card bg-islamic text-white">
                                <div class="card-body text-center">
                                    <h5>مقدار الزكاة</h5>
                                    <h3>${result.zakatAmount.toFixed(2)} ${this.getUnit(result.type)}</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <p class="text-muted">
                            <i class="fas fa-info-circle me-2"></i>
                            النصاب: ${result.nisab || result.nisabValue} ${this.getUnit(result.type)}
                        </p>
                    </div>
                `;
            } else {
                html = `
                    <div class="alert alert-warning">
                        <h5><i class="fas fa-exclamation-triangle me-2"></i>الزكاة غير واجبة</h5>
                        <p class="mb-0">لم يبلغ المال النصاب المطلوب (${result.nisab || result.nisabValue} ${this.getUnit(result.type)})</p>
                    </div>
                `;
            }
        }

        resultsContent.innerHTML = html;
        resultsCard.style.display = 'block';

        // Scroll to results
        resultsCard.scrollIntoView({ behavior: 'smooth' });
    }

    getUnit(type) {
        const units = {
            money: 'جنيه',
            gold: 'جرام',
            silver: 'جرام',
            trade: 'جنيه',
            crops: 'كيلو',
            livestock: 'رأس'
        };
        return units[type] || '';
    }

    resetCalculator() {
        const form = document.querySelector(`#${this.zakatData.currentType}-zakat-form`);
        if (form) {
            form.reset();
        }

        document.getElementById('results-card').style.display = 'none';
    }
    loadSettingsPage() {
        const content = `
            <div class="container py-5">
                <!-- Header -->
                <div class="text-center mb-5">
                    <h1 class="mb-3" style="font-family: var(--font-arabic);">الإعدادات</h1>
                    <p class="text-muted">خصص التطبيق حسب احتياجاتك وتفضيلاتك</p>
                </div>

                <div class="row">
                    <!-- Settings Categories -->
                    <div class="col-lg-3">
                        <div class="card card-islamic mb-4">
                            <div class="card-header-islamic">
                                <h5 class="mb-0">
                                    <i class="fas fa-list me-2"></i>
                                    فئات الإعدادات
                                </h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="list-group list-group-flush">
                                    <a href="#" class="list-group-item list-group-item-action active"
                                       data-settings-category="general" onclick="app.selectSettingsCategory('general')">
                                        <i class="fas fa-cog me-2"></i>إعدادات عامة
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-settings-category="appearance" onclick="app.selectSettingsCategory('appearance')">
                                        <i class="fas fa-palette me-2"></i>المظهر
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-settings-category="notifications" onclick="app.selectSettingsCategory('notifications')">
                                        <i class="fas fa-bell me-2"></i>الإشعارات
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-settings-category="prayer" onclick="app.selectSettingsCategory('prayer')">
                                        <i class="fas fa-pray me-2"></i>إعدادات الصلاة
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-settings-category="azkar" onclick="app.selectSettingsCategory('azkar')">
                                        <i class="fas fa-book me-2"></i>إعدادات الأذكار
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-settings-category="backup" onclick="app.selectSettingsCategory('backup')">
                                        <i class="fas fa-cloud me-2"></i>النسخ الاحتياطي
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action"
                                       data-settings-category="about" onclick="app.selectSettingsCategory('about')">
                                        <i class="fas fa-info-circle me-2"></i>حول التطبيق
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Settings Content -->
                    <div class="col-lg-9">
                        <div class="card card-islamic">
                            <div class="card-header-islamic">
                                <h5 class="mb-0" id="settings-title">
                                    <i class="fas fa-cog me-2"></i>
                                    الإعدادات العامة
                                </h5>
                            </div>
                            <div class="card-body">
                                <div id="settings-content">
                                    <!-- Settings content will be loaded here -->
                                </div>
                            </div>
                        </div>

                        <!-- Save Button -->
                        <div class="text-center mt-4">
                            <button class="btn btn-islamic btn-lg" onclick="app.saveSettings()">
                                <i class="fas fa-save me-2"></i>حفظ الإعدادات
                            </button>
                            <button class="btn btn-outline-islamic btn-lg ms-3" onclick="app.resetSettings()">
                                <i class="fas fa-undo me-2"></i>إعادة تعيين
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.getElementById('main-content').innerHTML = content;
        this.initializeSettingsPage();
    }

    initializeSettingsPage() {
        this.loadSettingsCategory('general');
    }

    selectSettingsCategory(category) {
        // Update active category
        document.querySelectorAll('[data-settings-category]').forEach(item => {
            item.classList.remove('active');
        });
        document.querySelector(`[data-settings-category="${category}"]`).classList.add('active');

        this.loadSettingsCategory(category);
    }

    loadSettingsCategory(category) {
        const settingsContent = document.getElementById('settings-content');
        const settingsTitle = document.getElementById('settings-title');

        const titles = {
            general: 'الإعدادات العامة',
            appearance: 'إعدادات المظهر',
            notifications: 'إعدادات الإشعارات',
            prayer: 'إعدادات الصلاة',
            azkar: 'إعدادات الأذكار',
            backup: 'النسخ الاحتياطي',
            about: 'حول التطبيق'
        };

        const icons = {
            general: 'fas fa-cog',
            appearance: 'fas fa-palette',
            notifications: 'fas fa-bell',
            prayer: 'fas fa-pray',
            azkar: 'fas fa-book',
            backup: 'fas fa-cloud',
            about: 'fas fa-info-circle'
        };

        settingsTitle.innerHTML = `<i class="${icons[category]} me-2"></i>${titles[category]}`;

        let html = '';

        switch(category) {
            case 'general':
                html = this.getGeneralSettingsHTML();
                break;
            case 'appearance':
                html = this.getAppearanceSettingsHTML();
                break;
            case 'notifications':
                html = this.getNotificationsSettingsHTML();
                break;
            case 'prayer':
                html = this.getPrayerSettingsHTML();
                break;
            case 'azkar':
                html = this.getAzkarSettingsHTML();
                break;
            case 'backup':
                html = this.getBackupSettingsHTML();
                break;
            case 'about':
                html = this.getAboutHTML();
                break;
        }

        settingsContent.innerHTML = html;
    }

    getGeneralSettingsHTML() {
        return `
            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label">اللغة</label>
                    <select class="form-select" id="language-select">
                        <option value="ar" selected>العربية</option>
                        <option value="en">English</option>
                        <option value="fr">Français</option>
                        <option value="ur">اردو</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">المنطقة الزمنية</label>
                    <select class="form-select" id="timezone-select">
                        <option value="Africa/Cairo" selected>القاهرة (GMT+2)</option>
                        <option value="Asia/Riyadh">الرياض (GMT+3)</option>
                        <option value="Asia/Dubai">دبي (GMT+4)</option>
                        <option value="Europe/London">لندن (GMT+0)</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">تنسيق التاريخ</label>
                    <select class="form-select" id="date-format">
                        <option value="hijri" selected>هجري</option>
                        <option value="gregorian">ميلادي</option>
                        <option value="both">كلاهما</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">تنسيق الوقت</label>
                    <select class="form-select" id="time-format">
                        <option value="12" selected>12 ساعة</option>
                        <option value="24">24 ساعة</option>
                    </select>
                </div>
                <div class="col-12">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="auto-location" checked>
                        <label class="form-check-label" for="auto-location">
                            تحديد الموقع تلقائياً
                        </label>
                    </div>
                </div>
                <div class="col-12">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="offline-mode">
                        <label class="form-check-label" for="offline-mode">
                            تفعيل الوضع غير المتصل
                        </label>
                    </div>
                </div>
            </div>
        `;
    }

    getAppearanceSettingsHTML() {
        return `
            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label">المظهر</label>
                    <select class="form-select" id="theme-select">
                        <option value="light" selected>فاتح</option>
                        <option value="dark">داكن</option>
                        <option value="auto">تلقائي</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">حجم الخط</label>
                    <select class="form-select" id="font-size-select">
                        <option value="small">صغير</option>
                        <option value="medium" selected>متوسط</option>
                        <option value="large">كبير</option>
                        <option value="extra-large">كبير جداً</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">نوع الخط العربي</label>
                    <select class="form-select" id="arabic-font">
                        <option value="amiri" selected>أميري</option>
                        <option value="cairo">القاهرة</option>
                        <option value="noto">نوتو</option>
                        <option value="scheherazade">شهرزاد</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">اللون الأساسي</label>
                    <select class="form-select" id="primary-color">
                        <option value="green" selected>أخضر</option>
                        <option value="blue">أزرق</option>
                        <option value="brown">بني</option>
                        <option value="gold">ذهبي</option>
                    </select>
                </div>
                <div class="col-12">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="animations" checked>
                        <label class="form-check-label" for="animations">
                            تفعيل الرسوم المتحركة
                        </label>
                    </div>
                </div>
                <div class="col-12">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="islamic-patterns" checked>
                        <label class="form-check-label" for="islamic-patterns">
                            إظهار النقوش الإسلامية
                        </label>
                    </div>
                </div>
            </div>
        `;
    }

    getNotificationsSettingsHTML() {
        return `
            <div class="row g-4">
                <div class="col-12">
                    <h6 class="text-islamic">إشعارات الصلاة</h6>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="fajr-notification" checked>
                        <label class="form-check-label" for="fajr-notification">
                            إشعار صلاة الفجر
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="dhuhr-notification" checked>
                        <label class="form-check-label" for="dhuhr-notification">
                            إشعار صلاة الظهر
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="asr-notification" checked>
                        <label class="form-check-label" for="asr-notification">
                            إشعار صلاة العصر
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="maghrib-notification" checked>
                        <label class="form-check-label" for="maghrib-notification">
                            إشعار صلاة المغرب
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="isha-notification" checked>
                        <label class="form-check-label" for="isha-notification">
                            إشعار صلاة العشاء
                        </label>
                    </div>
                </div>
                <div class="col-12">
                    <hr>
                    <h6 class="text-islamic">إشعارات الأذكار</h6>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="morning-azkar-notification" checked>
                        <label class="form-check-label" for="morning-azkar-notification">
                            تذكير أذكار الصباح
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="evening-azkar-notification" checked>
                        <label class="form-check-label" for="evening-azkar-notification">
                            تذكير أذكار المساء
                        </label>
                    </div>
                </div>
                <div class="col-12">
                    <hr>
                    <h6 class="text-islamic">إعدادات الصوت</h6>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="sound-enabled" checked>
                        <label class="form-check-label" for="sound-enabled">
                            تفعيل الأصوات
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="vibration-enabled" checked>
                        <label class="form-check-label" for="vibration-enabled">
                            تفعيل الاهتزاز
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label">مستوى الصوت</label>
                    <input type="range" class="form-range" min="0" max="100" value="70" id="volume-level">
                </div>
                <div class="col-md-6">
                    <label class="form-label">نغمة الإشعار</label>
                    <select class="form-select" id="notification-sound">
                        <option value="default" selected>افتراضي</option>
                        <option value="adhan">أذان</option>
                        <option value="bell">جرس</option>
                        <option value="chime">نغمة</option>
                    </select>
                </div>
            </div>
        `;
    }

    getPrayerSettingsHTML() {
        return `
            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label">طريقة حساب المواقيت</label>
                    <select class="form-select" id="calculation-method">
                        <option value="egypt" selected>الهيئة المصرية العامة للمساحة</option>
                        <option value="mwl">رابطة العالم الإسلامي</option>
                        <option value="umm-al-qura">جامعة أم القرى</option>
                        <option value="isna">الجمعية الإسلامية لأمريكا الشمالية</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">المذهب الفقهي</label>
                    <select class="form-select" id="madhab">
                        <option value="shafi" selected>شافعي</option>
                        <option value="hanafi">حنفي</option>
                        <option value="maliki">مالكي</option>
                        <option value="hanbali">حنبلي</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">تعديل وقت الفجر (دقائق)</label>
                    <input type="number" class="form-control" id="fajr-adjustment" value="0" min="-30" max="30">
                </div>
                <div class="col-md-6">
                    <label class="form-label">تعديل وقت الظهر (دقائق)</label>
                    <input type="number" class="form-control" id="dhuhr-adjustment" value="0" min="-30" max="30">
                </div>
                <div class="col-md-6">
                    <label class="form-label">تعديل وقت العصر (دقائق)</label>
                    <input type="number" class="form-control" id="asr-adjustment" value="0" min="-30" max="30">
                </div>
                <div class="col-md-6">
                    <label class="form-label">تعديل وقت المغرب (دقائق)</label>
                    <input type="number" class="form-control" id="maghrib-adjustment" value="0" min="-30" max="30">
                </div>
                <div class="col-md-6">
                    <label class="form-label">تعديل وقت العشاء (دقائق)</label>
                    <input type="number" class="form-control" id="isha-adjustment" value="0" min="-30" max="30">
                </div>
                <div class="col-12">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="dst-adjustment" checked>
                        <label class="form-check-label" for="dst-adjustment">
                            تعديل تلقائي للتوقيت الصيفي
                        </label>
                    </div>
                </div>
            </div>
        `;
    }

    getAzkarSettingsHTML() {
        return `
            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label">حجم خط الأذكار</label>
                    <input type="range" class="form-range" min="14" max="28" value="18" id="azkar-font-size">
                    <div class="d-flex justify-content-between">
                        <small>صغير</small>
                        <small>كبير</small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check mt-4">
                        <input class="form-check-input" type="checkbox" id="show-translation" checked>
                        <label class="form-check-label" for="show-translation">
                            إظهار الترجمة
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="show-reference" checked>
                        <label class="form-check-label" for="show-reference">
                            إظهار المرجع
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="show-benefit">
                        <label class="form-check-label" for="show-benefit">
                            إظهار الفائدة
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="auto-play" checked>
                        <label class="form-check-label" for="auto-play">
                            التشغيل التلقائي للصوت
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="counter-sound" checked>
                        <label class="form-check-label" for="counter-sound">
                            صوت العداد
                        </label>
                    </div>
                </div>
                <div class="col-12">
                    <label class="form-label">وقت تذكير أذكار الصباح</label>
                    <input type="time" class="form-control" id="morning-reminder-time" value="06:00">
                </div>
                <div class="col-12">
                    <label class="form-label">وقت تذكير أذكار المساء</label>
                    <input type="time" class="form-control" id="evening-reminder-time" value="18:00">
                </div>
            </div>
        `;
    }

    getBackupSettingsHTML() {
        return `
            <div class="row g-4">
                <div class="col-12">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        يمكنك حفظ إعداداتك وبياناتك واستعادتها في أي وقت
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body text-center">
                            <i class="fas fa-download text-islamic mb-3" style="font-size: 2rem;"></i>
                            <h6>تصدير البيانات</h6>
                            <p class="text-muted small">احفظ جميع إعداداتك وبياناتك</p>
                            <button class="btn btn-islamic btn-sm" onclick="app.exportData()">
                                تصدير
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body text-center">
                            <i class="fas fa-upload text-islamic mb-3" style="font-size: 2rem;"></i>
                            <h6>استيراد البيانات</h6>
                            <p class="text-muted small">استعد إعداداتك وبياناتك المحفوظة</p>
                            <input type="file" id="import-file" accept=".json" style="display: none;" onchange="app.importData(event)">
                            <button class="btn btn-islamic btn-sm" onclick="document.getElementById('import-file').click()">
                                استيراد
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="auto-backup" checked>
                        <label class="form-check-label" for="auto-backup">
                            النسخ الاحتياطي التلقائي
                        </label>
                    </div>
                </div>
                <div class="col-12">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="cloud-sync">
                        <label class="form-check-label" for="cloud-sync">
                            مزامنة مع التخزين السحابي
                        </label>
                    </div>
                </div>
            </div>
        `;
    }

    getAboutHTML() {
        return `
            <div class="text-center">
                <div class="mb-4">
                    <i class="fas fa-mosque text-islamic" style="font-size: 4rem;"></i>
                </div>
                <h3 class="mb-3">أذكار المسلم المحترف</h3>
                <p class="text-muted mb-4">رفيقك في رحلة الإيمان</p>

                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h6>الإصدار</h6>
                                <p class="text-islamic mb-0">1.0.0</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h6>تاريخ الإصدار</h6>
                                <p class="text-islamic mb-0">يناير 2024</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h6>المطور</h6>
                                <p class="text-islamic mb-0">Ahmed Mostafa Ibrahim</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <h5>الميزات</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check text-success me-2"></i>
                                <span>أكثر من 100 ذكر مع المراجع</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check text-success me-2"></i>
                                <span>مواقيت الصلاة الدقيقة</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check text-success me-2"></i>
                                <span>السبحة الرقمية التفاعلية</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check text-success me-2"></i>
                                <span>قارئ القرآن الكريم</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check text-success me-2"></i>
                                <span>حاسبة الزكاة الشاملة</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check text-success me-2"></i>
                                <span>تصميم إسلامي جميل</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <h5>تواصل معنا</h5>
                    <p class="text-muted">gogom8870@gmail.com</p>
                </div>

                <div class="text-muted">
                    <small>
                        جميع الحقوق محفوظة © 2024<br>
                        تم التطوير بـ ❤️ لخدمة المسلمين
                    </small>
                </div>
            </div>
        `;
    }

    saveSettings() {
        // Collect all settings from the form
        const settings = {};

        // Get all form inputs
        const inputs = document.querySelectorAll('#settings-content input, #settings-content select');
        inputs.forEach(input => {
            if (input.type === 'checkbox') {
                settings[input.id] = input.checked;
            } else if (input.type === 'range') {
                settings[input.id] = parseInt(input.value);
            } else {
                settings[input.id] = input.value;
            }
        });

        // Save to localStorage
        localStorage.setItem('muslim-app-settings', JSON.stringify(settings));

        // Apply settings
        this.applySettings(settings);

        // Show success message
        this.showNotification('تم حفظ الإعدادات بنجاح', 'success');
    }

    resetSettings() {
        if (confirm('هل أنت متأكد من إعادة تعيين جميع الإعدادات؟')) {
            localStorage.removeItem('muslim-app-settings');
            this.settings = this.loadSettings();
            this.loadSettingsCategory('general');
            this.showNotification('تم إعادة تعيين الإعدادات', 'info');
        }
    }

    applySettings(settings) {
        // Apply theme
        if (settings['theme-select']) {
            this.theme = settings['theme-select'];
            this.applyTheme();
        }

        // Apply other settings as needed
        // This would include font size, colors, etc.
    }

    exportData() {
        const data = {
            settings: this.settings,
            userData: {
                // Add user data like favorites, progress, etc.
            },
            exportDate: new Date().toISOString()
        };

        const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);

        const a = document.createElement('a');
        a.href = url;
        a.download = `muslim-app-backup-${new Date().toISOString().split('T')[0]}.json`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

        URL.revokeObjectURL(url);
        this.showNotification('تم تصدير البيانات بنجاح', 'success');
    }

    importData(event) {
        const file = event.target.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = (e) => {
            try {
                const data = JSON.parse(e.target.result);

                if (data.settings) {
                    localStorage.setItem('muslim-app-settings', JSON.stringify(data.settings));
                    this.settings = data.settings;
                    this.applySettings(data.settings);
                }

                this.showNotification('تم استيراد البيانات بنجاح', 'success');
                this.loadSettingsCategory('general');
            } catch (error) {
                this.showNotification('خطأ في استيراد البيانات', 'error');
            }
        };

        reader.readAsText(file);
    }
}

    // Advanced Features
    enableOfflineMode() {
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('sw.js')
                .then(registration => {
                    console.log('Service Worker registered:', registration);
                    this.showNotification('تم تفعيل الوضع غير المتصل', 'success');
                })
                .catch(error => {
                    console.error('Service Worker registration failed:', error);
                });
        }
    }

    requestNotificationPermission() {
        if ('Notification' in window) {
            Notification.requestPermission().then(permission => {
                if (permission === 'granted') {
                    this.showNotification('تم تفعيل الإشعارات', 'success');
                } else {
                    this.showNotification('لم يتم تفعيل الإشعارات', 'warning');
                }
            });
        }
    }

    installApp() {
        if (this.deferredPrompt) {
            this.deferredPrompt.prompt();
            this.deferredPrompt.userChoice.then(choiceResult => {
                if (choiceResult.outcome === 'accepted') {
                    console.log('User accepted the install prompt');
                } else {
                    console.log('User dismissed the install prompt');
                }
                this.deferredPrompt = null;
            });
        }
    }

    // Performance monitoring
    measurePerformance() {
        if ('performance' in window) {
            const navigation = performance.getEntriesByType('navigation')[0];
            const loadTime = navigation.loadEventEnd - navigation.loadEventStart;
            console.log(`Page load time: ${loadTime}ms`);

            // Send to analytics if available
            if (window.gtag) {
                window.gtag('event', 'timing_complete', {
                    name: 'load',
                    value: Math.round(loadTime)
                });
            }
        }
    }

    // Error handling
    handleError(error, context = 'Unknown') {
        console.error(`Error in ${context}:`, error);

        // Show user-friendly error message
        this.showNotification('حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.', 'error');

        // Send error to monitoring service
        if (window.Sentry) {
            window.Sentry.captureException(error, {
                tags: { context }
            });
        }
    }

    // Accessibility improvements
    improveAccessibility() {
        // Add skip links
        const skipLink = document.createElement('a');
        skipLink.href = '#main-content';
        skipLink.className = 'sr-only sr-only-focusable';
        skipLink.textContent = 'تخطي إلى المحتوى الرئيسي';
        document.body.insertBefore(skipLink, document.body.firstChild);

        // Add ARIA labels
        document.querySelectorAll('button').forEach(button => {
            if (!button.getAttribute('aria-label') && !button.textContent.trim()) {
                button.setAttribute('aria-label', 'زر');
            }
        });

        // Improve focus management
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Tab') {
                document.body.classList.add('keyboard-navigation');
            }
        });

        document.addEventListener('mousedown', () => {
            document.body.classList.remove('keyboard-navigation');
        });
    }

    // Analytics integration
    trackEvent(action, category = 'General', label = '') {
        if (window.gtag) {
            window.gtag('event', action, {
                event_category: category,
                event_label: label
            });
        }

        console.log(`Analytics: ${category} - ${action} - ${label}`);
    }

    // User preferences
    saveUserPreference(key, value) {
        const preferences = this.loadFromLocalStorage('user-preferences', {});
        preferences[key] = value;
        this.saveToLocalStorage('user-preferences', preferences);
    }

    getUserPreference(key, defaultValue = null) {
        const preferences = this.loadFromLocalStorage('user-preferences', {});
        return preferences[key] !== undefined ? preferences[key] : defaultValue;
    }

    // Data synchronization
    async syncData() {
        try {
            // Sync prayer times
            await this.syncPrayerTimes();

            // Sync user progress
            await this.syncUserProgress();

            this.showNotification('تم تحديث البيانات بنجاح', 'success');
        } catch (error) {
            this.handleError(error, 'Data Sync');
        }
    }

    async syncPrayerTimes() {
        if (this.currentLocation) {
            // This would call a real prayer times API
            const mockPrayerTimes = {
                fajr: '05:30',
                sunrise: '06:45',
                dhuhr: '12:30',
                asr: '15:45',
                maghrib: '18:20',
                isha: '19:45'
            };

            this.prayerTimes = mockPrayerTimes;
            this.saveToLocalStorage('prayer-times', mockPrayerTimes);
        }
    }

    async syncUserProgress() {
        const progress = {
            azkarCompleted: this.getUserPreference('azkar-completed', 0),
            tasbihCount: this.getUserPreference('tasbih-count', 0),
            lastSyncDate: new Date().toISOString()
        };

        this.saveToLocalStorage('user-progress', progress);
    }

    // Utility methods
    saveToLocalStorage(key, data) {
        try {
            localStorage.setItem(key, JSON.stringify(data));
        } catch (error) {
            console.error('Error saving to localStorage:', error);
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
}

// Initialize app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.app = new ProfessionalMuslimApp();

    // Enable advanced features
    window.app.enableOfflineMode();
    window.app.requestNotificationPermission();
    window.app.improveAccessibility();
    window.app.measurePerformance();
});

// Handle browser back/forward buttons
window.addEventListener('popstate', (event) => {
    if (event.state && event.state.page) {
        window.app.navigateTo(event.state.page);
    }
});

// Handle PWA install prompt
window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    window.app.deferredPrompt = e;

    // Show install button
    const installButton = document.createElement('button');
    installButton.className = 'btn btn-islamic position-fixed';
    installButton.style.cssText = 'bottom: 20px; left: 20px; z-index: 1000;';
    installButton.innerHTML = '<i class="fas fa-download me-2"></i>تثبيت التطبيق';
    installButton.onclick = () => window.app.installApp();

    document.body.appendChild(installButton);
});

// Handle app installation
window.addEventListener('appinstalled', () => {
    console.log('PWA was installed');
    window.app.trackEvent('app_installed', 'PWA');
});

// Handle online/offline status
window.addEventListener('online', () => {
    window.app.showNotification('تم الاتصال بالإنترنت', 'success');
    window.app.syncData();
});

window.addEventListener('offline', () => {
    window.app.showNotification('لا يوجد اتصال بالإنترنت - يعمل التطبيق في الوضع غير المتصل', 'warning');
});

// Global error handler
window.addEventListener('error', (event) => {
    window.app.handleError(event.error, 'Global Error');
});

// Unhandled promise rejection handler
window.addEventListener('unhandledrejection', (event) => {
    window.app.handleError(event.reason, 'Unhandled Promise Rejection');
});
