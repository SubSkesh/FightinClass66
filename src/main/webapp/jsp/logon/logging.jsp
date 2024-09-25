<%--
    Document   : logging
    Created on : 5-mar-2024, 14.55.48
    Author     : Oscar Costanzelli
--%>

<%@page session = "false"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="model.session.mo.Carrello"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String opzione = (String) request.getAttribute("opzione");
    if (opzione == null) {
        opzione = "L"; // Default a "L" per il login
    }

    //boolean loggedOn = (boolean) request.getAttribute("loggedOn");
    Boolean loggedOnAttribute = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = loggedOnAttribute != null ? loggedOnAttribute : false;


    /*Carico i cookie*/
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");

    String applicationMessage = (String) request.getAttribute("applicationMessage");

    String menuActiveLink = "Logging";
%>
<!DOCTYPE html>
<html lang="it-IT">
<head>

    <script language="javascript">
        var loggedOn = <%=loggedOn%>;
        var opzione = "<%=opzione%>";

        function validateAndSubmit(){
            if(opzione === "L"){
                document.getElementById('controllerAction').value = "LogOn.logon";
                document.getElementById('registerForm').submit();
            }
            if(opzione === "R"){
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

                /*CONTROLLO IL CAMPO NOME*/
                if (nomeUtente === "") {
                    alert("Il campo Nome è obbligatorio");
                    document.getElementById('nomeUtente').focus();
                    return false;
                }

                /*CONTROLLO IL CAMPO COGNOME*/
                if (cognome === "") {
                    alert("Il campo Cognome è obbligatorio");
                    document.getElementById('cognome').focus();
                    return false;
                }

                /*CONTROLLO IL CAMPO EMAIL*/
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

                /*CONTROLLO IL CAMPO PASSWORD*/
                if (password === "") {
                    alert("Il campo Password è obbligatorio");
                    document.getElementById('password').focus();
                    return false;
                }

                /*CONTROLLO IL CAMPO CONFERMA PASSWORD*/
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

                /*CONTROLLO IL CAMPO NAZIONE*/
                if (nazione === "") {
                    alert("Il campo Nazione è obbligatorio");
                    document.getElementById('nazione').focus();
                    return false;
                }

                /*CONTROLLO IL CAMPO CITTA*/
                if (citta === "") {
                    alert("Il campo Città è obbligatorio");
                    document.getElementById('citta').focus();
                    return false;
                }

                /*CONTROLLO IL CAMPO VIA*/
                if (via === "") {
                    alert("Il campo Via è obbligatorio");
                    document.getElementById('via').focus();
                    return false;
                }

                /*CONTROLLO IL CAMPO NUMERO CIVICO*/
                if (numeroCivico === "") {
                    alert("Il campo Numero civico è obbligatorio");
                    document.getElementById('numeroCivico').focus();
                    return false;
                }

                /*CONTROLLO IL CAMPO CAP*/
                if (CAP === "") {
                    alert("Il campo CAP è obbligatorio");
                    document.getElementById('CAP').focus();
                    return false;
                }

                /*INVIO IL MODULO*/
                document.getElementById('controllerAction').value = "LogOn.registraUtenti";
                document.getElementById('registerForm').submit();
            }
        }

        function checkEmail(email){
            var regexp = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return regexp.test(email);
        }

        function goBack(){
            var f = document.getElementById('backForm');
            f.controllerAction.value = "Catalogo.view";
            f.submit();
        }

        function mainOnLoadHandler(){
            document.getElementById('backButton').addEventListener("click", goBack);
            document.getElementById('submitButton').addEventListener("click", validateAndSubmit);
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
        <p>Benvenuto su FightinClass66, effettua il login per iniziare il tuo acquisto di attrezzature da combattimento</p>
    </div>

    <div class="content" id="loginContent">
        <%if(opzione.equals("L")){%>
        <div>
            <h2 id="loginTitle">LOGIN</h2>
        </div>
        <%}else{%>
        <div>
            <h2 id="registerTitle">CREA UN ACCOUNT</h2>
        </div>
        <%}%>

        <!--FORM DI REGISTRAZIONE O DI LOGIN-->
        <form id="registerForm" action="Dispatcher" method="post">
            <input type="hidden" id="controllerAction" name="controllerAction"/>

            <%if(opzione.equalsIgnoreCase("R")){%>
            <div class="form" id="formName">
                <label for="nomeUtente">Nome:* </label>
                <input type="text" id="nomeUtente" name="nomeUtente" maxlength="20" required placeholder="Mike"/>
            </div>

            <div class="form" id="formSurname">
                <label for="cognome">Cognome:* </label>
                <input type="text" id="cognome" name="cognome" maxlength="20" required placeholder="Tyson"/>
            </div>

            <div class="form" id="formEmail">
                <label for="email">E-Mail:* </label>
                <input type="email" id="email" name="email" autocomplete="username email" maxlength="50" required placeholder="mike.tyson@boxing.com"/>
            </div>

            <div class="form" id="formPassword">
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
            <%}%>

            <div class="formButtons">
                <input type="button" id="submitButton" value="Ok" class="button">
                <input type="button" id="backButton" value="Annulla" class="button">
            </div>
        </form>

        <div id="mandatoryFieldNotice">
            <p id="clausola">*: Campo obbligatorio</p>
        </div>
    </div>

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

<%--    String menuActiveLink = "Logging";--%>
<%--%>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="it-IT">--%>
<%--<head>--%>

<%--    <script language="javascript">--%>
<%--        var loggedOn = <%=loggedOn%>;--%>
<%--        var opzione = "<%=opzione%>";--%>

<%--        function validateAndSubmit(){--%>
<%--            if(opzione === "L"){--%>
<%--                document.registerForm.controllerAction.value = "LogOn.logon";--%>
<%--                document.registerForm.submit();--%>
<%--            }--%>
<%--            if(opzione === "R"){--%>
<%--                var nomeUtente = document.registerForm.nomeUtente.value;--%>
<%--                var cognome = document.registerForm.cognome.value;--%>
<%--                var email = document.registerForm.email.value;--%>
<%--                var password = document.registerForm.password.value;--%>
<%--                var conferma = document.registerForm.passwordConf.value;--%>
<%--                var nazione = document.registerForm.nazione.value;--%>
<%--                var citta = document.registerForm.citta.value;--%>
<%--                var via = document.registerForm.via.value;--%>
<%--                var numeroCivico = document.registerForm.numeroCivico.value;--%>
<%--                var CAP = document.registerForm.CAP.value;--%>

<%--                /*CONTROLLO IL CAMPO NOME*/--%>
<%--                if ((nomeUtente == "") || (nomeUtente == "undefined")) {--%>
<%--                    alert("Il campo Nome è obbligatorio");--%>
<%--                    document.registerForm.nomeUtente.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO COGNOME*/--%>
<%--                else if ((cognome == "") || (cognome == "undefined")) {--%>
<%--                    alert("Il campo Cognome è obbligatorio");--%>
<%--                    document.registerForm.cognome.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO EMAIL*/--%>
<%--                else if ((email == "") || (email == "undefined")) {--%>
<%--                    alert("Il campo E-Mail è obbligatorio");--%>
<%--                    document.registerForm.email.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                else if (!checkEmail(email)){--%>
<%--                    alert("Il formato dell'email inserita non è valido");--%>
<%--                    document.registerForm.email.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO PASSWORD*/--%>
<%--                else if ((password == "") || (password == "undefined")) {--%>
<%--                    alert("Il campo Password è obbligatorio");--%>
<%--                    document.registerForm.password.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO CONFERMA PASSWORD*/--%>
<%--                else if ((conferma == "") || (conferma == "undefined")) {--%>
<%--                    alert("Il campo Conferma password è obbligatorio");--%>
<%--                    document.registerForm.conferma.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO L'UGUAGLIANZA TRA PASSWORD E CONFERMA PASSWORD*/--%>
<%--                else if (password != conferma) {--%>
<%--                    alert("La password confermata è diversa da quella scelta");--%>
<%--                    document.registerForm.conferma.value = "";--%>
<%--                    document.registerForm.conferma.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO NAZIONE*/--%>
<%--                else if ((nazione == "") || (nazione == "undefined")) {--%>
<%--                    alert("Il campo Nazione è obbligatorio");--%>
<%--                    document.registerForm.nazione.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO CITTA*/--%>
<%--                else if ((citta == "") || (citta == "undefined")) {--%>
<%--                    alert("Il campo Città è obbligatorio");--%>
<%--                    document.registerForm.citta.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO VIA*/--%>
<%--                else if ((via == "") || (via == "undefined")) {--%>
<%--                    alert("Il campo Via è obbligatorio");--%>
<%--                    document.registerForm.via.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO NUMERO CIVICO*/--%>
<%--                else if ((numeroCivico == "") || (numeroCivico == "undefined")) {--%>
<%--                    alert("Il campo Numero civico è obbligatorio");--%>
<%--                    document.registerForm.numeroCivico.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*CONTROLLO IL CAMPO CAP*/--%>
<%--                else if ((CAP == "") || (CAP == "undefined")) {--%>
<%--                    alert("Il campo CAP è obbligatorio");--%>
<%--                    document.registerForm.CAP.focus();--%>
<%--                    return false;--%>
<%--                }--%>

<%--                /*INVIO IL MODULO*/--%>
<%--                else{--%>
<%--                    document.registerForm.controllerAction.value = "LogOn.registraUtenti";--%>
<%--                    document.registerForm.submit();--%>
<%--                }--%>

<%--            }--%>
<%--        }--%>

<%--        function validaEmail(email) {--%>
<%--            var regexp = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;//regex--%>
<%--            return regexp.test(email);--%>
<%--        }--%>

<%--        function checkEmail(email){--%>
<%--            if (validaEmail(email)) {--%>
<%--                return true;--%>
<%--            } else {--%>
<%--                return false;--%>
<%--            }--%>
<%--        }--%>

<%--        function goBack(){--%>
<%--            var f = document.backForm;--%>
<%--            f.controllerAction.value = "Catalogo.view";--%>
<%--            f.submit();--%>
<%--        }--%>

<%--        function mainOnLoadHandler(){--%>
<%--            document.registerForm.backButton.addEventListener("click", goBack);--%>
<%--            document.registerForm.submitButton.addEventListener("click", validateAndSubmit);--%>
<%--        }--%>
<%--    </script>--%>
<%--&lt;%&ndash;    <style>&ndash;%&gt;--%>
<%--&lt;%&ndash;        body {&ndash;%&gt;--%>
<%--&lt;%&ndash;            background-color: #1a1a1a;&ndash;%&gt;--%>
<%--&lt;%&ndash;            color: #f2f2f2;&ndash;%&gt;--%>
<%--&lt;%&ndash;            font-family: 'Arial Black', Arial, sans-serif;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        .content{&ndash;%&gt;--%>
<%--&lt;%&ndash;            width: 56%;&ndash;%&gt;--%>
<%--&lt;%&ndash;            margin-left: 22%;&ndash;%&gt;--%>
<%--&lt;%&ndash;            background-color: #2a2a2a;&ndash;%&gt;--%>
<%--&lt;%&ndash;            padding: 20px;&ndash;%&gt;--%>
<%--&lt;%&ndash;            border-radius: 10px;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        h2 {&ndash;%&gt;--%>
<%--&lt;%&ndash;            color: #e63946;&ndash;%&gt;--%>
<%--&lt;%&ndash;            text-align: center;&ndash;%&gt;--%>
<%--&lt;%&ndash;            font-size: 2em;&ndash;%&gt;--%>
<%--&lt;%&ndash;            margin-bottom: 20px;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        .form {&ndash;%&gt;--%>
<%--&lt;%&ndash;            margin-bottom: 15px;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        label {&ndash;%&gt;--%>
<%--&lt;%&ndash;            display: block;&ndash;%&gt;--%>
<%--&lt;%&ndash;            margin-bottom: 5px;&ndash;%&gt;--%>
<%--&lt;%&ndash;            font-weight: bold;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        input[type="text"],&ndash;%&gt;--%>
<%--&lt;%&ndash;        input[type="email"],&ndash;%&gt;--%>
<%--&lt;%&ndash;        input[type="password"] {&ndash;%&gt;--%>
<%--&lt;%&ndash;            width: 90%;&ndash;%&gt;--%>
<%--&lt;%&ndash;            padding: 8px;&ndash;%&gt;--%>
<%--&lt;%&ndash;            border: none;&ndash;%&gt;--%>
<%--&lt;%&ndash;            border-radius: 4px;&ndash;%&gt;--%>
<%--&lt;%&ndash;            font-size: 1em;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        input[type="radio"] {&ndash;%&gt;--%>
<%--&lt;%&ndash;            margin-right: 5px;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        .button {&ndash;%&gt;--%>
<%--&lt;%&ndash;            background-color: #e63946;&ndash;%&gt;--%>
<%--&lt;%&ndash;            color: #f2f2f2;&ndash;%&gt;--%>
<%--&lt;%&ndash;            border: none;&ndash;%&gt;--%>
<%--&lt;%&ndash;            padding: 10px 20px;&ndash;%&gt;--%>
<%--&lt;%&ndash;            margin-right: 10px;&ndash;%&gt;--%>
<%--&lt;%&ndash;            border-radius: 5px;&ndash;%&gt;--%>
<%--&lt;%&ndash;            cursor: pointer;&ndash;%&gt;--%>
<%--&lt;%&ndash;            font-weight: bold;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        .button:hover {&ndash;%&gt;--%>
<%--&lt;%&ndash;            background-color: #d62839;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        #clausola{&ndash;%&gt;--%>
<%--&lt;%&ndash;            font-size: smaller;&ndash;%&gt;--%>
<%--&lt;%&ndash;            color: #a8a8a8;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        .nomeUtente p {&ndash;%&gt;--%>
<%--&lt;%&ndash;            text-align: center;&ndash;%&gt;--%>
<%--&lt;%&ndash;            font-size: 1.2em;&ndash;%&gt;--%>
<%--&lt;%&ndash;            margin-bottom: 20px;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>
<%--&lt;%&ndash;    </style>&ndash;%&gt;--%>

<%--    <%@include file="/include/htmlHead.jsp" %>--%>

<%--</head>--%>
<%--<body onload="mainOnLoadHandler()">--%>

<%--<header>--%>
<%--    <%@include file="/include/HeaderUtente.jsp"%>--%>
<%--</header>--%>

<%--<hr>--%>

<%--<main>--%>
<%--    <div class="nomeUtente" style="margin-bottom: 15px;">--%>
<%--        <p>Benvenuto su FightinClass66, effettua il login per iniziare il tuo acquisto di attrezzature da combattimento</p>--%>
<%--    </div>--%>

<%--    <div class="content">--%>
<%--        <%if(opzione.equals("L")){%>--%>
<%--        <div>--%>
<%--            <h2>LOGIN</h2>--%>
<%--        </div>--%>
<%--        <%}else{%>--%>
<%--        <div>--%>
<%--            <h2>CREA UN ACCOUNT</h2>--%>
<%--        </div>--%>
<%--        <%}%>--%>

<%--        <!--FORM DI REGISTRAZIONE O DI LOGIN-->--%>
<%--        <form name="registerForm" action="Dispatcher" method="post">--%>

<%--            <%if(opzione.equalsIgnoreCase("R")){%>--%>
<%--            <div class="form" id="left" style="width: 46%;">--%>
<%--                <label for="nomeUtente">Nome:* </label>--%>
<%--                <input type="text" id="nomeUtente" name="nomeUtente" value="" maxlength="20" required placeholder="Mike"/>--%>
<%--            </div>--%>

<%--            <div class="form" style="float: left; width: 50%;">\--%>
<%--                <label for="cognome">Cognome:* </label>--%>
<%--                <input type="text" id="cognome" name="cognome" value="" maxlength="20" required placeholder="Tyson"/>--%>
<%--            </div>--%>
<%--            <%}%>--%>

<%--            <div style="clear: both"></div>--%>

<%--            <div class="form">--%>
<%--                <label for="email">E-Mail:* </label>--%>
<%--                <input type="email" id="email" name="email" autocomplete="username email" value="" maxlength="50" required placeholder="mike.tyson@boxing.com"/>--%>
<%--            </div>--%>

<%--            <div class="form">--%>
<%--                <label for="password">Password:* </label>--%>
<%--                <input type="password" id="password" name="password" autocomplete="new-password" maxlength="50" required/>--%>
<%--            </div>--%>

<%--            <%if(opzione.equalsIgnoreCase("R")){%>--%>
<%--            <div class="form">--%>
<%--                <label for="passwordConf">Conferma Password:* </label>--%>
<%--                <input type="password" id="passwordConf" name="passwordConf" autocomplete="new-password" maxlength="50" required/>--%>
<%--            </div>--%>

<%--            <div class="form">--%>
<%--                <label>Sesso:* </label>--%>
<%--                <input type="radio" name="genere" value="M" checked>Maschio--%>
<%--                <input type="radio" name="genere" value="F">Femmina--%>
<%--            </div>--%>

<%--            <div class="form" id="left" style="width: 47%;">--%>
<%--                <label for="nazione">Nazione:* </label>--%>
<%--                <input type="text" id="nazione" name="nazione" value="" maxlength="20" required placeholder="Stati Uniti"/>--%>
<%--            </div>--%>

<%--            <div class="form" style="float: left; width: 49%;">--%>
<%--                <label for="citta">Citt&agrave;:* </label>--%>
<%--                <input type="text" id="citta" name="citta" value="" maxlength="20" required placeholder="Las Vegas"/>--%>
<%--            </div>--%>

<%--            <div class="form" id="left" style="width: 45%;">--%>
<%--                <label for="via">Via:* </label>--%>
<%--                <input type="text" id="via" name="via" value="" maxlength="20" required placeholder="Avenida Federal"/>--%>
<%--            </div>--%>

<%--            <div class="form" id="left" style="width: 29%;">--%>
<%--                <label for="numeroCivico">Numero civico:* </label>--%>
<%--                <input type="text" id="numeroCivico" name="numeroCivico" value="" maxlength="10" required placeholder="12B"/>--%>
<%--            </div>--%>

<%--            <div class="form" style="float: left; width: 18%;">--%>
<%--                <label for="CAP">CAP:* </label>--%>
<%--                <input type="text" id="CAP" name="CAP" value="" maxlength="5" required placeholder="89101"/>--%>
<%--            </div>--%>
<%--            <%}%>--%>

<%--            <input type="hidden" name="controllerAction"/>--%>

<%--            <div style="clear: both"></div>--%>

<%--            <div style="margin-top: 10px; text-align: center;">--%>
<%--                <input type="button" name="submitButton" value="Ok" class="button">--%>
<%--                <input type="button" name="backButton" value="Annulla" class="button">--%>
<%--            </div>--%>

<%--        </form>--%>

<%--        <div style="margin-top: 20px; text-align: center;">--%>
<%--            <p id="clausola">*: Campo obbligatorio</p>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <!--FORM DI ANNULLA => TORNO NELLA HOME DEGLI UTENTI O DELL'ADMIN-->--%>
<%--    <form name="backForm" method="post" action="Dispatcher">--%>
<%--        <input type="hidden" name="controllerAction"/>--%>
<%--    </form>--%>

<%--</main>--%>

<%--<%@include file="/include/footer.jsp" %>--%>

<%--</body>--%>
<%--</html>--%>
