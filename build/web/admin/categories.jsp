```jsp
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    HttpSession adminSession = request.getSession(false);

    if (adminSession == null
            || adminSession.getAttribute("adminId") == null) {
        response.sendRedirect(
                request.getContextPath() + "/admin/adminLogin.jsp");
        return;
    }

    List<Map<String, Object>> categories =
            (List<Map<String, Object>>) request.getAttribute("categories");

    if (categories == null) {
        categories = new java.util.ArrayList<>();
    }

    String ctx = request.getContextPath();
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Manage Categories | CampusCrave</title>

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
    padding: 25px 3%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
}
header h1 {
    margin: 0 0 10px;
    font-size: 32px;
}
.subtitle {
    color: #8b7765;
    margin: 0;
}
.header-buttons {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}
.header-buttons a {
    padding: 14px 20px;
    border-radius: 10px;
    background: #dcc0a4;
    color: #49382c;
    text-decoration: none;
    font-weight: bold;
}
.container {
    padding: 20px 2.5%;
}
.panel {
    background: #fffdf9;
    border: 1px solid #e6d6c3;
    border-radius: 17px;
    padding: 28px;
    margin-bottom: 25px;
}
h2 {
    margin-top: 0;
    margin-bottom: 20px;
}
.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px;
}
.full {
    grid-column: 1 / -1;
}
label {
    display: block;
    font-weight: bold;
    margin-bottom: 8px;
}
input, select, textarea {
    width: 100%;
    padding: 13px;
    border: 1px solid #ddcbb8;
    border-radius: 8px;
    background: white;
    font-size: 15px;
}
textarea {
    min-height: 85px;
    resize: vertical;
}
input:focus, select:focus, textarea:focus {
    outline: 2px solid #dcc0a4;
}
button {
    border: none;
    padding: 13px 20px;
    border-radius: 8px;
    font-weight: bold;
    cursor: pointer;
}
.add-btn {
    background: #594536;
    color: white;
}
.delete-btn {
    background: #a94438;
    color: white;
}
.message {
    background: #f0e5d7;
    border: 1px solid #e2ceb8;
    border-radius: 8px;
    padding: 13px;
    margin-bottom: 18px;
}
.table-wrap {
    overflow-x: auto;
}
table {
    width: 100%;
    min-width: 650px;
    border-collapse: collapse;
}
th, td {
    padding: 15px;
    text-align: left;
    border-bottom: 1px solid #e6d6c3;
}
th {
    color: #514235;
}
footer {
    margin: 25px 2.5%;
    padding-top: 25px;
    border-top: 1px solid #e6d6c3;
    color: #8b7765;
}
@media(max-width: 650px) {
    header {
        align-items: flex-start;
        flex-direction: column;
        padding: 20px;
    }
    .container {
        padding: 15px;
    }
    .panel {
        padding: 18px;
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

<header>
    <div>
        <h1>Categories</h1>
        <p class="subtitle">CampusCrave administration</p>
    </div>

    <div class="header-buttons">
        <a href="<%= ctx %>/admin/dashboard">Dashboard</a>
        <a href="<%= ctx %>/admin/logout">Logout</a>
    </div>
</header>

<main class="container">

    <% if ("added".equals(success)) { %>
        <div class="message">
            Category added successfully! It is saved in the database.
        </div>
    <% } else if ("deleted".equals(success)) { %>
        <div class="message">Category deleted successfully.</div>
    <% } else if ("required".equals(error)) { %>
        <div class="message">Please enter a category name.</div>
    <% } else if ("duplicate".equals(error)) { %>
        <div class="message">This category already exists.</div>
    <% } else if ("notfound".equals(error)) { %>
        <div class="message">Category was not found.</div>
    <% } else if ("invalid".equals(error)) { %>
        <div class="message">Invalid category ID.</div>
    <% } %>

    <!-- ADD CATEGORY FORM -->
    <section class="panel">
        <h2>Add New Category</h2>

        <form action="<%= ctx %>/adminCategory" method="post">
            <input type="hidden" name="action" value="add">

            <div class="form-grid">

                <div>
                    <label for="categoryName">Category Name</label>
                    <input type="text"
                           id="categoryName"
                           name="categoryName"
                           maxlength="100"
                           placeholder="e.g. Breakfast"
                           required>
                </div>

                <div>
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                </div>

                <div class="full">
                    <label for="description">Description</label>
                    <textarea id="description"
                              name="description"
                              maxlength="255"
                              placeholder="Enter category description"></textarea>
                </div>

                <div class="full">
                    <button class="add-btn" type="submit">
                        + Add Category
                    </button>
                </div>

            </div>
        </form>
    </section>

    <!-- CATEGORY RECORDS -->
    <section class="panel">
        <h2>Categories Records</h2>
        <p>Total records: <%= categories.size() %></p>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>category_id</th>
                        <th>category_name</th>
                        <th>description</th>
                        <th>status</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                <% if (categories.isEmpty()) { %>
                    <tr>
                        <td colspan="5">No records found.</td>
                    </tr>
                <% } else {
                    for (Map<String, Object> category : categories) { %>
                    <tr>
                        <td><%= category.get("category_id") %></td>
                        <td><%= category.get("category_name") %></td>
                        <td><%= category.get("description") == null
                                ? "" : category.get("description") %></td>
                        <td><%= category.get("status") %></td>
                        <td>
                            <form action="<%= ctx %>/adminCategory"
                                  method="post"
                                  onsubmit="return confirm('Delete this category?');">
                                <input type="hidden"
                                       name="action"
                                       value="delete">
                                <input type="hidden"
                                       name="categoryId"
                                       value="<%= category.get("category_id") %>">
                                <button type="submit" class="delete-btn">
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

<footer>© 2026 CampusCrave | Admin Panel</footer>

</body>
</html>
