<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connection.jsp" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add Book — Garden of Knowledge</title>
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
                <h1 class="page-title">➕ Add New Book</h1>
                <div class="form-card glass-card">
                    <form action="addBookProcess.jsp" method="post">
                        <div class="form-group">
                            <label>Title</label>
                            <input type="text" name="title" required placeholder="Enter book title">
                        </div>
                        <div class="form-group">
                            <label>Author</label>
                            <input type="text" name="author" required placeholder="Enter author name">
                        </div>
                        <div class="form-group">
                            <label>Genre</label>
                            <input type="text" name="genre" placeholder="e.g. Fiction, Science, History">
                        </div>
                        <div class="form-group">
                            <label>Total Copies</label>
                            <input type="number" name="totalCopies" required min="1">
                        </div>
                        <button type="submit" class="btn-primary">Add Book</button>
                        <a href="adminDashboard.jsp" class="btn-secondary">Cancel</a>
                    </form>
                </div>
            </div>
        </div>

        <script src="style.js"></script>
    </body>
</html>