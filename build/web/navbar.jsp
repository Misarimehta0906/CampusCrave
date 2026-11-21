
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    .navbar {
        width: 100%;
        min-height: 76px;
        padding: 12px 4%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 20px;
        background: #FFFDF8;
        border-bottom: 1px solid #E4D8C5;
        box-shadow: 0 3px 12px rgba(107, 79, 58, 0.07);
        position: relative;
        z-index: 10;
        box-sizing: border-box;
    }

    .navbar * {
        box-sizing: border-box;
    }

    .navbar .campus-logo {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        flex-shrink: 0;
        color: #49382B;
        text-decoration: none;
    }

    /* Logo icon size is fixed here */
    .navbar .logo-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 44px;
        height: 44px;
        min-width: 44px;
        overflow: hidden;
    }

    .navbar .logo-icon svg {
        display: block;
        width: 40px !important;
        height: 40px !important;
        max-width: 40px !important;
        max-height: 40px !important;
    }

    .navbar .logo-text {
        display: flex;
        flex-direction: column;
        line-height: 1.2;
        white-space: nowrap;
    }

    .navbar .logo-text strong {
        font-size: 20px;
        font-weight: 700;
        color: #6B4F3A;
    }

    .navbar .logo-text small {
        margin-top: 4px;
        font-size: 9px;
        letter-spacing: 2px;
        color: #887866;
    }

    .navbar .nav-links {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        flex-wrap: wrap;
        gap: 8px;
    }

    .navbar .nav-links a {
        display: inline-block;
        padding: 10px 11px;
        border-radius: 7px;
        color: #49382B;
        font-size: 14px;
        text-decoration: none;
        white-space: nowrap;
    }

    .navbar .nav-links a:hover {
        background: #F3EDE3;
    }

    .navbar .nav-links .login-btn {
        background: #6B4F3A;
        color: #FFFFFF;
    }

    .navbar .nav-links .logout-btn {
        background: #8B4238;
        color: #FFFFFF;
    }

    @media (max-width: 900px) {
        .navbar {
            flex-direction: column;
            align-items: flex-start;
        }

        .navbar .nav-links {
            justify-content: flex-start;
            width: 100%;
        }
    }

    @media (max-width: 500px) {
        .navbar .nav-links {
            gap: 4px;
        }

        .navbar .nav-links a {
            padding: 8px;
            font-size: 13px;
        }
    }
</style>

<nav class="navbar">

    <a class="campus-logo" href="index.jsp">

        <span class="logo-icon">
            <svg viewBox="0 0 64 64"
                 xmlns="http://www.w3.org/2000/svg"
                 aria-label="CampusCrave logo">

                <path d="M19 8 C10 8 10 22 19 25 L19 54"
                      fill="none"
                      stroke="#795638"
                      stroke-width="4"
                      stroke-linecap="round"/>

                <path d="M13 9 L13 19 M19 8 L19 19 M25 9 L25 19"
                      fill="none"
                      stroke="#795638"
                      stroke-width="3"
                      stroke-linecap="round"/>

                <path d="M43 9 L43 24 C43 30 37 31 37 25 L37 9
                         M43 25 L43 54"
                      fill="none"
                      stroke="#795638"
                      stroke-width="4"
                      stroke-linecap="round"/>

                <path d="M23 34 C16 25 27 22 32 29
                         C37 22 48 25 41 34 L32 45 Z"
                      fill="#E9A2A0"
                      stroke="#795638"
                      stroke-width="2"
                      stroke-linejoin="round"/>
            </svg>
        </span>

        <span class="logo-text">
            <strong>CampusCrave</strong>
            <small>CAMPUS CANTEEN</small>
        </span>

    </a>

    <div class="nav-links">

        <a href="index.jsp">Home</a>
        <a href="about.jsp">About</a>
        <a href="menu">Menu</a>
        <a href="favorites.jsp">♡ Favorites</a>
        <a href="cart.jsp">🛒 My Cart</a>
        <a href="orders.jsp">My Orders</a>
        <a href="feedback.jsp">Feedback</a>

        <% if (session.getAttribute("userId") != null) { %>

            <a href="profile">Profile</a>

            <a class="logout-btn"
               href="logout"
               onclick="return confirm('Are you sure you want to logout?');">
                Logout
            </a>

        <% } else { %>

            <a class="login-btn" href="login.jsp">Student Login</a>

        <% } %>

    </div>

</nav>
