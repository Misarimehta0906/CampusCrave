
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Feedback | CampusCrave</title>

<style>
* { box-sizing: border-box; font-family: Arial, sans-serif; }
body {
    margin: 0;
    background: #f8f4ee;
    color: #514235;
}
header {
    padding: 22px 6%;
    background: #514235;
    color: white;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
header a { color: white; text-decoration: none; }
.container {
    max-width: 650px;
    margin: 45px auto;
    padding: 0 18px;
}
.card {
    background: #fffdf9;
    border: 1px solid #e6d6c3;
    border-radius: 18px;
    padding: 30px;
    box-shadow: 0 8px 25px rgba(80, 60, 40, .07);
}
h1 { margin-top: 0; }
p { color: #8b7765; line-height: 1.6; }
label {
    display: block;
    margin: 18px 0 8px;
    font-weight: bold;
}
input, select, textarea {
    width: 100%;
    padding: 13px;
    border: 1px solid #ddcbb8;
    border-radius: 8px;
    font-size: 15px;
    background: white;
}
textarea { min-height: 120px; resize: vertical; }
button {
    margin-top: 22px;
    width: 100%;
    padding: 14px;
    border: 0;
    border-radius: 8px;
    background: #514235;
    color: white;
    font-weight: bold;
    font-size: 16px;
    cursor: pointer;
}
button:hover { background: #705742; }
.error {
    padding: 12px;
    border-radius: 8px;
    background: #f8e4df;
    color: #9c3528;
}
</style>
</head>
<body>

<header>
    <strong>CampusCrave</strong>
    <a href="<%= ctx %>/index.jsp">Home</a>
</header>

<div class="container">
    <div class="card">
        <h1>Share Your Feedback 💬</h1>
        <p>
            Tell us about your canteen experience.
            Your feedback helps us serve you better!
        </p>

        <% if ("required".equals(error)) { %>
            <div class="error">Please fill in all the fields.</div>
        <% } else if ("rating".equals(error)) { %>
            <div class="error">Please select a valid rating.</div>
        <% } %>

        <form action="<%= ctx %>/feedback" method="post">

            <label for="name">Your Name</label>
            <input type="text" id="name" name="name"
                   maxlength="100" placeholder="Enter your name" required>

            <label for="rating">Rate Your Experience</label>
            <select id="rating" name="rating" required>
                <option value="">Select a rating</option>
                <option value="5">★★★★★ - Excellent</option>
                <option value="4">★★★★ - Very Good</option>
                <option value="3">★★★ - Good</option>
                <option value="2">★★ - Fair</option>
                <option value="1">★ - Poor</option>
            </select>

            <label for="comment">Your Feedback</label>
            <textarea id="comment" name="comment"
                      maxlength="500"
                      placeholder="Write your feedback here..."
                      required></textarea>

            <button type="submit">Submit Feedback</button>
        </form>
    </div>
</div>

</body>
</html>