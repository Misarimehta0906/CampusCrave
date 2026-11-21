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

    List<Map<String, Object>> payments =
        (List<Map<String, Object>>) request.getAttribute("payments");

    if (payments == null) {
        payments = new java.util.ArrayList<>();
    }
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Payments - Smart Canteen</title>

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
            min-width: 1000px;
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

            <h1>Payment Management</h1>

            <a href="dashboard.jsp" class="back">
                ? Back to Dashboard
            </a>

        </div>


        <div class="table-box">

            <h2>All Payments</h2>

            <table>

                <thead>

                    <tr>

                        <th>Payment ID</th>
                        <th>Order ID</th>
                        <th>User Name</th>
                        <th>Email</th>
                        <th>Payment Method</th>
                        <th>Amount</th>
                        <th>Payment Date</th>
                        <th>Status</th>
                        <th>Update</th>

                    </tr>

                </thead>


                <tbody>

                <%
                    if (payments.isEmpty()) {
                %>

                    <tr>

                        <td colspan="9"
                            class="empty">

                            No payments found.

                        </td>

                    </tr>

                <%
                    } else {

                        for (Map<String, Object> payment : payments) {
                %>

                    <tr>

                        <td>
                            <%= payment.get("payment_id") %>
                        </td>

                        <td>
                            #<%= payment.get("order_id") %>
                        </td>

                        <td>
                            <%= payment.get("name") %>
                        </td>

                        <td>
                            <%= payment.get("email") %>
                        </td>

                        <td>
                            <%= payment.get("payment_method") %>
                        </td>

                        <td class="amount">
                            ?<%= payment.get("amount") %>
                        </td>

                        <td>
                            <%= payment.get("payment_date") %>
                        </td>

                        <td>
                            <%= payment.get("payment_status") %>
                        </td>

                        <td>

                            <form action="../adminPayment"
                                  method="post"
                                  class="status-form">

                                <input type="hidden"
                                       name="action"
                                       value="updateStatus">

                                <input type="hidden"
                                       name="paymentId"
                                       value="<%= payment.get("payment_id") %>">


                                <select name="status">

                                    <option value="Pending"
                                        <%= "Pending".equals(payment.get("payment_status")) ? "selected" : "" %>>
                                        Pending
                                    </option>

                                    <option value="Success"
                                        <%= "Success".equals(payment.get("payment_status")) ? "selected" : "" %>>
                                        Success
                                    </option>

                                    <option value="Failed"
                                        <%= "Failed".equals(payment.get("payment_status")) ? "selected" : "" %>>
                                        Failed
                                    </option>

                                    <option value="Refunded"
                                        <%= "Refunded".equals(payment.get("payment_status")) ? "selected" : "" %>>
                                        Refunded
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
