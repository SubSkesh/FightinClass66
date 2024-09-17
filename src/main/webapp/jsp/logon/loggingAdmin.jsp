<%--
    Document   : loggingAdmin
    Created on : 5-mar-2020, 14.56.09
    Author     : Utente
--%>
<%@page session = "false"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Controllo se l'attributo 'loggedUser' è presente nella richiesta
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");

    // Se l'oggetto 'loggedUser' non esiste, creo un utente fittizio per evitare errori
    if (ul == null) {
        ul = new LoggedUser();
        ul.setNomeUtente("Admin");
        ul.setCognome("Default");
        ul.setEmail("admin@default.com");
        ul.setAdmin(true);  // Supponiamo che sia admin per questo esempio
    }

    // Recupero altri attributi necessari
    String applicationMessage = (String) request.getAttribute("applicationMessage");
    if (applicationMessage == null) {
        applicationMessage = "Benvenuto nell'area amministrativa!";
    }

    // Imposto un valore di default per il menu attivo
    String menuActiveLink = "Logging";
%>
<!DOCTYPE html>
<html lang="it-IT">
<head>
    <title>Area Admin - Fighter's Arena</title>
    <style>
        body {
            background-color: #1a1a1a;
            color: #f2f2f2;
            font-family: 'Arial Black', Arial, sans-serif;
        }

        .content {
            width: 60%;
            margin-left: 20%;
            background-color: #2a2a2a;
            padding: 25px;
            border-radius: 10px;
        }

        h2 {
            color: #e63946;
            text-align: center;
            font-size: 2.2em;
            margin-bottom: 25px;
        }

        .form {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 92%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            background-color: #3a3a3a;
            color: #f2f2f2;
        }

        .button {
            background-color: #e63946;
            color: #f2f2f2;
            border: none;
            padding: 12px 25px;
            margin-right: 15px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            font-size: 1em;
        }

        .button:hover {
            background-color: #d62839;
        }

        #clausola {
            font-size: 0.9em;
            color: #a8a8a8;
            text-align: center;
        }

        .nome p {
            text-align: center;
            font-size: 1.3em;
            margin-bottom: 25px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .content {
                width: 80%;
                margin-left: 10%;
            }

            input[type="text"],
            input[type="email"],
            input[type="password"] {
                width: 100%;
            }

            .button {
                width: 45%;
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>

<header>
    <!-- Includi l'header per l'admin -->
    <%@include file="/include/HeaderAdmin.jsp"%>
</header>

<hr>

<main>
    <div class="nome" style="margin-bottom: 20px;">
        <p>Benvenuto <%=ul.getNomeUtente()%> <%=ul.getCognome()%> nell'Area Admin di FightingClass66</p>
    </div>

    <div class="content">
        <div>
            <h2>CREA UN ACCOUNT ADMIN</h2>
        </div>

        <!-- FORM DI REGISTRAZIONE -->
        <form name="registerForm" action="Dispatcher" method="post">

            <div class="form left" style="width: 46%;">
                <label for="nome">Nome:* </label>
                <input type="text" id="nome" name="nome" value="" maxlength="20" required placeholder="Mike"/>
            </div>

            <div class="form left" style="float: left; width: 50%;">
                <label for="cognome">Cognome:* </label>
                <input type="text" id="cognome" name="cognome" value="" maxlength="20" required placeholder="Tyson"/>
            </div>

            <div style="clear: both"></div>

            <div class="form">
                <label for="email">E-Mail:* </label>
                <input type="email" id="email" name="email" autocomplete="username email" value="" maxlength="50" required placeholder="mike.tyson@boxing.com"/>
            </div>

            <div class="form">
                <label for="password">Password:* </label>
                <input type="password" id="password" name="password" autocomplete="new-password" maxlength="50" required/>
            </div>

            <div class="form">
                <label for="passwordConf">Conferma Password:* </label>
                <input type="password" id="passwordConf" name="passwordConf" autocomplete="new-password" maxlength="50" required/>
            </div>

            <div class="form">
                <label>Sesso:* </label>
                <input type="radio" name="genere" value="M" checked>Maschio
                <input type="radio" name="genere" value="F">Femmina
            </div>

            <div class="form left" style="width: 47%;">
                <label for="nazione">Nazione:* </label>
                <input type="text" id="nazione" name="nazione" value="" maxlength="20" required placeholder="Stati Uniti"/>
            </div>

            <div class="form left" style="float: left; width: 49%;">
                <label for="citta">Citt&agrave;:* </label>
                <input type="text" id="citta" name="citta" value="" maxlength="20" required placeholder="Las Vegas"/>
            </div>

            <div style="clear: both"></div>

            <div class="form" style="float: left; width: 50%;">
                <label>Admin:* </label>
                <input type="radio" name="admin" value="S" checked>S&iacute;
                <input type="radio" name="admin" value="N">No
            </div>

            <div style="clear: both"></div>

            <div style="margin-top: 15px; text-align: center;">
                <input type="button" name="submitButton" value="Ok" class="button">
                <input type="button" name="backButton" value="Annulla" class="button">
            </div>

        </form>

        <div style="margin-top: 25px; text-align: center;">
            <p id="clausola">*: Campo obbligatorio</p>
        </div>
    </div>

</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>
