<%-- 
    Document   : home
    Created on : Feb 24, 2026, 11:20:11 PM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="connection.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Garden of Knowledge</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css">
    </head>
    <body>
        <canvas id="particles-canvas"></canvas>
        <div class="page-transition" id="pageTransition"></div>

        <!-- NAVBAR -->
        <nav class="navbar">
            <a href="home.jsp" class="navbar-brand">🌿 Garden of Knowledge</a>
            <ul class="navbar-links">
                <li><a href="#books">Books</a></li>
                <li><a href="#categories">Categories</a></li>
                <li><a href="#about">About</a></li>
                <li><a href="#membership">Membership</a></li>
            </ul>
            <div class="navbar-controls">
                <button class="icon-btn" id="darkToggle" title="Toggle theme">🌙</button>
                <button class="icon-btn" id="musicToggle" title="Toggle music">🎵</button>
                <a href="login.jsp" class="btn-secondary" style="padding:8px 20px; font-size:0.85rem;">Login</a>
            </div>
        </nav>

        <!-- HERO -->
        <section class="hero">
            <div class="hero-content">
                <span class="hero-tag">✦ Welcome to your sanctuary ✦</span>
                <h1>Enter the Garden<br><em>of Knowledge</em></h1>
                <p>A peaceful haven where stories bloom and wisdom grows. Discover thousands of books in our ethereal collection.</p>
                <div class="hero-buttons">
                    <a href="login.jsp" class="btn-primary">Begin Your Journey</a>
                    <a href="#books" class="btn-secondary">Explore Books</a>
                </div>
            </div>
        </section>

        <!-- FLOATING LEAVES -->
        <div id="leaves"></div>

        <!-- FEATURED BOOKS -->
        <section class="section" id="books">
            <div class="section-header" data-aos="fade-up">
                <span class="section-tag">✦ Our Collection ✦</span>
                <h2>Featured Books</h2>
                <div class="section-divider"></div>
            </div>
            <div class="books-grid">
                <%
                    try {
                        PreparedStatement ps = conn.prepareStatement(
                            "SELECT * FROM books ORDER BY title");
                        ResultSet rs = ps.executeQuery();
                        String[] emojis = {"📖","🌿","🌌","🕊️","🌸","📜","🔮","🌙","📚","🎋"};
                        int i = 0;
                        while (rs.next()) {
                            String title = rs.getString("title");
                            String author = rs.getString("author");
                            String genre = rs.getString("genre");
                            int available = rs.getInt("available_copies");
                            String emoji = emojis[i % emojis.length];
                            i++;
                %>
                        <div class="book-card" data-aos="fade-up" data-aos-delay="<%= 100 + (i * 50) %>">
                            <span class="book-emoji"><%= emoji %></span>
                            <div class="book-title"><%= title %></div>
                            <div class="book-author"><%= author %></div>
                            <div class="book-genre"><%= genre %></div>
                            <span class="book-availability <%= available > 0 ? "available" : "unavailable" %>">
                                <%= available > 0 ? "Available" : "Unavailable" %>
                            </span>
                        </div>
                <%
                        }
                        rs.close();
                    } catch (Exception e) {
                        out.println("<p style='color:rgba(255,255,255,0.5);text-align:center;'>Could not load books: " + e.getMessage() + "</p>");
                    }
                %>
            </div>
        </section>

        <!-- CATEGORIES -->
        <section class="section" id="categories">
            <div class="section-header" data-aos="fade-up">
                <span class="section-tag">✦ Explore ✦</span>
                <h2>Categories</h2>
                <div class="section-divider"></div>
            </div>
            <div class="categories-grid">
                <%
                    try {
                        PreparedStatement ps2 = conn.prepareStatement(
                            "SELECT DISTINCT genre FROM books WHERE genre IS NOT NULL ORDER BY genre");
                        ResultSet rs2 = ps2.executeQuery();
                        String[] icons = {"📚","🔬","🌍","💭","🎨","💻","🕊️","🌿","🌌","🔮"};
                        int j = 0;
                        while (rs2.next()) {
                            String genre = rs2.getString("genre");
                            String icon = icons[j % icons.length];
                            j++;
                %>
                        <div class="category-card" data-aos="fade-up" data-aos-delay="<%= 100 + (j * 50) %>">
                            <span class="category-icon"><%= icon %></span>
                            <div class="category-name"><%= genre %></div>
                        </div>
                <%
                        }
                        rs2.close();
                    } catch (Exception e) {
                        out.println("<p style='color:rgba(255,255,255,0.5);text-align:center;'>Could not load categories: " + e.getMessage() + "</p>");
                    }
                %>
            </div>
        </section>

        <!-- ABOUT -->
        <section class="section" id="about">
            <div class="section-header" data-aos="fade-up">
                <span class="section-tag">✦ Our Story ✦</span>
                <h2>About the Library</h2>
                <div class="section-divider"></div>
            </div>
            <div class="about-content" data-aos="fade-up" data-aos-delay="100">
                <p>Nestled in the heart of knowledge, our library is more than a collection of books — it is a living garden where ideas take root and grow. Every volume holds a universe waiting to be explored, every page a doorway to new worlds. We believe that reading is an act of quiet revolution, a gentle rebellion against the noise of the world.</p>
            </div>
        </section>

        <!-- MEMBERSHIP -->
        <section class="section" id="membership">
            <div class="membership-card" data-aos="fade-up">
                <h3>Join the Garden</h3>
                <p>Become a member and gain access to thousands of books, exclusive reading events, and a community of like-minded souls who believe in the power of stories.</p>
                <a href="login.jsp" class="btn-glow">Begin Your Journey ✦</a>
            </div>
        </section>

        <!-- FOOTER -->
        <footer data-aos="fade-up">
            <div class="footer-brand">🌿 Garden of Knowledge</div>
            <p>✦ A sanctuary for curious minds ✦</p>
        </footer>

        <!-- MUSIC INDICATOR -->
        <div class="music-indicator" id="musicIndicator">
            <div class="music-dot"></div>
            <span id="musicLabel">Ambient Off</span>
        </div>

        <audio id="ambientMusic" loop>
            <source src="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3" type="audio/mpeg">
        </audio>

        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            AOS.init({ duration: 800, once: true, offset: 100 });

            // PARTICLES
            const canvas = document.getElementById('particles-canvas');
            const ctx = canvas.getContext('2d');
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;

            const particles = [];
            for (let i = 0; i < 80; i++) {
                particles.push({
                    x: Math.random() * canvas.width,
                    y: Math.random() * canvas.height,
                    size: Math.random() * 2 + 0.5,
                    speedX: (Math.random() - 0.5) * 0.3,
                    speedY: -Math.random() * 0.4 - 0.1,
                    opacity: Math.random() * 0.3 + 0.1
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

            // FLOATING LEAVES
            const leavesContainer = document.getElementById('leaves');
            const leafEmojis = ['🍃', '🌿', '✦', '🍂', '🌱'];
            for (let i = 0; i < 8; i++) {
                const leaf = document.createElement('div');
                leaf.className = 'leaf';
                leaf.textContent = leafEmojis[Math.floor(Math.random() * leafEmojis.length)];
                leaf.style.left = Math.random() * 100 + 'vw';
                leaf.style.animationDuration = (Math.random() * 15 + 10) + 's';
                leaf.style.animationDelay = (Math.random() * 10) + 's';
                leaf.style.fontSize = (Math.random() * 1 + 0.8) + 'rem';
                document.body.appendChild(leaf);
            }

            // DARK MODE TOGGLE
            const darkToggle = document.getElementById('darkToggle');
            darkToggle.addEventListener('click', () => {
                document.body.classList.toggle('light-mode');
                darkToggle.textContent = document.body.classList.contains('light-mode') ? '☀️' : '🌙';
            });

            // MUSIC TOGGLE
            const music = document.getElementById('ambientMusic');
            const musicToggle = document.getElementById('musicToggle');
            const musicIndicator = document.getElementById('musicIndicator');
            const musicLabel = document.getElementById('musicLabel');
            let playing = false;

            musicToggle.addEventListener('click', () => {
                if (playing) {
                    music.pause();
                    musicIndicator.classList.remove('playing');
                    musicLabel.textContent = 'Ambient Off';
                    musicToggle.textContent = '🎵';
                } else {
                    music.play();
                    musicIndicator.classList.add('playing');
                    musicLabel.textContent = 'Ambient On';
                    musicToggle.textContent = '🔇';
                }
                playing = !playing;
            });

            // SMOOTH SCROLL
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function(e) {
                    e.preventDefault();
                    document.querySelector(this.getAttribute('href')).scrollIntoView({ behavior: 'smooth' });
                });
            });

            // PAGE TRANSITION
            document.querySelectorAll('a:not([href^="#"])').forEach(link => {
                link.addEventListener('click', function(e) {
                    const href = this.getAttribute('href');
                    if (href && !href.startsWith('#')) {
                        e.preventDefault();
                        document.getElementById('pageTransition').classList.add('active');
                        setTimeout(() => { window.location.href = href; }, 400);
                    }
                });
            });
        </script>
    </body>
</html>