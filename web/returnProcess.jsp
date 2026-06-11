<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int borrowingId = Integer.parseInt(request.getParameter("borrowingId"));

    PreparedStatement ps = conn.prepareStatement(
        "UPDATE borrowings SET return_date = CURRENT_DATE WHERE id = ?");
    ps.setInt(1, borrowingId);
    ps.executeUpdate();

    PreparedStatement ps2 = conn.prepareStatement(
        "UPDATE books SET available_copies = available_copies + 1 WHERE id = (SELECT book_id FROM borrowings WHERE id = ?)");
    ps2.setInt(1, borrowingId);
    ps2.executeUpdate();

    response.sendRedirect("userDashboard.jsp");
%>