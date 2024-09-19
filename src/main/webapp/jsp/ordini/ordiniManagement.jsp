<%--
    Document   : ordiniManager
    Created on : 5-mar-2024, 14.56.48
    Author     : oscar costanzelli
--%>

<%@page session = "false"%>
<%@page import="model.mo.Ordine"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.session.mo.Carrello"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int i=0, j=0;

    ArrayList<Ordine> ordini = (ArrayList<Ordine>) request.getAttribute("ordini");
    int numOrdini;
    if(ordini == null || ordini.isEmpty()){  // Aggiungiamo un controllo per gestire i casi in cui l'array è nullo o vuoto
        numOrdini = 0;
    }else{
        numOrdini = ordini.size();
    }

    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = (loggedOnAttr != null) ? loggedOnAttr : false;

    /*Carico i cookie*/
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    if (ul == null) {
        ul = new LoggedUser();
        ul.setNomeUtente("Admin");
        ul.setCognome("Sconosciutogomedov");
    }

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
        function statoOrdine(index){
            var f = document.forms["aggiornaStato" + index];
            f.submit();
            return;
        }
    </script>
    <style>
        #statoOrdine{
            width: 30%;
            height: 22px;
            font-size: medium;
        }
    </style>

    <%@include file="/include/htmlHead.jsp" %>

</head>
<body>

<header>
    <%@include file="/include/HeaderAdmin.jsp"%>
</header>

<hr>

<main>
    <div class="nome" style="margin-bottom: 15px;">
        <p>Benvenuto <%=ul.getNomeUtente()%> <%=ul.getCognome()%></p>
    </div>

    <!-- GESTIONE DEL CASO IN CUI NON CI SIANO ORDINI -->
    <% if (numOrdini == 0) { %>
    <div class="alert alert-info">
        <p>Non ci sono ordini da visualizzare.</p>
    </div>
    <% } else { %>

    <!-- LISTA DEGLI ORDINI DA VISUALIZZARE -->
    <% for(i=0 ; i<numOrdini ; i++){ %>

    <article>
        <hr>
        <div class="clearfix" style="margin-top: 15px; margin-bottom: 15px;">
            <div style="float: left; width: 60%">

                <% for(j=0 ; j<ordini.get(i).getContiene().size() ; j++){ %>
                <div class="clearfix">

                    <!--IMMAGINE DEL PRODOTTO-->
                    <div style="float: left; padding-left: 2%; padding-right: 2%;">
                        <img id="ProdImage" src="images/<%=ordini.get(i).getContiene().get(j).getProdotto().getImmagine()%>" width="186" height="186"/>
                    </div>

                    <!--INFORMAZIONI DEL PRODOTTO-->
                    <div style="float: left; padding-left: 2%; padding-right: 2%; padding-top: 50px;">
                        <p><b><%=ordini.get(i).getContiene().get(j).getProdotto().getNomeProdotto()%></b></br>
                            Prezzo unitario: €<%=ordini.get(i).getContiene().get(j).getProdotto().getPrezzo()%></br>
                            Quantit&agrave;: <%=ordini.get(i).getContiene().get(j).getQuantitàOrdine()%></p>
                    </div>

                </div>
                <% } %>
            </div>

            <!-- INFORMAZIONI GENERALI DELL'ORDINE -->
            <div style="float: left; width: 40%">
                <h3>Dettagli ordine</h3><br>
                <p><b>Cliente:</b> <%=ordini.get(i).getUtente().getNomeUtente()%> <%=ordini.get(i).getUtente().getCognome()%></p>
                <p><b>Data ordine: </b><%=ordini.get(i).getDataOrdineString()%></br>
                    <b>Data consegna: </b><%=ordini.get(i).getDataConsegnaString()%></br>
                    <b>Indirizzo di consegna: </b><%=ordini.get(i).getVia()%> n° <%=ordini.get(i).getNumeroCivico()%>, <%=ordini.get(i).getCittà()%>, <%=ordini.get(i).getNazione()%></br>
                    <b>Importo:</b> €<%=ordini.get(i).getPagamento().getImporto()%></br></p>

                <% if (ordini.get(i).getStatoOrdine().equalsIgnoreCase("consegnato")) { %>
                <p style="color: green">Consegnato</p>
                <% } else { %>
                <p style="color: orangered"><%=ordini.get(i).getStatoOrdine()%></p>
                <% } %>

                <!-- FORM PER LA MODIFICA DELLO STATO DELL'ORDINE -->
                <% if (!ordini.get(i).getStatoOrdine().equalsIgnoreCase("consegnato")) { %>
                <form name="aggiornaStato<%=i%>" action="Dispatcher" method="post">
                    <input type="hidden" name="codiceOrdine" value="<%=ordini.get(i).getCodiceOrdine()%>"/>
                    <select id="stato" name="stato" onchange="statoOrdine(<%=i%>)">
                        <label for="stato">Stato: </label>
                        <option value="In preparazione" <% if (ordini.get(i).getStatoOrdine().equalsIgnoreCase("In preparazione")) { %>selected="selected"<% } %>>In preparazione</option>
                        <option value="In viaggio" <% if (ordini.get(i).getStatoOrdine().equalsIgnoreCase("In viaggio")) { %>selected="selected"<% } %>>In viaggio</option>
                        <option value="Consegnato" <% if (ordini.get(i).getStatoOrdine().equalsIgnoreCase("Consegnato")) { %>selected="selected"<% } %>>Consegnato</option>
                    </select>
                    <input type="hidden" name="controllerAction" value="Ordini.aggiornaStato"/>
                </form>
                <% } %>
            </div>
        </div>
    </article>

    <% } %>

    <% } %>

</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>
