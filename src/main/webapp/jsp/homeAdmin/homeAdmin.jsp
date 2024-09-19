<%--
    Document   : homeAdmin
    Created on : 5-mar-2020, 14.55.28
    Author     : Utente
--%>

<%@page session = "false"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int i = 0;

    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = (loggedOnAttr != null) ? loggedOnAttr : false; // Se nullo, imposta a false

    /*Carico i cookie*/
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    if (ul == null) {
        ul = new LoggedUser(); // Crea un utente vuoto se non esiste
        ul.setNomeUtente("Amministratore");
        ul.setCognome("Sconosciuto");
    }

    String applicationMessage = (String) request.getAttribute("applicationMessage");
    if (applicationMessage == null) {
        applicationMessage = "Nessun messaggio disponibile.";
    }

    String menuActiveLink = "Home amministratore";
%>

<!DOCTYPE html>
<html lang="it-IT">
<head>
    <script language="javascript">
        function UtentiManagementSubmit(){
            var f = document.utentiManagement;
            f.submit();
        }

        function ordiniSubmit(){
            var f = document.ordini;
            f.submit();
        }

        function magazzinoSubmit(){
            var f = document.magazzino;
            f.submit();
        }

        function buoniSubmit(){
            var f = document.buoni;
            f.submit();
        }
    </script>
    <style>
        .content {
            margin-top: 15px;
            margin-left: 5%;
            width: 90%;
        }

        .image {
            width: 25%;
            float: left;
        }

        #linkImage {
            width: 150px;
            height: 150px;
            margin-left: 22%;
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
    <div class='nome'>
        <p>Benvenuto <%=ul.getNomeUtente()%> <%=ul.getCognome()%></p>
    </div>

    <% if (applicationMessage != null && !applicationMessage.isEmpty()) { %>
    <div class="alert alert-info">
        <p><%= applicationMessage %></p>
    </div>
    <% } %>

    <div class="content">
        <!-- FORM PER PASSARE ALLA SCHERMATA DI GESTIONE ORDINI -->
        <div class="image">
            <form name="ordini" action="Dispatcher" method="post">
                <input type="hidden" name="controllerAction" value="Ordini.view"/>
                <a href="javascript:ordiniSubmit();">
                    <img id="linkImageOrdini" src="${pageContext.request.contextPath}/images/Ordini.png" width="300" height="300" alt="Ordini"/>
                    </br><p style="text-align: center"><b>GESTIONE ORDINI</b></p>
                </a>
            </form>
        </div>

        <!-- FORM PER PASSARE ALLA SCHERMATA DI GESTIONE UTENTI -->
        <div class="image">
            <form name="utentiManagement" action="Dispatcher" method="post">
                <input type="hidden" name="controllerAction" value="HomeManagement.view"/>
                <a href="javascript:UtentiManagementSubmit();">
                    <img id="linkImageUtenti" src="${pageContext.request.contextPath}/images/Utenti.png" width="300" height="300" alt="Utenti"/></br><p style="text-align: center"><b>GESTIONE UTENTI</b></p>
                </a>
            </form>
        </div>

        <!-- FORM PER PASSARE ALLA SCHERMATA DI GESTIONE PRODOTTI -->
        <div class="image">
            <form name="magazzino" action="Dispatcher" method="post">
                <input type="hidden" name="controllerAction" value="ProdottoManagement.view"/>
                <a href="javascript:magazzinoSubmit();">
                    <img id="linkImageMagazzino" src="${pageContext.request.contextPath}/images/Magazzino.png" width="300" height="300" alt="Magazzino"/></br><p style="text-align: center"><b>GESTIONE MAGAZZINO</b></p>
                </a>
            </form>
        </div>

        <!-- FORM PER PASSARE ALLA SCHERMATA DI GESTIONE BUONI -->
        <div class="image">
            <form name="buoni" action="Dispatcher" method="post">
                <input type="hidden" name="controllerAction" value="BuonoManagement.view"/>
                <a href="javascript:buoniSubmit();">
                    <img id="linkImageBuoni" src="${pageContext.request.contextPath}/images/Buoni.png" width="300" height="300" alt="Buoni"/></br><p style="text-align: center"><b>GESTIONE BUONI</b></p>
                </a>
            </form>
        </div>
    </div>

    <div style="clear: both; margin-bottom: 15px;"></div>

</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>
