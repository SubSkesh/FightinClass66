<%--
    Document   : ordini
    Created on : 5-mar-2024, 14.56.34
    Author     : Oscar Costanzelli
--%>

<%@page session = "false"%>
<%@page import="model.mo.Ordine"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.session.mo.Carrello"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int i=0, j=0;

    // Recupera gli ordini e gestisci il valore null
    ArrayList<Ordine> ordini = (ArrayList<Ordine>) request.getAttribute("ordini");
    int numOrdini = (ordini != null) ? ordini.size() : 0;

    // Verifica se l'utente è loggato
    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = (loggedOnAttr != null) ? loggedOnAttr : false;

    // Gestione dell'utente loggato per evitare null pointer exceptions
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    if (ul == null) {
        ul = new LoggedUser(); // Crea un utente vuoto se non esiste
        ul.setNomeUtente("Utente");
        ul.setCognome("Sconosciutogomedov");
    }

    // Messaggio applicativo, se non presente imposta un valore di default
    String applicationMessage = (String) request.getAttribute("applicationMessage");
    if (applicationMessage == null) {
        applicationMessage = "Nessun messaggio disponibile.";
    }

    String menuActiveLink = "Ordini";
%>
<!DOCTYPE html>
<html lang="it-IT">
<head>
    <script language="javascript">
        function prodottoFormSubmit(indexi, indexj){
            var f = document.forms["prodottoForm" + indexi + indexj];
            f.submit();
            return;
        }
    </script>
    <style>
        #stato {
            width: 30%;
            height: 22px;
            font-size: medium;
        }
    </style>

    <%@include file="/include/htmlHead.jsp" %>

</head>
<body>

<header>
    <%@include file="/include/HeaderUtente.jsp"%>
</header>

<hr>

<main>
    <div class="nome" style="margin-bottom: 15px;">
        <p>Benvenuto <%= ul.getNomeUtente() %> <%= ul.getCognome() %></p>
    </div>

    <!-- Controllo se ci sono ordini -->
    <% if (numOrdini == 0) { %>
    <p>Non hai effettuato ordini.</p>
    <% } else { %>
    <!-- LISTA DEGLI ORDINI DA VISUALIZZARE -->
    <% for (i = 0; i < numOrdini; i++) { %>

    <article>
        <hr>
        <div class="clearfix" style="margin-top: 15px; margin-bottom: 15px;">
            <div style="float: left; width: 60%">

                <!-- Mostra i prodotti dell'ordine -->
                <% for (j = 0; j < ordini.get(i).getContiene().size(); j++) { %>
                <div class="clearfix">

                    <!-- IMMAGINE DEL PRODOTTO E FORM PER ANDARE SULLA PAGINA DI VISUALIZZAZIONE DEL PRODOTTO -->
                    <div style="float: left; padding-left: 2%; padding-right: 2%;">
                        <form name="prodottoForm<%=i%><%=j%>" action="Dispatcher" method="post">
                            <input type="hidden" name="controllerAction" value="Catalogo.viewProdotto"/>
                            <input type="hidden" name="idProdotto" value="<%= ordini.get(i).getContiene().get(j).getProdotto().getId() %>"/>
                            <a href="javascript:prodottoFormSubmit(<%=i%> <%=j%>);">
                                <img id="ProdImage" src="images/<%= ordini.get(i).getContiene().get(j).getProdotto().getImmagine() %>" width="186" height="186" alt="Visualizza prodotto"/>
                            </a>
                        </form>
                    </div>

                    <!-- INFORMAZIONI DEL PRODOTTO -->
                    <div style="float: left; padding-left: 2%; padding-right: 2%; padding-top: 50px;">
                        <p><b><%= ordini.get(i).getContiene().get(j).getProdotto().getNomeProdotto() %></b><br>
                            Prezzo unitario: €<%= ordini.get(i).getContiene().get(j).getProdotto().getPrezzo() %><br>
                            Quantità: <%= ordini.get(i).getContiene().get(j).getQuantitàOrdine() %></p>
                    </div>

                </div>
                <% } %>
            </div>

            <!-- INFORMAZIONI GENERALI DELL'ORDINE -->
            <div style="float: left; width: 40%">
                <h3>Dettagli ordine</h3><br>
                <p><b>Data ordine: </b><%= ordini.get(i).getDataOrdineString() %><br>
                    <b>Data consegna: </b><%= ordini.get(i).getDataConsegnaString() %><br>
                    <b>Indirizzo di consegna: </b><%= ordini.get(i).getVia() %> n° <%= ordini.get(i).getNumeroCivico() %>, <%= ordini.get(i).getCittà() %>, <%= ordini.get(i).getNazione() %><br>
                    <b>Importo:</b> €<%= ordini.get(i).getPagamento().getImporto() %><br></p>
                <% if (ordini.get(i).getStatoOrdine().equalsIgnoreCase("consegnato")) { %>
                <p style="color: green">Consegnato</p>
                <% } else { %>
                <p style="color: orangered"><%= ordini.get(i).getStatoOrdine() %></p>
                <% } %>
            </div>
        </div>
    </article>

    <% } %>
    <% } %>

</main>

<%@include file="/include/footer.jsp" %>

</html>
