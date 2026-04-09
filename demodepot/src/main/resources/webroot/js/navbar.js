// Dynamic Navbar Component for DemoDepot
class Navbar {
  constructor(containerId, auth) {
    this.containerId = containerId || 'app-navbar';
    this.auth = auth || null;
  }

  init() {
    if (!this.auth) {
      this.auth = window.checkAuth();
    }
    console.log('[Navbar] Initializing with auth:', this.auth);
    this.render();
    this.attachEventListeners();
  }

  getNavItems() {
    if (!this.auth.isAuthenticated) {
      return [
        { label: 'Public Dashboard', href: '/demodashboard.html', icon: '📊' },
        { label: 'Login', href: '/login.html', icon: '🔐' }
      ];
    }

    const commonItems = [
      { label: 'My Requests', href: '/loggedIn/user-dashboard.html', icon: '📋' },
      { label: 'New Request', href: '/loggedIn/demorequest.html', icon: '➕' },
      { label: 'Public Dashboard', href: '/demodashboard.html', icon: '📊' }
    ];

    console.log('[Navbar] User role:', this.auth.role);
    
    if (this.auth.role === 'admin') {
      console.log('[Navbar] Adding Admin Portal link');
      return [
        { label: 'Admin Portal', href: '/loggedIn/admin-dashboard.html', icon: '⚙️', highlight: true },
        ...commonItems
      ];
    }

    return commonItems;
  }

  render() {
    const navContainer = document.getElementById(this.containerId);
    if (!navContainer) {
      console.error('[Navbar] Container not found:', this.containerId);
      return;
    }

    const navItems = this.getNavItems();
    const currentPath = window.location.pathname;

    const navHTML = `
      <nav class="demodepot-navbar">
        <div class="navbar-container">
          <div class="navbar-brand">
            <a href="${this.auth.isAuthenticated ? (this.auth.role === 'admin' ? '/loggedIn/admin-dashboard.html' : '/loggedIn/user-dashboard.html') : '/demodashboard.html'}" class="brand-link">
              <span class="brand-icon">🎯</span>
              <span class="brand-text">DemoDepot</span>
            </a>
          </div>
          
          <div class="navbar-menu">
            ${navItems.map(item => `
              <a href="${item.href}" 
                 class="nav-item ${currentPath === item.href ? 'active' : ''} ${item.highlight ? 'highlight' : ''}">
                <span class="nav-icon">${item.icon}</span>
                <span class="nav-label">${item.label}</span>
              </a>
            `).join('')}
          </div>

          <div class="navbar-user">
            ${this.auth.isAuthenticated ? `
              <div class="user-info">
                <span class="user-avatar">${this.auth.username.charAt(0).toUpperCase()}</span>
                <div class="user-details">
                  <span class="user-name">${this.auth.username}</span>
                  <span class="user-role">${this.auth.role === 'admin' ? '👑 Admin' : '👤 User'}</span>
                </div>
              </div>
              <button id="navbar-logout" class="btn-logout">
                <span>🚪</span> Logout
              </button>
            ` : `
              <a href="/login.html" class="btn-login">
                <span>🔐</span> Login
              </a>
            `}
          </div>
        </div>
      </nav>
    `;

    navContainer.innerHTML = navHTML;
  }

  attachEventListeners() {
    const logoutBtn = document.getElementById('navbar-logout');
    if (logoutBtn) {
      logoutBtn.addEventListener('click', () => {
        console.log('[Navbar] Logout clicked');
        if (typeof logout === 'function') {
          logout();
        } else {
          localStorage.clear();
          window.location.href = '/login.html';
        }
      });
    }
  }
}

// Auto-initialize navbar when DOM is ready (fallback)
document.addEventListener('DOMContentLoaded', () => {
  // Only auto-init if navbar hasn't been manually initialized
  const navContainer = document.getElementById('app-navbar');
  if (navContainer && !navContainer.hasAttribute('data-navbar-initialized')) {
    console.log('[Navbar] Auto-initializing');
    const navbar = new Navbar();
    navbar.init();
    navContainer.setAttribute('data-navbar-initialized', 'true');
  }
});

// Made with Bob
