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
                    <form action="book-admin.jsp" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="mode" value="add">
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
                        <div class="form-group">
                            <label>Digital Book File</label>
                            <input type="file" name="digitalFile" accept=".pdf,.epub,application/pdf,application/epub+zip">
                            <small style="display:block; margin-top:6px; opacity:0.75;">Optional PDF or EPUB upload. Stored on the server and linked to this book.</small>
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