<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CampusCrave | My Cart</title>

    <link rel="stylesheet" href="<%= contextPath %>/style.css">

    <style>
        .cart-item {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 18px;
            margin-bottom: 14px;
            background: var(--white, #fff);
            border: 1px solid var(--border, #e4d8c5);
            border-radius: 15px;
        }

        .cart-item h3 { margin: 0 0 6px; }
        .cart-item p { margin: 5px 0; color: var(--muted, #887866); }

        .cart-item input[type=number] {
            width: 75px;
            padding: 9px;
            border: 1px solid var(--border, #e4d8c5);
            border-radius: 8px;
        }

        .remove-btn {
            padding: 9px 13px;
            border: 1px solid #f0cbd0;
            background: #fff0f1;
            color: #a43d51;
            border-radius: 9px;
            cursor: pointer;
        }

        .cart-summary {
            margin-top: 22px;
            padding: 22px;
            background: var(--sage, #e9ddcc);
            border-radius: 16px;
        }

        .total-line {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            margin: 12px 0;
        }

        .grand-total {
            border-top: 1px solid var(--border, #e4d8c5);
            padding-top: 14px;
            font-size: 22px;
            font-weight: bold;
        }

        .empty-cart {
            padding: 25px;
            text-align: center;
        }

        .error-message {
            margin: 12px 0;
            font-size: 14px;
            color: #b42335;
        }

        .payment-select {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border, #e4d8c5);
            border-radius: 9px;
            margin: 8px 0 18px;
            background: #fffdf8;
        }

        .checkout-btn {
            width: 100%;
            padding: 14px 20px;
            border: 0;
            border-radius: 10px;
            background: var(--green, #6b4f3a);
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .checkout-btn:disabled {
            opacity: .6;
            cursor: wait;
        }

        @media(max-width: 600px) {
            .cart-item { align-items: flex-start; }
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<main class="container">
    <section class="section">

        <h1>🛒 My Cart</h1>
        <p>Review your items and proceed to order.</p>

        <div id="cartItems"></div>

        <div id="cartSummary" class="cart-summary" style="display:none">

            <div class="total-line">
                <span>Total Items</span>
                <strong id="totalQuantity">0</strong>
            </div>

            <div class="total-line">
                <span>Food Total</span>
                <strong id="foodTotal">₹0.00</strong>
            </div>

            <div class="total-line grand-total">
                <span>Final Total</span>
                <span id="grandTotal">₹0.00</span>
            </div>

            <p id="errorMessage"
               class="error-message"
               aria-live="polite"
               style="display:none"></p>

            <label for="paymentMethod">
                <strong>Payment Method</strong>
            </label>

            <select id="paymentMethod" class="payment-select">
                <option value="Cash">Cash at Canteen</option>
                <option value="UPI">UPI</option>
                <option value="Card">Card</option>
            </select>

            <button class="checkout-btn"
                    id="checkoutBtn"
                    type="button">
                Proceed to Order
            </button>
        </div>

    </section>
</main>

<script>
(function () {
    "use strict";

    const contextPath = "<%= contextPath %>";

    const itemsContainer = document.getElementById("cartItems");
    const summary = document.getElementById("cartSummary");
    const errorMessage = document.getElementById("errorMessage");
    const checkoutBtn = document.getElementById("checkoutBtn");

    let submitting = false;

    function readCart() {
        try {
            const data = JSON.parse(
                localStorage.getItem("campusCraveCart") || "[]"
            );

            return Array.isArray(data) ? data : [];
        } catch (error) {
            return [];
        }
    }

    function saveCart(cart) {
        localStorage.setItem("campusCraveCart", JSON.stringify(cart));
    }

    function money(value) {
        return "₹" + Number(value || 0).toFixed(2);
    }

    function getTotals(cart) {
        let total = 0;
        let quantityTotal = 0;

        cart.forEach(function (item) {
            const quantity = Number(item.quantity);
            const price = Number(item.price);

            if (Number.isFinite(quantity) && quantity > 0 &&
                Number.isFinite(price) && price >= 0) {
                total += price * quantity;
                quantityTotal += quantity;
            }
        });

        return {
            total: Number(total.toFixed(2)),
            quantity: quantityTotal
        };
    }

    function showError(text) {
        errorMessage.textContent = text;
        errorMessage.style.display = text ? "block" : "none";
    }

    function renderCart() {
        const cart = readCart();
        itemsContainer.replaceChildren();

        if (cart.length === 0) {
            const empty = document.createElement("div");
            empty.className = "empty-cart";

            const heading = document.createElement("h3");
            heading.textContent = "Your cart is empty 🥺";

            const paragraph = document.createElement("p");
            paragraph.textContent = "Add something tasty from the menu.";

            empty.append(heading, paragraph);
            itemsContainer.appendChild(empty);

            summary.style.display = "none";
            return;
        }

        summary.style.display = "block";

        cart.forEach(function (item, index) {
            const quantity = Number(item.quantity);
            const price = Number(item.price);

            const row = document.createElement("div");
            row.className = "cart-item";

            const info = document.createElement("div");

            const title = document.createElement("h3");
            title.textContent = item.name || "Food item";

            const category = document.createElement("p");
            category.textContent = item.category || "";

            const unitPrice = document.createElement("p");
            unitPrice.textContent = "Price: " + money(price);

            const itemSubtotal = document.createElement("p");
            itemSubtotal.textContent =
                "Subtotal: " + money(price * quantity);

            info.append(title, category, unitPrice, itemSubtotal);

            const quantityBox = document.createElement("div");

            const label = document.createElement("label");
            label.textContent = "Quantity ";

            const quantityInput = document.createElement("input");
            quantityInput.type = "number";
            quantityInput.min = "1";
            quantityInput.max = "99";
            quantityInput.value = quantity;
            quantityInput.setAttribute(
                "aria-label",
                "Quantity for " + (item.name || "food item")
            );

            quantityInput.addEventListener("change", function () {
                const newQuantity = Number.parseInt(
                    quantityInput.value, 10
                );

                if (!Number.isInteger(newQuantity) ||
                    newQuantity < 1 || newQuantity > 99) {
                    alert("Quantity must be between 1 and 99.");
                    renderCart();
                    return;
                }

                const updatedCart = readCart();

                if (!updatedCart[index]) {
                    return;
                }

                updatedCart[index].quantity = newQuantity;
                saveCart(updatedCart);

                renderCart();
            });

            quantityBox.append(label, quantityInput);

            const removeButton = document.createElement("button");
            removeButton.className = "remove-btn";
            removeButton.type = "button";
            removeButton.textContent = "Remove";

            removeButton.addEventListener("click", function () {
                const updatedCart = readCart();
                updatedCart.splice(index, 1);
                saveCart(updatedCart);

                renderCart();
            });

            row.append(info, quantityBox, removeButton);
            itemsContainer.appendChild(row);
        });

        const totals = getTotals(cart);

        document.getElementById("totalQuantity").textContent =
            totals.quantity;

        document.getElementById("foodTotal").textContent =
            money(totals.total);

        document.getElementById("grandTotal").textContent =
            money(totals.total);
    }

    // Send the order to OrderServlet.
    checkoutBtn.addEventListener("click", function () {
        if (submitting) {
            return;
        }

        const cart = readCart();

        if (cart.length === 0) {
            alert("Your cart is empty. Please add food items first.");
            return;
        }

        const paymentMethod =
            document.getElementById("paymentMethod").value;

        const form = document.createElement("form");
        form.method = "POST";
        form.action = contextPath + "/order";

        function addField(name, value) {
            const input = document.createElement("input");
            input.type = "hidden";
            input.name = name;
            input.value = String(value);
            form.appendChild(input);
        }

        for (const item of cart) {
            const id = Number.parseInt(item.id, 10);
            const quantity = Number.parseInt(item.quantity, 10);

            if (!Number.isInteger(id) || id <= 0 ||
                !Number.isInteger(quantity) ||
                quantity < 1 || quantity > 99) {
                alert(
                    "Invalid cart item. Remove it and add it again from Menu."
                );
                return;
            }

            addField("foodIds", id);
            addField("quantities", quantity);
        }

        addField("paymentMethod", paymentMethod);

        submitting = true;
        checkoutBtn.disabled = true;
        checkoutBtn.textContent = "Placing Order...";

        document.body.appendChild(form);
        form.submit();
    });

    // Show any error returned by OrderServlet.
    const params = new URLSearchParams(window.location.search);
    const error = params.get("error");

    if (error) {
        showError(error);
    }

    renderCart();
})();
</script>

</body>
</html>