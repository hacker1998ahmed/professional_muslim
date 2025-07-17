/**
 * Simple Router for Professional Muslim Web App
 * Author: Ahmed Mostafa Ibrahim
 */

class Router {
    constructor() {
        this.routes = new Map();
        this.currentRoute = null;
        this.defaultRoute = 'home';
        this.notFoundRoute = '404';
        
        // Initialize router
        this.init();
    }

    init() {
        // Listen for hash changes
        window.addEventListener('hashchange', () => this.handleRouteChange());
        window.addEventListener('load', () => this.handleRouteChange());
        
        // Listen for popstate (back/forward buttons)
        window.addEventListener('popstate', (event) => {
            if (event.state && event.state.route) {
                this.navigateTo(event.state.route, false);
            }
        });
    }

    // Register a route
    addRoute(path, handler, options = {}) {
        this.routes.set(path, {
            handler,
            title: options.title || path,
            requiresAuth: options.requiresAuth || false,
            middleware: options.middleware || []
        });
    }

    // Remove a route
    removeRoute(path) {
        this.routes.delete(path);
    }

    // Navigate to a route
    navigateTo(path, pushState = true) {
        const route = this.routes.get(path);
        
        if (!route) {
            console.warn(`Route not found: ${path}`);
            this.navigateTo(this.notFoundRoute);
            return;
        }

        // Run middleware
        if (route.middleware.length > 0) {
            for (const middleware of route.middleware) {
                if (!middleware()) {
                    return; // Middleware blocked navigation
                }
            }
        }

        // Check authentication if required
        if (route.requiresAuth && !this.isAuthenticated()) {
            this.navigateTo('login');
            return;
        }

        // Update current route
        this.currentRoute = path;

        // Update URL
        if (pushState) {
            const url = path === this.defaultRoute ? '/' : `/#${path}`;
            window.history.pushState({ route: path }, route.title, url);
        }

        // Update page title
        document.title = `${route.title} - أذكار المسلم المحترف`;

        // Execute route handler
        try {
            route.handler();
        } catch (error) {
            console.error(`Error executing route handler for ${path}:`, error);
            this.navigateTo(this.notFoundRoute);
        }

        // Update active navigation
        this.updateActiveNavigation(path);

        // Scroll to top
        window.scrollTo(0, 0);

        // Trigger route change event
        this.triggerRouteChangeEvent(path);
    }

    // Handle route changes from hash or direct navigation
    handleRouteChange() {
        const hash = window.location.hash.slice(1); // Remove #
        const route = hash || this.defaultRoute;
        
        // Parse query parameters
        const [routePath, queryString] = route.split('?');
        const queryParams = this.parseQueryString(queryString);
        
        // Store query params for access by route handlers
        this.currentQueryParams = queryParams;
        
        this.navigateTo(routePath, false);
    }

    // Parse query string into object
    parseQueryString(queryString) {
        const params = {};
        if (!queryString) return params;
        
        queryString.split('&').forEach(param => {
            const [key, value] = param.split('=');
            params[decodeURIComponent(key)] = decodeURIComponent(value || '');
        });
        
        return params;
    }

    // Get current query parameters
    getQueryParams() {
        return this.currentQueryParams || {};
    }

    // Update active navigation links
    updateActiveNavigation(currentRoute) {
        // Remove active class from all nav links
        document.querySelectorAll('.nav-link').forEach(link => {
            link.classList.remove('active');
        });

        // Add active class to current route link
        const activeLink = document.querySelector(`[href="#${currentRoute}"]`);
        if (activeLink) {
            activeLink.classList.add('active');
        }
    }

    // Trigger custom route change event
    triggerRouteChangeEvent(route) {
        const event = new CustomEvent('routechange', {
            detail: {
                route,
                queryParams: this.currentQueryParams
            }
        });
        window.dispatchEvent(event);
    }

    // Get current route
    getCurrentRoute() {
        return this.currentRoute;
    }

    // Check if user is authenticated (placeholder)
    isAuthenticated() {
        // Implement your authentication logic here
        return true;
    }

    // Go back in history
    goBack() {
        window.history.back();
    }

    // Go forward in history
    goForward() {
        window.history.forward();
    }

    // Refresh current route
    refresh() {
        if (this.currentRoute) {
            this.navigateTo(this.currentRoute, false);
        }
    }

    // Set default route
    setDefaultRoute(route) {
        this.defaultRoute = route;
    }

    // Set 404 route
    setNotFoundRoute(route) {
        this.notFoundRoute = route;
    }

    // Add middleware
    addGlobalMiddleware(middleware) {
        this.globalMiddleware = this.globalMiddleware || [];
        this.globalMiddleware.push(middleware);
    }

    // Route guards
    addRouteGuard(path, guard) {
        const route = this.routes.get(path);
        if (route) {
            route.middleware = route.middleware || [];
            route.middleware.push(guard);
        }
    }

    // Breadcrumb support
    getBreadcrumbs() {
        const breadcrumbs = [];
        const route = this.routes.get(this.currentRoute);
        
        if (route && route.breadcrumbs) {
            return route.breadcrumbs;
        }
        
        // Generate default breadcrumbs
        breadcrumbs.push({ name: 'الرئيسية', path: 'home' });
        
        if (this.currentRoute !== 'home') {
            breadcrumbs.push({ 
                name: route ? route.title : this.currentRoute, 
                path: this.currentRoute 
            });
        }
        
        return breadcrumbs;
    }

    // Route transition effects
    setTransitionEffect(effect) {
        this.transitionEffect = effect;
    }

    // Apply transition effect
    applyTransition(callback) {
        const mainContent = document.getElementById('main-content');
        
        if (!mainContent || !this.transitionEffect) {
            callback();
            return;
        }

        switch (this.transitionEffect) {
            case 'fade':
                mainContent.style.opacity = '0';
                setTimeout(() => {
                    callback();
                    mainContent.style.opacity = '1';
                }, 150);
                break;
                
            case 'slide':
                mainContent.style.transform = 'translateX(100px)';
                mainContent.style.opacity = '0';
                setTimeout(() => {
                    callback();
                    mainContent.style.transform = 'translateX(0)';
                    mainContent.style.opacity = '1';
                }, 150);
                break;
                
            default:
                callback();
        }
    }

    // Route caching
    enableRouteCache() {
        this.routeCache = new Map();
    }

    cacheRoute(path, content) {
        if (this.routeCache) {
            this.routeCache.set(path, content);
        }
    }

    getCachedRoute(path) {
        return this.routeCache ? this.routeCache.get(path) : null;
    }

    clearRouteCache() {
        if (this.routeCache) {
            this.routeCache.clear();
        }
    }

    // Route analytics
    trackRoute(path) {
        // Implement analytics tracking here
        console.log(`Route visited: ${path}`);
        
        // Example: Send to analytics service
        if (window.gtag) {
            window.gtag('config', 'GA_MEASUREMENT_ID', {
                page_path: `/#${path}`
            });
        }
    }

    // Route prefetching
    prefetchRoute(path) {
        const route = this.routes.get(path);
        if (route && route.prefetch) {
            route.prefetch();
        }
    }

    // Lazy loading support
    addLazyRoute(path, importFunction, options = {}) {
        this.addRoute(path, async () => {
            try {
                const module = await importFunction();
                if (module.default) {
                    module.default();
                } else if (typeof module === 'function') {
                    module();
                }
            } catch (error) {
                console.error(`Error loading lazy route ${path}:`, error);
                this.navigateTo(this.notFoundRoute);
            }
        }, options);
    }

    // Route metadata
    setRouteMetadata(path, metadata) {
        const route = this.routes.get(path);
        if (route) {
            route.metadata = metadata;
        }
    }

    getRouteMetadata(path) {
        const route = this.routes.get(path);
        return route ? route.metadata : null;
    }

    // Cleanup
    destroy() {
        window.removeEventListener('hashchange', this.handleRouteChange);
        window.removeEventListener('load', this.handleRouteChange);
        window.removeEventListener('popstate', this.handleRouteChange);
        
        this.routes.clear();
        if (this.routeCache) {
            this.routeCache.clear();
        }
    }
}

// Initialize global router
window.router = new Router();

// Export for module systems
if (typeof module !== 'undefined' && module.exports) {
    module.exports = Router;
}
