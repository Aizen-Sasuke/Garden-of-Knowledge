<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login — Garden of Knowledge</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <canvas id="particles-canvas"></canvas>
        <div class="page-transition" id="pageTransition"></div>

        <div class="login-wrapper">
            <div class="login-card">
                <div class="brand">
                    <span class="brand-icon">🌿</span>
                    <h1>Garden of Knowledge</h1>
                    <p>Enter your sanctuary of books</p>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="error-msg"><%= request.getAttribute("error") %></div>
                <% } %>

                <form action="loginProcess.jsp" method="post">
                    <label>Username</label>
                    <input type="text" name="username" placeholder="Enter your username" required>
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Enter your password" required>
                    <input type="submit" value="Enter the Garden →">
                </form>

                <p style="margin-top: 16px; font-size: 0.9rem; opacity: 0.8; line-height: 1.5;">
                    Demo logins after first launch: <strong>admin / admin123</strong> or <strong>user / user123</strong>.
                </p>
            </div>
        </div>

        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            // PARTICLES
            const canvas = document.getElementById('particles-canvas');
            const ctx = canvas.getContext('2d');
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;

            const particles = [];
            for (let i = 0; i < 60; i++) {
                particles.push({
                    x: Math.random() * canvas.width,
                    y: Math.random() * canvas.height,
                    size: Math.random() * 2 + 0.5,
                    speedX: (Math.random() - 0.5) * 0.3,
                    speedY: -Math.random() * 0.5 - 0.2,
                    opacity: Math.random() * 0.4 + 0.1
                });
            }

            function animateParticles() {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                particles.forEach(p => {
                    ctx.beginPath();
                    ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                    ctx.fillStyle = `rgba(201, 168, 76, ${p.opacity})`;
                    ctx.fill();
                    p.x += p.speedX;
                    p.y += p.speedY;
                    if (p.y < -10) { p.y = canvas.height + 10; p.x = Math.random() * canvas.width; }
                });
                requestAnimationFrame(animateParticles);
            }
            animateParticles();

            window.addEventListener('resize', () => {
                canvas.width = window.innerWidth;
                canvas.height = window.innerHeight;
            });

            // PAGE TRANSITION
            document.querySelector('form').addEventListener('submit', () => {
                document.getElementById('pageTransition').classList.add('active');
            });
        </script>
    </body>
</html>