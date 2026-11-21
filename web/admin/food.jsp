```jsp
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    HttpSession adminSession = request.getSession(false);

    if (adminSession == null
            || adminSession.getAttribute("adminId") == null) {
        response.sendRedirect(
                request.getContextPath() + "/admin/adminLogin.jsp");
        return;
    }

    List<Map<String, Object>> categoryList =
            (List<Map<String, Object>>) request.getAttribute("categoryList");

    List<Map<String, Object>> foodList =
            (List<Map<String, Object>>) request.getAttribute("foodList");

    if (categoryList == null) categoryList = new ArrayList<>();
    if (foodList == null) foodList = new ArrayList<>();

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Manage Food | CampusCrave</title>

<style>
* {
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {
    margin: 0;
    background: #f8f4ee;
    color: #514235;
}

header {
    background: #514235;
    color: white;
    padding: 22px 5%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
}

header h2 {
    margin: 0;
}

header a {
    background: #e0c4a8;
    color: #49382c;
    text-decoration: none;
    padding: 12px 18px;
    border-radius: 8px;
    font-weight: bold;
}

.container {
    max-width: 1200px;
    margin: auto;
    padding: 30px 20px;
}

.panel {
    background: #fffdf9;
    border: 1px solid #e6d6c3;
    border-radius: 14px;
    padding: 25px;
    margin-bottom: 25px;
}

h1, h2 {
    margin-top: 0;
}

.grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px;
}

label {
    display: block;
    font-weight: bold;
    margin-bottom: 7px;
}

input, select, textarea {
    width: 100%;
    padding: 12px;
    border: 1px solid #d8cabb;
    border-radius: 7px;
    background: white;
    font-size: 15px;
}

textarea {
    min-height: 85px;
    resize: vertical;
}

.full {
    grid-column: 1 / -1;
}

button {
    border: 0;
    border-radius: 7px;
    padding: 12px 18px;
    cursor: pointer;
    font-weight: bold;
}

.add {
    background: #514235;
    color: white;
}

.add:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.delete {
    background: #a94438;
    color: white;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 650px;
}

th, td {
    padding: 13px;
    text-align: left;
    border-bottom: 1px solid #eadfd1;
}

th {
    background: #f0e5d7;
}

.table-wrap {
    overflow-x: auto;
}

.message {
    padding: 12px;
    border-radius: 7px;
    background: #f0e5d7;
    margin-bottom: 18px;
}

@media (max-width: 650px) {
    .grid {
        grid-template-columns: 1fr;
    }

    .full {
        grid-column: auto;
    }

    header {
        padding: 18px;
    }

    .container {
        padding: 18px 12px;
    }
}
</style>
</head>

<body>

<header>
    <h2>CampusCrave | Manage Food</h2>
    <a href="<%= ctx %>/admin/dashboard">Dashboard</a>
</header>

<main class="container">

    <%
        String error = request.getParameter("error");
        String success = request.getParameter("success");

        if ("added".equals(success)) {
    %>
        <div class="message">
            Food added successfully!
        </div>
    <%
        } else if ("deleted".equals(success)) {
    %>
        <div class="message">
            Food deleted successfully.
        </div>
    <%
        } else if ("required".equals(error)) {
    %>
        <div class="message">
            Please fill in the food name, category and price.
        </div>
    <%
        } else if ("price".equals(error)) {
    %>
        <div class="message">
            Please enter a valid price.
        </div>
    <%
        } else if ("category".equals(error)) {
    %>
        <div class="message">
            Please select an active category.
        </div>
    <%
        } else if ("id".equals(error)) {
    %>
        <div class="message">
            Invalid food ID.
        </div>
    <%
        }
    %>

    <section class="panel">
        <h1>Add New Food</h1>

        <% if (categoryList.isEmpty()) { %>
            <div class="message">
                No active categories found. Add categories first.
            </div>
        <% } %>

        <form action="<%= ctx %>/admin/food" method="post">
            <input type="hidden" name="action" value="add">

            <div class="grid">

                <div>
                    <label for="name">Food Name</label>
                    <input id="name" name="name" type="text"
                           maxlength="100"
                           placeholder="e.g. Veg Sandwich" required>
                </div>

                <div>
                    <label for="category">Category</label>
                    <select id="category" name="category" required>
                        <option value="">Select Category</option>

                        <% for (Map<String, Object> cat : categoryList) { %>
                            <option value="<%= cat.get("category_name") %>">
                                <%= cat.get("category_name") %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div>
                    <label for="price">Price (₹)</label>
                    <input id="price" name="price" type="number"
                           min="0" step="0.01"
                           placeholder="e.g. 50" required>
                </div>

                <div>
                    <label for="special">Today's Special?</label>
                    <select id="special" name="special">
                        <option value="0">No</option>
                        <option value="1">Yes</option>
                    </select>
                </div>

                <div class="full">
                    <label for="description">Description</label>
                    <textarea id="description" name="description"
                              maxlength="255"
                              placeholder="Describe the food item"></textarea>
                </div>

                <div class="full">
                    <button class="add" type="submit"
                            <%= categoryList.isEmpty() ? "disabled" : "" %>>
                        + Add Food
                    </button>
                </div>

            </div>
        </form>
    </section>

    <section class="panel">
        <h2>Food Records</h2>
        <p>Total food items: <%= foodList.size() %></p>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Food Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Description</th>
                        <th>Special</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                <% if (foodList.isEmpty()) { %>
                    <tr>
                        <td colspan="7">
                            No food items found. Add your first food item above.
                        </td>
                    </tr>
                <% } else {
                    for (Map<String, Object> food : foodList) { %>
                    <tr>
                        <td><%= food.get("id") %></td>
                        <td><%= food.get("name") %></td>
                        <td><%= food.get("category") %></td>
                        <td>₹<%= String.format("%.2f", food.get("price")) %></td>
                        <td><%= food.get("description") == null
                                ? "" : food.get("description") %></td>
                        <td><%= Boolean.TRUE.equals(food.get("special"))
                                ? "Yes" : "No" %></td>
                        <td>
                            <form action="<%= ctx %>/admin/food"
                                  method="post"
                                  onsubmit="return confirm('Delete this food item?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id"
                                       value="<%= food.get("id") %>">
                                <button class="delete" type="submit">
                                    Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                <%  }
                   } %>
                </tbody>
            </table>
        </div>
    </section>

</main>

</body>
</html>
