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

    List<Map<String, Object>> orders =
        (List<Map<String, Object>>) request.getAttribute("orders");

    if (orders == null) {
        orders = new java.util.ArrayList<>();
    }
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Manage Orders - Smart Canteen</title>

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
            min-width: 950px;
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

        .amount {
            font-weight: bold;
            color: #ff6335;
        }

        .status-form {
            display: flex;
            gap: 6px;
            align-items: center;
        }

        select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .update-btn {
            background: #ff6335;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
        }

        .update-btn:hover {
            background: #e95025;
        }

        .empty {
            text-align: center;
            color: #777;
            padding: 25px;
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

            <h1>Manage Orders</h1>

            <a href="dashboard.jsp" class="back">
                ? Back to Dashboard
            </a>

        </div>


        <div class="table-box">

            <h2>All Orders</h2>

            <table>

                <thead>

                    <tr>

                        <th>Order ID</th>
                        <th>User ID</th>
                        <th>User Name</th>
                        <th>Email</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Order Date</th>
                        <th>Update</th>

                    </tr>

                </thead>


                <tbody>

                <%
                    if (orders.isEmpty()) {
                %>

                    <tr>

                        <td colspan="8"
                            class="empty">

                            No orders found.

                        </td>

                    </tr>

                <%
                    } else {

                        for (Map<String, Object> order : orders) {
                %>

                    <tr>

                        <td>
                            #<%= order.get("order_id") %>
                        </td>

                        <td>
                            <%= order.get("user_id") %>
                        </td>

                        <td>
                            <%= order.get("name") %>
                        </td>

                        <td>
                            <%= order.get("email") %>
                        </td>

                        <td class="amount">
                            ?<%= order.get("total_amount") %>
                        </td>

                        <td>
                            <%= order.get("status") %>
                        </td>

                        <td>
                            <%= order.get("order_date") %>
                        </td>

                        <td>

                            <form action="../adminOrder"
                                  method="post"
                                  class="status-form">

                                <input type="hidden"
                                       name="action"
                                       value="updateStatus">

                                <input type="hidden"
                                       name="orderId"
                                       value="<%= order.get("order_id") %>">


                                <select name="status">

                                    <option value="Pending"
                                        <%= "Pending".equals(order.get("status")) ? "selected" : "" %>>
                                        Pending
                                    </option>

                                    <option value="Confirmed"
                                        <%= "Confirmed".equals(order.get("status")) ? "selected" : "" %>>
                                        Confirmed
                                    </option>

                                    <option value="Preparing"
                                        <%= "Preparing".equals(order.get("status")) ? "selected" : "" %>>
                                        Preparing
                                    </option>

                                    <option value="Ready"
                                        <%= "Ready".equals(order.get("status")) ? "selected" : "" %>>
                                        Ready
                                    </option>

                                    <option value="Completed"
                                        <%= "Completed".equals(order.get("status")) ? "selected" : "" %>>
                                        Completed
                                    </option>

                                    <option value="Cancelled"
                                        <%= "Cancelled".equals(order.get("status")) ? "selected" : "" %>>
                                        Cancelled
                                    </option>

                                </select>


                                <button type="submit"
                                        class="update-btn">
                                    Update
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