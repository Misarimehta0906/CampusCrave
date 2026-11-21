<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Map<String, Object>> feedbackList =
        (List<Map<String, Object>>) request.getAttribute("feedbackList");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Feedback - Smart Canteen</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #fff8f2;
            color: #333;
        }

        .navbar {
            background: #ff6335;
            color: white;
            padding: 18px 35px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h2 {
            font-size: 24px;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-weight: bold;
        }

        .container {
            width: 92%;
            margin: 30px auto;
        }

        .title {
            margin-bottom: 25px;
        }

        .title h1 {
            color: #ff6335;
        }

        .table-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            overflow-x: auto;
        }

        .table-box h2 {
            color: #ff6335;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 13px;
            border-bottom: 1px solid #eee;
            text-align: left;
            vertical-align: top;
        }

        th {
            background: #ff6335;
            color: white;
        }

        tr:hover {
            background: #fff8f2;
        }

        .rating {
            font-weight: bold;
        }

        .delete-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 5px;
            cursor: pointer;
        }

        .delete-btn:hover {
            background: #bb2d3b;
        }

        .empty {
            text-align: center;
            padding: 25px;
            color: #777;
        }

        .comment {
            max-width: 300px;
            word-wrap: break-word;
        }

        @media(max-width: 700px) {

            .navbar {
                flex-direction: column;
                gap: 10px;
            }

            .container {
                width: 96%;
            }

        }

    </style>

</head>

<body>


<div class="navbar">

    <h2>Smart Canteen - Admin</h2>

    <div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="../adminLogout">Logout</a>
    </div>

</div>


<div class="container">

    <div class="title">
        <h1>Customer Feedback</h1>
    </div>


    <div class="table-box">

        <h2>All Feedback</h2>

        <table>

            <thead>

                <tr>

                    <th>ID</th>
                    <th>User</th>
                    <th>Email</th>
                    <th>Food</th>
                    <th>Rating</th>
                    <th>Comment</th>
                    <th>Date</th>
                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

            <%
                if (feedbackList != null && !feedbackList.isEmpty()) {

                    for (Map<String, Object> feedback : feedbackList) {
            %>

                <tr>

                    <td>
                        <%= feedback.get("feedback_id") %>
                    </td>

                    <td>
                        <%= feedback.get("user_name") %>
                    </td>

                    <td>
                        <%
                            /*
                             * AdminFeedbackServlet currently sends
                             * user_name and food_name, but not email.
                             * So email is intentionally not displayed here.
                             */
                        %>
                        Not Available
                    </td>

                    <td>
                        <%= feedback.get("food_name") != null
                            ? feedback.get("food_name")
                            : "General Feedback" %>
                    </td>

                    <td class="rating">
                        <%= feedback.get("rating") %> / 5
                    </td>

                    <td class="comment">
                        <%= feedback.get("comment") %>
                    </td>

                    <td>
                        <%= feedback.get("created_at") %>
                    </td>

                    <td>

                        <form action="../adminFeedback"
                              method="post"
                              onsubmit="return confirm('Delete this feedback?');">

                            <input type="hidden"
                                   name="action"
                                   value="delete">

                            <input type="hidden"
                                   name="feedbackId"
                                   value="<%= feedback.get("feedback_id") %>">

                            <button type="submit"
                                    class="delete-btn">
                                Delete
                            </button>

                        </form>

                    </td>

                </tr>

            <%
                    }

                } else {
            %>

                <tr>

                    <td colspan="8"
                        class="empty">

                        No feedback found.

                    </td>

                </tr>

            <%
                }
            %>

            </tbody>

        </table>

    </div>

</div>

</body>
</html>
