```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Thank You | CampusCrave</title>

<style>
* { box-sizing: border-box; font-family: Arial, sans-serif; }
body {
    margin: 0;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    background: #f8f4ee;
    color: #514235;
}
.card {
    width: 100%;
    max-width: 620px;
    padding: 45px 28px;
    text-align: center;
    background: #fffdf9;
    border: 1px solid #e6d6c3;
    border-radius: 22px;
    box-shadow: 0 12px 35px rgba(80, 60, 40, .09);
}
.heart { font-size: 55px; margin-bottom: 12px; }
h1 { font-size: 34px; margin: 12px 0; }
p {
    color: #8b7765;
    line-height: 1.8;
    font-size: 17px;
}
.buttons {
    display: flex;
    gap: 12px;
    justify-content: center;
    flex-wrap: wrap;
    margin-top: 28px;
}
a {
    display: inline-block;
    padding: 14px 22px;
    border-radius: 9px;
    text-decoration: none;
    font-weight: bold;
}
.primary { background: #514235; color: white; }
.secondary {
    background: #e6d2bc;
    color: #514235;
}
</style>
</head>
<body>

<div class="card">
    <div class="heart">💛</div>

    <h1>Thank You!</h1>

    <p>
        Thank you for sharing your valuable feedback with us.
        Your opinion means a lot to the CampusCrave team.
    </p>

    <p>
        We look forward to serving you again.
        <br>
        <strong>Thank you for visiting our canteen! 🍽️</strong>
    </p>

    <div class="buttons">
        <a class="primary" href="<%= ctx %>/menu">Explore Menu</a>
        <a class="secondary" href="<%= ctx %>/index.jsp">Back to Home</a>
    </div>
</div>

</body>
</html>
