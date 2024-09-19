<%--
    Document   : utenti
    Created on : 5-mar-2024, 10.05.37
    Author     : Oscar Costanzelli
--%>

<%@page session = "false"%>
<%@page import="model.mo.Utente"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int i = 0;

    // Recupera l'iniziale selezionata e gestisci il valore null
    String selectedInitial = (String) request.getAttribute("selectedInitial");
    if (selectedInitial == null) {
        selectedInitial = "*"; // Imposta '*' se null
    }

    // Gestione della lista di iniziali
    ArrayList<String> initials = (ArrayList<String>) request.getAttribute("initials");
    int numInitials = (initials != null) ? initials.size() : 0;

    // Gestione della lista di utenti
    ArrayList<Utente> utenti = (ArrayList<Utente>) request.getAttribute("utenti");
    int numUtenti = (utenti != null) ? utenti.size() : 0;

    // Gestione della lista dei numeri degli ordini
    ArrayList<Integer> numeroOrdini = (ArrayList<Integer>) request.getAttribute("numeroOrdini");
    int numOrdini = (numeroOrdini != null) ? numeroOrdini.size() : 0;

    // Verifica se l'utente è loggato
    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = (loggedOnAttr != null) ? loggedOnAttr : false;

    // Gestione dell'utente loggato per evitare null pointer exceptions
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    if (ul == null) {
        ul = new LoggedUser(); // Crea un utente vuoto se non esiste
        ul.setNomeUtente("Admin ");
        ul.setCognome("Sconosciutonomagomedov");
    }

    // Messaggio applicativo, se non presente imposta un valore di default
    String applicationMessage = (String) request.getAttribute("applicationMessage");
    if (applicationMessage == null) {
        applicationMessage = "Nessun messaggio disponibile.";
    }

    String menuActiveLink = "Utenti";
%>
<!DOCTYPE html>
<html lang="it-IT">
<head>
    <style>
        .initial {
            color: black;
        }

        .selectedInitial {
            color: steelblue;
        }
        .email {
            font-size: 0.9em;
        }
    </style>
    <script language="javascript">
        function changeInitial(inital) {
            document.changeInitialForm.selectedInitial.value = inital;
            document.changeInitialForm.submit();
        }

        function bloccaUtente(email) {
            document.bloccaUtenteForm.email.value = email;
            document.bloccaUtenteForm.submit();
        }

        function sbloccaUtente(email) {
            document.sbloccaUtenteForm.email.value = email;
            document.sbloccaUtenteForm.submit();
        }
    </script>

    <%@include file="/include/htmlHead.jsp" %>

</head>
<body>

<header>
    <%@include file="/include/HeaderAdmin.jsp"%>
</header>

<hr>

<main>

    <div class="nome" style="margin-bottom: 15px;">
        <p>Benvenuto <%= ul.getNomeUtente() %> <%= ul.getCognome() %></p>
    </div>

    <section>
        <!--FORM PER PASSARE ALLA PAGINA DI REGISTRAZIONE DI UN NUOVO UTENTE-->
        <form name="inserisciUtente" action="Dispatcher" method="post">
            <input type="hidden" name="controllerAction" value="LogOn.view"/>
            <input type="hidden" name="opzione" value="R"/>
            <input type="submit" value="Nuovo utente" class="mainButton">
        </form>
    </section>

    <!--MINI MENU DI NAVIGAZIONE CON LE INIZIALI DEI NOMI DEGLI UTENTI-->
    <nav style="margin-top: 15px;">
        <%if(selectedInitial.equals("*")) { %>
        <span class="selectedInitial">*</span>
        <% } else { %>
        <a class="initial" href="javascript:changeInitial('*');">*</a>
        <% } %>

        <%for(i = 0; i < numInitials; i++) {
            if(initials.get(i).equals(selectedInitial)) { %>
        <span class="selectedInitial"><%= initials.get(i) %></span>
        <% } else { %>
        <a class="initial" href="javascript:changeInitial('<%= initials.get(i) %>');"><%= initials.get(i) %></a>
        <% } %>
        <% } %>
    </nav>

    <section id="box" class="clearfix">
        <!-- Controlla se ci sono utenti -->
        <% if (numUtenti == 0) { %>
        <p>Nessun fighter disponibile.</p>
        <% } else { %>
        <!--LISTA DEGLI UTENTI DA MOSTRARE-->
        <% for (i = 0; i < numUtenti; i++) { %>
        <article>
            <h1><%= utenti.get(i).getNomeUtente() %> <%= utenti.get(i).getCognome() %></h1>
            <span class="email"><%= utenti.get(i).getEmail() %></span>
            <address>
                <%= utenti.get(i).getVia() %> n.<%= utenti.get(i).getNumeroCivico() %><br/>
                <%= utenti.get(i).getCittà() %>, <%= utenti.get(i).getNazione() %><br/>
            </address>
            <% if(!utenti.get(i).isAdmin()) { %>
            <p>Ordini effettuati: <%= (numeroOrdini != null && i < numOrdini) ? numeroOrdini.get(i) : 0 %></p>
            <% } else { %>
            <p>Admin</p>
            <% } %>

            <!--BOTTONI PER BLOCCARE O SBLOCCARE UN UTENTE-->
            <% if(!utenti.get(i).isBlocked()) { %>
            <a class="button" href="javascript:bloccaUtente('<%= utenti.get(i).getEmail() %>');">Blocca</a>
            <% } else { %>
            <a class="button" href="javascript:sbloccaUtente('<%= utenti.get(i).getEmail() %>');">Sblocca</a>
            <% } %>
        </article>
        <% } %>
        <% } %>
    </section>

    <!--FORM PER CAMBIARE IL FILTRO DEGLI UTENTI IN BASE ALL'INIZIALE SELEZIONATA-->
    <form name="changeInitialForm" method="post" action="Dispatcher">
        <input type="hidden" name="selectedInitial"/>
        <input type="hidden" name="controllerAction" value="HomeManagement.view"/>
    </form>

    <!--FORM PER BLOCCARE L'UTENTE SELEZIONATO-->
    <form name="bloccaUtenteForm" method="post" action="Dispatcher">
        <input type="hidden" name="selectedInitial" value="<%= selectedInitial %>"/>
        <input type="hidden" name="email"/>
        <input type="hidden" name="controllerAction" value="HomeManagement.bloccaUtente"/>
    </form>

    <!--FORM PER SBLOCCARE L'UTENTE SELEZIONATO-->
    <form name="sbloccaUtenteForm" method="post" action="Dispatcher">
        <input type="hidden" name="selectedInitial" value="<%= selectedInitial %>"/>
        <input type="hidden" name="email"/>
        <input type="hidden" name="controllerAction" value="HomeManagement.sbloccaUtente"/>
    </form>

</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>
