<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int memberId = Integer.parseInt(request.getParameter("memberId"));
    int bookId = Integer.parseInt(request.getParameter("bookId"));

    PreparedStatement ps = conn.prepareStatement(
        "INSERT INTO borrowings (book_id, member_id, borrow_date) VALUES (?, ?, CURRENT_DATE)");
    ps.setInt(1, bookId);
    ps.setInt(2, memberId);
    ps.executeUpdate();

    PreparedStatement ps2 = conn.prepareStatement(
        "UPDATE books SET available_copies = available_copies - 1 WHERE id = ?");
    ps2.setInt(1, bookId);
    ps2.executeUpdate();

    response.sendRedirect("userDashboard.jsp");
%>