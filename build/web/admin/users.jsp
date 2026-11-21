<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession adminSession = request.getSession(false);

    if (adminSession == null ||
        adminSession.getAttribute("adminId") == null) {

        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Map<String, Object>> users =
        (List<Map<String, Object>>) request.getAttribute("users");

    if (users == null) {
        users = new java.util.ArrayList<>();
    }
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Users - Smart Canteen</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f5f6fa;
        }

        .navbar {
            height: 70px;
            background: #ff6335;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 35px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .logout {
            background: white;
            color: #ff6335;
            text-decoration: none;
            padding: 10px 18px;
            border-radius: 6px;
            font-weight: bold;
        }

        .container {
            padding: 30px;
        }

        .top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .top h1 {
            color: #333;
        }

        .back {
            text-decoration: none;
            color: #ff6335;
            font-weight: bold;
        }

        .table-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
            overflow-x: auto;
        }

        .table-box h2 {
            margin-bottom: 20px;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }

        th,
        td {
            padding: 13px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }

        th {
            background: #fff0eb;
            color: #333;
        }

        .user-id {
            font-weight: bold;
            color: #ff6335;
        }

        .delete-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 13px;
            border-radius: 5px;
            cursor: pointer;
        }

        .delete-btn:hover {
            background: #b02a37;
        }

        .empty {
            text-align: center;
            color: #777;
            padding: 25px;
        }

        .count-box {
            display: inline-block;
            background: #fff0eb;
            color: #ff6335;
            padding: 8px 15px;
            border-radius: 20px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        @media (max-width: 700px) {

            .navbar {
                padding: 0 15px;
            }

            .container {
                padding: 15px;
            }

        }

    </style>

</head>

<body>

    <!-- NAVBAR -->

    <div class="navbar">

        <div class="logo">
            ? Smart Canteen - Admin
        </div>

        <a href="../adminLogout" class="logout">
            Logout
        </a>

    </div>


    <div class="container">

        <div class="top">

            <h1>User Management</h1>

            <a href="dashboard.jsp" class="back">
                ? Back to Dashboard
            </a>

        </div>


        <div class="table-box">

            <h2>Registered Users</h2>

            <div class="count-box">
                Total Users: <%= users.size() %>
            </div>


            <table>

                <thead>

                    <tr>

                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Registration Date</th>
                        <th>Action</th>

                    </tr>

                </thead>


                <tbody>

                <%
                    if (users.isEmpty()) {
                %>

                    <tr>

                        <td colspan="6"
                            class="empty">

                            No registered users found.

                        </td>

                    </tr>

                <%
                    } else {

                        for (Map<String, Object> user : users) {
                %>

                    <tr>

                        <td class="user-id">
                            #<%= user.get("user_id") %>
                        </td>

                        <td>
                            <%= user.get("name") %>
                        </td>

                        <td>
                            <%= user.get("email") %>
                        </td>

                        <td>
                            <%= user.get("phone") %>
                        </td>

                        <td>
                            <%= user.get("created_at") %>
                        </td>

                        <td>

                            <form action="../adminUser"
                                  method="post"
                                  onsubmit="return confirm('Are you sure you want to delete this user?');">

                                <input type="hidden"
                                       name="action"
                                       value="delete">

                                <input type="hidden"
                                       name="userId"
                                       value="<%= user.get("user_id") %>">

                                <button type="submit"
                                        class="delete-btn">

                                    Delete

                                </button>

                            </form>

                        </td>

                    </tr>

                <%
                        }
                    }
                %>

                </tbody>

            </table>

        </div>

    </div>

</body>
</html>