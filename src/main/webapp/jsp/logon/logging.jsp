<%--
    Document   : logging
    Created on : 5-mar-2024, 14.55.48
    Author     : Oscar Costanzelli
--%>

<%@page session="false"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="model.session.mo.Carrello"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String opzione = (String) request.getAttribute("opzione");
    if (opzione == null) {
        opzione = "L"; // Default a "L" per il login
    }

    Boolean loggedOnAttribute = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = loggedOnAttribute != null ? loggedOnAttribute : false;

    /* Carico i cookie */
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");

    String applicationMessage = (String) request.getAttribute("applicationMessage");

    String adminCreating = (String) request.getAttribute("adminCreating");
    System.out.println("adminCreating in loggingjsp: " + adminCreating); // Debug

    String menuActiveLink = "Logging";
%>
<!DOCTYPE html>
<html lang="it-IT">
<head>

    <script language="javascript">
        var loggedOn = <%= loggedOn %>;
        var opzione = "<%= opzione %>"

        function validateAndSubmit(){
            console.log("validateAndSubmit called with opzione: " + opzione);
            if(opzione === "L"){
                console.log("Processing login");
                document.getElementById('controllerAction').value = "LogOn.logon";
                document.getElementById('registerForm').submit();
            }
            if(opzione === "R"){
                console.log("Processing registration");
                var nomeUtente = document.getElementById('nomeUtente').value;
                var cognome = document.getElementById('cognome').value;
                var email = document.getElementById('email').value;
                var password = document.getElementById('password').value;
                var conferma = document.getElementById('passwordConf').value;
                var nazione = document.getElementById('nazione').value;
                var citta = document.getElementById('citta').value;
                var via = document.getElementById('via').value;
                var numeroCivico = document.getElementById('numeroCivico').value;
                var CAP = document.getElementById('CAP').value;

                /* CONTROLLO IL CAMPO NOME */
                if (nomeUtente === "") {
                    alert("Il campo Nome è obbligatorio");
                    document.getElementById('nomeUtente').focus();
                    return false;
                }

                /* CONTROLLO IL CAMPO COGNOME */
                if (cognome === "") {
                    alert("Il campo Cognome è obbligatorio");
                    document.getElementById('cognome').focus();
                    return false;
                }

                /* CONTROLLO IL CAMPO EMAIL */
                if (email === "") {
                    alert("Il campo E-Mail è obbligatorio");
                    document.getElementById('email').focus();
                    return false;
                }

                if (!checkEmail(email)){
                    alert("Il formato dell'email inserita non è valido");
                    document.getElementById('email').focus();
                    return false;
                }

                /* CONTROLLO IL CAMPO PASSWORD */
                if (password === "") {
                    alert("Il campo Password è obbligatorio");
                    document.getElementById('password').focus();
                    return false;
                }

                /* CONTROLLO IL CAMPO CONFERMA PASSWORD */
                if (conferma === "") {
                    alert("Il campo Conferma password è obbligatorio");
                    document.getElementById('passwordConf').focus();
                    return false;
                }

                if (password !== conferma) {
                    alert("La password confermata è diversa da quella scelta");
                    document.getElementById('passwordConf').value = "";
                    document.getElementById('passwordConf').focus();
                    return false;
                }

                /* CONTROLLO IL CAMPO NAZIONE */
                if (nazione === "") {
                    alert("Il campo Nazione è obbligatorio");
                    document.getElementById('nazione').focus();
                    return false;
                }

                /* CONTROLLO IL CAMPO CITTA */
                if (citta === "") {
                    alert("Il campo Città è obbligatorio");
                    document.getElementById('citta').focus();
                    return false;
                }

                /* CONTROLLO IL CAMPO VIA */
                if (via === "") {
                    alert("Il campo Via è obbligatorio");
                    document.getElementById('via').focus();
                    return false;
                }

                /* CONTROLLO IL CAMPO NUMERO CIVICO */
                if (numeroCivico === "") {
                    alert("Il campo Numero civico è obbligatorio");
                    document.getElementById('numeroCivico').focus();
                    return false;
                }

                /* CONTROLLO IL CAMPO CAP */
                if (CAP === "") {
                    alert("Il campo CAP è obbligatorio");
                    document.getElementById('CAP').focus();
                    return false;
                }

                /* INVIO IL MODULO */
                console.log("Submitting registration form");
                document.getElementById('controllerAction').value = "LogOn.registraUtenti";
                document.getElementById('registerForm').submit();
            }
        }

        function checkEmail(email){
            var regexp = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return regexp.test(email);
        }

        function goBack(){
            console.log("goBack called");
            var f = document.getElementById('backForm');
            if(f){
                f.controllerAction.value = "Catalogo.view";
                f.submit();
            } else {
                console.error("Form 'backForm' non trovato.");
            }
        }

        function registrati(){
            console.log("registrati() called");
            var f = document.getElementById('registerfirstForm');
            if(f){
                var controllerAction = document.getElementById('registerfirstControllerAction');
                if(controllerAction){
                    controllerAction.value = "LogOn.view";
                    f.submit();
                } else {
                    console.error("Input 'registerfirstControllerAction' non trovato.");
                }
            } else {
                console.error("Form 'registerfirstForm' non trovato.");
            }
        }

        function mainOnLoadHandler(){
            var backBtn = document.getElementById('backButton');
            if (backBtn) {
                backBtn.addEventListener("click", goBack);
            }

            var submitBtn = document.getElementById('submitButton');
            if (submitBtn) {
                submitBtn.addEventListener("click", validateAndSubmit);
            }

            var registerBtn = document.getElementById('registerbutton');
            if (registerBtn) {
                registerBtn.addEventListener("click", registrati);
            }

            var creautenteBtn = document.getElementById('creautente');
            if (creautenteBtn) {
                creautenteBtn.addEventListener("click", validateAndSubmit);
            }
        }
    </script>

    <%@include file="/include/htmlHead.jsp" %>

</head>
<body onload="mainOnLoadHandler()">

<header>
    <%@include file="/include/HeaderUtente.jsp"%>
</header>

<hr>

<main>
    <div class="nomeUtente" id="welcomeMessage">
        <p>Benvenuto su FightinClass66, effettua il login per iniziare il tuo acquisto di attrezzature da combattimento!</p>
    </div>

    <div class="content" id="loginContent">
        <% if ("L".equals(opzione)) { %>
        <div>
            <h2 id="loginTitle">LOGIN</h2>
        </div>
        <% } else { %>
        <div>
            <h2 id="registerTitle">CREA UN ACCOUNT</h2>
        </div>
        <% } %>

        <!-- FORM DI LOGIN O DI REGISTRAZIONE -->
        <form id="registerForm" action="Dispatcher" method="post">
            <input type="hidden" id="controllerAction" name="controllerAction"/>

            <!-- Visualizza solo Email e Password per il login -->
            <% if ("L".equalsIgnoreCase(opzione)) { %>
            <div class="form" id="loginEmailForm">
                <label for="loginEmail">E-Mail:* </label>
                <input type="email" id="loginEmail" name="email" maxlength="50" required placeholder="email@esempio.com"/>
            </div>

            <div class="form" id="loginPasswordForm">
                <label for="loginPassword">Password:* </label>
                <input type="password" id="loginPassword" name="password" maxlength="50" required/>
            </div>
            <% } %>

            <!-- Visualizza tutti i campi per la registrazione -->
            <% if ("R".equalsIgnoreCase(opzione)) { %>
            <div class="form" id="formName">
                <label for="nomeUtente">Nome:* </label>
                <input type="text" id="nomeUtente" name="nomeUtente" maxlength="20" required placeholder="Mike"/>
            </div>

            <div class="form" id="formSurname">
                <label for="cognome">Cognome:* </label>
                <input type="text" id="cognome" name="cognome" maxlength="20" required placeholder="Tyson"/>
            </div>

            <div class="form" id="emailForm">
                <label for="email">E-Mail:* </label>
                <input type="email" id="email" name="email" autocomplete="username email" maxlength="50" required placeholder="mike.tyson@boxing.com"/>
            </div>

            <div class="form" id="passwordForm">
                <label for="password">Password:* </label>
                <input type="password" id="password" name="password" autocomplete="new-password" maxlength="50" required/>
            </div>

            <div class="form" id="formPasswordConfirm">
                <label for="passwordConf">Conferma Password:* </label>
                <input type="password" id="passwordConf" name="passwordConf" autocomplete="new-password" maxlength="50" required/>
            </div>

            <div class="form" id="formGender">
                <label>Sesso:* </label>
                <input type="radio" id="genderMale" name="genere" value="M" checked>Maschio
                <input type="radio" id="genderFemale" name="genere" value="F">Femmina
            </div>

            <div class="form" id="formCountry">
                <label for="nazione">Nazione:* </label>
                <input type="text" id="nazione" name="nazione" maxlength="20" required placeholder="Stati Uniti"/>
            </div>

            <div class="form" id="formCity">
                <label for="citta">Citt&agrave;:* </label>
                <input type="text" id="citta" name="citta" maxlength="20" required placeholder="Las Vegas"/>
            </div>

            <div class="form" id="formStreet">
                <label for="via">Via:* </label>
                <input type="text" id="via" name="via" maxlength="20" required placeholder="Avenida Federal"/>
            </div>

            <div class="form" id="formHouseNumber">
                <label for="numeroCivico">Numero civico:* </label>
                <input type="text" id="numeroCivico" name="numeroCivico" maxlength="10" required placeholder="12B"/>
            </div>

            <div class="form" id="formZipCode">
                <label for="CAP">CAP:* </label>
                <input type="text" id="CAP" name="CAP" maxlength="5" required placeholder="89101"/>
            </div>
            <% } %>

            <div class="formButtons">
                <input type="hidden" name="adminCreating" value="<%= adminCreating %>"/> <!-- Parametro per indicare che è un admin -->
                <% if ("L".equals(opzione)) { %>
                <input type="button" id="registerbutton" value="Registrati" class="button">
                <input type="button" id="submitButton" value="Login" class="button">
                <% } %>
                <% if ("R".equals(opzione)) { %>
                <input type="button" id="creautente" value="Registrati" class="button">
                <% } %>

                <input type="button" id="backButton" value="Annulla" class="button">
            </div>
        </form>

        <div id="mandatoryFieldNotice">
            <p id="clausola">*: Campo obbligatorio</p>
        </div>
    </div>

    <!-- Form per passare alla registrazione -->
    <form id="registerfirstForm" method="post" action="Dispatcher">
        <input type="hidden" id="registerfirstControllerAction" name="controllerAction"/>
        <input type="hidden" name="opzione" value="R"/>
    </form>

    <!-- Form per tornare alla home -->
    <form id="backForm" method="post" action="Dispatcher">
        <input type="hidden" id="backControllerAction" name="controllerAction"/>
    </form>

</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>

<%--&lt;%&ndash;--%>
<%--    Document   : logging--%>
<%--    Created on : 5-mar-2024, 14.55.48--%>
<%--    Author     : Oscar Costanzelli--%>
<%--&ndash;%&gt;--%>

<%--<%@page session = "false"%>--%>
<%--<%@page import="java.util.ArrayList"%>--%>
<%--<%@page import="model.session.mo.LoggedUser"%>--%>
<%--<%@page import="model.session.mo.Carrello"%>--%>
<%--<%@page contentType="text/html" pageEncoding="UTF-8"%>--%>

<%--<%--%>
<%--    String opzione = (String) request.getAttribute("opzione");--%>
<%--    if (opzione == null) {--%>
<%--        opzione = "L"; // Default a "L" per il login--%>
<%--    }--%>

<%--    //boolean loggedOn = (boolean) request.getAttribute("loggedOn");--%>
<%--    Boolean loggedOnAttribute = (Boolean) request.getAttribute("loggedOn");--%>
<%--    boolean loggedOn = loggedOnAttribute != null ? loggedOnAttribute : false;--%>


<%--    /*Carico i cookie*/--%>
<%--    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");--%>
<%--    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");--%>

<%--    String applicationMessage = (String) request.getAttribute("applicationMessage");--%>

<%--    String adminCreating= (String) request.getAttribute("adminCreating");--%>
<%--    System.out.println("adminCreating in loggingjsp: " + adminCreating); // Debug--%>

<%--//    request.setAttribute("adminCreating", adminCreating);--%>

<%--    String menuActiveLink = "Logging";--%>
<%--%>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="it-IT">--%>
<%--<head>--%>

<%--    <script language="javascript">--%>
<%--        var loggedOn = <%=loggedOn%>;--%>
<%--        var opzione = "<%=opzione%>"--%>

<%--        function validateAndSubmit(){--%>
<%--            if(opzione === "L"){--%>
<%--                document.getElementById('controllerAction').value = "LogOn.logon";--%>
<%--                document.getElementById('registerForm').submit();--%>
<%--            }--%>
<%--            if(opzione === "R"){--%>
<%--                var nomeUtente = document.getElementById('nomeUtente').value;--%>
<%--                var cognome = document.getElementById('cognome').value;--%>
<%--                var email = document.getElementById('email').value;--%>
<%--                var password = document.getElementById('password').value;--%>
<%--                var conferma = document.getElementById('passwordConf').value;--%>
<%--                var nazione = document.getElementById('nazione').value;--%>
<%--                var citta = document.getElementById('citta').value;--%>
<%--                var via = document.getElementById('via').value;--%>
<%--                var numeroCivico = document.getElementById('numeroCivico').value;--%>
<%--                var CAP = document.getElementById('CAP').value;--%>

<%--                /*CONTROLLO IL CAMPO NOME*/--%>
<%--                if (nomeUtente === "") {--%>
<%--                    alert("Il campo Nome è obbligatorio");--%>
<%--                    document.getElementById('nomeUtente').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO COGNOME*/--%>
<%--                if (cognome === "") {--%>
<%--                    alert("Il campo Cognome è obbligatorio");--%>
<%--                    document.getElementById('cognome').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO EMAIL*/--%>
<%--                if (email === "") {--%>
<%--                    alert("Il campo E-Mail è obbligatorio");--%>
<%--                    document.getElementById('email').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                if (!checkEmail(email)){--%>
<%--                    alert("Il formato dell'email inserita non è valido");--%>
<%--                    document.getElementById('email').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO PASSWORD*/--%>
<%--                if (password === "") {--%>
<%--                    alert("Il campo Password è obbligatorio");--%>
<%--                    document.getElementById('password').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO CONFERMA PASSWORD*/--%>
<%--                if (conferma === "") {--%>
<%--                    alert("Il campo Conferma password è obbligatorio");--%>
<%--                    document.getElementById('passwordConf').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                if (password !== conferma) {--%>
<%--                    alert("La password confermata è diversa da quella scelta");--%>
<%--                    document.getElementById('passwordConf').value = "";--%>
<%--                    document.getElementById('passwordConf').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO NAZIONE*/--%>
<%--                if (nazione === "") {--%>
<%--                    alert("Il campo Nazione è obbligatorio");--%>
<%--                    document.getElementById('nazione').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO CITTA*/--%>
<%--                if (citta === "") {--%>
<%--                    alert("Il campo Città è obbligatorio");--%>
<%--                    document.getElementById('citta').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO VIA*/--%>
<%--                if (via === "") {--%>
<%--                    alert("Il campo Via è obbligatorio");--%>
<%--                    document.getElementById('via').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO NUMERO CIVICO*/--%>
<%--                if (numeroCivico === "") {--%>
<%--                    alert("Il campo Numero civico è obbligatorio");--%>
<%--                    document.getElementById('numeroCivico').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO CAP*/--%>
<%--                if (CAP === "") {--%>
<%--                    alert("Il campo CAP è obbligatorio");--%>
<%--                    document.getElementById('CAP').focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*INVIO IL MODULO*/--%>
<%--                document.getElementById('controllerAction').value = "LogOn.registraUtenti";--%>
<%--                document.getElementById('registerForm').submit();--%>
<%--            }--%>
<%--        }--%>

<%--        function checkEmail(email){--%>
<%--            var regexp = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;--%>
<%--            return regexp.test(email);--%>
<%--        }--%>

<%--        function goBack(){--%>
<%--            var f = document.getElementById('backForm');--%>
<%--            f.controllerAction.value = "Catalogo.view";--%>
<%--            f.submit();--%>
<%--        }--%>
<%--        function registrati(){--%>
<%--            var f = document.getElementById('registerfirstForm');--%>
<%--            f.controllerAction.value = "LogOn.view";--%>
<%--            f.submit();--%>
<%--        }--%>



<%--        function mainOnLoadHandler(){--%>
<%--            document.getElementById('backButton').addEventListener("click", goBack);--%>
<%--            document.getElementById('submitButton').addEventListener("click", validateAndSubmit);--%>
<%--            document.getElementById('registerbutton').addEventListener("click", registrati);--%>
<%--            document.getElementById('creautente').addEventListener("click", validateAndSubmit);--%>


<%--        }--%>
<%--    </script>--%>

<%--    <%@include file="/include/htmlHead.jsp" %>--%>

<%--</head>--%>
<%--<body onload="mainOnLoadHandler()">--%>

<%--<header>--%>
<%--    <%@include file="/include/HeaderUtente.jsp"%>--%>
<%--</header>--%>

<%--<hr>--%>

<%--<main>--%>
<%--    <div class="nomeUtente" id="welcomeMessage">--%>
<%--        <p>Benvenuto su FightinClass66, effettua il login per iniziare il tuo acquisto di attrezzature da combattimento!</p>--%>
<%--    </div>--%>

<%--    <div class="content" id="loginContent">--%>
<%--        <% if (opzione.equals("L")) { %>--%>
<%--        <div>--%>
<%--            <h2 id="loginTitle">LOGIN</h2>--%>
<%--        </div>--%>
<%--        <% } else { %>--%>
<%--        <div>--%>
<%--            <h2 id="registerTitle">CREA UN ACCOUNT</h2>--%>
<%--        </div>--%>
<%--        <% } %>--%>

<%--        <!--FORM DI LOGIN O DI REGISTRAZIONE-->--%>
<%--        <form id="registerForm" action="Dispatcher" method="post">--%>
<%--            <input type="hidden" id="controllerAction" name="controllerAction"/>--%>

<%--            <!-- Visualizza solo Email e Password per il login -->--%>
<%--            <% if (opzione.equalsIgnoreCase("L")) { %>--%>
<%--            <div class="form" id="loginEmailForm">--%>
<%--                <label for="loginEmail">E-Mail:* </label>--%>
<%--                <input type="email" id="loginEmail" name="email" maxlength="50" required placeholder="email@esempio.com"/>--%>
<%--            </div>--%>

<%--            <div class="form" id="loginPasswordForm">--%>
<%--                <label for="loginPassword">Password:* </label>--%>
<%--                <input type="password" id="loginPassword" name="password" maxlength="50" required/>--%>
<%--            </div>--%>
<%--            <% } %>--%>

<%--            <!-- Visualizza tutti i campi per la registrazione -->--%>
<%--            <% if (opzione.equalsIgnoreCase("R")) { %>--%>
<%--            <div class="form" id="formName">--%>
<%--                <label for="nomeUtente">Nome:* </label>--%>
<%--                <input type="text" id="nomeUtente" name="nomeUtente" maxlength="20" required placeholder="Mike"/>--%>
<%--            </div>--%>

<%--            <div class="form" id="formSurname">--%>
<%--                <label for="cognome">Cognome:* </label>--%>
<%--                <input type="text" id="cognome" name="cognome" maxlength="20" required placeholder="Tyson"/>--%>
<%--            </div>--%>

<%--            <div class="form" id="emailForm">--%>
<%--                <label for="email">E-Mail:* </label>--%>
<%--                <input type="email" id="email" name="email" autocomplete="username email" maxlength="50" required placeholder="mike.tyson@boxing.com"/>--%>
<%--            </div>--%>

<%--            <div class="form" id="passwordForm">--%>
<%--                <label for="password">Password:* </label>--%>
<%--                <input type="password" id="password" name="password" autocomplete="new-password" maxlength="50" required/>--%>
<%--            </div>--%>

<%--            <div class="form" id="formPasswordConfirm">--%>
<%--                <label for="passwordConf">Conferma Password:* </label>--%>
<%--                <input type="password" id="passwordConf" name="passwordConf" autocomplete="new-password" maxlength="50" required/>--%>
<%--            </div>--%>

<%--            <div class="form" id="formGender">--%>
<%--                <label>Sesso:* </label>--%>
<%--                <input type="radio" id="genderMale" name="genere" value="M" checked>Maschio--%>
<%--                <input type="radio" id="genderFemale" name="genere" value="F">Femmina--%>
<%--            </div>--%>

<%--            <div class="form" id="formCountry">--%>
<%--                <label for="nazione">Nazione:* </label>--%>
<%--                <input type="text" id="nazione" name="nazione" maxlength="20" required placeholder="Stati Uniti"/>--%>
<%--            </div>--%>

<%--            <div class="form" id="formCity">--%>
<%--                <label for="citta">Citt&agrave;:* </label>--%>
<%--                <input type="text" id="citta" name="citta" maxlength="20" required placeholder="Las Vegas"/>--%>
<%--            </div>--%>

<%--            <div class="form" id="formStreet">--%>
<%--                <label for="via">Via:* </label>--%>
<%--                <input type="text" id="via" name="via" maxlength="20" required placeholder="Avenida Federal"/>--%>
<%--            </div>--%>

<%--            <div class="form" id="formHouseNumber">--%>
<%--                <label for="numeroCivico">Numero civico:* </label>--%>
<%--                <input type="text" id="numeroCivico" name="numeroCivico" maxlength="10" required placeholder="12B"/>--%>
<%--            </div>--%>

<%--            <div class="form" id="formZipCode">--%>
<%--                <label for="CAP">CAP:* </label>--%>
<%--                <input type="text" id="CAP" name="CAP" maxlength="5" required placeholder="89101"/>--%>
<%--            </div>--%>
<%--            <% } %>--%>

<%--            <div class="formButtons">--%>
<%--                <input type="hidden" name="adminCreating" value="<%= adminCreating %>"/> <!-- Parametro per indicare che è un admin -->--%>
<%--                <% if (opzione.equals("L")){ %>--%>
<%--                <input type="button" id="registerbutton" value="Registrati" class="button">--%>
<%--                <input type="button" id="submitButton" value="Login" class="button">--%>
<%--                <%}%>--%>
<%--                <% System.out.println(request.getAttribute(opzione)); %>--%>
<%--                <% if (opzione.equals("R")){ %>--%>


<%--                <input type="button" id="creautente" value="Registrati" class="button">--%>
<%--                <%;}%>--%>


<%--                <input type="button" id="backButton" value="Annulla" class="button">--%>

<%--            </div>--%>
<%--        </form>--%>

<%--        <div id="mandatoryFieldNotice">--%>
<%--            <p id="clausola">*: Campo obbligatorio</p>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <form id="registerfirstForm" method="post" action="Dispatcher">--%>
<%--        <input type="hidden" id="registerfirstControllerAction" name="controllerAction"/>--%>
<%--        <input type="hidden" name="opzione" value="R"/>--%>

<%--    </form>--%>
<%--    <form id="backForm" method="post" action="Dispatcher">--%>
<%--        <input type="hidden" id="backControllerAction" name="controllerAction"/>--%>
<%--    </form>--%>

<%--</main>--%>


<%--<%@include file="/include/footer.jsp" %>--%>

<%--</body>--%>
<%--</html>--%>
<%--&lt;%&ndash;-------------------------------------------------&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;&ndash;%&gt;--%>
<%--&lt;%&ndash;    Document   : logging&ndash;%&gt;--%>
<%--&lt;%&ndash;    Created on : 5-mar-2024, 14.55.48&ndash;%&gt;--%>
<%--&lt;%&ndash;    Author     : Oscar Costanzelli&ndash;%&gt;--%>
<%--&lt;%&ndash;&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;<%@page session = "false"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@page import="java.util.ArrayList"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@page import="model.session.mo.LoggedUser"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@page import="model.session.mo.Carrello"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@page contentType="text/html" pageEncoding="UTF-8"%>&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;%>--%>
<%--&lt;%&ndash;    String opzione = (String) request.getAttribute("opzione");&ndash;%&gt;--%>
<%--&lt;%&ndash;    if (opzione == null) {&ndash;%&gt;--%>
<%--&lt;%&ndash;        opzione = "L"; // Default a "L" per il login&ndash;%&gt;--%>
<%--&lt;%&ndash;    }&ndash;%&gt;--%>

<%--&lt;%&ndash;    //boolean loggedOn = (boolean) request.getAttribute("loggedOn");&ndash;%&gt;--%>
<%--&lt;%&ndash;    Boolean loggedOnAttribute = (Boolean) request.getAttribute("loggedOn");&ndash;%&gt;--%>
<%--&lt;%&ndash;    boolean loggedOn = loggedOnAttribute != null ? loggedOnAttribute : false;&ndash;%&gt;--%>


<%--&lt;%&ndash;    /*Carico i cookie*/&ndash;%&gt;--%>
<%--&lt;%&ndash;    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");&ndash;%&gt;--%>
<%--&lt;%&ndash;    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");&ndash;%&gt;--%>

<%--&lt;%&ndash;    String applicationMessage = (String) request.getAttribute("applicationMessage");&ndash;%&gt;--%>

<%--&lt;%&ndash;    String menuActiveLink = "Logging";&ndash;%&gt;--%>
<%--&lt;%&ndash;%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<!DOCTYPE html>&ndash;%&gt;--%>
<%--&lt;%&ndash;<html lang="it-IT">&ndash;%&gt;--%>
<%--&lt;%&ndash;<head>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <script language="javascript">&ndash;%&gt;--%>
<%--&lt;%&ndash;        var loggedOn = <%=loggedOn%>;&ndash;%&gt;--%>
<%--&lt;%&ndash;        var opzione = "<%=opzione%>";&ndash;%&gt;--%>

<%--&lt;%&ndash;        function validateAndSubmit(){&ndash;%&gt;--%>
<%--&lt;%&ndash;            if(opzione === "L"){&ndash;%&gt;--%>
<%--&lt;%&ndash;                document.registerForm.controllerAction.value = "LogOn.logon";&ndash;%&gt;--%>
<%--&lt;%&ndash;                document.registerForm.submit();&ndash;%&gt;--%>
<%--&lt;%&ndash;            }&ndash;%&gt;--%>
<%--&lt;%&ndash;            if(opzione === "R"){&ndash;%&gt;--%>
<%--&lt;%&ndash;                var nomeUtente = document.registerForm.nomeUtente.value;&ndash;%&gt;--%>
<%--&lt;%&ndash;                var cognome = document.registerForm.cognome.value;&ndash;%&gt;--%>
<%--&lt;%&ndash;                var email = document.registerForm.email.value;&ndash;%&gt;--%>
<%--&lt;%&ndash;                var password = document.registerForm.password.value;&ndash;%&gt;--%>
<%--&lt;%&ndash;                var conferma = document.registerForm.passwordConf.value;&ndash;%&gt;--%>
<%--&lt;%&ndash;                var nazione = document.registerForm.nazione.value;&ndash;%&gt;--%>
<%--&lt;%&ndash;                var citta = document.registerForm.citta.value;&ndash;%&gt;--%>
<%--&lt;%&ndash;                var via = document.registerForm.via.value;&ndash;%&gt;--%>
<%--&lt;%&ndash;                var numeroCivico = document.registerForm.numeroCivico.value;&ndash;%&gt;--%>
<%--&lt;%&ndash;                var CAP = document.registerForm.CAP.value;&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO IL CAMPO NOME*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                if ((nomeUtente == "") || (nomeUtente == "undefined")) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il campo N           ome è obbligatorio");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.nomeUtente.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO IL CAMPO COGNOME*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else if ((cognome == "") || (cognome == "undefined")) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il campo Cognome è obbligatorio");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.cognome.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO IL CAMPO EMAIL*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else if ((email == "") || (email == "undefined")) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il campo E-Mail è obbligatorio");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.email.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                else if (!checkEmail(email)){&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il formato dell'email inserita non è valido");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.email.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO IL CAMPO PASSWORD*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else if ((password == "") || (password == "undefined")) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il campo Password è obbligatorio");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.password.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO IL CAMPO CONFERMA PASSWORD*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else if ((conferma == "") || (conferma == "undefined")) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il campo Conferma password è obbligatorio");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.conferma.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO L'UGUAGLIANZA TRA PASSWORD E CONFERMA PASSWORD*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else if (password != conferma) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("La password confermata è diversa da quella scelta");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.conferma.value = "";&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.conferma.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO IL CAMPO NAZIONE*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else if ((nazione == "") || (nazione == "undefined")) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il campo Nazione è obbligatorio");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.nazione.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO IL CAMPO CITTA*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else if ((citta == "") || (citta == "undefined")) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il campo Città è obbligatorio");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.citta.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO IL CAMPO VIA*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else if ((via == "") || (via == "undefined")) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il campo Via è obbligatorio");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.via.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO IL CAMPO NUMERO CIVICO*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else if ((numeroCivico == "") || (numeroCivico == "undefined")) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il campo Numero civico è obbligatorio");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.numeroCivico.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*CONTROLLO IL CAMPO CAP*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else if ((CAP == "") || (CAP == "undefined")) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    alert("Il campo CAP è obbligatorio");&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.CAP.focus();&ndash;%&gt;--%>
<%--&lt;%&ndash;                    return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;                /*INVIO IL MODULO*/&ndash;%&gt;--%>
<%--&lt;%&ndash;                else{&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.controllerAction.value = "LogOn.registraUtenti";&ndash;%&gt;--%>
<%--&lt;%&ndash;                    document.registerForm.submit();&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>

<%--&lt;%&ndash;            }&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        function validaEmail(email) {&ndash;%&gt;--%>
<%--&lt;%&ndash;            var regexp = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;//regex&ndash;%&gt;--%>
<%--&lt;%&ndash;            return regexp.test(email);&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        function checkEmail(email){&ndash;%&gt;--%>
<%--&lt;%&ndash;            if (validaEmail(email)) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                return true;&ndash;%&gt;--%>
<%--&lt;%&ndash;            } else {&ndash;%&gt;--%>
<%--&lt;%&ndash;                return false;&ndash;%&gt;--%>
<%--&lt;%&ndash;            }&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        function goBack(){&ndash;%&gt;--%>
<%--&lt;%&ndash;            var f = document.backForm;&ndash;%&gt;--%>
<%--&lt;%&ndash;            f.controllerAction.value = "Catalogo.view";&ndash;%&gt;--%>
<%--&lt;%&ndash;            f.submit();&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        function mainOnLoadHandler(){&ndash;%&gt;--%>
<%--&lt;%&ndash;            document.registerForm.backButton.addEventListener("click", goBack);&ndash;%&gt;--%>
<%--&lt;%&ndash;            document.registerForm.submitButton.addEventListener("click", validateAndSubmit);&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>
<%--&lt;%&ndash;    </script>&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;    <style>&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        body {&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            background-color: #1a1a1a;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            color: #f2f2f2;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            font-family: 'Arial Black', Arial, sans-serif;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;        .content{&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            width: 56%;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            margin-left: 22%;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            background-color: #2a2a2a;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            padding: 20px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            border-radius: 10px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;        h2 {&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            color: #e63946;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            text-align: center;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            font-size: 2em;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            margin-bottom: 20px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;        .form {&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            margin-bottom: 15px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;        label {&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            display: block;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            margin-bottom: 5px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            font-weight: bold;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;        input[type="text"],&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        input[type="email"],&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        input[type="password"] {&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            width: 90%;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            padding: 8px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            border: none;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            border-radius: 4px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            font-size: 1em;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;        input[type="radio"] {&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            margin-right: 5px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;        .button {&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            background-color: #e63946;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            color: #f2f2f2;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            border: none;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            padding: 10px 20px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            margin-right: 10px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            border-radius: 5px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            cursor: pointer;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            font-weight: bold;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;        .button:hover {&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            background-color: #d62839;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;        #clausola{&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            font-size: smaller;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            color: #a8a8a8;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;        .nomeUtente p {&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            text-align: center;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            font-size: 1.2em;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;            margin-bottom: 20px;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;        }&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;&lt;%&ndash;    </style>&ndash;%&gt;&ndash;%&gt;--%>

<%--&lt;%&ndash;    <%@include file="/include/htmlHead.jsp" %>&ndash;%&gt;--%>

<%--&lt;%&ndash;</head>&ndash;%&gt;--%>
<%--&lt;%&ndash;<body onload="mainOnLoadHandler()">&ndash;%&gt;--%>

<%--&lt;%&ndash;<header>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <%@include file="/include/HeaderUtente.jsp"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;</header>&ndash;%&gt;--%>

<%--&lt;%&ndash;<hr>&ndash;%&gt;--%>

<%--&lt;%&ndash;<main>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <div class="nomeUtente" style="margin-bottom: 15px;">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <p>Benvenuto su FightinClass66, effettua il login per iniziare il tuo acquisto di attrezzature da combattimento</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <div class="content">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <%if(opzione.equals("L")){%>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <h2>LOGIN</h2>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <%}else{%>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <h2>CREA UN ACCOUNT</h2>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <%}%>&ndash;%&gt;--%>

<%--&lt;%&ndash;        <!--FORM DI REGISTRAZIONE O DI LOGIN-->&ndash;%&gt;--%>
<%--&lt;%&ndash;        <form name="registerForm" action="Dispatcher" method="post">&ndash;%&gt;--%>

<%--&lt;%&ndash;            <%if(opzione.equalsIgnoreCase("R")){%>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <div class="form" id="left" style="width: 46%;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label for="nomeUtente">Nome:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="text" id="nomeUtente" name="nomeUtente" value="" maxlength="20" required placeholder="Mike"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div class="form" style="float: left; width: 50%;">\&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label for="cognome">Cognome:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="text" id="cognome" name="cognome" value="" maxlength="20" required placeholder="Tyson"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <%}%>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div style="clear: both"></div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div class="form">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label for="email">E-Mail:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="email" id="email" name="email" autocomplete="username email" value="" maxlength="50" required placeholder="mike.tyson@boxing.com"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div class="form">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label for="password">Password:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="password" id="password" name="password" autocomplete="new-password" maxlength="50" required/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <%if(opzione.equalsIgnoreCase("R")){%>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <div class="form">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label for="passwordConf">Conferma Password:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="password" id="passwordConf" name="passwordConf" autocomplete="new-password" maxlength="50" required/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div class="form">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label>Sesso:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="radio" name="genere" value="M" checked>Maschio&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="radio" name="genere" value="F">Femmina&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div class="form" id="left" style="width: 47%;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label for="nazione">Nazione:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="text" id="nazione" name="nazione" value="" maxlength="20" required placeholder="Stati Uniti"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div class="form" style="float: left; width: 49%;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label for="citta">Citt&agrave;:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="text" id="citta" name="citta" value="" maxlength="20" required placeholder="Las Vegas"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div class="form" id="left" style="width: 45%;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label for="via">Via:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="text" id="via" name="via" value="" maxlength="20" required placeholder="Avenida Federal"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div class="form" id="left" style="width: 29%;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label for="numeroCivico">Numero civico:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="text" id="numeroCivico" name="numeroCivico" value="" maxlength="10" required placeholder="12B"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div class="form" style="float: left; width: 18%;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <label for="CAP">CAP:* </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="text" id="CAP" name="CAP" value="" maxlength="5" required placeholder="89101"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <%}%>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <input type="hidden" name="controllerAction"/>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div style="clear: both"></div>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <div style="margin-top: 10px; text-align: center;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="button" name="submitButton" value="Ok" class="button">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="button" name="backButton" value="Annulla" class="button">&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;        </form>&ndash;%&gt;--%>

<%--&lt;%&ndash;        <div style="margin-top: 20px; text-align: center;">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <p id="clausola">*: Campo obbligatorio</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <!--FORM DI ANNULLA => TORNO NELLA HOME DEGLI UTENTI O DELL'ADMIN-->&ndash;%&gt;--%>
<%--&lt;%&ndash;    <form name="backForm" method="post" action="Dispatcher">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <input type="hidden" name="controllerAction"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </form>&ndash;%&gt;--%>

<%--&lt;%&ndash;</main>&ndash;%&gt;--%>

<%--&lt;%&ndash;<%@include file="/include/footer.jsp" %>&ndash;%&gt;--%>

<%--&lt;%&ndash;</body>&ndash;%&gt;--%>
<%--&lt;%&ndash;</html>&ndash;%&gt;--%>
