
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CampusCrave | Student Registration</title>
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
            max-width: 460px;
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
            margin-bottom: 22px;
        }

        .auth-icon {
            text-align: center;
            font-size: 42px;
        }

        .auth-card label {
            display: block;
            margin: 15px 0 7px;
            color: #49382B;
            font-weight: 600;
        }

        .auth-card input {
            width: 100%;
            box-sizing: border-box;
            padding: 12px;
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

        .phone-group {
            display: flex;
            gap: 8px;
        }

        .phone-code {
            width: 65px !important;
            text-align: center;
            font-weight: 600;
            background: #F5EDE2 !important;
        }

        .phone-number {
            flex: 1;
            min-width: 0;
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<main class="auth-page">
    <section class="auth-card">

        <div class="auth-icon">🍑</div>

        <h1>Create Account</h1>

        <p class="auth-subtitle">
            Join the CampusCrave community!
        </p>

        <%
        String error = request.getParameter("error");

        if ("exists".equals(error)) {
        %>
            <div class="auth-error">
                Username already exists! Please choose another.
            </div>
        <%
        } else if ("empty".equals(error)) {
        %>
            <div class="auth-error">
                Please fill in all fields!
            </div>
        <%
        } else if ("name".equals(error)) {
        %>
            <div class="auth-error">
                Please enter a valid full name.
            </div>
        <%
        } else if ("username".equals(error)) {
        %>
            <div class="auth-error">
                Please enter a valid username.
            </div>
        <%
        } else if ("phone".equals(error)) {
        %>
            <div class="auth-error">
                Phone number must be exactly 10 digits after +91!
            </div>
        <%
        } else if ("password".equals(error)) {
        %>
            <div class="auth-error">
                Password must be at least 6 characters long.
            </div>
        <%
        } else if ("mismatch".equals(error)) {
        %>
            <div class="auth-error">
                Password and Confirm Password do not match!
            </div>
        <%
        } else if ("1".equals(error)) {
        %>
            <div class="auth-error">
                Registration failed. Please try again.
            </div>
        <%
        }
        %>

        <form action="userRegister" method="post">

            <label for="name">Full Name</label>
            <input type="text" id="name" name="name"
                   placeholder="Enter your full name"
                   maxlength="100"
                   autocomplete="name" required>

            <label for="username">Username</label>
            <input type="text" id="username" name="username"
                   placeholder="Create a username"
                   maxlength="100"
                   autocomplete="username" required>

            <label for="phone">Phone Number</label>

            <div class="phone-group">

                <input type="text" value="+91"
                       class="phone-code" readonly>

                <input type="tel" id="phone" name="phone"
                       class="phone-number"
                       placeholder="Enter 10 digit number"
                       maxlength="10"
                       minlength="10"
                       pattern="[0-9]{10}"
                       inputmode="numeric"
                       autocomplete="tel-national"
                       oninput="this.value=this.value.replace(/[^0-9]/g,'').slice(0,10)"
                       required>

            </div>

            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   placeholder="Create a password"
                   minlength="6"
                   maxlength="100"
                   autocomplete="new-password" required>

            <label for="confirmPassword">Confirm Password</label>
            <input type="password" id="confirmPassword"
                   name="confirmPassword"
                   placeholder="Re-enter your password"
                   minlength="6"
                   maxlength="100"
                   autocomplete="new-password" required>

            <button type="submit" class="auth-submit">
                Create Account →
            </button>

        </form>

        <div class="auth-bottom">
            Already have an account?
            <a href="login.jsp">Login here</a>
        </div>

    </section>
</main>

<footer class="footer">
    <div class="footer-bottom">
        © 2026 CampusCrave. Made for campus life.
    </div>
</footer>

<script>
document.querySelector("form").addEventListener("submit", function(e) {

    let name = document.getElementById("name").value.trim();
    let username = document.getElementById("username").value.trim();
    let phone = document.getElementById("phone").value.trim();
    let password = document.getElementById("password").value;
    let confirmPassword = document.getElementById("confirmPassword").value;

    let namePattern = /^[\p{L} .'-]+$/u;
    let usernamePattern = /^[A-Za-z0-9._-]+$/;
    let phonePattern = /^[0-9]{10}$/;

    // Empty field validation
    if (name === "" || username === "" || phone === "" ||
        password === "" || confirmPassword === "") {

        alert("Please fill in all fields!");
        e.preventDefault();
        return;
    }

    // Name validation
    if (!namePattern.test(name)) {
        alert("Please enter a valid full name!");
        e.preventDefault();
        return;
    }

    // Username validation
    if (!usernamePattern.test(username)) {
        alert("Username can contain only letters, numbers, dot, underscore and hyphen!");
        e.preventDefault();
        return;
    }

    // Phone number validation
    if (!phonePattern.test(phone)) {
        alert("Phone number must be exactly 10 digits after +91!");
        e.preventDefault();
        return;
    }

    // Password validation
    if (password.trim() === "" || password.length < 6) {
        alert("Password must contain at least 6 characters!");
        e.preventDefault();
        return;
    }

    // Confirm password validation
    if (password !== confirmPassword) {
        alert("Password and Confirm Password do not match!");
        e.preventDefault();
        return;
    }

});
</script>

</body>
</html>
