
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CampusCrave | Campus Canteen</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<jsp:include page="navbar.jsp"/>

<main>
    <section class="hero">
        <div class="hero-content">
            <span class="eyebrow">YOUR CAMPUS, YOUR CANTEEN</span>

            <h1>
                Good Food.<br>
                Better Mood.<br>
                <span>CampusCrave!</span>
            </h1>

            <p>
                From quick snacks between lectures to tasty lunch breaks,
                CampusCrave makes your school and college days more delicious.
                Great bites, friendly prices and happy moments with friends.
            </p>

            <div class="hero-buttons">
                <a class="btn" href="menu">Explore Our Menu →</a>
                <a class="btn btn-light" href="login.jsp">Get Started</a>
            </div>
        </div>

        <div class="hero-art">
            <div class="sandwich-art" aria-label="Sandwich illustration" role="img">
                🥪
            </div>
        </div>
    </section>

    <section class="section features-section">
        <div class="section-heading">
            <span class="eyebrow">MADE FOR CAMPUS LIFE</span>
            <h2>Your Break Deserves Better</h2>
            <p class="muted">
                Tasty food and little moments that make your day.
            </p>
        </div>

        <div class="grid">
            <div class="card feature-card">
                <div class="feature-icon">🥪</div>
                <div>
                    <h3>Fresh &amp; Tasty</h3>
                    <p class="muted">
                        Discover snacks, meals and drinks for every craving.
                    </p>
                </div>
            </div>

            <div class="card feature-card">
                <div class="feature-icon">🎓</div>
                <div>
                    <h3>Student Friendly</h3>
                    <p class="muted">
                        Everyday food choices made with students in mind.
                    </p>
                </div>
            </div>

            <div class="card feature-card">
                <div class="feature-icon">◷</div>
                <div>
                    <h3>Break-Time Ready</h3>
                    <p class="muted">
                        Make the most of your break with a delicious bite.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="special-banner">
            <div class="banner-content">
                <span class="eyebrow">A LITTLE CAMPUS HAPPINESS</span>
                <h2>What's Your Craving Today? 🍟</h2>
                <p class="muted">
                    Explore the menu and find something delicious for your next break.
                </p>
            </div>
            <div class="banner-decoration">🍽️</div>
        </div>
    </section>
</main>

<footer class="footer">
    <a class="campus-logo footer-logo" href="index.jsp">
        <span class="logo-icon">
            <svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
                <path d="M30 8 C26 8 24 12 24 16 C24 20 26 22 29 23 L18 41"
                      fill="none" stroke="#795638" stroke-width="5"
                      stroke-linecap="round"/>
                <path d="M10 8 L10 17 M15 7 L15 17 M20 8 L20 17
                         M10 17 Q15 23 20 17"
                      fill="none" stroke="#795638" stroke-width="2.5"
                      stroke-linecap="round"/>
                <circle cx="17" cy="26" r="4" fill="#E58CA4"/>
                <circle cx="23" cy="26" r="4" fill="#E58CA4"/>
                <circle cx="20" cy="21" r="4" fill="#E58CA4"/>
                <circle cx="20" cy="31" r="4" fill="#E58CA4"/>
                <circle cx="20" cy="26" r="2.5" fill="#E6B75A"/>
            </svg>
        </span>
        <span class="logo-text">
            <strong>CampusCrave</strong>
            <small>CAMPUS CANTEEN</small>
        </span>
    </a>

    <p>Your Campus. Your Canteen. Your Cravings.</p>

    <div class="footer-links">
        <a href="index.jsp">Home</a>
        <a href="menu">Menu</a>
        <a href="feedback.jsp">Feedback</a>
        <a href="about.jsp">About</a>
    </div>

    <div class="footer-bottom">
        © 2026 CampusCrave. Made for campus life.
    </div>
</footer>

</body>
</html>
