
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Help & Complaints | CampusCrave</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<nav class="navbar">
    <a class="brand" href="index.jsp">🌸 CampusCrave</a>
    <div class="nav-links"><a href="index.jsp">Home</a><a href="menu">Menu</a></div>
</nav>

<div class="form-card">
    <span class="eyebrow">WE'RE HERE TO HELP</span>
    <h1>Tell Us What's Wrong</h1>
    <p class="muted">Your feedback helps us improve the canteen experience.</p>

    <form action="complaint" method="post">
        <label for="name">Your Name</label>
        <input id="name" name="name" required placeholder="Enter your name">

        <label for="subject">Complaint Subject</label>
        <input id="subject" name="subject" required placeholder="What is the issue?">

        <label for="message">Details</label>
        <textarea id="message" name="message" rows="5" required
                  placeholder="Describe the issue..."></textarea>

        <button type="submit">Submit Complaint →</button>
    </form>
    <p class="muted">For urgent concerns, please speak to the canteen staff directly.</p>
</div>
</body>
</html>
