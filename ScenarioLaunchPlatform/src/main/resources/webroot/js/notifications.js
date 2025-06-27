let eventSource;

function connectToNotifications() {
    if (eventSource && eventSource.readyState !== EventSource.CLOSED) return;

    eventSource = new EventSource('/notifications');

    eventSource.addEventListener('open', () => {
        console.log('[SSE] Connected to server');
    });

    eventSource.addEventListener('message', event => {
        console.log('[SSE] Message received:', event.data);
        try {
            const msg = JSON.parse(event.data);
            displayPopup(msg);
        } catch (err) {
            console.error('Failed to parse SSE message:', err);
        }
    });

    eventSource.addEventListener('error', err => {
        console.error('[SSE] Error:', err);
    });
}

function displayPopup(msg) {
    const title = msg.result === 'SOLVED' ? 'Challenge Solved!' : 'CTF Update';
    Swal.fire({
        title,
        html: `Team <b>${msg.team}</b> ${msg.result.toLowerCase()} challenge <i>${msg.challenge}</i>`,
        icon: msg.result === 'SOLVED' ? 'success' : 'info',
        timer: 5000,
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        background: '#343a40',
        color: '#fff',
        iconColor: '#ffc107',
        timerProgressBar: true
    });
}

document.addEventListener('DOMContentLoaded', connectToNotifications);
