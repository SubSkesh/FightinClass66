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
<!DOCTYPE html>
<html lang="it-IT">
<%@include file="/include/htmlHead.jsp" %>
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
</head>
<body>
<header>
    <%@include file="/include/HeaderAdmin.jsp"%>
</header>

<hr>

    <main>
    <div class="admin-welcome">
        <p>Benvenuto <%=ul.getNomeUtente()%> <%=ul.getCognome()%></p>
        <img src="${pageContext.request.contextPath}/images/result.png" alt="Welcome Image" class="welcome-image">

    </div>

    <% if (applicationMessage != null && !applicationMessage.isEmpty()) { %>
    <div id="admin-alert-info">
        <p><%= applicationMessage %></p>
    </div>
    <% } %>

    <div id="admin-content">
        <!-- FORM PER GESTIONE ORDINI -->
        <div class="image">
            <form name="ordini" action="Dispatcher" method="post">
                <input type="hidden" name="controllerAction" value="Ordini.view"/>
                <a href="javascript:ordiniSubmit();">
                    <img src="${pageContext.request.contextPath}/images/Ordini.png" alt="Ordini"/>
                    <br><p><b>Gestione Ordini</b></p>
                </a>
            </form>
        </div>

        <!-- FORM PER GESTIONE UTENTI -->
        <div class="image">
            <form name="utentiManagement" action="Dispatcher" method="post">
                <input type="hidden" name="controllerAction" value="HomeManagement.view"/>
                <a href="javascript:UtentiManagementSubmit();">
                    <img src="${pageContext.request.contextPath}/images/Utenti.png" alt="Utenti"/>
                    <br><p><b>Gestione Utenti</b></p>
                </a>
            </form>
        </div>

        <!-- FORM PER GESTIONE MAGAZZINO -->
        <div class="image">
            <form name="magazzino" action="Dispatcher" method="post">
                <input type="hidden" name="controllerAction" value="ProdottoManagement.view"/>
                <a href="javascript:magazzinoSubmit();">
                    <img src="${pageContext.request.contextPath}/images/Magazzino.png" alt="Magazzino"/>
                    <br><p><b>Gestione Magazzino</b></p>
                </a>
            </form>
        </div>

        <!-- FORM PER GESTIONE BUONI -->
        <div class="image">
            <form name="buoni" action="Dispatcher" method="post">
                <input type="hidden" name="controllerAction" value="BuonoManagement.view"/>
                <a href="javascript:buoniSubmit();">
                    <img src="${pageContext.request.contextPath}/images/Buoni.png" alt="Buoni"/>
                    <br><p><b>Gestione Buoni</b></p>
                </a>
            </form>
        </div>
    </div>
</main>

<footer id="admin-footer">
    <%@include file="/include/footer.jsp" %>
</footer>

</body>
</html>

