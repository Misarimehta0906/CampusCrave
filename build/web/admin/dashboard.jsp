```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(
                request.getContextPath() + "/admin/adminLogin.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("adminName");

    if (adminName == null) {
        adminName = "Administrator";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Admin Dashboard | CampusCrave</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/admin/admin-style.css">
</head>
<body>

<div class="admin-layout">

    <aside class="sidebar">

        <div class="sidebar-brand">CampusCrave</div>
        <p class="sidebar-label">ADMINISTRATION</p>

        <a class="side-link active"
           href="<%= request.getContextPath() %>/admin/dashboard">
            Dashboard
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/food">
            Food Menu
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/categories">
            Categories
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/orders">
            Orders
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/users">
            Students
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/feedback">
            Feedback
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/coupons">
            Coupons
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/payments">
            Payments
        </a>

        <a class="side-link"
           href="<%= request.getContextPath() %>/admin/specials">
            Today's Specials
        </a>

        <a class="side-link logout-link"
           href="<%= request.getContextPath() %>/admin/logout">
            Logout
        </a>

    </aside>

    <main class="main-content">

        <header class="topbar">
            <div>
                <h1>Admin Dashboard</h1>
                <p class="muted">
                    Manage your campus canteen in one place.
                </p>
            </div>

            <div class="admin-welcome">
                Welcome, <strong><%= adminName %></strong>
            </div>
        </header>

        <section class="welcome-panel">
            <h2>Welcome to CampusCrave!</h2>
            <p>
                Monitor food, students, orders and canteen activities.
            </p>
        </section>

        <section class="stats-grid">

            <div class="stat-card">
                <span class="stat-icon">🍽️</span>
                <p>Total Food Items</p>
                <h2>${foodCount}</h2>
            </div>

            <div class="stat-card">
                <span class="stat-icon">🎓</span>
                <p>Registered Students</p>
                <h2>${userCount}</h2>
            </div>

            <div class="stat-card">
                <span class="stat-icon">🧾</span>
                <p>Total Orders</p>
                <h2>${orderCount}</h2>
            </div>

            <div class="stat-card">
                <span class="stat-icon">⏳</span>
                <p>Pending Orders</p>
                <h2>${pendingCount}</h2>
            </div>

            <div class="stat-card">
                <span class="stat-icon">📂</span>
                <p>Categories</p>
                <h2>${categoryCount}</h2>
            </div>

            <div class="stat-card">
                <span class="stat-icon">⭐</span>
                <p>Feedback Entries</p>
                <h2>${feedbackCount}</h2>
            </div>

            <div class="stat-card">
                <span class="stat-icon">🎟️</span>
                <p>Coupons</p>
                <h2>${couponCount}</h2>
            </div>

        </section>

        <section class="quick-panel">
            <h2>Quick Actions</h2>

            <div class="quick-actions">

                <a class="btn-primary"
                   href="<%= request.getContextPath() %>/admin/food">
                    Manage Food
                </a>

                <a class="btn-secondary"
                   href="<%= request.getContextPath() %>/admin/orders">
                    View Orders
                </a>

                <a class="btn-secondary"
                   href="<%= request.getContextPath() %>/admin/categories">
                    Manage Categories
                </a>

            </div>
        </section>

        <footer class="admin-footer">
            © 2026 CampusCrave | Admin Panel
        </footer>

    </main>

</div>

</body>
</html>
