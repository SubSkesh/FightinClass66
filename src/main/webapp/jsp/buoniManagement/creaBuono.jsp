<%--
    Document   : creaBuono
    Created on : 5-mar-2024, 14.54.22
    Author     : Oscar Costqnzelli
--%>

<%@page session = "false"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Gestione dell'attributo loggedOn con controllo su null
    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = (loggedOnAttr != null) ? loggedOnAttr : false;

    // Carico i cookie
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    if (ul == null) {
        ul = new LoggedUser();
        ul.setNomeUtente("Utente");
        ul.setCognome("Sconosciuto");
    }

    String applicationMessage = (String) request.getAttribute("applicationMessage");

    String menuActiveLink = "Crea Buoni";
%>
<!DOCTYPE html>
<html lang="it-IT">
<head>
    <script language="javascript">
        function validateAndSubmit() {
            var nomeBuono = document.creaBuono.nomeBuono.value;
            var sconto = document.creaBuono.sconto.value;
            var dataScadenza = document.creaBuono.dataScadenza.value;
            var quantita = document.creaBuono.quantita.value;
            var codiceBuono=document.creaBuono.codiceBuono.value;


            // Controllo il campo nome
            if (!nomeBuono.trim()) {
                alert("Il campo Nome è obbligatorio");
                document.creaBuono.nomeBuono.focus();
                return false;
            }

            // Controllo il campo sconto e verifica se è un numero valido
            else if (!sconto.trim() || isNaN(sconto) || sconto <= 0 || sconto > 100) {
                alert("Il campo Sconto deve essere un numero valido tra 1 e 100");
                document.creaBuono.sconto.focus();
                return false;
            }

            // Controllo il campo data
            else if (!dataScadenza.trim()) {
                alert("Il campo Data è obbligatorio");
                document.creaBuono.dataScadenza.focus();
                return false;
            }

            // Controllo il campo quantità e verifica se è un numero valido
            else if (!quantita.trim() || isNaN(quantita) || quantita <= 0) {
                alert("Il numero di buoni deve essere un numero positivo");
                document.creaBuono.quantita.focus();
                return false;
            }
            if (!codiceBuono.trim()) {
                alert("Il campo codice buono è obbligatorio");
                document.creaBuono.nomeBuono.focus();
                return false;
            }

            // Invio il modulo
            else {
                document.creaBuono.submit();
            }
        }

        function goBack() {
            document.backForm.submit();
        }

        function mainOnLoadHandler() {
            document.creaBuono.backButton.addEventListener("click", goBack);
            document.creaBuono.submitButton.addEventListener("click", validateAndSubmit);
        }
    </script>


    <%@include file="/include/htmlHead.jsp" %>

</head>
<body onload="mainOnLoadHandler()">

<header>
    <%@include file="/include/HeaderAdmin.jsp"%>
</header>

<hr>

<main>
    <div class='nome'>
        <p>Benvenuto <%= ul.getNomeUtente() %> <%= ul.getCognome() %></p>
    </div>

    <div class="content">
        <div>
            <h2>CREA BUONO</h2>
        </div>

        <!-- FORM PER LA CREAZIONE DI NUOVI BUONI -->
        <section>
            <div id = "creaBuonoForm">
                <form name="creaBuono" action="Dispatcher" method="post">
                    <input type="hidden" name="controllerAction" value="BuonoManagement.inserisciBuono"/>
                    <div class="form" >
                        <label for="nomeBuono">Nome: </label>
                        <input type="text" id="nomeBuono" name="nomeBuono" value="" required maxlength="20"/>
                    </div>
                    <div class="form">
                        <label for="sconto">Sconto%: </label>
                        <input type="text" id="sconto" name="sconto" value="" required/>
                    </div>
                    <div class="form">
                        <label for="dataScadenza">Data di Scadenza: </label>
                        <input type="date" id="dataScadenza" name="dataScadenza" max="2030-12-31"/>
                    </div>
                    <div class="form">
                        <label for="codiceBuono">Codice Buono: </label>
                        <input type="text" id="codiceBuono" name="codiceBuono" value="" required maxlength="10"/>
                    </div>
                    <div class="form">
                        <label for="quantita">Numero di buoni da generare: </label>
                        <input type="text" id="quantita" name="quantita" value="" required/>
                    </div>
                    <div>
                        <input type="button" name="submitButton" value="Genera" class="button">
                        <input type="button" name="backButton" value="Annulla" class="button">
                    </div>
                </form>

                <!-- FORM PER ANNULLARE -->
                <form name="backForm" method="post" action="Dispatcher">
                    <input type="hidden" name="controllerAction" value="BuonoManagement.view"/>
                </form>
            </div>
        </section>
    </div>

</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>
