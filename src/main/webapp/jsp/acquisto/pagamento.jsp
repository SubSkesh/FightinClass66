<%-- 
    Document   : pagamento
    Created on : 5-mar-2024, 14.33.34
    Author     : Oscar Costanzelli
--%>

<%@page session="false"%>
<%@page import="model.session.mo.Carrello"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Impostazione del titolo della pagina
    String menuActiveLink = "Modulo ordine";
    request.setAttribute("menuActiveLink", menuActiveLink);
    System.out.println("menuActiveLink: " + menuActiveLink);

    // Recupero degli attributi dalla richiesta
    boolean loggedOn = false;
    LoggedUser loggedUser = null;
    if (request.getAttribute("loggedUser") != null) {
        loggedUser = (LoggedUser) request.getAttribute("loggedUser");
        loggedOn = true;
    }

    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");

    String applicationMessage = (String) request.getAttribute("applicationMessage");
    request.setAttribute("applicationMessage", applicationMessage);
    System.out.println("menuActiveLink: " + menuActiveLink);
%>
<!DOCTYPE html>
<html lang="it">
<jsp:include page="/include/htmlHead.jsp" />
<body>
<header>
    <%
        if (loggedOn && loggedUser.isAdmin()) {
    %>
    <jsp:include page="/include/HeaderAdmin.jsp" />
    <%
    } else {
    %>
    <jsp:include page="/include/HeaderUtente.jsp" />
    <%
        }
    %>
</header>

<!-- Includi le funzioni JavaScript -->
<script language="javascript">
    function procedi(){
        var campi = true;
        var f = document.pagamentoForm;

        var cartaPagamento = f.cartaPagamento.value;
        var nazione = f.nazione.value;
        var citta = f.citta.value;
        var via = f.via.value;
        var numeroCivico = f.numeroCivico.value;
        var CAP = f.CAP.value;

        /*CONTROLLO IL CAMPO CARTA*/
        if ((cartaPagamento == "") || (cartaPagamento == "undefined")) {
            alert("Il campo Carta è obbligatorio");
            campi = false;
        }

        /*CONTROLLO IL CAMPO NAZIONE*/
        if ((nazione == "") || (nazione == "undefined")) {
            alert("Il campo Nazione è obbligatorio");
            campi = false;
        }

        /*CONTROLLO IL CAMPO CITTA*/
        if ((citta == "") || (citta == "undefined")) {
            alert("Il campo Città è obbligatorio");
            campi = false;
        }

        /*CONTROLLO IL CAMPO VIA*/
        if ((via == "") || (via == "undefined")) {
            alert("Il campo Via è obbligatorio");
            campi = false;
        }

        /*CONTROLLO IL CAMPO NUMERO CIVICO*/
        if ((numeroCivico == "") || (numeroCivico == "undefined")) {
            alert("Il campo Numero Civico è obbligatorio");
            campi = false;
        }

        /*CONTROLLO IL CAMPO CAP*/
        if ((CAP == "") || (CAP == "undefined")) {
            alert("Il campo CAP è obbligatorio");
            campi = false;
        }

        if(campi){
            f.controllerAction.value = "Acquisto.procedi";
            if(f.codiceBuono.value === ""){
                f.codiceBuono.value = 0;/*Codice di default se non ne è stato inserito nessuno*/
            }
            f.submit();
        }
    }

    function goBack(){
        var f = document.backForm;
        f.controllerAction.value = "Acquisto.view";
        f.submit();
    }

    function mainOnLoadHandler(){
        document.pagamentoForm.backButton.addEventListener("click", goBack);
        document.pagamentoForm.submitButton.addEventListener("click", procedi);
    }
</script>

<hr>

<main class="container mt-4">
    <div class='nome' style="margin-bottom: 15px;">
        <p>Benvenuto <%= loggedUser != null ? loggedUser.getNomeUtente() + " " + loggedUser.getCognome() : "Combattente" %></p>
    </div>

    <div style="margin-top: 15px; margin-bottom: 15px;">
        <h2>Step 1: Inserimento dati</h2>
    </div>

    <!--FORM PER L'INSERIMENTO DEI DATI PER L'ORDINE-->
    <div class="clearfix">
        <form id="pagamentoForm" name="pagamentoForm" action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post">

            <!--LATO DI SINISTRA DEDICATO ALL'INDIRIZZO DI CONSEGNA-->
            <div class="indirizzo" id="indirizzoConsegna">
                <h3>Indirizzo di consegna</h3>
                <br>

                <div class="form" id="nazioneField">
                    <label for="nazione">Nazione:* </label>
                    <input type="text" id="nazione" name="nazione" value="" maxlength="20" required placeholder="Thailand"/>
                </div>

                <div class="form" id="cittaField">
                    <label for="citta">Città:* </label>
                    <input type="text" id="citta" name="citta" value="" maxlength="20" required placeholder="Bangkok"/>
                </div>

                <div class="form" id="viaField">
                    <label for="via">Via:* </label>
                    <input type="text" id="via" name="via" value="" maxlength="20" required placeholder="Via Yokkao"/>
                </div>

                <div class="form" id="numeroCivicoField">
                    <label for="numeroCivico">Numero civico:* </label>
                    <input type="text" id="numeroCivico" name="numeroCivico" value="" maxlength="11" required placeholder="66"/>
                </div>

                <div class="form" id="capField">
                    <label for="CAP">CAP:* </label>
                    <input type="text" id="CAP" name="CAP" value="" maxlength="5" required placeholder="226622"/>
                </div>
            </div>

            <!--LATO DI DESTRA DEDICATO ALLA CARTA E AL BUONO SCONTO-->
            <div class="pagamento" id="datiPagamento">
                <h3>Dati carta di credito</h3>
                <br>

                <div class="form" id="cartaPagamentoField">
                    <label for="cartaPagamento">Numero carta:* </label>
                    <input type="text" id="cartaPagamento" name="cartaPagamento" value="" maxlength="16" required/>
                </div>

                <br>
                <h3>Dati buono sconto</h3>
                <br>

                <div class="form" id="buonoScontoField">
                    <label for="codiceBuono">Codice buono sconto: </label>
                    <input type="text" id="codiceBuono" name="codiceBuono" value="" maxlength="11"/>
                </div>

                <input type="hidden" name="controllerAction"/>
            </div>

            <div id="formButtons" style="clear: both">
                <input type="button" id="submitButton" name="submitButton" value="Procedi" class="btn btn-primary" style="font-size: medium;">
                <input type="button" id="backButton" name="backButton" value="Annulla" class="btn btn-secondary" style="font-size: medium;">
            </div>

        </form>
    </div>

    <!--FORM DI ANNULLA => TORNO NELLA VISTA DEL CARRELLO-->
    <form name="backForm" method="post" action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher">
        <input type="hidden" name="controllerAction"/>
    </form>

</main>

<%@include file="/include/footer.jsp" %>

        </body>
        </html>
