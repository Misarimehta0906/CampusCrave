```jsp
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Map<String, Object>> specials =
        (List<Map<String, Object>>) request.getAttribute("specials");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Today's Specials - Smart Canteen</title>

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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .title h1 {
            color: #ff6335;
        }

        .add-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .add-box h2 {
            margin-bottom: 20px;
            color: #ff6335;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 7px;
            font-size: 15px;
        }

        textarea {
            resize: vertical;
        }

        .full {
            grid-column: 1 / -1;
        }

        .btn {
            background: #ff6335;
            color: white;
            border: none;
            padding: 12px 22px;
            border-radius: 7px;
            cursor: pointer;
            font-weight: bold;
        }

        .btn:hover {
            background: #e65328;
        }

        .table-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            overflow-x: auto;
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
        }

        th {
            background: #ff6335;
            color: white;
        }

        tr:hover {
            background: #fff8f2;
        }

        .delete-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 5px;
            cursor: pointer;
        }

        .status-btn {
            background: #198754;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 5px;
            cursor: pointer;
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

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: auto;
            }

            .title {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }

    </style>

</head>

<body>

<div class="navbar">

    <h2>? Smart Canteen - Admin</h2>

    <div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="../adminLogout">Logout</a>
    </div>

</div>


<div class="container">

    <div class="title">
        <h1>Today's Specials</h1>
    </div>


    <!-- ADD SPECIAL -->

    <div class="add-box">

        <h2>Add Today's Special</h2>

        <form action="../adminSpecial" method="post">

            <input type="hidden"
                   name="action"
                   value="add">

            <div class="form-grid">

                <div>
                    <label>Food ID</label>
                    <input type="number"
                           name="foodId"
                           placeholder="Enter Food ID"
                           required>
                </div>


                <div>
                    <label>Special Date</label>
                    <input type="date"
                           name="specialDate"
                           required>
                </div>


                <div class="full">

                    <label>Description</label>

                    <textarea name="description"
                              rows="3"
                              placeholder="Enter special description"></textarea>

                </div>


                <div>

                    <label>Status</label>

                    <select name="status">

                        <option value="Active">
                            Active
                        </option>

                        <option value="Inactive">
                            Inactive
                        </option>

                    </select>

                </div>


                <div style="display:flex; align-items:end;">

                    <button type="submit"
                            class="btn">
                        + Add Special
                    </button>

                </div>

            </div>

        </form>

    </div>


    <!-- SPECIALS TABLE -->

    <div class="table-box">

        <h2 style="margin-bottom:20px;">
            Special Food Items
        </h2>


        <table>

            <thead>

                <tr>

                    <th>ID</th>
                    <th>Food</th>
                    <th>Price</th>
                    <th>Date</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

            <%
                if (specials != null && !specials.isEmpty()) {

                    for (Map<String, Object> special : specials) {
            %>

                <tr>

                    <td>
                        <%= special.get("special_id") %>
                    </td>

                    <td>
                        <%= special.get("name") %>
                    </td>

                    <td>
                        ?<%= special.get("price") %>
                    </td>

                    <td>
                        <%= special.get("special_date") %>
                    </td>

                    <td>
                        <%= special.get("description") %>
                    </td>

                    <td>
                        <%= special.get("status") %>
                    </td>

                    <td>

                        <form action="../adminSpecial"
                              method="post"
                              style="display:inline;">

                            <input type="hidden"
                                   name="action"
                                   value="updateStatus">

                            <input type="hidden"
                                   name="specialId"
                                   value="<%= special.get("special_id") %>">

                            <input type="hidden"
                                   name="status"
                                   value="<%= "Active".equals(special.get("status"))
                                           ? "Inactive"
                                           : "Active" %>">

                            <button type="submit"
                                    class="status-btn">
                                <%= "Active".equals(special.get("status"))
                                    ? "Deactivate"
                                    : "Activate" %>
                            </button>

                        </form>


                        <form action="../adminSpecial"
                              method="post"
                              style="display:inline;"
                              onsubmit="return confirm('Delete this special item?');">

                            <input type="hidden"
                                   name="action"
                                   value="delete">

                            <input type="hidden"
                                   name="specialId"
                                   value="<%= special.get("special_id") %>">

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

                    <td colspan="7"
                        class="empty">
                        No special food items found.
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
```

