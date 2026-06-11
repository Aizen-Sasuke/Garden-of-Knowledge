<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");

    PreparedStatement ps1 = conn.prepareStatement(
        "SELECT COUNT(*) FROM borrowings WHERE member_id = ?");
    ps1.setInt(1, userId);
    ResultSet rs1 = ps1.executeQuery();
    rs1.next();
    int totalBorrowed = rs1.getInt(1);

    PreparedStatement ps2 = conn.prepareStatement(
        "SELECT COUNT(*) FROM borrowings WHERE member_id = ? AND return_date IS NULL");
    ps2.setInt(1, userId);
    ResultSet rs2 = ps2.executeQuery();
    rs2.next();
    int activeBorrowings = rs2.getInt(1);

    PreparedStatement ps3 = conn.prepareStatement(
        "SELECT COUNT(*) FROM borrowings WHERE member_id = ? AND return_date IS NOT NULL");
    ps3.setInt(1, userId);
    ResultSet rs3 = ps3.executeQuery();
    rs3.next();
    int returned = rs3.getInt(1);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>My Dashboard — Garden of Knowledge</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css">
    </head>
    <body>
        <canvas id="particles-canvas"></canvas>

        <nav class="navbar">
            <a href="home.jsp" class="navbar-brand">🌿 Garden of Knowledge</a>
            <div class="navbar-controls">
                <button class="icon-btn" id="darkToggle">🌙</button>
            </div>
        </nav>

        <div class="dashboard-wrapper">
            <div class="dashboard-header">
                <h1>👤 My Dashboard</h1>
                <div class="nav-actions">
                    <a href="books.jsp">📖 Browse Books</a>
                    <a href="logout.jsp">🚪 Logout</a>
                </div>
            </div>

            <div class="welcome-card" data-aos="fade-up">
                <h2>Welcome back, <%= username %>! 👋</h2>
                <p>Here's your library activity</p>
            </div>

            <div class="stats-grid" data-aos="fade-up" data-aos-delay="100">
                <div class="stat-card">
                    <div class="stat-number"><%= totalBorrowed %></div>
                    <div class="stat-label">📚 Total Borrowed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= activeBorrowings %></div>
                    <div class="stat-label">⏳ Currently Borrowed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= returned %></div>
                    <div class="stat-label">✅ Returned</div>
                </div>
            </div>

            <div class="section-title" data-aos="fade-up">📋 My Borrowing History</div>
            <div class="table-container" data-aos="fade-up" data-aos-delay="100">
                <table>
                    <tr>
                        <th>Book Title</th>
                        <th>Borrow Date</th>
                        <th>Return Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    <%
                        PreparedStatement ps = conn.prepareStatement(
                            "SELECT b.id, bk.title, b.borrow_date, b.return_date " +
                            "FROM borrowings b JOIN books bk ON b.book_id = bk.id " +
                            "WHERE b.member_id = ? ORDER BY b.borrow_date DESC");
                        ps.setInt(1, userId);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("title") %></td>
                        <td><%= rs.getDate("borrow_date") %></td>
                        <td><%= rs.getDate("return_date") != null ? rs.getDate("return_date") : "-" %></td>
                        <td>
                            <% if (rs.getDate("return_date") != null) { %>
                                <span class="status-returned">✅ Returned</span>
                            <% } else { %>
                                <span class="status-active">⏳ Active</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (rs.getDate("return_date") == null) { %>
                                <a class="return-btn" href="returnProcess.jsp?borrowingId=<%= rs.getInt("id") %>">Return</a>
                            <% } else { %>
                                -
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>
        </div>

        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            AOS.init({ duration: 800, once: true });

            const canvas = document.getElementById('particles-canvas');
            const ctx = canvas.getContext('2d');
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            const particles = [];
            for (let i = 0; i < 50; i++) {
                particles.push({
                    x: Math.random() * canvas.width,
                    y: Math.random() * canvas.height,
                    size: Math.random() * 1.5 + 0.5,
                    speedX: (Math.random() - 0.5) * 0.3,
                    speedY: -Math.random() * 0.3 - 0.1,
                    opacity: Math.random() * 0.2 + 0.05
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

            document.getElementById('darkToggle').addEventListener('click', () => {
                document.body.classList.toggle('light-mode');
                document.getElementById('darkToggle').textContent = document.body.classList.contains('light-mode') ? '☀️' : '🌙';
            });
        </script>
    </body>
</html>