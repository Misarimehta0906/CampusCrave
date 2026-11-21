
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.sql.*, java.math.BigDecimal" %>

<%
    String contextPath = request.getContextPath();
    Object sessionUserId = session.getAttribute("userId");

    if (sessionUserId == null) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    int userId;

    try {
        userId = Integer.parseInt(sessionUserId.toString());
    } catch (NumberFormatException ex) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    String customerName = null;
    String phone = null;
    String errorMessage = null;
    boolean hasOrders = false;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>My Orders | CampusCrave</title>

    <link rel="stylesheet" href="<%= contextPath %>/style.css">

    <style>
        .orders-container {
            max-width: 1050px;
            margin: 35px auto;
            padding: 20px;
        }

        .orders-heading {
            margin-bottom: 25px;
        }

        .order-card {
            background: var(--white, #fffdf8);
            border: 1px solid var(--border, #e4d8c5);
            border-radius: 15px;
            padding: 22px;
            margin-bottom: 18px;
            box-shadow: var(--shadow, 0 6px 20px rgba(107,79,58,.08));
        }

        .order-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            border-bottom: 1px solid var(--border, #e4d8c5);
            padding-bottom: 14px;
        }

        .order-top h3 {
            margin: 0;
            color: var(--text, #49382b);
        }

        .order-date {
            color: var(--muted, #887866);
            font-size: 13px;
            margin-top: 7px;
        }

        .order-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-top: 18px;
        }

        .detail-label {
            color: var(--muted, #887866);
            font-size: 13px;
            margin-bottom: 5px;
        }

        .detail-value {
            color: var(--text, #49382b);
            font-weight: 600;
            overflow-wrap: anywhere;
        }

        .status {
            display: inline-block;
            padding: 7px 13px;
            border-radius: 20px;
            background: #f3eadb;
            color: #6b4f3a;
            font-size: 13px;
            font-weight: bold;
        }

        .order-total {
            font-size: 20px;
            color: var(--green, #6b4f3a);
            font-weight: bold;
        }

        .notice {
            padding: 14px 17px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .notice-success {
            background: #e9f7ed;
            color: #216e39;
        }

        .notice-error {
            background: #fff0f1;
            color: #a43d51;
        }

        .empty-orders {
            background: var(--white, #fffdf8);
            border: 1px solid var(--border, #e4d8c5);
            border-radius: 15px;
            text-align: center;
            padding: 35px 20px;
        }

        .empty-orders h3 {
            margin-top: 0;
        }

        .order-actions {
            margin-top: 22px;
        }

        .order-actions a {
            display: inline-block;
            text-decoration: none;
            padding: 11px 18px;
            background: var(--green, #6b4f3a);
            color: white;
            border-radius: 9px;
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<main class="orders-container">

    <div class="orders-heading">
        <span class="eyebrow">YOUR CAMPUS CRAVINGS</span>
        <h1>My Orders</h1>
        <p class="muted">Check your order history and order status.</p>
    </div>

    <%
        String success = request.getParameter("success");
        String successOrderId = request.getParameter("orderId");

        if ("1".equals(success)) {
    %>
        <div class="notice notice-success">
            Order placed successfully!
            <% if (successOrderId != null) { %>
                Your Order ID is #<%= successOrderId %>.
            <% } %>
        </div>
    <%
        }

        Connection con = null;
        PreparedStatement userPs = null;
        PreparedStatement orderPs = null;
        ResultSet userRs = null;
        ResultSet orderRs = null;

        try {
            con = com.smartcanteen.DBConnection.getConnection();

            // Get the logged-in user's details.
            userPs = con.prepareStatement(
                "SELECT name, phone FROM users WHERE id = ?"
            );

            userPs.setInt(1, userId);
            userRs = userPs.executeQuery();

            if (!userRs.next()) {
                throw new SQLException("Logged-in user was not found.");
            }

            customerName = userRs.getString("name");
            phone = userRs.getString("phone");

            userRs.close();
            userRs = null;
            userPs.close();
            userPs = null;

            /*
             * Current orders table has no user_id column.
             * Therefore, find orders by customer name and phone.
             */
            String orderSql =
                "SELECT id, customer_name, phone, food_details, total, " +
                "payment, status, order_date " +
                "FROM orders " +
                "WHERE customer_name = ? " +
                "AND (phone = ? OR (phone IS NULL AND ? IS NULL)) " +
                "ORDER BY order_date DESC, id DESC";

            orderPs = con.prepareStatement(orderSql);
            orderPs.setString(1, customerName);
            orderPs.setString(2, phone);

            if (phone == null) {
                orderPs.setNull(3, Types.VARCHAR);
            } else {
                orderPs.setString(3, phone);
            }

            orderRs = orderPs.executeQuery();

            while (orderRs.next()) {
                hasOrders = true;

                int orderId = orderRs.getInt("id");
                String foodDetails = orderRs.getString("food_details");
                BigDecimal total = orderRs.getBigDecimal("total");
                String payment = orderRs.getString("payment");
                String status = orderRs.getString("status");
                Timestamp orderDate = orderRs.getTimestamp("order_date");

                if (total == null) {
                    total = BigDecimal.ZERO;
                }

                if (foodDetails == null || foodDetails.trim().isEmpty()) {
                    foodDetails = "Order details unavailable";
                }

                if (payment == null || payment.trim().isEmpty()) {
                    payment = "Not specified";
                }

                if (status == null || status.trim().isEmpty()) {
                    status = "Pending";
                }
    %>

    <article class="order-card">

        <div class="order-top">
            <div>
                <h3>Order #<%= orderId %></h3>

                <div class="order-date">
                    <%= orderDate != null
                        ? orderDate.toString()
                        : "Date unavailable" %>
                </div>
            </div>

            <span class="status"><%= status %></span>
        </div>

        <div class="order-details">

            <div>
                <div class="detail-label">Food Items</div>
                <div class="detail-value"><%= foodDetails %></div>
            </div>

            <div>
                <div class="detail-label">Payment Method</div>
                <div class="detail-value"><%= payment %></div>
            </div>

            <div>
                <div class="detail-label">Order Total</div>
                <div class="order-total">
                    ₹<%= total.setScale(2, java.math.RoundingMode.HALF_UP).toPlainString() %>
                </div>
            </div>

        </div>

    </article>

    <%
            }

        } catch (Exception e) {
            application.log(
                "Unable to load CampusCrave order history.", e
            );

            errorMessage =
                "Unable to load orders. Please check the database connection and table structure.";

        } finally {
            try {
                if (orderRs != null) orderRs.close();
            } catch (SQLException ignored) {}

            try {
                if (orderPs != null) orderPs.close();
            } catch (SQLException ignored) {}

            try {
                if (userRs != null) userRs.close();
            } catch (SQLException ignored) {}

            try {
                if (userPs != null) userPs.close();
            } catch (SQLException ignored) {}

            try {
                if (con != null) con.close();
            } catch (SQLException ignored) {}
        }

        if (errorMessage != null) {
    %>

        <div class="notice notice-error">
            <%= errorMessage %>
        </div>

    <%
        } else if (!hasOrders) {
    %>

        <div class="empty-orders">
            <h3>No orders yet 🍽️</h3>

            <p class="muted">
                Your orders will appear here after you place an order.
            </p>

            <div class="order-actions">
                <a href="<%= contextPath %>/menu">
                    Order Something Tasty
                </a>
            </div>
        </div>

    <%
        }
    %>

    <div class="order-actions">
        <a href="<%= contextPath %>/menu">Order More Food</a>
    </div>

</main>

<footer class="footer">
    CampusCrave · Made for campus life.
</footer>

</body>
</html>
