<%@ page import="java.util.*" %>

<%
    List<Map<String,Object>> offers =
        (List<Map<String,Object>>) request.getAttribute("offers");

    if(offers == null) {
        offers =
            new ArrayList<Map<String,Object>>();
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Offers - Smart Canteen</title>

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

        .card {
            background: #fff;
            padding: 25px;
            margin: 15px 0;
            border-radius: 10px;
            box-shadow: 0 2px 12px #ddd;
        }

        .discount {
            font-size: 25px;
            color: #ff6335;
            font-weight: bold;
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
        Current Offers
    </h1>


    <% for(Map<String,Object> o : offers) { %>

        <div class="card">

            <h2>
                <%= o.get("offer_title") %>
            </h2>

            <div class="discount">
                <%= o.get("discount") %>% OFF
            </div>

            <p>
                <%= o.get("description") %>
            </p>

            <p>
                Valid from
                <%= o.get("start_date") %>
                to
                <%= o.get("end_date") %>
            </p>

        </div>

    <% } %>


    <% if(offers.isEmpty()) { %>

        <p>
            No active offers available.
        </p>

    <% } %>

</div>

</body>
</html>
