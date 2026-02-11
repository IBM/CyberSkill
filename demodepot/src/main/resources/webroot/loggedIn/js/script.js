
document.addEventListener('DOMContentLoaded', function() {
    // Initialize dashboard charts if on dashboard page
    if (document.getElementById('typeChart')) {
        initDashboard();
    } else {
        // If not dashboard, check for demo request form
        const demoRequestForm = document.getElementById('demoRequestForm');
    if (demoRequestForm) {
demoRequestForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = new FormData(demoRequestForm);
            try {
                // In a real app, you would send this to your backend
                const response = await fetch('/api/demo-requests', {
                    method: 'POST',
                    body: formData
});
// Dashboard functions
async function initDashboard() {
    try {
        const demoRequests = await fetchDemoRequests();
        
        if (demoRequests.length === 0) {
            console.warn('No demo requests found');
            return;
        }
        
        renderTypeChart(demoRequests);
        renderMonthlyChart(demoRequests);
        renderRequestsTable(demoRequests);
    } catch (error) {
        console.error('Dashboard initialization failed:', error);
    }
}
async function fetchDemoRequests() {
    try {
        // First try fetching from API endpoint
        const apiResponse = await fetch('/api/demo-requests');
        if (apiResponse.ok) {
            const apiData = await apiResponse.json();
            return apiData;
        }
        
        // Fallback to local JSON file if API fails
        const response = await fetch('data/demo_requests.json');
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        return data.demo_requests || [];
    } catch (error) {
        console.error('Error loading demo requests:', error);
        // Use the sample data from our JSON file directly
        return [
            {
                "pm_owner": "Alice Johnson",
                "demo_type": "Product Overview",
                "product_name": "InsightX",
                "delivery_date": "2025-01-15",
                "title": "InsightX Smart Analytics Demo",
                "subtitle": "Transforming Data Into Decisions",
                "value_proposition": "InsightX provides real-time analytics with customizable dashboards to empower business teams.",
                "feature_focus": "Dashboard customization, automated insights, predictive analytics.",
                "flow_sequence": "1. Login → 2. Dashboard view → 3. Customizing widgets → 4. Generating insights",
                "existing_docs_path": "existing_docs_insightx.pdf",
                "demo_url": "https://demo.insightx.com",
                "demo_script_path": "insightx_demo_script.docx",
                "created_at": "2024-12-01T09:00:00Z",
                "status": "Submitted"
            },
            {
                "pm_owner": "Brian Peterson",
                "demo_type": "Technical Deep Dive",
                "product_name": "SecureVault",
                "delivery_date": "2025-02-10",
                "title": "SecureVault Encryption Engine Demo",
                "subtitle": "Enterprise-Grade Data Protection",
                "value_proposition": "SecureVault offers unmatched encryption performance with seamless integration into existing systems.",
                "feature_focus": "AES-256 encryption, role-based access, key rotation automation.",
                "flow_sequence": "1. User creation → 2. Assign keys → 3. Encrypt/Decrypt workflow",
                "existing_docs_path": "securevault_docs.pdf",
                "demo_url": "https://demo.securevault.com",
                "demo_script_path": "securevault_script.docx",
                "created_at": "2025-01-15T14:30:00Z",
                "status": "In Progress"
            }
        ];
    }
}
function renderTypeChart(requests) {
    const ctx = document.getElementById('typeChart');
    if (!ctx) return;

    const ctx2d = ctx.getContext('2d');
    
    // Group by demo type
    const typeCounts = requests.reduce((acc, request) => {
        if (request.demo_type) {
            acc[request.demo_type] = (acc[request.demo_type] || 0) + 1;
        }
        return acc;
    }, {});

    new Chart(ctx2d, {
type: 'doughnut',
        data: {
            labels: Object.keys(typeCounts),
            datasets: [{
                data: Object.values(typeCounts),
                backgroundColor: [
                    '#3b82f6',
                    '#10b981',
                    '#f59e0b',
                    '#ef4444'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                }
            }
        }
    });
}
function renderMonthlyChart(requests) {
    const ctx = document.getElementById('monthlyChart');
    if (!ctx) return;

    const ctx2d = ctx.getContext('2d');
    
    // Group by month
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const monthCounts = Array(12).fill(0);
    
    requests.forEach(request => {
        if (request.created_at) {
            const date = new Date(request.created_at);
            if (!isNaN(date.getTime())) {
                const month = date.getMonth();
                monthCounts[month]++;
            }
        }
    });

    new Chart(ctx2d, {
type: 'bar',
        data: {
            labels: months,
            datasets: [{
                label: 'Requests',
                data: monthCounts,
                backgroundColor: '#3b82f6',
                borderColor: '#2563eb',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });
}
function renderRequestsTable(requests) {
    const tbody = document.querySelector('#requestsTable tbody');
    const loadingMessage = document.getElementById('loadingMessage');
    
    if (!tbody) return;
    
    if (requests.length === 0) {
        if (loadingMessage) {
            loadingMessage.textContent = 'No demo requests found';
        } else {
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" class="px-6 py-4 text-center text-sm text-gray-500">
                        No demo requests found
                    </td>
                </tr>
            `;
        }
        return;
    }
    
    tbody.innerHTML = '';
    
    requests.forEach(request => {
        const deliveryDate = request.delivery_date ? 
            new Date(request.delivery_date).toLocaleDateString() : 
            'Not specified';
            
        const status = request.status || 'Submitted';
        const statusClass = status === 'Submitted' ? 
            'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800';
            
        const row = document.createElement('tr');
        row.innerHTML = `
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${request.pm_owner || '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${request.demo_type || '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${request.product_name || '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${deliveryDate}</td>
            <td class="px-6 py-4 text-sm text-gray-900">${request.title || '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${statusClass}">
                    ${status}
                </span>
            </td>
        `;
        tbody.appendChild(row);
    });
}
            if (response.ok) {
                alert('Demo request submitted successfully!');
                demoRequestForm.reset();
            } else {
                throw new Error('Submission failed');
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Failed to submit demo request. Please try again.');
        }
    });
    }
});