/**
 * Service Worker for Professional Muslim Web App
 * Provides offline functionality and push notifications
 */

const CACHE_NAME = 'professional-muslim-v1.0.0';
const STATIC_CACHE = 'static-v1';
const DYNAMIC_CACHE = 'dynamic-v1';

// Files to cache for offline use
const STATIC_FILES = [
    '/',
    '/index.html',
    '/assets/css/main.css',
    '/assets/css/responsive.css',
    '/assets/css/animations.css',
    '/assets/js/app.js',
    '/assets/js/router.js',
    '/assets/js/components.js',
    '/assets/js/utils.js',
    '/manifest.json',
    // External resources
    'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css',
    'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js',
    'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css',
    'https://fonts.googleapis.com/css2?family=Amiri:ital,wght@0,400;0,700;1,400;1,700&family=Cairo:wght@200;300;400;500;600;700;800;900&display=swap'
];

// Install event - cache static files
self.addEventListener('install', (event) => {
    console.log('Service Worker: Installing...');
    
    event.waitUntil(
        caches.open(STATIC_CACHE)
            .then((cache) => {
                console.log('Service Worker: Caching static files');
                return cache.addAll(STATIC_FILES);
            })
            .catch((error) => {
                console.error('Service Worker: Error caching static files', error);
            })
    );
    
    // Force the waiting service worker to become the active service worker
    self.skipWaiting();
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
    console.log('Service Worker: Activating...');
    
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheName !== STATIC_CACHE && cacheName !== DYNAMIC_CACHE) {
                        console.log('Service Worker: Deleting old cache', cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
    
    // Claim control of all clients
    self.clients.claim();
});

// Fetch event - serve cached files or fetch from network
self.addEventListener('fetch', (event) => {
    // Skip non-GET requests
    if (event.request.method !== 'GET') {
        return;
    }
    
    // Skip chrome-extension requests
    if (event.request.url.startsWith('chrome-extension://')) {
        return;
    }
    
    event.respondWith(
        caches.match(event.request)
            .then((cachedResponse) => {
                // Return cached version if available
                if (cachedResponse) {
                    return cachedResponse;
                }
                
                // Otherwise fetch from network
                return fetch(event.request)
                    .then((response) => {
                        // Check if response is valid
                        if (!response || response.status !== 200 || response.type !== 'basic') {
                            return response;
                        }
                        
                        // Clone the response
                        const responseToCache = response.clone();
                        
                        // Cache dynamic content
                        caches.open(DYNAMIC_CACHE)
                            .then((cache) => {
                                cache.put(event.request, responseToCache);
                            });
                        
                        return response;
                    })
                    .catch(() => {
                        // Return offline page for navigation requests
                        if (event.request.destination === 'document') {
                            return caches.match('/index.html');
                        }
                        
                        // Return placeholder for images
                        if (event.request.destination === 'image') {
                            return new Response(
                                '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200"><rect width="200" height="200" fill="#f0f0f0"/><text x="50%" y="50%" text-anchor="middle" dy=".3em" fill="#999">صورة غير متاحة</text></svg>',
                                { headers: { 'Content-Type': 'image/svg+xml' } }
                            );
                        }
                    });
            })
    );
});

// Background sync for prayer times
self.addEventListener('sync', (event) => {
    if (event.tag === 'prayer-times-sync') {
        event.waitUntil(syncPrayerTimes());
    }
});

// Push notification handler
self.addEventListener('push', (event) => {
    console.log('Service Worker: Push notification received');
    
    let notificationData = {
        title: 'أذكار المسلم المحترف',
        body: 'إشعار جديد',
        icon: '/assets/images/icon-192.png',
        badge: '/assets/images/badge-72.png',
        tag: 'muslim-app-notification',
        requireInteraction: true,
        actions: [
            {
                action: 'open',
                title: 'فتح التطبيق',
                icon: '/assets/images/action-open.png'
            },
            {
                action: 'dismiss',
                title: 'إغلاق',
                icon: '/assets/images/action-dismiss.png'
            }
        ]
    };
    
    if (event.data) {
        try {
            const data = event.data.json();
            notificationData = { ...notificationData, ...data };
        } catch (error) {
            console.error('Error parsing push data:', error);
        }
    }
    
    event.waitUntil(
        self.registration.showNotification(notificationData.title, notificationData)
    );
});

// Notification click handler
self.addEventListener('notificationclick', (event) => {
    console.log('Service Worker: Notification clicked');
    
    event.notification.close();
    
    if (event.action === 'open' || !event.action) {
        event.waitUntil(
            clients.matchAll({ type: 'window' }).then((clientList) => {
                // Check if app is already open
                for (const client of clientList) {
                    if (client.url.includes(self.location.origin) && 'focus' in client) {
                        return client.focus();
                    }
                }
                
                // Open new window if app is not open
                if (clients.openWindow) {
                    return clients.openWindow('/');
                }
            })
        );
    }
});

// Prayer time notifications
function schedulePrayerNotifications() {
    const now = new Date();
    const prayerTimes = {
        fajr: { hour: 5, minute: 30, name: 'الفجر' },
        dhuhr: { hour: 12, minute: 30, name: 'الظهر' },
        asr: { hour: 15, minute: 45, name: 'العصر' },
        maghrib: { hour: 18, minute: 20, name: 'المغرب' },
        isha: { hour: 19, minute: 45, name: 'العشاء' }
    };
    
    Object.entries(prayerTimes).forEach(([key, prayer]) => {
        const prayerTime = new Date();
        prayerTime.setHours(prayer.hour, prayer.minute, 0, 0);
        
        // If prayer time has passed today, schedule for tomorrow
        if (prayerTime <= now) {
            prayerTime.setDate(prayerTime.getDate() + 1);
        }
        
        const timeUntilPrayer = prayerTime.getTime() - now.getTime();
        
        setTimeout(() => {
            self.registration.showNotification(`حان وقت صلاة ${prayer.name}`, {
                body: 'حان الآن وقت الصلاة',
                icon: '/assets/images/icon-192.png',
                badge: '/assets/images/badge-72.png',
                tag: `prayer-${key}`,
                requireInteraction: true,
                vibrate: [200, 100, 200],
                actions: [
                    {
                        action: 'open-prayer',
                        title: 'عرض مواقيت الصلاة'
                    }
                ]
            });
            
            // Send message to main app
            self.clients.matchAll().then(clients => {
                clients.forEach(client => {
                    client.postMessage({
                        type: 'PRAYER_TIME_NOTIFICATION',
                        prayer: prayer.name
                    });
                });
            });
            
            // Schedule next day
            schedulePrayerNotifications();
        }, timeUntilPrayer);
    });
}

// Sync prayer times from API
async function syncPrayerTimes() {
    try {
        // This would fetch from a real prayer times API
        const response = await fetch('/api/prayer-times');
        if (response.ok) {
            const prayerTimes = await response.json();
            
            // Store in cache
            const cache = await caches.open(DYNAMIC_CACHE);
            await cache.put('/api/prayer-times', new Response(JSON.stringify(prayerTimes)));
            
            console.log('Prayer times synced successfully');
        }
    } catch (error) {
        console.error('Error syncing prayer times:', error);
    }
}

// Initialize prayer notifications when service worker starts
schedulePrayerNotifications();

// Handle messages from main app
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'SKIP_WAITING') {
        self.skipWaiting();
    }
    
    if (event.data && event.data.type === 'SCHEDULE_AZKAR_REMINDER') {
        const { time, type } = event.data;
        scheduleAzkarReminder(time, type);
    }
});

// Schedule azkar reminders
function scheduleAzkarReminder(time, type) {
    const now = new Date();
    const [hours, minutes] = time.split(':').map(Number);
    
    const reminderTime = new Date();
    reminderTime.setHours(hours, minutes, 0, 0);
    
    // If time has passed today, schedule for tomorrow
    if (reminderTime <= now) {
        reminderTime.setDate(reminderTime.getDate() + 1);
    }
    
    const timeUntilReminder = reminderTime.getTime() - now.getTime();
    
    setTimeout(() => {
        const title = type === 'morning' ? 'تذكير أذكار الصباح' : 'تذكير أذكار المساء';
        const body = type === 'morning' ? 'حان وقت أذكار الصباح' : 'حان وقت أذكار المساء';
        
        self.registration.showNotification(title, {
            body: body,
            icon: '/assets/images/icon-192.png',
            badge: '/assets/images/badge-72.png',
            tag: `azkar-${type}`,
            actions: [
                {
                    action: 'open-azkar',
                    title: 'فتح الأذكار'
                }
            ]
        });
        
        // Schedule for next day
        scheduleAzkarReminder(time, type);
    }, timeUntilReminder);
}

// Cache management
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'CLEAR_CACHE') {
        event.waitUntil(
            caches.keys().then((cacheNames) => {
                return Promise.all(
                    cacheNames.map((cacheName) => {
                        return caches.delete(cacheName);
                    })
                );
            }).then(() => {
                event.ports[0].postMessage({ success: true });
            })
        );
    }
});

console.log('Service Worker: Loaded successfully');
