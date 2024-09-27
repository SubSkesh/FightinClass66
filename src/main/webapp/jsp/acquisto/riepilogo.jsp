<%--
    Document   : riepilogo
    Created on : 5-mar-2024, 14.33.43
    Author     : Oscar Costanzelli
--%>

<%@page session="false"%>
<%@page import="model.mo.Buono"%>
<%@page import="model.mo.Prodotto"%>
<%@page import="model.session.mo.Carrello"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Recupera gli attributi dalla richiesta con controllo sui null
    String nazione = (String) request.getAttribute("nazione");
    if (nazione == null) nazione = "Nazione non specificata";

    String citta = (String) request.getAttribute("citta");
    if (citta == null) citta = "Città non specificata";

    String via = (String) request.getAttribute("via");
    if (via == null) via = "Via non specificata";

    Long numeroCivicoObj = (Long) request.getAttribute("numeroCivico");
    long numeroCivico = (numeroCivicoObj != null) ? numeroCivicoObj : 0; // Valore di default

    Integer capObj = (Integer) request.getAttribute("CAP");
    int CAP = (capObj != null) ? capObj : 0; // Valore di default

    String cartaPagamento = (String) request.getAttribute("cartaPagamento");
    if (cartaPagamento == null) cartaPagamento = "Carta non specificata";

//    Double prezzoObj = (Double) request.getAttribute("prezzo");
//    double prezzo = (prezzoObj != null) ? prezzoObj : 0.0; // Valore di default
    Double prezzoObj = (Double) request.getAttribute("prezzoTotale");
    double prezzo = (prezzoObj != null) ? prezzoObj : 0.0; // Valore di default

    Boolean buonoPresenteObj = (Boolean) request.getAttribute("buonoPresente");
    boolean buonoPresente = (buonoPresenteObj != null) ? buonoPresenteObj : false;

    Buono buono = (Buono) request.getAttribute("buono");
    String codiceBuono = null;
    if (buonoPresente && buono != null) {
        codiceBuono = buono.getCodiceBuono();
    }

    ArrayList<Prodotto> prodotti = (ArrayList<Prodotto>) request.getAttribute("prodotti");
    if (prodotti == null) prodotti = new ArrayList<>(); // Valore di default

    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");
    if (carrello == null) carrello = new ArrayList<>(); // Valore di default

    int numProdotto = prodotti.size();

    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    if (ul == null) {
        ul = new LoggedUser(); // Crea un utente vuoto se non esiste
        ul.setNomeUtente("Utente");
        ul.setCognome("Sconosciuto");
    }

    String applicationMessage = (String) request.getAttribute("applicationMessage");
%>

<!DOCTYPE html>
<html lang="it-IT">
<head>
    <script language="javascript">
        function procedi(){
            var f = document.paga;
            f.submit();
        }

        function goBack(){
            var f = document.annulla;
            f.submit();
        }

        function mainOnLoadHandler(){
            document.paga.submitButton.addEventListener("click", procedi);
            document.paga.backButton.addEventListener("click", goBack);
        }
    </script>
    <!-- Inclusione del foglio di stile CSS esterno -->
    <%@include file="/include/htmlHead.jsp" %>
</head>
<body>

<header>
    <%@include file="/include/HeaderUtente.jsp" %>
</header>

<hr>

<main>
    <div id="riepilogoBenvenuto" class='nome'>
        <p>Benvenuto <%= ul.getNomeUtente() %> <%= ul.getCognome() %></p>
    </div>

    <% if (applicationMessage != null) { %>
    <div id="riepilogoMessage" class="alert alert-danger" style="margin-top: 20px;">
        <%= applicationMessage %>
    </div>
    <% } %>

    <div id="riepilogoTitle" style="margin-top: 15px; margin-bottom: 15px;">
        <h2>Step 2: Riepilogo pagamento</h2>
    </div>

    <div id="riepilogoContainer" class="clearfix">
        <!-- LATO SINISTRO: Conferma Dati Ordine -->
        <div class="indirizzo" id="riepilogoIndirizzo">
            <h3>Indirizzo di consegna</h3>
            <br/>
            <address id="riepilogoAddress"><%= via %> n. <%= numeroCivico %>, <%= citta %>, <%= nazione %><br/>CAP: <%= CAP %></address>
            <br/>
            <h3>Dati carta</h3>
            <br/>
            <p id="riepilogoCarta">Numero carta di credito: <%= cartaPagamento %></p>

            <% if (buonoPresente) { %>
            <br/>
            <h3>Dati buono sconto</h3>
            <br/>
            <p id="riepilogoCodiceBuono">Codice buono sconto: <%= codiceBuono != null ? codiceBuono : "Non disponibile" %></p>
            <p id="riepilogoSconto">Sconto applicato: <%= buono != null ? buono.getSconto() : "0" %>%</p>
            <% } %>
        </div>

        <!-- LATO DESTRO: Prodotti Inclusi nell'Ordine -->
        <div class="pagamento" id="riepilogoProdotti">
            <h3>Lista prodotti inclusi nell'ordine</h3>
            <br/>
            <% if (numProdotto == 0) { %>
            <p id="riepilogoNessunProdotto">Nessun prodotto nel carrello.</p>
            <% } else { %>
            <% for (int i = 0; i < numProdotto; i++) { %>
            <p class="riepilogoProdotto">
                <b id="riepilogoNomeProdotto"><%= prodotti.get(i).getNomeProdotto() %></b><br/>
                Quantità: <%= carrello.get(i).getQuantità() %><br/>
                Prezzo unitario: €<%= String.format("%.2f", prodotti.get(i).getPrezzo()) %><br/><br/>
            </p>
            <% } %>
            <% } %>
            <p id="riepilogoPrezzoFinale"><b>Prezzo finale:</b> €<%= prezzo %></p>
        </div>

        <!-- BOTTONI -->
        <div id="riepilogoBottoni" style="clear: both;">
            <div class="left">
                <form id="pagaForm" name="paga" action="Dispatcher" method="post">
                    <input type="hidden" name="controllerAction" value="Acquisto.paga"/>
                    <input type="hidden" name="cartaPagamento" value="<%= cartaPagamento %>"/>
                    <input type="hidden" name="nazione" value="<%= nazione %>"/>
                    <input type="hidden" name="citta" value="<%= citta %>"/>
                    <input type="hidden" name="via" value="<%= via %>"/>
                    <input type="hidden" name="numeroCivico" value="<%= numeroCivico %>"/>
                    <input type="hidden" name="CAP" value="<%= CAP %>"/>
                    <input type="hidden" name="prezzoTotale" value="<%= prezzo %>"/>
                    <% if (buonoPresente) { %>
                    <input type="hidden" name="buonoPresente" value="S"/>
                    <input type="hidden" name="codiceBuono" value="<%= codiceBuono %>"/>
                    <% } else { %>
                    <input type="hidden" name="buonoPresente" value="N"/>
                    <% } %>
                    <input type="button" id="submitButton" name="submitButton" value="Paga" class="button">
                    <input type="button" id="backButton" name="backButton" value="Annulla" class="button">
                </form>
            </div>
        </div>
    </div>

    <!-- FORM DI ANNULLA => Torna alla Vista del Carrello -->
    <form id="annullaForm" name="annulla" action="Dispatcher" method="post">
        <input type="hidden" name="controllerAction" value="Acquisto.ordina"/>
    </form>
</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>
