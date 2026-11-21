
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.smartcanteen.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    private String escapeHtml(Object value) {
        if (value == null) return "";

        return String.valueOf(value)
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }
%>

<%
    List<Map<String, Object>> foodList =
        (List<Map<String, Object>>) request.getAttribute("foodList");

    if (foodList == null) {
        foodList = new ArrayList<Map<String, Object>>();
    }

    List<Map<String, Object>> categoryList =
        (List<Map<String, Object>>) request.getAttribute("categoryList");

    if (categoryList == null) {
        categoryList = new ArrayList<Map<String, Object>>();
    }

    List<Map<String, Object>> specialList =
        new ArrayList<Map<String, Object>>();

    Set<String> specialFoodIds = new HashSet<String>();

    String specialSql =
        "SELECT f.id, f.name, f.category, f.price, f.description, " +
        "s.description AS special_description " +
        "FROM specials s JOIN food f ON f.id = s.food_id " +
        "WHERE s.status = 'Active' " +
        "AND s.special_date = CURDATE() " +
        "ORDER BY s.special_id DESC";

    try (
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(specialSql);
        ResultSet rs = ps.executeQuery()
    ) {
        while (rs.next()) {
            Map<String, Object> item =
                new HashMap<String, Object>();

            item.put("id", rs.getInt("id"));
            item.put("name", rs.getString("name"));
            item.put("category", rs.getString("category"));
            item.put("price", rs.getDouble("price"));
            item.put("description", rs.getString("description"));
            item.put("special_description",
                     rs.getString("special_description"));

            specialList.add(item);
            specialFoodIds.add(String.valueOf(rs.getInt("id")));
        }
    } catch (Exception e) {
        application.log("Unable to load today's specials", e);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusCrave | Menu</title>

    <link rel="stylesheet" href="style.css">

    <style>
        .menu-tools {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin: 22px 0;
        }

        .menu-tools input,
        .menu-tools select {
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 12px;
            background: white;
            color: var(--text);
            font-size: 15px;
        }

        .menu-tools input {
            flex: 1;
            min-width: 180px;
        }

        .menu-tools select {
            min-width: 190px;
        }

        .food-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 22px;
        }

        .food-card {
            position: relative;
            display: flex;
            flex-direction: column;
            background: white;
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 20px;
            box-shadow: var(--shadow);
            transition: transform .2s ease;
        }

        .food-card:hover {
            transform: translateY(-3px);
        }

        .food-category {
            display: inline-block;
            align-self: flex-start;
            background: var(--sage);
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 12px;
            margin-bottom: 10px;
        }

        .special-section {
            margin: 28px 0 42px;
            padding: 24px;
            background: linear-gradient(135deg, #fff8e9, #fffdf8);
            border: 1px solid #ead8b7;
            border-radius: 22px;
        }

        .special-section h2 {
            margin-top: 0;
            color: var(--green);
        }

        .special-note {
            color: var(--muted);
            font-size: 14px;
        }

        .special-badge {
            display: inline-block;
            align-self: flex-start;
            background: #fff0cf;
            color: #875b16;
            border: 1px solid #f0d79e;
            border-radius: 20px;
            padding: 7px 11px;
            font-size: 11px;
            font-weight: 800;
            margin-bottom: 12px;
        }

        .heart-btn {
            position: absolute;
            right: 16px;
            top: 15px;
            border: 1px solid var(--border);
            background: #fff8f5;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            font-size: 21px;
            cursor: pointer;
        }

        .heart-btn.active {
            color: #D94B69;
            background: #fff0f3;
        }

        .food-name {
            margin: 8px 0;
            padding-right: 24px;
        }

        .food-description {
            color: var(--muted);
            font-size: 14px;
            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        .food-price {
            color: var(--green);
            font-size: 23px;
            font-weight: 800;
            margin: 12px 0;
        }

        .quantity-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 14px 0;
        }

        .quantity-row input {
            width: 78px;
            padding: 10px;
            border: 1px solid var(--border);
            border-radius: 9px;
            font-size: 15px;
        }

        .add-cart-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            min-height: 49px;
            padding: 13px 18px;
            margin-top: auto;
            background: linear-gradient(135deg, #6B4F3A, #8B684B);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
        }

        .add-cart-btn:hover {
            background: linear-gradient(135deg, #543B2A, #6B4F3A);
        }

        .add-cart-btn:disabled {
            opacity: .75;
            cursor: default;
        }

        .empty-menu {
            padding: 20px;
            color: var(--muted);
        }

        .section-heading {
            margin-bottom: 8px;
        }

        @media (max-width: 600px) {
            .special-section {
                padding: 15px;
            }

            .food-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<main class="container">
    <section class="section">

        <h1>Explore Our Menu 🍽️</h1>
        <p>Fresh bites, campus favourites, and something delicious for everyone.</p>

        <section class="special-section">
            <h2>⭐ Today's Special</h2>
            <p class="special-note">Handpicked favourites for today!</p>

            <% if (specialList.isEmpty()) { %>
                <p class="empty-menu">
                    No special items available today. Check back later!
                </p>
            <% } else { %>

                <div class="food-grid">
                <% for (Map<String, Object> item : specialList) {
                    String id = String.valueOf(item.get("id"));
                    String name = String.valueOf(item.get("name"));
                    String category = String.valueOf(item.get("category"));

                    String description = item.get("description") == null
                        ? "" : String.valueOf(item.get("description"));

                    String specialDescription =
                        item.get("special_description") == null
                        ? "" : String.valueOf(item.get("special_description"));

                    double price = Double.parseDouble(
                        String.valueOf(item.get("price")));
                %>

                    <article class="food-card"
                        data-id="<%= escapeHtml(id) %>"
                        data-name="<%= escapeHtml(name) %>"
                        data-category="<%= escapeHtml(category) %>"
                        data-price="<%= price %>"
                        data-description="<%= escapeHtml(description) %>">

                        <button type="button" class="heart-btn"
                            title="Add to Favorites">♡</button>

                        <span class="special-badge">⭐ TODAY'S SPECIAL</span>

                        <span class="food-category">
                            <%= escapeHtml(category) %>
                        </span>

                        <h3 class="food-name"><%= escapeHtml(name) %></h3>

                        <p class="food-description">
                            <%= escapeHtml(description) %>
                        </p>

                        <% if (!specialDescription.trim().isEmpty()) { %>
                            <p class="special-note">
                                <%= escapeHtml(specialDescription) %>
                            </p>
                        <% } %>

                        <div class="food-price">
                            ₹<%= String.format("%.2f", price) %>
                        </div>

                        <div class="quantity-row">
                            <label>Qty:</label>
                            <input class="food-quantity" type="number"
                                min="1" max="99" value="1">
                        </div>

                        <button type="button" class="add-cart-btn">
                            🛒 Add to Cart
                        </button>
                    </article>

                <% } %>
                </div>
            <% } %>
        </section>

        <h2 class="section-heading">🍴 All Menu Items</h2>

        <div class="menu-tools">
            <input type="search" id="foodSearch"
                placeholder="Search food items...">

            <select id="categoryFilter">
                <option value="all">All Categories</option>

                <% for (Map<String, Object> category : categoryList) {
                    String categoryName =
                        String.valueOf(category.get("category_name"));
                %>
                    <option value="<%= escapeHtml(categoryName) %>">
                        <%= escapeHtml(categoryName) %>
                    </option>
                <% } %>
            </select>
        </div>

        <div class="food-grid" id="foodGrid">

            <% if (!foodList.isEmpty()) {
                for (Map<String, Object> food : foodList) {
                    String id = String.valueOf(food.get("id"));
                    String name = String.valueOf(food.get("name"));
                    String category = String.valueOf(food.get("category"));

                    String description = food.get("description") == null
                        ? "" : String.valueOf(food.get("description"));

                    double price = Double.parseDouble(
                        String.valueOf(food.get("price")));

                    boolean isSpecial = specialFoodIds.contains(id);
            %>

                <article class="food-card"
                    data-id="<%= escapeHtml(id) %>"
                    data-name="<%= escapeHtml(name) %>"
                    data-category="<%= escapeHtml(category) %>"
                    data-price="<%= price %>"
                    data-description="<%= escapeHtml(description) %>">

                    <button type="button" class="heart-btn"
                        title="Add to Favorites">♡</button>

                    <% if (isSpecial) { %>
                        <span class="special-badge">⭐ TODAY'S SPECIAL</span>
                    <% } %>

                    <span class="food-category">
                        <%= escapeHtml(category) %>
                    </span>

                    <h3 class="food-name"><%= escapeHtml(name) %></h3>

                    <p class="food-description">
                        <%= escapeHtml(description) %>
                    </p>

                    <div class="food-price">
                        ₹<%= String.format("%.2f", price) %>
                    </div>

                    <div class="quantity-row">
                        <label>Qty:</label>
                        <input class="food-quantity" type="number"
                            min="1" max="99" value="1">
                    </div>

                    <button type="button" class="add-cart-btn">
                        🛒 Add to Cart
                    </button>
                </article>

            <% }
               } else { %>

                <p class="empty-menu">
                    No food items found. Add food items from the database.
                </p>

            <% } %>

        </div>
    </section>
</main>

<script>
(function () {
    var cards = Array.prototype.slice.call(
        document.querySelectorAll(".food-card")
    );

    var categoryFilter = document.getElementById("categoryFilter");
    var foodSearch = document.getElementById("foodSearch");

    function readStorage(key) {
        try {
            var value = JSON.parse(localStorage.getItem(key));
            return Array.isArray(value) ? value : [];
        } catch (e) {
            return [];
        }
    }

    function saveStorage(key, value) {
        localStorage.setItem(key, JSON.stringify(value));
    }

    function renderFavorites() {
        var favorites = readStorage("campusCraveFavorites");

        cards.forEach(function (card) {
            var button = card.querySelector(".heart-btn");
            var id = String(card.dataset.id);

            var isFavorite = favorites.some(function (item) {
                return String(item.id) === id;
            });

            button.classList.toggle("active", isFavorite);
            button.textContent = isFavorite ? "♥" : "♡";
            button.title = isFavorite
                ? "Remove from Favorites"
                : "Add to Favorites";
        });
    }

    function filterMenu() {
        var selectedCategory = categoryFilter.value.toLowerCase();
        var searchText = foodSearch.value.trim().toLowerCase();

        cards.forEach(function (card) {
            var category = card.dataset.category.toLowerCase();

            var matchesCategory =
                selectedCategory === "all" ||
                category === selectedCategory;

            var matchesSearch =
                card.dataset.name.toLowerCase().indexOf(searchText) !== -1 ||
                card.dataset.description.toLowerCase().indexOf(searchText) !== -1;

            card.style.display =
                matchesCategory && matchesSearch ? "" : "none";
        });
    }

    cards.forEach(function (card) {
        card.querySelector(".heart-btn").addEventListener("click", function () {
            var favorites = readStorage("campusCraveFavorites");
            var id = String(card.dataset.id);

            var alreadySaved = favorites.some(function (item) {
                return String(item.id) === id;
            });

            if (alreadySaved) {
                favorites = favorites.filter(function (item) {
                    return String(item.id) !== id;
                });
            } else {
                favorites.push({
                    id: id,
                    name: card.dataset.name,
                    category: card.dataset.category,
                    price: Number(card.dataset.price),
                    description: card.dataset.description
                });
            }

            saveStorage("campusCraveFavorites", favorites);
            renderFavorites();
        });

        card.querySelector(".add-cart-btn").addEventListener("click", function () {
            var quantityInput = card.querySelector(".food-quantity");
            var quantity = parseInt(quantityInput.value, 10);

            if (isNaN(quantity) || quantity < 1 || quantity > 99) {
                alert("Please select a quantity from 1 to 99.");
                return;
            }

            var id = String(card.dataset.id);
            var cart = readStorage("campusCraveCart");

            var existing = cart.find(function (item) {
                return String(item.id) === id;
            });

            if (existing) {
                var currentQuantity = Number(existing.quantity) || 0;

                if (currentQuantity + quantity > 99) {
                    alert("Maximum quantity for one item is 99.");
                    return;
                }

                existing.quantity = currentQuantity + quantity;
            } else {
                cart.push({
                    id: id,
                    name: card.dataset.name,
                    category: card.dataset.category,
                    price: Number(card.dataset.price),
                    quantity: quantity
                });
            }

            saveStorage("campusCraveCart", cart);

            var button = card.querySelector(".add-cart-btn");
            var oldText = button.textContent;

            button.textContent = "✓ Added to Cart!";
            button.disabled = true;

            window.setTimeout(function () {
                button.textContent = oldText;
                button.disabled = false;
            }, 1000);
        });
    });

    categoryFilter.addEventListener("change", filterMenu);
    foodSearch.addEventListener("input", filterMenu);

    renderFavorites();
})();
</script>

</body>
</html>
