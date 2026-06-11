<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Success — Garden of Knowledge</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <canvas id="particles-canvas"></canvas>

        <div class="dashboard-wrapper">
            <nav class="navbar">
                <div class="nav-brand">📚 Garden of Knowledge</div>
            </nav>
            <div class="content-area center-content">
                <div class="success-card glass-card">
                    <div class="success-icon">✅</div>
                    <h1>Success!</h1>
                    <p><%= request.getAttribute("message") != null ? request.getAttribute("message") : "Action completed successfully." %></p>
                    <a href="userDashboard.jsp" class="btn-primary">Go to Dashboard</a>
                </div>
            </div>
        </div>

        <script src="style.js"></script>
    </body>
</html>