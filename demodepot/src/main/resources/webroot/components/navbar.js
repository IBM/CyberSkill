class CustomNavbar extends HTMLElement {
  connectedCallback() {
    this.attachShadow({ mode: 'open' });
    this.shadowRoot.innerHTML = `
      <style>
        nav {
          background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
          box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .nav-container {
          max-width: 1200px;
          margin: 0 auto;
          padding: 1rem 2rem;
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        .logo {
          font-weight: 700;
          font-size: 1.5rem;
          color: white;
          display: flex;
          align-items: center;
          gap: 0.5rem;
        }
        .nav-links {
          display: flex;
          gap: 1.5rem;
        }
        .nav-link {
          color: white;
          font-weight: 500;
          transition: all 0.2s;
        }
        .nav-link:hover {
          opacity: 0.8;
          transform: translateY(-2px);
        }
        @media (max-width: 768px) {
          .nav-container {
            flex-direction: column;
            padding: 1rem;
          }
          .nav-links {
            margin-top: 1rem;
            gap: 1rem;
          }
        }
      </style>
      <nav>
        <div class="nav-container">
          <a href="#" class="logo">
            <i data-feather="palette"></i>
            ChromaForm
          </a>
          <div class="nav-links">
            <a href="/" class="nav-link">Demo Request</a>
            <a href="/dashboard.html" class="nav-link">Dashboard</a>
</div>
        </div>
      </nav>
    `;
  }
}

customElements.define('custom-navbar', CustomNavbar);