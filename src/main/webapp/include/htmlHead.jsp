<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FightinClass66: <%= (String) request.getAttribute("menuActiveLink") %></title>

    <!-- Link ai fogli di stile -->

    <!-- Script JavaScript -->
    <%
        // Preleva il messaggio dalla richiesta (se esiste)
        String applicationMessageFromServer = (String) request.getAttribute("applicationMessage");
    %>
    <script>
        // Inizializzazione in JavaScript
        var applicationMessage = null;

        // Se il messaggio esiste nel server, lo assegno alla variabile JavaScript
        <% if (applicationMessageFromServer != null && !applicationMessageFromServer.isEmpty()) { %>
        applicationMessage = "<%= applicationMessageFromServer %>";
        <% } %>

        function onLoadHandler() {
            try {
                mainOnLoadHandler();
            } catch (e) {
                console.error(e);
            }

            // Mostra un alert con il messaggio solo se esiste e non è vuoto
            if (applicationMessage !== null && applicationMessage !== "") {
                alert(applicationMessage);
            }
        }

        window.addEventListener("load", onLoadHandler);
    </script>
</head>
