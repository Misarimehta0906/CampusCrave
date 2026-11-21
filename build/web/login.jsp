
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CampusCrave | Student Login</title>
    <link rel="stylesheet" href="style.css">

    <style>
        .auth-page {
            min-height: 75vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 16px;
        }
        .auth-card {
            width: 100%;
            max-width: 440px;
            padding: 35px;
            background: #FFFCF6;
            border: 1px solid #E4D2B8;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(107,79,58,.09);
        }
        .auth-card h1 {
            text-align: center;
            color: #49382B;
            font-family: Georgia, serif;
            margin: 10px 0;
        }
        .auth-subtitle {
            text-align: center;
            color: #887866;
            margin-bottom: 25px;
        }
        .auth-icon {
            text-align: center;
            font-size: 42px;
        }
        .auth-card label {
            display: block;
            margin: 17px 0 7px;
            color: #49382B;
            font-weight: 600;
        }
        .auth-card input {
            width: 100%;
            box-sizing: border-box;
            padding: 13px;
            border: 1px solid #DDCBB4;
            border-radius: 10px;
            background: #FFFDF8;
            color: #49382B;
        }
        .auth-card input:focus {
            outline: 2px solid #E9DDCC;
            border-color: #A17A52;
        }
        .auth-submit {
            width: 100%;
            margin-top: 24px;
            padding: 13px;
            background: #795638;
            color: white;
            border: 1px solid #795638;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
        }
        .auth-submit:hover {
            background: #60452F;
        }
        .auth-bottom {
            text-align: center;
            margin-top: 22px;
            color: #887866;
        }
        .auth-bottom a {
            color: #795638;
            font-weight: 600;
        }
        .auth-error {
            padding: 11px;
            margin: 15px 0;
            background: #F8E5DF;
            border: 1px solid #E8C5B8;
            border-radius: 9px;
            color: #8B4235;
            text-align: center;
        }
        .auth-success {
            padding: 11px;
            margin: 15px 0;
            background: #E9F1E3;
            border: 1px solid #C9D9BD;
            border-radius: 9px;
            color: #43613A;
            text-align: center;
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<main class="auth-page">
    <section class="auth-card">
        <div class="auth-icon">🍑</div>
        <h1>Welcome Back!</h1>
        <p class="auth-subtitle">Login to your CampusCrave account.</p>

        <% if ("1".equals(request.getParameter("error"))) { %>
            <div class="auth-error">Invalid username or password.</div>
        <% } %>

        <% if ("1".equals(request.getParameter("registered"))) { %>
            <div class="auth-success">Registration successful! Please login.</div>
        <% } %>

        <% if ("1".equals(request.getParameter("logout"))) { %>
            <div class="auth-success">You have logged out successfully.</div>
        <% } %>

        <form action="userLogin" method="post">
            <label for="username">Username</label>
            <input type="text" id="username" name="username"
                   placeholder="Enter your username"
                   maxlength="100" autocomplete="username" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   placeholder="Enter your password"
                   autocomplete="current-password" required>

            <button type="submit" class="auth-submit">Student Login →</button>
        </form>

        <div class="auth-bottom">
            Don't have an account?
            <a href="register.jsp">Register here</a>
        </div>
    </section>
</main>

<footer class="footer">
    <div class="footer-bottom">© 2026 CampusCrave. Made for campus life.</div>
</footer>

</body>
</html>
