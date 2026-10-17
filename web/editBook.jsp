<%-- 
    Document   : editBook
    Created on : Feb 26, 2026, 6:50:41 PM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM books WHERE id = ?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();
    rs.next();
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Book — Garden of Knowledge</title>
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
                    <a href="adminDashboard.jsp">Dashboard</a>
                    <a href="logout.jsp">Logout</a>
                </div>
            </nav>

            <div class="content-area">
                <h1 class="page-title">✏️ Edit Book</h1>
                <div class="form-card glass-card">
                    <form action="book-admin.jsp" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="mode" value="edit">
                        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                        <div class="form-group">
                            <label>Title</label>
                            <input type="text" name="title" value="<%= rs.getString("title") %>" required>
                        </div>
                        <div class="form-group">
                            <label>Author</label>
                            <input type="text" name="author" value="<%= rs.getString("author") %>" required>
                        </div>
                        <div class="form-group">
                            <label>Genre</label>
                            <input type="text" name="genre" value="<%= rs.getString("genre") %>" required>
                        </div>
                        <div class="form-group">
                            <label>Total Copies</label>
                            <input type="number" name="totalCopies" value="<%= rs.getInt("total_copies") %>" required>
                        </div>
                        <div class="form-group">
                            <label>Available Copies</label>
                            <input type="number" name="availableCopies" value="<%= rs.getInt("available_copies") %>" required>
                        </div>
                        <div class="form-group">
                            <label>Current Digital File</label>
                            <% if (rs.getString("digital_file_name") != null) { %>
                                <p style="margin-bottom:10px; opacity:0.85;">Attached: <strong><%= rs.getString("digital_file_name") %></strong></p>
                                <div style="display:flex; gap:10px; flex-wrap:wrap; margin-bottom:12px;">
                                    <a class="btn-secondary" href="book-file.jsp?id=<%= rs.getInt("id") %>&mode=read" target="_blank" rel="noopener">Read</a>
                                    <a class="btn-primary" href="book-file.jsp?id=<%= rs.getInt("id") %>&mode=download">Download</a>
                                </div>
                            <% } else { %>
                                <p style="margin-bottom:10px; opacity:0.75;">No file attached yet.</p>
                            <% } %>
                            <input type="file" name="digitalFile" accept=".pdf,.epub,application/pdf,application/epub+zip">
                            <small style="display:block; margin-top:6px; opacity:0.75;">Choose a new file to replace the existing one.</small>
                        </div>
                        <% if (rs.getString("digital_file_name") != null) { %>
                            <label style="display:flex; gap:10px; align-items:center; text-transform:none; letter-spacing:0; margin-bottom:20px;">
                                <input type="checkbox" name="removeDigitalFile" value="true" style="width:auto; margin:0;">
                                Remove current digital file
                            </label>
                        <% } %>
                        <button type="submit" class="btn-primary">Save Changes</button>
                        <a href="adminDashboard.jsp" class="btn-secondary">Cancel</a>
                    </form>
                </div>
            </div>
        </div>

        <script src="style.js"></script>
    </body>
</html>
