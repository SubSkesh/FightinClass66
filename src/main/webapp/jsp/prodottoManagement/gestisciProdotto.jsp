<%--
    Document   : gestisciProdotto
    Created on : 5-mar-2024, 14.59.44
    Author     : Oscar Costanzelli
--%>

<%@page session = "false"%>
<%@page import="model.mo.Prodotto"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int i = 0;

    // Azione: modifica o inserisci
    String action = (request.getAttribute("prodotto") != null) ? "modify" : "insert";

    // Gestione del prodotto per evitare null pointer exceptions
    Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");
    if (prodotto == null) {
        prodotto = new Prodotto(); // Crea un nuovo oggetto prodotto vuoto
    }

    // Verifica se l'utente è loggato
    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = (loggedOnAttr != null) ? loggedOnAttr : false;

    // Gestione dell'utente loggato per evitare null pointer exceptions
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    if (ul == null) {
        ul = new LoggedUser(); // Crea un utente vuoto se non esiste
        ul.setNomeUtente("Admin sconosciuto");
        ul.setCognome("Nurmagomedov");
    }

    // Messaggio applicativo, se non presente imposta un valore di default
    String applicationMessage = (String) request.getAttribute("applicationMessage");
    if (applicationMessage == null) {
        applicationMessage = "Nessun messaggio disponibile.";
    }


%>
<!DOCTYPE html>
<html lang="it-IT">
<head>
    <script language="javascript">
        var action = "<%=action%>";

        function validateAndSubmit(){
            var errors = [];
            var form = document.inserisciProdotto;

            if (!form.nomeProdotto.value.trim()) {
                errors.push("Il campo Nome Prodotto è obbligatorio");
            }

            if (!form.categoria.value.trim()) {
                errors.push("Il campo Categoria Prodotto è obbligatorio");
            }

            if (!form.materiale.value.trim()) {
                errors.push("Il campo Materiale è obbligatorio");
            }

            if (!form.taglia.value.trim()) {
                errors.push("Il campo Taglia è obbligatorio");
            }

            if (!form.prezzo.value.trim()) {
                errors.push("Il campo Prezzo è obbligatorio");
            }

            if (!form.immagine.value.trim()) {
                errors.push("Il campo Immagine è obbligatorio");
            }

            if (!form.quantita.value.trim()) {
                errors.push("Il campo Quantità è obbligatorio");
            }

            if (errors.length > 0) {
                alert(errors.join("\n"));
                return false;
            } else {
                form.controllerAction.value = (action === "insert") ? "ProdottoManagement.inserisciNelDB" : "ProdottoManagement.modificaProdotto";
                form.submit();
            }
        }

        function goBack(){
            document.backForm.submit();
        }

        function mainOnLoadHandler(){
            document.inserisciProdotto.backButton.addEventListener("click", goBack);
            document.inserisciProdotto.submitButton.addEventListener("click", validateAndSubmit);
        }
    </script>
    <style>
        .content {
            width: 61%;
            margin-left: 19%;
        }

        #nomeProdotto, #categoriaProdotto, #materiale, #taglia, #quantita, #prezzo, #immagine {
            width: 98%;
            height: 22px;
            font-size: large;
        }
        /* Stile per i placeholder */
        ::placeholder {
            font-family: 'Arial', sans-serif;
            font-size: 14px;
            color: #888; /* Un grigio elegante */
            font-style: italic; /* Corsivo per un tocco più fine */
        }
    </style>

    <%@include file="/include/htmlHead.jsp" %>

</head>
<body onload="mainOnLoadHandler()">

<header>
    <%@include file="/include/HeaderAdmin.jsp"%>
</header>

<hr>

<main>

    <div class="nome" style="margin-bottom: 15px;">
        <p>Benvenuto <%=ul.getNomeUtente()%> <%=ul.getCognome()%></p>
    </div>

    <div class="content">
        <%if(action.equals("modify")){%>
        <div>
            <h2>MODIFICA PRODOTTO</h2>
        </div>
        <%}else{%>
        <div>
            <h2>AGGIUNGI UN PRODOTTO</h2>
        </div>
        <%}%>
        <%-- Sezione di Debug: Visualizza i Valori Correnti del Prodotto --%>
        <% if(action.equals("modify")) { %>
        <div class="debug-section" style="border: 1px solid #f00; padding: 10px; margin-bottom: 20px;">
            <h3>Debug: Valori Correnti del Prodotto</h3>
            <ul>
                <li><strong>ID Prodotto:</strong> <%= prodotto.getId() %></li>
                <li><strong>Nome Prodotto:</strong> <%= prodotto.getNomeProdotto() %></li>
                <li><strong>Categoria:</strong> <%= prodotto.getCategoria() %></li>
                <li><strong>Materiale:</strong> <%= prodotto.getMateriale() %></li>
                <li><strong>Taglia:</strong> <%= prodotto.getTaglia() %></li>
                <li><strong>Quantità:</strong> <%= prodotto.getQuantita() %></li>
                <li><strong>Prezzo:</strong> <%= prodotto.getPrezzo() %></li>
                <li><strong>Immagine:</strong> <%= prodotto.getImmagine() %></li>
                <li><strong>Descrizione:</strong> <%= prodotto.getDescrizione() %></li>
                <li><strong>Blocked:</strong> <%= prodotto.isBlocked() ? "Sì" : "No" %></li>
                <li><strong>Push:</strong> <%= prodotto.isPush() ? "Sì" : "No" %></li>
            </ul>
        </div>
        <% } %>

        <!-- Visualizzazione dell'immagine del prodotto -->
        <% if(action.equals("modify")) { %>

        <div class="product-image">
            <img src="<%= request.getContextPath() %>/images/<%= prodotto.getImmagine() %>" alt="Immagine del prodotto" />
            <p>Nome immagine: <%= prodotto.getImmagine() %></p>
        </div>
        <% } %>

        <!--FORM PER L'INSERIMENTO O LA MODIFICA DI UN PRODOTTO-->
        <form name="inserisciProdotto" action="Dispatcher" method="post">




            <div class="form" style="width: 48%; float: left;">
                <label for="nomeProdotto">Nome del Prodotto: </label>
                <input type="text" id="nomeProdotto" name="nomeProdotto" value="<%= (prodotto.getNomeProdotto() != null) ? prodotto.getNomeProdotto() : "" %>" required maxlength="20" placeholder="Guantoni" />
            </div>

            <div class="form" style="width: 48%; float: right;">
                <label for="categoria">Categoria di prodotto: </label>
                <input type="text" id="categoria" name="categoria" value="<%= (prodotto.getCategoria() != null) ? prodotto.getCategoria() : "" %>" required maxlength="20" placeholder="Colpitori"/>
            </div>
            <!-- Campo Categoria -->
<%--            <div class="form" style="width: 48%; float: right;">--%>
<%--                <label for="categoria">Categoria di prodotto: </label>--%>
<%--                <input type="text" id="categoria" name="categoria" value="<%= (prodotto.getCategoria() != null) ? prodotto.getCategoria() : "" %>" required maxlength="20" placeholder="Colpitori"/>--%>
<%--            </div>--%>


            <div class="form" style="width: 48%; float: left;">
                <label for="materiale">Materiale: </label>
                <input type="text" id="materiale" name="materiale" value="<%= (prodotto.getMateriale() != null) ? prodotto.getMateriale() : "" %>" required maxlength="20" placeholder="Cuoio"/>
            </div>

            <div class="form" style="width: 48%; float: right;">
                <label for="taglia">Taglia: </label>
                <input type="text" id="taglia" name="taglia" value="<%= (prodotto.getTaglia() != null) ? prodotto.getTaglia() : "" %>" required maxlength="20" placeholder="10oz"/>
            </div>

            <div class="form" style="width: 48%; float: left;">
                <label for="quantita">Quantità: </label>
                <input type="text" id="quantita" name="quantita" value="<%= (prodotto.getQuantita() != 0) ? prodotto.getQuantita() : "" %>" required maxlength="20"/>
            </div>

            <div class="form" style="width: 48%; float: right;">
                <label for="prezzo">Prezzo: </label>
                <input type="text" id="prezzo" name="prezzo" value="<%= (prodotto.getPrezzo() != 0) ? prodotto.getPrezzo() : "" %>" required maxlength="20" placeholder="66,66"/>
            </div>

            <div class="form" style="width: 48%; float: left;">
                <label for="immagine">Nome immagine: </label>
                <input type="text" id="immagine" name="immagine" value="<%= (prodotto.getImmagine() != null) ? prodotto.getImmagine() : "" %>" required maxlength="100" placeholder="McGregorSmokingInDaRing.png"/>
            </div>

            <div style="clear: both;"></div>

            <div class="form">
                <label for="descrizione">Testo: </label>
                <textarea id="descrizione" name="descrizione" cols="100" rows="10" wrap="soft" required placeholder="Gloves for smashin' your face out"><%= (prodotto.getDescrizione() != null) ? prodotto.getDescrizione() : "" %></textarea>
            </div>
            <!-- Campo Descrizione -->
<%--            <div class="form">--%>
<%--                <label for="descrizione">Descrizione: </label>--%>
<%--                <textarea id="descrizione" name="descrizione" cols="100" rows="10" wrap="soft" required placeholder="Gloves for smashin' your face out"><%= (prodotto.getDescrizione() != null) ? prodotto.getDescrizione() : "" %></textarea>--%>
<%--            </div>--%>
            <% if(action.equals("modify")) { %>
            <input type="hidden" name="blocked" value="<%= prodotto.isBlocked() ? "1" : "0" %>"/>
            <input type="hidden" name="push" value="<%= prodotto.isPush() ? "1" : "0" %>"/>
            <% } %>

            <input type="hidden" name="controllerAction"/>
            <%if(action.equals("modify")){%>
            <input type="hidden" name="idProdotto" value="<%=prodotto.getId()%>"/>
            <%}%>

            <!--BOTTONI DI CONFERMA O DI ANNULLA-->
            <input type="button" name="submitButton" value="Ok" class="button">
            <input type="button" name="backButton" value="Annulla" class="button">

        </form>
    </div>

    <!--FORM PER ANNULLARE-->
    <form name="backForm" method="post" action="Dispatcher">
        <input type="hidden" name="controllerAction"/>
    </form>


</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>
