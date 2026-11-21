
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password | CampusCrave</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #F8F4EC;
            color: #49382B;
            margin: 0;
        }
        .box {
            max-width: 430px;
            margin: 45px auto;
            padding: 28px;
            background: #FFFDF8;
            border: 1px solid #E4D8C5;
            border-radius: 14px;
        }
        h2 { text-align: center; }
        label { display: block; margin-top: 16px; }
        input {
            width: 100%;
            box-sizing: border-box;
            padding: 12px;
            margin-top: 7px;
            border: 1px solid #E4D8C5;
            border-radius: 7px;
        }
        button {
            width: 100%;
            padding: 12px;
            margin-top: 22px;
            background: #6B4F3A;
            color: white;
            border: 0;
            border-radius: 7px;
            cursor: pointer;
        }
        .msg { padding: 10px; background: #E9DDCC; }
        a { color: #6B4F3A; }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="box">
    <h2>Change Password</h2>

    <% if ("1".equals(request.getParameter("changed"))) { %>
        <p class="msg">Password changed successfully!</p>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <p class="msg">
            <% if ("current".equals(request.getParameter("error"))) { %>
                Current password is incorrect.
            <% } else if ("invalid".equals(request.getParameter("error"))) { %>
                Check your entries. New password must be at least 6 characters
                and both new passwords must match.
            <% } else { %>
                Unable to change password. Please try again.
            <% } %>
        </p>
    <% } %>

    <form action="changePassword" method="post">
        <label>Current Password</label>
        <input type="password" name="currentPassword"
               autocomplete="current-password" required>

        <label>New Password</label>
        <input type="password" name="newPassword" minlength="6"
               autocomplete="new-password" required>

        <label>Confirm New Password</label>
        <input type="password" name="confirmPassword" minlength="6"
               autocomplete="new-password" required>

        <button type="submit">Update Password</button>
    </form>

    <p><a href="profile">← Back to Profile</a></p>
</div>
</body>
</html>

