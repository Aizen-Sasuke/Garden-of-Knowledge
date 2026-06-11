<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM books");
    ResultSet rs1 = ps1.executeQuery(); rs1.next();
    int totalBooks = rs1.getInt(1);

    PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM members");
    ResultSet rs2 = ps2.executeQuery(); rs2.next();
    int totalMembers = rs2.getInt(1);

    PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM borrowings");
    ResultSet rs3 = ps3.executeQuery(); rs3.next();
    int totalBorrowings = rs3.getInt(1);

    PreparedStatement ps4 = conn.prepareStatement("SELECT COUNT(*) FROM borrowings WHERE return_date IS NULL");
    ResultSet rs4 = ps4.executeQuery(); rs4.next();
    int activeBorrowings = rs4.getInt(1);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Dashboard — Garden of Knowledge</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <canvas id="particles-canvas"></canvas>

        <nav class="navbar">
            <a href="home.jsp" class="navbar-brand">🌿 Garden of Knowledge</a>
            <div class="navbar-controls">
                <button class="icon-btn" id="darkToggle">🌙</button>
            </div>
        </nav>

        <div class="dashboard-wrapper" style="max-width:1200px; margin:0 auto;">
            <div class="dashboard-header" data-aos="fade-down">
                <h1>⚙️ Admin Dashboard</h1>
                <div class="nav-actions">
                    <a href="addBook.jsp">➕ Add Book</a>
                    <a href="addMember.jsp">👤 Add Member</a>
                    <a href="borrow.jsp">📤 Borrow</a>
                    <a href="return.jsp">📥 Return</a>
                    <a href="logout.jsp">🚪 Logout</a>
                </div>
            </div>

            <!-- STAT CARDS -->
            <div class="stats-grid" data-aos="fade-up">
                <div class="stat-card">
                    <div class="stat-number"><%= totalBooks %></div>
                    <div class="stat-label">📚 Total Books</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= totalMembers %></div>
                    <div class="stat-label">👥 Total Members</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= totalBorrowings %></div>
                    <div class="stat-label">📤 Total Borrowings</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= activeBorrowings %></div>
                    <div class="stat-label">⏳ Active Borrowings</div>
                </div>
            </div>

            <!-- CHARTS -->
            <div class="charts-grid" data-aos="fade-up" data-aos-delay="100">
                <div class="chart-card">
                    <h3>📊 Library Overview</h3>
                    <canvas id="barChart"></canvas>
                </div>
                <div class="chart-card">
                    <h3>🍩 Borrowing Status</h3>
                    <canvas id="doughnutChart"></canvas>
                </div>
            </div>

            <!-- BOOKS TABLE -->
            <div class="section-title" data-aos="fade-up">📖 Manage Books</div>
            <div class="table-container" data-aos="fade-up" data-aos-delay="100">
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Genre</th>
                        <th>Total</th>
                        <th>Available</th>
                        <th>Actions</th>
                    </tr>
                    <%
                        PreparedStatement psBooks = conn.prepareStatement("SELECT * FROM books");
                        ResultSet rsBooks = psBooks.executeQuery();
                        while (rsBooks.next()) {
                    %>
                    <tr>
                        <td><%= rsBooks.getInt("id") %></td>
                        <td><%= rsBooks.getString("title") %></td>
                        <td><%= rsBooks.getString("author") %></td>
                        <td><%= rsBooks.getString("genre") %></td>
                        <td><%= rsBooks.getInt("total_copies") %></td>
                        <td><%= rsBooks.getInt("available_copies") %></td>
                        <td>
                            <a class="action-btn edit-btn" href="editBook.jsp?id=<%= rsBooks.getInt("id") %>">✏️ Edit</a>
                            <a class="action-btn delete-btn" href="deleteBookProcess.jsp?id=<%= rsBooks.getInt("id") %>"
                               onclick="return confirm('Delete this book?')">🗑️ Delete</a>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>

            <!-- MEMBERS TABLE -->
            <div class="section-title" data-aos="fade-up" style="margin-top:40px;">👥 All Members</div>
            <div class="table-container" data-aos="fade-up" data-aos-delay="100">
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                    </tr>
                    <%
                        PreparedStatement psMembers = conn.prepareStatement("SELECT * FROM members");
                        ResultSet rsMembers = psMembers.executeQuery();
                        while (rsMembers.next()) {
                    %>
                    <tr>
                        <td><%= rsMembers.getInt("id") %></td>
                        <td><%= rsMembers.getString("name") %></td>
                        <td><%= rsMembers.getString("email") %></td>
                        <td><%= rsMembers.getString("phone") %></td>
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

            // PARTICLES
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

            // DARK MODE
            document.getElementById('darkToggle').addEventListener('click', () => {
                document.body.classList.toggle('light-mode');
                document.getElementById('darkToggle').textContent = document.body.classList.contains('light-mode') ? '☀️' : '🌙';
            });

            // CHARTS
            new Chart(document.getElementById('barChart'), {
                type: 'bar',
                data: {
                    labels: ['Books', 'Members', 'Borrowings', 'Active'],
                    datasets: [{
                        data: [<%= totalBooks %>, <%= totalMembers %>, <%= totalBorrowings %>, <%= activeBorrowings %>],
                        backgroundColor: ['rgba(168,197,160,0.4)', 'rgba(184,205,217,0.4)', 'rgba(201,168,76,0.4)', 'rgba(255,153,153,0.4)'],
                        borderColor: ['#a8c5a0', '#b8cdd9', '#c9a84c', '#ff9999'],
                        borderWidth: 2,
                        borderRadius: 8
                    }]
                },
                options: {
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { ticks: { color: 'rgba(255,255,255,0.5)' }, grid: { color: 'rgba(255,255,255,0.05)' } },
                        x: { ticks: { color: 'rgba(255,255,255,0.5)' }, grid: { display: false } }
                    }
                }
            });

            new Chart(document.getElementById('doughnutChart'), {
                type: 'doughnut',
                data: {
                    labels: ['Returned', 'Active'],
                    datasets: [{
                        data: [<%= totalBorrowings - activeBorrowings %>, <%= activeBorrowings %>],
                        backgroundColor: ['rgba(168,197,160,0.6)', 'rgba(255,153,153,0.6)'],
                        borderColor: ['#a8c5a0', '#ff9999'],
                        borderWidth: 2
                    }]
                },
                options: {
                    plugins: { legend: { labels: { color: 'rgba(255,255,255,0.6)' } } }
                }
            });
        </script>
    </body>
</html>