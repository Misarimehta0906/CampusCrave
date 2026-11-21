<%@ page session="true" %>

<%
    String userName = (String) session.getAttribute("userName");
    boolean loggedIn = session.getAttribute("userId") != null;
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Home - Smart Canteen</title>

    <style>

        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            margin: 0;
            background: #fff8f2;
            color: #333;
        }

        nav {
            background: white;
            padding: 18px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .logo {
            font-size: 25px;
            font-weight: bold;
            color: #ff6335;
        }

        .links a {
            margin-left: 22px;
            text-decoration: none;
            color: #444;
            font-weight: bold;
        }

        .links a:hover {
            color: #ff6335;
        }

        .hero {
            min-height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 60px 20px;
        }

        .hero h1 {
            font-size: 52px;
            margin: 10px 0;
            color: #333;
        }

        .hero p {
            font-size: 19px;
            color: #666;
        }

        .tag {
            color: #ff6335;
            font-weight: bold;
            letter-spacing: 3px;
        }

        .btn {
            display: inline-block;
            margin: 15px 7px;
            padding: 13px 25px;
            background: #ff6335;
            color: white;
            text-decoration: none;
            border-radius: 7px;
            font-weight: bold;
        }

        .btn.alt {
            background: #333;
        }

        footer {
            text-align: center;
            padding: 25px;
            background: #333;
            color: white;
        }

    </style>

</head>

<body>

<nav>

    <div class="logo">
        Smart Canteen
    </div>

    <div class="links">

        <a href="index.jsp">Home</a>

        <a href="menu">Menu</a>

        <% if(loggedIn) { %>

            <a href="cart.jsp">Cart</a>

            <a href="orderHistory">Orders</a>

            <a href="profile">Profile</a>

            <a href="logout">Logout</a>

        <% } else { %>

            <a href="login.jsp">Login</a>

            <a href="register.jsp">Register</a>

        <% } %>

    </div>

</nav>


<section class="hero">

    <div>

        <div class="tag">
            FAST - FRESH - SIMPLE
        </div>

        <h1>
            Welcome
            <% if(userName != null) { %>
                , <%= userName %>
            <% } %>
        </h1>

        <p>
            Order your favourite food without waiting.
        </p>

        <a class="btn" href="menu">
            Explore Menu
        </a>

        <% if(!loggedIn) { %>

            <a class="btn alt" href="login.jsp">
                Login
            </a>

        <% } %>

    </div>

</section>


<footer>
    Copyright 2026 Smart Canteen
</footer>

</body>
</html>
