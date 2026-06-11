<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>All Books — Garden of Knowledge</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <canvas id="particles-canvas"></canvas>
        <div class="page-transition" id="pageTransition"></div>

        <div class="dashboard-wrapper">
            <nav class="navbar">
                <div class="nav-brand">📚 Garden of Knowledge</div>
                <div class="nav-links">
                    <% if ("admin".equals(role)) { %>
                        <a href="adminDashboard.jsp">Dashboard</a>
                    <% } else { %>
                        <a href="userDashboard.jsp">Dashboard</a>
                    <% } %>
                    <a href="logout.jsp">Logout</a>
                </div>
            </nav>

            <div class="content-area">
                <h1 class="page-title">📖 All Books</h1>

                <div class="books-grid">
                <%
                    PreparedStatement ps = conn.prepareStatement("SELECT * FROM books ORDER BY title");
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String title = rs.getString("title");
                        String author = rs.getString("author");
                        String genre = rs.getString("genre");
                        int available = rs.getInt("available_copies");
                %>
                    <div class="book-card glass-card">
                        <div class="book-icon">📗</div>
                        <h3><%= title %></h3>
                        <p class="book-author">by <%= author %></p>
                        <p class="book-genre"><%= genre %></p>
                        <p class="book-availability <%= available > 0 ? "available" : "unavailable" %>">
                            <%= available > 0 ? "✅ " + available + " copies available" : "❌ Unavailable" %>
                        </p>
                        <% if ("user".equals(role) && available > 0) { %>
                            <a href="borrow.jsp?bookId=<%= id %>" class="btn-primary">Borrow</a>
                        <% } %>
                        <% if ("admin".equals(role)) { %>
                            <a href="editBook.jsp?id=<%= id %>" class="btn-secondary">Edit</a>
                            <a href="deleteBook.jsp?id=<%= id %>" class="btn-danger" onclick="return confirm('Delete this book?')">Delete</a>
                        <% } %>
                    </div>
                <% } %>
                </div>
            </div>
        </div>

        <script src="style.js"></script>
    </body>
</html>