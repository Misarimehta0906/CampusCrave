```jsp
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Map<String, Object>> offers =
        (List<Map<String, Object>>) request.getAttribute("offers");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Offers - Smart Canteen</title>

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
            margin-right: 5px;
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

    <h2>? Smart Canteen - Admin</h2>

    <div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="../adminLogout">Logout</a>
    </div>

</div>


<div class="container">

    <div class="title">
        <h1>Offers Management</h1>
    </div>


    <!-- ADD OFFER -->

    <div class="add-box">

        <h2>Add New Offer</h2>

        <form action="../adminOffer" method="post">

            <input type="hidden"
                   name="action"
                   value="add">

            <div class="form-grid">

                <div>

                    <label>Offer Title</label>

                    <input type="text"
                           name="offerTitle"
                           placeholder="Enter offer title"
                           required>

                </div>


                <div>

                    <label>Discount (%)</label>

                    <input type="number"
                           name="discount"
                           min="0"
                           max="100"
                           step="0.01"
                           placeholder="Enter discount"
                           required>

                </div>


                <div class="full">

                    <label>Description</label>

                    <textarea name="description"
                              rows="3"
                              placeholder="Enter offer description"
                              required></textarea>

                </div>


                <div>

                    <label>Start Date</label>

                    <input type="date"
                           name="startDate"
                           required>

                </div>


                <div>

                    <label>End Date</label>

                    <input type="date"
                           name="endDate"
                           required>

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
                        + Add Offer
                    </button>

                </div>

            </div>

        </form>

    </div>


    <!-- OFFERS TABLE -->

    <div class="table-box">

        <h2>All Offers</h2>

        <table>

            <thead>

                <tr>

                    <th>ID</th>
                    <th>Offer Title</th>
                    <th>Description</th>
                    <th>Discount</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

            <%
                if (offers != null && !offers.isEmpty()) {

                    for (Map<String, Object> offer : offers) {
            %>

                <tr>

                    <td>
                        <%= offer.get("offer_id") %>
                    </td>

                    <td>
                        <%= offer.get("offer_title") %>
                    </td>

                    <td>
                        <%= offer.get("description") %>
                    </td>

                    <td>
                        <%= offer.get("discount") %>%
                    </td>

                    <td>
                        <%= offer.get("start_date") %>
                    </td>

                    <td>
                        <%= offer.get("end_date") %>
                    </td>

                    <td>
                        <%= offer.get("status") %>
                    </td>

                    <td>

                        <!-- STATUS -->

                        <form action="../adminOffer"
                              method="post"
                              style="display:inline;">

                            <input type="hidden"
                                   name="action"
                                   value="updateStatus">

                            <input type="hidden"
                                   name="offerId"
                                   value="<%= offer.get("offer_id") %>">

                            <input type="hidden"
                                   name="status"
                                   value="<%= "Active".equals(offer.get("status"))
                                           ? "Inactive"
                                           : "Active" %>">

                            <button type="submit"
                                    class="status-btn">

                                <%= "Active".equals(offer.get("status"))
                                    ? "Deactivate"
                                    : "Activate" %>

                            </button>

                        </form>


                        <!-- DELETE -->

                        <form action="../adminOffer"
                              method="post"
                              style="display:inline;"
                              onsubmit="return confirm('Delete this offer?');">

                            <input type="hidden"
                                   name="action"
                                   value="delete">

                            <input type="hidden"
                                   name="offerId"
                                   value="<%= offer.get("offer_id") %>">

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

                        No offers found.

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
