```jsp
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session == null || session.getAttribute("adminId") == null) {
        response.sendRedirect(
                request.getContextPath() + "/admin/adminLogin.jsp");
        return;
    }

    List<Map<String, Object>> feedbackList =
            (List<Map<String, Object>>) request.getAttribute("feedbackList");

    if (feedbackList == null) {
        feedbackList = new java.util.ArrayList<>();
    }

    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>User Feedback | CampusCrave Admin</title>
<style>
* { box-sizing: border-box; font-family: Arial, sans-serif; }
body { margin: 0; padding: 30px; background: #f8f4ee; color: #514235; }
header {
    display: flex; justify-content: space-between;
    align-items: center; gap: 15px; margin-bottom: 25px;
}
a {
    display: inline-block; padding: 12px 18px;
    background: #dcc0a4; color: #49382c;
    text-decoration: none; border-radius: 8px; font-weight: bold;
}
.panel {
    background: #fffdf9; border: 1px solid #e6d6c3;
    border-radius: 15px; padding: 25px;
}
.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; min-width: 600px; }
th, td { text-align: left; padding: 14px; border-bottom: 1px solid #e6d6c3; }
th { background: #f0e5d7; }
@media(max-width:600px) { body { padding: 15px; } }
</style>
</head>
<body>

<header>
    <div>
        <h1>User Feedback</h1>
        <p>CampusCrave administration</p>
    </div>
    <a href="<%= ctx %>/admin/dashboard">Dashboard</a>
</header>

<div class="panel">
    <h2>Total feedback: <%= feedbackList.size() %></h2>

    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Rating</th>
                    <th>Comment</th>
                </tr>
            </thead>
            <tbody>
            <% if (feedbackList.isEmpty()) { %>
                <tr>
                    <td colspan="4">No feedback submitted yet.</td>
                </tr>
            <% } else {
                for (Map<String, Object> item : feedbackList) { %>
                <tr>
                    <td><%= item.get("id") %></td>
                    <td><%= item.get("name") == null ? "" : item.get("name") %></td>
                    <td><%= item.get("rating") %> / 5</td>
                    <td><%= item.get("comment") == null ? "" : item.get("comment") %></td>
                </tr>
            <%  }
               } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>

