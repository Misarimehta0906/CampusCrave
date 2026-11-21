
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin/adminLogin.jsp");
        return;
    }

    String pageName = (String) request.getAttribute("pageName");
    List<String> columns =
        (List<String>) request.getAttribute("columns");
    List<List<String>> rows =
        (List<List<String>>) request.getAttribute("rows");

    String title = pageName == null ? "Management" :
        pageName.substring(0, 1).toUpperCase()
        + pageName.substring(1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= title %> | CampusCrave</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/admin/admin-style.css">
</head>
<body>

<div class="admin-layout">

    <aside class="sidebar">
        <div class="sidebar-brand">CampusCrave</div>
        <p class="sidebar-label">ADMINISTRATION</p>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/dashboard">
            Dashboard
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/food">
            Food Menu
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/categories">
            Categories
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/orders">
            Orders
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/users">
            Students
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/feedback">
            Feedback
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/coupons">
            Coupons
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/payments">
            Payments
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/specials">
            Today's Specials
        </a>

        <a class="side-link logout-link"
           href="<%= request.getContextPath() %>/admin/logout">
            Logout
        </a>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div>
                <h1><%= title %></h1>
                <p class="muted">CampusCrave administration</p>
            </div>

            <a class="btn-secondary"
               href="<%= request.getContextPath() %>/admin/dashboard">
                Dashboard
            </a>
        </header>

        <section class="quick-panel">
            <h2><%= title %> Records</h2>

            <p class="muted">
                Total records: <%= rows == null ? 0 : rows.size() %>
            </p>

            <div style="overflow-x:auto;">
                <table style="width:100%;border-collapse:collapse;">
                    <thead>
                        <tr>
                            <% if (columns != null) {
                                for (String column : columns) { %>
                                <th style="text-align:left;padding:12px;border-bottom:1px solid #E4D8C5;">
                                    <%= column %>
                                </th>
                            <% }} %>
                        </tr>
                    </thead>

                    <tbody>
                        <% if (rows != null && !rows.isEmpty()) {
                            for (List<String> row : rows) { %>
                            <tr>
                                <% for (String value : row) { %>
                                <td style="padding:12px;border-bottom:1px solid #E4D8C5;">
                                    <%= value %>
                                </td>
                                <% } %>
                            </tr>
                        <% }} else { %>
                            <tr>
                                <td colspan="<%= columns == null ? 1 : Math.max(columns.size(), 1) %>"
                                    style="padding:18px;">
                                    No records found.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <footer class="admin-footer">
            © 2026 CampusCrave | Admin Panel
        </footer>

    </main>
</div>

</body>
</html>
