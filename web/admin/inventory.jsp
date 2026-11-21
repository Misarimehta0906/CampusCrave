<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Map<String, Object>> inventory =
        (List<Map<String, Object>>) request.getAttribute("inventory");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Inventory - Smart Canteen</title>

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

        .add-box,
        .table-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .add-box h2,
        .table-box h2 {
            color: #ff6335;
            margin-bottom: 20px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .full {
            grid-column: 1 / -1;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input,
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 7px;
            font-size: 15px;
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

        .edit-btn {
            background: #0d6efd;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 5px;
        }

        .delete-btn {
            background: #dc3545;
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
        <h1>Inventory Management</h1>
    </div>


    <!-- ADD INVENTORY -->

    <div class="add-box">

        <h2>Add Inventory Item</h2>

        <form action="../adminInventory" method="post">

            <input type="hidden"
                   name="action"
                   value="add">

            <div class="form-grid">


                <div>

                    <label>Item Name</label>

                    <input type="text"
                           name="itemName"
                           placeholder="Enter item name"
                           required>

                </div>


                <div>

                    <label>Quantity</label>

                    <input type="number"
                           name="quantity"
                           step="0.01"
                           min="0"
                           placeholder="Enter quantity"
                           required>

                </div>


                <div>

                    <label>Unit</label>

                    <input type="text"
                           name="unit"
                           placeholder="Example: kg, litre, packet"
                           required>

                </div>


                <div>

                    <label>Price</label>

                    <input type="number"
                           name="price"
                           step="0.01"
                           min="0"
                           placeholder="Enter price"
                           required>

                </div>


                <div>

                    <button type="submit"
                            class="btn">
                        + Add Inventory
                    </button>

                </div>

            </div>

        </form>

    </div>


    <!-- INVENTORY TABLE -->

    <div class="table-box">

        <h2>Inventory Items</h2>

        <table>

            <thead>

                <tr>

                    <th>ID</th>
                    <th>Item Name</th>
                    <th>Quantity</th>
                    <th>Unit</th>
                    <th>Price</th>
                    <th>Last Updated</th>
                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

            <%
                if (inventory != null && !inventory.isEmpty()) {

                    for (Map<String, Object> item : inventory) {
            %>

                <tr>

                    <td>
                        <%= item.get("inventory_id") %>
                    </td>

                    <td>
                        <%= item.get("item_name") %>
                    </td>

                    <td>
                        <%= item.get("quantity") %>
                    </td>

                    <td>
                        <%= item.get("unit") %>
                    </td>

                    <td>
                        Rs. <%= item.get("price") %>
                    </td>

                    <td>
                        <%= item.get("last_updated") %>
                    </td>

                    <td>

                        <!-- UPDATE FORM -->

                        <form action="../adminInventory"
                              method="post"
                              style="margin-bottom:8px;">

                            <input type="hidden"
                                   name="action"
                                   value="update">

                            <input type="hidden"
                                   name="inventoryId"
                                   value="<%= item.get("inventory_id") %>">

                            <input type="text"
                                   name="itemName"
                                   value="<%= item.get("item_name") %>"
                                   required
                                   style="width:130px;">

                            <input type="number"
                                   name="quantity"
                                   value="<%= item.get("quantity") %>"
                                   step="0.01"
                                   min="0"
                                   required
                                   style="width:90px;">

                            <input type="text"
                                   name="unit"
                                   value="<%= item.get("unit") %>"
                                   required
                                   style="width:80px;">

                            <input type="number"
                                   name="price"
                                   value="<%= item.get("price") %>"
                                   step="0.01"
                                   min="0"
                                   required
                                   style="width:90px;">

                            <button type="submit"
                                    class="edit-btn">
                                Update
                            </button>

                        </form>


                        <!-- DELETE FORM -->

                        <form action="../adminInventory"
                              method="post"
                              onsubmit="return confirm('Delete this inventory item?');">

                            <input type="hidden"
                                   name="action"
                                   value="delete">

                            <input type="hidden"
                                   name="inventoryId"
                                   value="<%= item.get("inventory_id") %>">

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

                        No inventory items found.

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
