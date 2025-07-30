<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Access Denied</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0f4f8;
            text-align: center;
            padding-top: 80px;
            color: #333;
        }

        h1 {
            font-size: 3em;
            color: #e74c3c;
            animation: shake 0.6s infinite;
        }

        p {
            font-size: 1.2em;
            margin-top: 20px;
            animation: fadeIn 2s ease-in;
        }

        a {
            display: inline-block;
            margin-top: 30px;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            animation: bounce 2s infinite;
        }

        #animationContainer {
            width: 300px;
            margin: 0 auto 40px;
        }

        @keyframes shake {
            0% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            50% { transform: translateX(5px); }
            75% { transform: translateX(-5px); }
            100% { transform: translateX(0); }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
    </style>
</head>
<body>

    <h1>🚫 Access Denied</h1>
    <p>Oops! You don’t have permission to view this page.</p>
    <a href="/loggedIn/dashboard.ftl">🔙 Return to Home</a>

    <div id="animationContainer" style="width: 300px; margin: auto;"></div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie.min.js"></script>
<script>
  lottie.loadAnimation({
    container: document.getElementById('animationContainer'),
    renderer: 'svg',
    loop: true,
    autoplay: true,
    path: 'https://cdn.iconscout.com/lottie/premium/thumb/security-bot-scanning-4567890-3789012.json' // Replace with actual animation URL
  });
</script>
</body>
</html>
