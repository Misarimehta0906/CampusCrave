<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("adminId") != null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | CampusCrave</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/admin/admin-style.css">
</head>
<body class="login-page">

    <div class="login-card">
        <div class="brand-icon">CC</div>
        <h1>CampusCrave</h1>
        <p class="muted">Administrator Portal</p>

        <% if ("invalid".equals(error)) { %>
            <div class="alert">Invalid email or password, or inactive admin account.</div>
        <% } else if ("empty".equals(error)) { %>
            <div class="alert">Please enter email and password.</div>
        <% } else if ("server".equals(error)) { %>
            <div class="alert">Login failed. Please check the server and database.</div>
        <% } else if ("1".equals(request.getParameter("logout"))) { %>
            <div class="success">You have logged out successfully.</div>
        <% } %>

        <form action="<%= request.getContextPath() %>/admin/login"
              method="post">

            <label for="email">Admin Email</label>
            <input type="email" id="email" name="email"
                   placeholder="Enter admin email" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   placeholder="Enter password" required>

            <button class="btn-primary full-width" type="submit">
                Login to Dashboard
            </button>
        </form>

        <a class="back-link"
           href="<%= request.getContextPath() %>/index.jsp">
            Back to CampusCrave
        </a>
    </div>

</body>
</html>