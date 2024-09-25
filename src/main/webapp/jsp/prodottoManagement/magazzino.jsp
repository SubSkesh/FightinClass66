<%@page session = "false"%>
<%@page import="model.mo.Prodotto"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int i = 0;

    // Gestione del prodotto per evitare null pointer exceptions
    ArrayList<Prodotto> prodotti = (ArrayList<Prodotto>) request.getAttribute("prodotti");
    int numeroProdotti = (prodotti != null) ? prodotti.size() : 0;

    // Verifica se l'utente è loggato
    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = (loggedOnAttr != null) ? loggedOnAttr : false;

    // Gestione dell'utente loggato per evitare null pointer exceptions
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    if (ul == null) {
        ul = new LoggedUser(); // Crea un utente vuoto se non esiste
        ul.setNomeUtente("Fighter");
        ul.setCognome("Sconosciuto");
    }

    // Messaggio applicativo, se non presente imposta un valore di default
    String applicationMessage = (String) request.getAttribute("applicationMessage");
    if (applicationMessage == null) {
        applicationMessage = "Nessun messaggio disponibile.";
    }

    String menuActiveLink = "Magazzino";
%>
<!DOCTYPE html>
<html lang="it-IT">
<head>
    <script language="javascript">
        function prodottoFormSubmit(index, codice){
            var form = document.forms["prodottoForm" + index];
            form.idProdotto.value = codice;
            form.submit();
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
    <!-- Messaggio Applicativo -->
    <% if(applicationMessage != null && !applicationMessage.isEmpty()) { %>
    <div class="messaggio">
        <p><%= applicationMessage %></p>
    </div>
    <% } %>

    <!-- FORM PER INSERIRE UN NUOVO PRODOTTO -->
    <form name="inserisciProdotto" action="Dispatcher" method="post">
        <input type="hidden" name="controllerAction" value="ProdottoManagement.inserisciProdottoView"/>
        <input type="submit" value="Nuovo prodotto" class="mainButton">
    </form>

    <!-- LISTA PRODOTTI NEL MAGAZZINO -->
    <section class="clearfix" id="boxMagazzino">
        <% for(i = 0; i < numeroProdotti; i++) { %>
        <article>

            <div>
                <!-- IMMAGINE SULLA SINISTRA -->
                <div style="float: left; margin-right: 50px;">
                    <form name="prodottoForm<%= i %>" action="Dispatcher" method="post">
                        <input type="hidden" name="idProdotto"  value="<%= prodotti.get(i).getId() %>"/>
                        <input type="hidden" name="controllerAction" value="ProdottoManagement.modificaProdottoView"/>

                        <a href="javascript:prodottoFormSubmit(<%= i %> <%= prodotti.get(i).getId() %>);">
                            <img id="ProdImage" src="<%= request.getContextPath() %>/images/<%= prodotti.get(i).getImmagine() %>" width="170" height="170" alt="Visualizza prodotto"/>
                        </a>
                    </form>
                </div>

                <!-- INFORMAZIONI DEL PRODOTTO -->
                <div style="float: left; margin-top: 2%;">
                    <p><b>Nome Prodotto:</b> <%= prodotti.get(i).getNomeProdotto() %></p>
                    <p><b>Categoria:</b> <%= prodotti.get(i).getCategoria() %></p>
                    <p><b>Materiale:</b> <%= prodotti.get(i).getMateriale() %></p>
                    <p><b>Taglia:</b> <%= prodotti.get(i).getTaglia() %></p>
<%--                    <p><b>Prezzo:</b> €<%= prodotti.get(i).getPrezzo() %></p>--%>
                    <p><b>Prezzo:</b> €<%= String.format("%.2f", prodotti.get(i).getPrezzo()) %></p>

                    <p><b>Quantità:</b><%= prodotti.get(i).getQuantita() %></p>


                    <!-- FORM PER IL BLOCCO/SBLOCCO DEL PRODOTTO -->
                    <div style="float: left;">
                        <% if(prodotti.get(i).isBlocked()) { %>
                        <form name="sbloccaProdotto<%= i %>" action="Dispatcher" method="post">
                            <input type="hidden" name="idProdotto" value="<%= prodotti.get(i).getId() %>"/>
                            <input type="hidden" name="controllerAction" value="ProdottoManagement.sbloccaProdotto"/>
                            <input type="submit" value="Sblocca" class="button">
                        </form>
                        <% } else { %>
                        <form name="bloccaProdotto<%= i %>" action="Dispatcher" method="post">
                            <input type="hidden" name="idProdotto" value="<%= prodotti.get(i).getId() %>"/>
                            <input type="hidden" name="controllerAction" value="ProdottoManagement.bloccaProdotto"/>
                            <input type="submit" value="Blocca" class="button">
                        </form>
                        <% } %>
                    </div>
                    <div style="float: left;">

                        <form name="modificaProdotto<%= i %>" action="Dispatcher" method="post">
                            <input type="hidden" name="idProdotto" value="<%= prodotti.get(i).getId() %>"/>
                            <input type="hidden" name="controllerAction" value="ProdottoManagement.modificaProdottoView"/>
                            <input type="submit" value="Modifica" class="button">
                        </form>


                    </div>
                </div>

            </div>

        </article>
        <% } %>
    </section>

</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>
