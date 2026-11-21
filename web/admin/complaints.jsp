<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Map<String, Object>> complaints =
        (List<Map<String, Object>>) request.getAttribute("complaints");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Complaints - Smart Canteen</title>

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
            width: 94%;
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

        .description {
            max-width: 300px;
            word-wrap: break-word;
        }

        .status-form {
            display: flex;
            gap: 5px;
            align-items: center;
        }

        .status-form select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .update-btn {
            background: #198754;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
        }

        .delete-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 7px;
        }

        .update-btn:hover {
            background: #157347;
        }

        .delete-btn:hover {
            background: #bb2d3b;
        }

        .empty {
            text-align: center;
            padding: 25px;
            color: #777;
        }

        @media(max-width: 700px) {

            .navbar {
                flex-direction: column;
                gap: 10px;
            }

            .container {
                width: 96%;
            }

            .status-form {
                flex-direction: column;
                align-items: stretch;
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
        <h1>Customer Complaints</h1>
    </div>


    <div class="table-box">

        <h2>All Complaints</h2>

        <table>

            <thead>

                <tr>

                    <th>ID</th>
                    <th>User</th>
                    <th>Email</th>
                    <th>Subject</th>
                    <th>Description</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

            <%
                if (complaints != null && !complaints.isEmpty()) {

                    for (Map<String, Object> complaint : complaints) {
            %>

                <tr>

                    <td>
                        <%= complaint.get("complaint_id") %>
                    </td>

                    <td>
                        <%= complaint.get("user_name") %>
                    </td>

                    <td>
                        <%= complaint.get("email") %>
                    </td>

                    <td>
                        <%= complaint.get("subject") %>
                    </td>

                    <td class="description">
                        <%= complaint.get("description") %>
                    </td>

                    <td>
                        <%= complaint.get("complaint_date") %>
                    </td>

                    <td>
                        <%= complaint.get("status") %>
                    </td>

                    <td>

                        <!-- UPDATE STATUS -->

                        <form action="../adminComplaint"
                              method="post"
                              class="status-form">

                            <input type="hidden"
                                   name="action"
                                   value="updateStatus">

                            <input type="hidden"
                                   name="complaintId"
                                   value="<%= complaint.get("complaint_id") %>">

                            <select name="status">

                                <option value="Pending"
                                    <%= "Pending".equals(complaint.get("status"))
                                        ? "selected" : "" %>>
                                    Pending
                                </option>

                                <option value="In Progress"
                                    <%= "In Progress".equals(complaint.get("status"))
                                        ? "selected" : "" %>>
                                    In Progress
                                </option>

                                <option value="Resolved"
                                    <%= "Resolved".equals(complaint.get("status"))
                                        ? "selected" : "" %>>
                                    Resolved
                                </option>

                                <option value="Rejected"
                                    <%= "Rejected".equals(complaint.get("status"))
                                        ? "selected" : "" %>>
                                    Rejected
                                </option>

                            </select>

                            <button type="submit"
                                    class="update-btn">
                                Update
                            </button>

                        </form>


                        <!-- DELETE -->

                        <form action="../adminComplaint"
                              method="post"
                              onsubmit="return confirm('Delete this complaint?');">

                            <input type="hidden"
                                   name="action"
                                   value="delete">

                            <input type="hidden"
                                   name="complaintId"
                                   value="<%= complaint.get("complaint_id") %>">

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

                        No complaints found.

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
