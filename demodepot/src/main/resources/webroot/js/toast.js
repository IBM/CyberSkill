// Toast Notification System
class Toast {
  constructor() {
    this.container = null;
    this.init();
  }

  init() {
    // Create toast container if it doesn't exist
    if (!document.getElementById('toast-container')) {
      this.container = document.createElement('div');
      this.container.id = 'toast-container';
      this.container.className = 'toast-container';
      document.body.appendChild(this.container);
    } else {
      this.container = document.getElementById('toast-container');
    }
  }

  show(message, type = 'info', duration = 5000) {
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    // Icon based on type
    const icons = {
      success: '✓',
      error: '✕',
      warning: '⚠',
      info: 'ℹ'
    };
    
    toast.innerHTML = `
      <span class="toast-icon">${icons[type] || icons.info}</span>
      <span class="toast-message">${message}</span>
      <button class="toast-close" onclick="this.parentElement.remove()">×</button>
    `;
    
    this.container.appendChild(toast);
    
    // Trigger animation
    setTimeout(() => toast.classList.add('show'), 10);
    
    // Auto remove
    if (duration > 0) {
      setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
      }, duration);
    }
    
    // Log to console for debugging
    console.log(`[Toast ${type.toUpperCase()}] ${message}`);
    
    return toast;
  }

  success(message, duration = 5000) {
    return this.show(message, 'success', duration);
  }

  error(message, duration = 7000) {
    return this.show(message, 'error', duration);
  }

  warning(message, duration = 6000) {
    return this.show(message, 'warning', duration);
  }

  info(message, duration = 5000) {
    return this.show(message, 'info', duration);
  }

  loading(message) {
    const toast = document.createElement('div');
    toast.className = 'toast toast-loading';
    toast.innerHTML = `
      <span class="toast-spinner"></span>
      <span class="toast-message">${message}</span>
    `;
    this.container.appendChild(toast);
    setTimeout(() => toast.classList.add('show'), 10);
    return toast;
  }

  removeLoading(toast) {
    if (toast) {
      toast.classList.remove('show');
      setTimeout(() => toast.remove(), 300);
    }
  }
}

// Create global toast instance
const toast = new Toast();

// Enhanced fetch wrapper with better error handling and logging
async function authFetch(url, options = {}) {
  const token = localStorage.getItem('token');
  const startTime = Date.now();
  
  console.log(`[API Request] ${options.method || 'GET'} ${url}`, {
    headers: options.headers,
    body: options.body ? JSON.parse(options.body) : null
  });
  
  const headers = {
    'Content-Type': 'application/json',
    ...options.headers
  };
  
  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }
  
  try {
    const response = await fetch(url, {
      ...options,
      headers
    });
    
    const duration = Date.now() - startTime;
    console.log(`[API Response] ${response.status} ${url} (${duration}ms)`);
    
    // Try to parse JSON response
    let data;
    const contentType = response.headers.get('content-type');
    if (contentType && contentType.includes('application/json')) {
      data = await response.json();
      console.log(`[API Data]`, data);
    } else {
      const text = await response.text();
      console.log(`[API Text]`, text);
      data = { message: text };
    }
    
    // Handle different status codes
    if (!response.ok) {
      const errorMessage = data.message || data.error || `Request failed with status ${response.status}`;
      console.error(`[API Error] ${response.status}:`, errorMessage);
      
      if (response.status === 401) {
        toast.error('Session expired. Please login again.');
        setTimeout(() => {
          localStorage.removeItem('token');
          localStorage.removeItem('username');
          localStorage.removeItem('role');
          window.location.href = '/login.html';
        }, 2000);
      } else if (response.status === 403) {
        toast.error('Access denied. You do not have permission to perform this action.');
      } else if (response.status === 404) {
        toast.error('Resource not found.');
      } else if (response.status >= 500) {
        toast.error('Server error. Please try again later.');
      } else {
        toast.error(errorMessage);
      }
      
      throw new Error(errorMessage);
    }
    
    return data;
  } catch (error) {
    console.error(`[API Exception] ${url}:`, error);
    
    if (error.message.includes('Failed to fetch')) {
      toast.error('Network error. Please check your connection.');
    } else if (!error.message.includes('status')) {
      toast.error(`Error: ${error.message}`);
    }
    
    throw error;
  }
}

// Check authentication status
function checkAuth() {
  const token = localStorage.getItem('token');
  const username = localStorage.getItem('username');
  const role = localStorage.getItem('role');
  
  console.log('[Auth Check]', { 
    hasToken: !!token, 
    username, 
    role,
    tokenLength: token ? token.length : 0
  });
  
  return { token, username, role, isAuthenticated: !!token };
}

// Logout function
function logout() {
  console.log('[Logout] User logging out');
  localStorage.removeItem('token');
  localStorage.removeItem('username');
  localStorage.removeItem('role');
  toast.info('Logged out successfully');
  setTimeout(() => {
    window.location.href = '/login.html';
  }, 1000);
}

// Made with Bob
