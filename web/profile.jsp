
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLEncoder" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String studentName = (String) request.getAttribute("studentName");
    String studentUsername = (String) request.getAttribute("studentUsername");
    String studentPhone = (String) request.getAttribute("studentPhone");
    String studentPhoto = (String) request.getAttribute("studentPhoto");
    String studentRole = (String) request.getAttribute("studentRole");

    String contextPath = request.getContextPath();
    String photoUrl = "";

    if (studentPhoto != null && !studentPhoto.trim().isEmpty()
            && studentPhoto.matches("student_[0-9]+_[a-fA-F0-9-]+\\.(jpg|png)")) {
        photoUrl = contextPath + "/uploads/"
                + URLEncoder.encode(studentPhoto, "UTF-8");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile | CampusCrave</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    background: #F8F4EC;
    color: #49382B;
}

.profile-page {
    width: 92%;
    max-width: 950px;
    margin: 35px auto;
}

.page-heading {
    text-align: center;
    margin-bottom: 25px;
}

.page-heading h1 {
    font-size: 30px;
    margin-bottom: 8px;
}

.page-heading p {
    color: #887866;
}

.profile-card {
    max-width: 760px;
    margin: auto;
    background: #FFFDF8;
    border: 1px solid #E4D8C5;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 6px 20px rgba(107, 79, 58, 0.08);
}

/* Small profile header */
.profile-header {
    padding: 30px 20px;
    text-align: center;
    background: #E9DDCC;
}

.profile-photo,
.profile-placeholder {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 115px;
    height: 115px;
    margin: 0 auto 14px;
    border-radius: 50%;
    border: 4px solid #FFFDF8;
    object-fit: cover;
    background: #B89A78;
    color: white;
    font-size: 42px;
}

.profile-header h2 {
    margin: 10px 0;
    font-size: 23px;
}

.role-label {
    display: inline-block;
    background: #FFFDF8;
    padding: 7px 15px;
    border-radius: 20px;
    font-size: 13px;
}

.upload-form {
    margin-top: 18px;
}

.upload-form input {
    display: block;
    max-width: 280px;
    width: 100%;
    margin: 0 auto 12px;
    font-size: 13px;
}

.content {
    padding: 28px;
}

.content h3 {
    margin-top: 0;
    margin-bottom: 22px;
    font-size: 20px;
}

.details-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px;
}

.form-field label {
    display: block;
    margin-bottom: 7px;
    font-size: 13px;
    color: #887866;
}

.form-field input {
    width: 100%;
    padding: 12px;
    border: 1px solid #E4D8C5;
    border-radius: 8px;
    background: #FFFDF8;
    color: #49382B;
    font-size: 15px;
}

.form-field input[readonly] {
    background: #F3EDE3;
}

.button-row {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    margin-top: 25px;
}

.btn {
    display: inline-block;
    border: none;
    border-radius: 8px;
    padding: 12px 17px;
    background: #6B4F3A;
    color: #FFFFFF;
    text-decoration: none;
    text-align: center;
    font-size: 14px;
    cursor: pointer;
}

.btn:hover {
    opacity: 0.9;
}

.btn-light {
    background: #B89A78;
}

.btn-logout {
    background: #8B4238;
}

.message {
    max-width: 760px;
    margin: 0 auto 15px;
    padding: 12px 15px;
    border-radius: 8px;
    background: #E9DDCC;
    overflow-wrap: anywhere;
}

@media (max-width: 600px) {
    .details-grid {
        grid-template-columns: 1fr;
    }

    .content {
        padding: 20px;
    }

    .button-row {
        flex-direction: column;
    }

    .btn {
        width: 100%;
    }
}
</style>
</head>

<body>

<jsp:include page="navbar.jsp" />

<main class="profile-page">

    <div class="page-heading">
        <h1>My Profile</h1>
        <p>Manage your CampusCrave student account.</p>
    </div>

    <% if ("1".equals(request.getParameter("updated"))) { %>
        <div class="message">Profile updated successfully!</div>
    <% } %>

    <% if ("1".equals(request.getParameter("photoUpdated"))) { %>
        <div class="message">Profile photo uploaded successfully!</div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <div class="message">Unable to update your profile. Please check your details.</div>
    <% } %>

    <% if (request.getParameter("photoError") != null) { %>
        <div class="message">
            Photo upload failed. Select a JPG or PNG image smaller than 2 MB.
        </div>
    <% } %>

    <section class="profile-card">

        <div class="profile-header">

            <% if (!photoUrl.isEmpty()) { %>
                <img class="profile-photo"
                     src="<%= photoUrl %>"
                     alt="Student Profile Photo">
            <% } else { %>
                <div class="profile-placeholder">&#128100;</div>
            <% } %>

            <h2><%= studentName == null ? "Student" : studentName %></h2>

            <span class="role-label">
                <%= studentRole == null ? "Student" : studentRole %>
            </span>

            <form class="upload-form"
                  action="<%= contextPath %>/uploadPhoto"
                  method="post"
                  enctype="multipart/form-data">

                <input type="file"
                       name="photoFile"
                       accept="image/jpeg,image/png"
                       required>

                <button class="btn" type="submit">
                    Upload Photo
                </button>
            </form>

        </div>

        <div class="content">

            <h3>Student Details</h3>

            <form action="<%= contextPath %>/profileUpdate" method="post">

                <div class="details-grid">

                    <div class="form-field">
                        <label>Student ID</label>
                        <input type="text"
                               value="<%= request.getAttribute("studentId") == null ? "" : request.getAttribute("studentId") %>"
                               readonly>
                    </div>

                    <div class="form-field">
                        <label>Username</label>
                        <input type="text"
                               value="<%= studentUsername == null ? "" : studentUsername %>"
                               readonly>
                    </div>

                    <div class="form-field">
                        <label>Full Name</label>
                        <input type="text"
                               name="name"
                               maxlength="100"
                               value="<%= studentName == null ? "" : studentName %>"
                               required>
                    </div>

                    <div class="form-field">
                        <label>Phone Number</label>
                        <input type="tel"
                               name="phone"
                               maxlength="15"
                               value="<%= studentPhone == null ? "" : studentPhone %>">
                    </div>

                </div>

                <div class="button-row">

                    <button class="btn" type="submit">
                        Save Changes
                    </button>

                    <a class="btn btn-light"
                       href="<%= contextPath %>/changePassword.jsp">
                        Change Password
                    </a>

                    <a class="btn btn-logout"
                       href="<%= contextPath %>/logout"
                       onclick="return confirm('Are you sure you want to logout?');">
                        Logout
                    </a>

                </div>

            </form>

        </div>
    </section>
</main>

</body>
</html>
