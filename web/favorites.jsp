
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusCrave | Favorites</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .favorite-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 20px;
            margin-top: 22px;
        }
        .favorite-card {
            padding: 20px;
            background: white;
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: var(--shadow);
        }
        .favorite-card h3 { margin-top: 0; }
        .favorite-category {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            background: var(--sage);
            font-size: 12px;
        }
        .favorite-price {
            margin: 12px 0;
            color: var(--green);
            font-size: 21px;
            font-weight: bold;
        }
        .favorite-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .favorite-actions button {
            padding: 11px;
            border: none;
            border-radius: 9px;
            cursor: pointer;
        }
        .favorite-add { background: var(--green); color: white; }
        .favorite-remove { background: #fff0f1; color: #a43d51; }
        .empty-favorites { padding: 25px; text-align: center; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<main class="container">
    <section class="section">
        <h1>♡ Your Favorites</h1>
        <p>Your saved campus food favourites, all in one place.</p>
        <div id="favoritesGrid" class="favorite-grid"></div>
    </section>
</main>

<script>
(function () {
    const grid = document.getElementById("favoritesGrid");

    function readStorage(key) {
        try {
            return JSON.parse(localStorage.getItem(key)) || [];
        } catch (e) {
            return [];
        }
    }

    function saveStorage(key, value) {
        localStorage.setItem(key, JSON.stringify(value));
    }

    function money(value) {
        return "₹" + Number(value).toFixed(2);
    }

    function renderFavorites() {
        const favorites = readStorage("campusCraveFavorites");
        grid.replaceChildren();

        if (favorites.length === 0) {
            const empty = document.createElement("div");
            empty.className = "empty-favorites";
            empty.innerHTML =
                "<h3>No favorites yet ♡</h3>" +
                "<p>Open the menu and tap the heart on any food item.</p>";
            grid.appendChild(empty);
            return;
        }

        favorites.forEach(item => {
            const card = document.createElement("article");
            card.className = "favorite-card";

            const category = document.createElement("span");
            category.className = "favorite-category";
            category.textContent = item.category || "Food";

            const name = document.createElement("h3");
            name.textContent = item.name;

            const description = document.createElement("p");
            description.textContent = item.description || "";

            const price = document.createElement("div");
            price.className = "favorite-price";
            price.textContent = money(item.price);

            const actions = document.createElement("div");
            actions.className = "favorite-actions";

            const add = document.createElement("button");
            add.className = "favorite-add";
            add.textContent = "Add to Cart 🛒";
            add.addEventListener("click", () => {
                const cart = readStorage("campusCraveCart");
                const existing = cart.find(
                    cartItem => String(cartItem.id) === String(item.id)
                );

                if (existing) {
                    if (existing.quantity >= 99) {
                        alert("Maximum quantity for one item is 99.");
                        return;
                    }
                    existing.quantity += 1;
                } else {
                    cart.push({
                        id: String(item.id),
                        name: item.name,
                        category: item.category,
                        price: Number(item.price),
                        quantity: 1
                    });
                }

                saveStorage("campusCraveCart", cart);
                alert("Added to My Cart!");
            });

            const remove = document.createElement("button");
            remove.className = "favorite-remove";
            remove.textContent = "♥ Remove Favorite";
            remove.addEventListener("click", () => {
                const updated = readStorage("campusCraveFavorites")
                    .filter(fav => String(fav.id) !== String(item.id));

                saveStorage("campusCraveFavorites", updated);
                renderFavorites();
            });

            actions.append(add, remove);
            card.append(category, name, description, price, actions);
            grid.appendChild(card);
        });
    }

    renderFavorites();
})();
</script>
</body>
</html>
