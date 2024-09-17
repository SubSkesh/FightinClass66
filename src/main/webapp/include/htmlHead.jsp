<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FightinClass66: <%= (String) request.getAttribute("menuActiveLink") %></title>

    <!-- Link ai fogli di stile -->

    <!-- Script JavaScript -->
    <%
        String applicationMessagelocal = (String) request.getAttribute("applicationMessage");
    %>
    <script>
        var applicationMessage;
        <% if (applicationMessage != null) { %>
        applicationMessage = "<%= applicationMessagelocal %>";
        <% } %>

        function onLoadHandler() {
            try { mainOnLoadHandler(); } catch (e) { console.error(e); }
            if (applicationMessage !== undefined) { alert(applicationMessage); }
        }

        window.addEventListener("load", onLoadHandler);
    </script>
</head>
