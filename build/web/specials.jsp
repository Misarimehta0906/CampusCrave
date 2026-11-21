<%@ page import="java.util.*" %>

<%
    List<Map<String,Object>> specials =
        (List<Map<String,Object>>) request.getAttribute("specials");

    if(specials == null) {
        specials =
            new ArrayList<Map<String,Object>>();
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Today's Specials - Smart Canteen</title>

    <style>

        body {
            margin: 0;
            background: #fff8f2;
            font-family: Arial;
        }

        .wrap {
            padding: 35px 6%;
        }

        nav {
            background: #fff;
            padding: 18px 6%;
            box-shadow: 0 2px 8px #ddd;
        }

        nav a {
            margin-right: 20px;
            text-decoration: none;
            color: #444;
        }

        .logo {
            font-size: 24px;
            color: #ff6335;
            font-weight: bold;
            margin-right: 30px;
        }

        .grid {
            display: grid;
            grid-template-columns:
                repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
        }

        .card {
            background: #fff;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 2px 12px #ddd;
        }

        .price {
            color: #ff6335;
            font-weight: bold;
            font-size: 20px;
        }

        .card a {
            display: inline-block;
            margin-top: 12px;
            padding: 9px 13px;
            background: #ff6335;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
        }

    </style>

</head>

<body>

<nav>

    <span class="logo">
        Smart Canteen
    </span>

    <a href="home.jsp">Home</a>

    <a href="menu">Menu</a>

    <a href="cart.jsp">Cart</a>

</nav>


<div class="wrap">

    <h1>
        Today's Specials
    </h1>

    <div class="grid">

        <% for(Map<String,Object> s : specials) { %>

            <div class="card">

                <h2>
                    <%= s.get("name") %>
                </h2>

                <p>
                    <%= s.get("description") %>
                </p>

                <div class="price">
                    Rs. <%= s.get("price") %>
                </div>

                <a href="cart?action=add&foodId=<%= s.get("food_id") %>">
                    Add to Cart
                </a>

            </div>

        <% } %>


        <% if(specials.isEmpty()) { %>

            <p>
                No specials available today.
            </p>

        <% } %>

    </div>

</div>

</body>
</html>