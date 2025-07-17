#!/bin/bash

# Professional Muslim Web App - Quick Start Script
# Author: Ahmed Mostafa Ibrahim
# Email: gogom8870@gmail.com

echo "🕌 أذكار المسلم المحترف - النسخة الويب"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if Node.js is installed
check_node() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        print_status "Node.js found: $NODE_VERSION"
        return 0
    else
        print_error "Node.js is not installed. Please install Node.js first."
        print_info "Visit: https://nodejs.org/"
        return 1
    fi
}

# Check if npm is installed
check_npm() {
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        print_status "npm found: $NPM_VERSION"
        return 0
    else
        print_error "npm is not installed. Please install npm first."
        return 1
    fi
}

# Install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    
    if [ -f "package.json" ]; then
        npm install
        if [ $? -eq 0 ]; then
            print_status "Dependencies installed successfully!"
        else
            print_error "Failed to install dependencies."
            return 1
        fi
    else
        print_warning "package.json not found. Skipping dependency installation."
    fi
}

# Start development server
start_dev_server() {
    print_status "Starting development server..."
    
    # Check for different server options
    if command -v npx &> /dev/null; then
        print_info "Using npx serve..."
        npx serve . -p 8080
    elif command -v python3 &> /dev/null; then
        print_info "Using Python 3 HTTP server..."
        python3 -m http.server 8080
    elif command -v python &> /dev/null; then
        print_info "Using Python HTTP server..."
        python -m SimpleHTTPServer 8080
    elif command -v php &> /dev/null; then
        print_info "Using PHP built-in server..."
        php -S localhost:8080
    else
        print_error "No suitable server found. Please install Node.js, Python, or PHP."
        return 1
    fi
}

# Open browser
open_browser() {
    local url="http://localhost:8080"
    print_status "Opening browser at $url"
    
    # Detect OS and open browser
    case "$(uname -s)" in
        Darwin)  # macOS
            open "$url"
            ;;
        Linux)
            if command -v xdg-open &> /dev/null; then
                xdg-open "$url"
            elif command -v gnome-open &> /dev/null; then
                gnome-open "$url"
            fi
            ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*)  # Windows
            start "$url"
            ;;
        *)
            print_info "Please open your browser and navigate to $url"
            ;;
    esac
}

# Main function
main() {
    echo "Starting Professional Muslim Web App..."
    echo ""
    
    # Check prerequisites
    if ! check_node; then
        exit 1
    fi
    
    if ! check_npm; then
        exit 1
    fi
    
    # Install dependencies if needed
    install_dependencies
    
    echo ""
    print_status "Ready to start the application!"
    print_info "The app will be available at: http://localhost:8080"
    print_info "Press Ctrl+C to stop the server"
    echo ""
    
    # Wait a moment then open browser
    sleep 2
    open_browser &
    
    # Start the server
    start_dev_server
}

# Handle script interruption
cleanup() {
    echo ""
    print_status "Shutting down server..."
    print_status "Thank you for using Professional Muslim Web App!"
    print_info "جزاكم الله خيراً"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Run main function
main "$@"
