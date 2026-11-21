
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>About CampusCrave</title>
    <link rel="stylesheet" href="style.css">

    <style>
        .about-page {
            width: min(1200px, 92%);
            margin: 40px auto 60px;
        }

        .about-intro {
            padding: 48px 30px;
            text-align: center;
            background: linear-gradient(120deg, #FFFCF6, #F0E3D0);
            border: 1px solid #E4D2B8;
            border-radius: 24px;
            box-shadow: 0 8px 24px rgba(107,79,58,.08);
        }

        .about-intro h1 {
            margin: 12px 0;
            color: #49382B;
            font: bold clamp(34px, 5vw, 55px) Georgia, serif;
        }

        .about-intro h1 span {
            color: #A17A52;
        }

        .about-intro p {
            max-width: 720px;
            margin: 15px auto 24px;
            color: #887866;
            line-height: 1.9;
        }

        .about-section {
            margin-top: 48px;
        }

        .about-section-title {
            margin-bottom: 24px;
            text-align: center;
        }

        .about-section-title h2 {
            margin: 8px 0;
            font: bold 32px Georgia, serif;
        }

        .about-story {
            display: grid;
            grid-template-columns: 1fr 1fr;
            align-items: stretch;
            gap: 22px;
        }

        .about-story-card {
            padding: 28px;
            background: #FFFCF6;
            border: 1px solid #E4D2B8;
            border-radius: 18px;
            box-shadow: 0 6px 20px rgba(107,79,58,.06);
        }

        .about-story-card h3 {
            margin-top: 0;
            color: #795638;
            font: bold 24px Georgia, serif;
        }

        .about-story-card p {
            color: #887866;
            line-height: 1.9;
        }

        .about-steps {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
        }

        .about-step {
            padding: 25px 20px;
            text-align: center;
            background: #FBF0DF;
            border: 1px solid #E4D2B8;
            border-radius: 16px;
        }

        .about-step .step-icon {
            width: 64px;
            height: 64px;
            margin: 0 auto 15px;
            display: grid;
            place-items: center;
            background: #EADCC7;
            border: 1px solid #DDC8A9;
            border-radius: 50%;
            font-size: 29px;
        }

        .about-step h3 {
            margin: 8px 0;
            font: bold 20px Georgia, serif;
        }

        .about-step p {
            margin-bottom: 0;
            color: #887866;
            font-size: 14px;
            line-height: 1.8;
        }

        .about-cta {
            margin-top: 45px;
            padding: 32px 20px;
            text-align: center;
            background: #EADCC7;
            border: 1px solid #DDC8A9;
            border-radius: 18px;
        }

        .about-cta h2 {
            margin-top: 0;
            font: bold 29px Georgia, serif;
        }

        .about-cta p {
            color: #796653;
            margin-bottom: 22px;
        }

        @media(max-width:700px) {
            .about-story {
                grid-template-columns: 1fr;
            }

            .about-steps {
                grid-template-columns: 1fr;
            }

            .about-intro {
                padding: 35px 20px;
            }
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<main class="about-page">

    <section class="about-intro">
        <span class="eyebrow">A LITTLE ABOUT US</span>

        <h1>Welcome to<br><span>CampusCrave ☕</span></h1>

        <p>
            Every campus day deserves a delicious break. CampusCrave brings
            your canteen experience online, making it easier to explore food,
            discover prices and choose what you love.
        </p>

        <a href="menu" class="btn">Discover the Menu →</a>
    </section>

    <section class="about-section">
        <div class="about-section-title">
            <span class="eyebrow">OUR STORY</span>
            <h2>Created for Your Campus Days</h2>
        </div>

        <div class="about-story">
            <div class="about-story-card">
                <h3>Why CampusCrave?</h3>
                <p>
                    Between lectures, assignments and time with friends,
                    students need a simple way to explore their canteen menu.
                    CampusCrave is designed to make browsing food and managing
                    an order more convenient.
                </p>
            </div>

            <div class="about-story-card">
                <h3>Our Purpose</h3>
                <p>
                    We want to make the campus food experience clear and
                    enjoyable with an easy-to-browse menu, helpful food
                    categories, favourites and a convenient cart.
                </p>
            </div>
        </div>
    </section>

    <section class="about-section">
        <div class="about-section-title">
            <span class="eyebrow">SIMPLE & CONVENIENT</span>
            <h2>Your Food Journey</h2>
            <p class="muted">Three simple steps to get started.</p>
        </div>

        <div class="about-steps">
            <div class="about-step">
                <div class="step-icon">🍽️</div>
                <h3>01. Explore</h3>
                <p>Browse the menu and discover snacks, meals and drinks.</p>
            </div>

            <div class="about-step">
                <div class="step-icon">🛒</div>
                <h3>02. Choose</h3>
                <p>Select food items and manage quantities in your cart.</p>
            </div>

            <div class="about-step">
                <div class="step-icon">💛</div>
                <h3>03. Enjoy</h3>
                <p>Make your campus break a little more delicious.</p>
            </div>
        </div>
    </section>

    <section class="about-cta">
        <h2>Make Your Break Delicious 🍰</h2>
        <p>Something tasty might be waiting on the menu.</p>
        <a href="menu" class="btn">Explore Our Menu →</a>
    </section>

</main>

<footer class="footer">
    <p>Your Campus. Your Canteen. Your Cravings.</p>

    <div class="footer-links">
        <a href="index.jsp">Home</a>
        <a href="menu">Menu</a>
        <a href="favorites.jsp">Favorites</a>
        <a href="feedback.jsp">Feedback</a>
    </div>

    <div class="footer-bottom">
        © 2026 CampusCrave. Made for campus life.
    </div>
</footer>

</body>
</html>
