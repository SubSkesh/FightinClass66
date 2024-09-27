<%@page session = "false"%>
<%@page import="model.session.mo.Carrello"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="model.mo.Prodotto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int i = 0;
    ArrayList<String> categorie = (ArrayList<String>) request.getAttribute("categorie");
    int numcategorie = (categorie != null) ? categorie.size() : 0;

    ArrayList<String> materiali = (ArrayList<String>) request.getAttribute("materiali");
    int nummateriali = (materiali != null) ? materiali.size() : 0;

    ArrayList<String> taglie = (ArrayList<String>) request.getAttribute("taglie");
    int numtaglie = (taglie != null) ? taglie.size() : 0;

    Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");

    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = loggedOnAttr != null && loggedOnAttr;

    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");

    String applicationMessage = (String) request.getAttribute("applicationMessage");
    String menuActiveLink = "Vista Prodotto";
%>

<!DOCTYPE html>
<html lang="it-IT">
<head>
    <script language="javascript">
        var logged = <%=loggedOn%>;
        function openModal() {
            var modal = document.getElementById("myModal");
            var modalImg = document.getElementById("imgModal");
            var img = document.getElementById("ProdImage");

            modal.style.display = "block";
            modalImg.src = img.src;
        }

        function closeModal() {
            var modal = document.getElementById("myModal");
            modal.style.display = "none";
        }


        function searchProdoctByStringSubmit() {
            var f = document.searchProdoctByString;
            f.submit();
            return;
        }

        function categorieFormSubmit(index) {
            var f = document.forms["categorieForm" + index];
            f.submit();
            return;
        }

        function materialeFormSubmit(index) {
            var f = document.forms["materialeForm" + index];
            f.submit();
            return;
        }

        function taglieFormSubmit(index) {
            var f = document.forms["taglieForm" + index];
            f.submit();
            return;
        }

        function carrelloSubmit(idProdotto) {
            var f = document.carrelloForm;
            if (logged ) {
                f.idProdotto.value = idProdotto;
                alert("Prodotto inserito nel carrello");
                f.submit();
            } else {
                alert("Per inserire un prodotto nel carrello bisogna eseguire l'accesso");
            }
            return;
        }
    </script>

    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Roboto', sans-serif;
            background: url('/images/FightinClass66_inverted.jpg') no-repeat center 50px fixed;
            background-size: 100vw 100vh;
            color: white;
            position: relative;
            min-height: 100vh;
        }
        header {
            position: relative; /* Assicurati che l'header abbia una posizione impostata */
            z-index: 1; /* Mantiene l'header dietro la modale */
        }

        body::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: -1;
        }

        main, header, footer {
            z-index: 1;
            position: relative;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: rgba(0, 0, 0, 0.5);
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.5);
        }

        .nome p {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.2em;
            font-weight: bold;
            color: #ff2e2e;
            text-align: center;
            margin-bottom: 20px;
            text-transform: uppercase;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
            transition: color 0.3s ease;
        }

        .nome p:hover {
            color: white;
            transform: scale(1.05);
        }

        .left_content {
            width: 25%;
            padding: 20px;
            background-color: rgba(0, 0, 0, 0.6);
            border-right: 1px solid #ff2e2e;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.5);
        }

        .left_content h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.5em;
            font-weight: bold;
            color: #ff2e2e;
            text-transform: uppercase;
            margin-bottom: 15px;
        }

        .left_content ul li {
            margin-bottom: 10px;
        }

        .left_content a {
            color: white;
            text-transform: uppercase;
            padding: 5px 10px;
            display: block;
            text-decoration: none;
            border-left: 2px solid transparent;
            transition: color 0.3s ease, border-left 0.3s ease;
        }

        .left_content a:hover {
            color: #ff2e2e;
            border-left: 2px solid #ff2e2e;
        }

        #product-info {
            width: 70%;
            padding-left: 40px;
        }

        #product-info img {
            width: 400px;
            height: 400px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(255, 0, 0, 0.7);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        #product-info img:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 12px rgba(255, 0, 0, 0.7);
        }

        #product-info span {
            font-family: 'Roboto', sans-serif;
            color: white;
            font-size: 1.1em;
            display: block;
            margin-bottom: 10px;
        }

        #product-info .price {
            color: #ff2e2e;
            font-weight: bold;
            font-size: 1.5em;
            margin-bottom: 20px;
        }

        #ordina {
            padding: 10px 20px;
            background-color: #ff2e2e;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.2em;
            text-transform: uppercase;
            width: 100%;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        #ordina:hover {
            background-color: #e60000;
            transform: scale(1.05);
        }

        .descrizione p {
            font-family: 'Roboto', sans-serif;
            color: white;
            font-size: 1.2em;
            margin-top: 20px;
            text-align: left;
            line-height: 1.5;
        }
        /* Stile per la modale */
        .modal {
            display: none;
            position: fixed;
            z-index: 10000;
            padding-top: 100px;
            left: 0;
            top: 0;
            width: 100%;
            height:100%;
            background-color: rgba(0, 0, 0, 0.8); /* Sfondo leggermente più scuro */
        }

        .modal-content {
            margin: auto;
            display: block;
            max-width: 80%;  /* Riduce la larghezza massima al 60% dello schermo */
            max-height: 70%; /* Imposta un'altezza massima dell'80% dello schermo */
            width: auto;     /* Mantiene la proporzione naturale dell'immagine */
            height: auto;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
            border-radius: 10px;
            padding-top: 70px; /* Aggiunge spazio per spostare l'immagine più in basso */

        }

        .modal-content:hover {
            transform: scale(1.05);
            transition: transform 0.3s ease;
        }

        .close {
            position: absolute;
            top: 50px;
            right: 50px;
            color: white;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
            padding-top: 100px;
        }


        .close:hover, .close:focus {
            color: #ff2e2e;
            text-decoration: none;
            cursor: pointer;
        }


    </style>

    <%@include file="/include/htmlHead.jsp" %>
</head>
<body>
<header>
    <%@include file="/include/HeaderUtente.jsp" %>
</header>

<hr>

<main>
    <div class='nome'>
        <% if (loggedOn) { %>
        <p>Benvenuto <%= ul.getNomeUtente() %> <%= ul.getCognome() %></p>
        <% } else { %>
        <p>Benvenuto, fai il login per procedere all'acquisto dei tuoi prodotti</p>
        <% } %>
    </div>

    <aside class="left_content">
        <section>
            <h1>Categorie</h1>
            <ul>
                <% for (i = 0; i < numcategorie; i++) { %>
                <li>
                    <form name="categorieForm<%= i %>" action="Dispatcher" method="post">
                        <input type="hidden" name="controllerAction" value="Catalogo.view" />
                        <input type="hidden" name="searchType" value="categorie" />
                        <input type="hidden" name="searchName" value="<%= categorie.get(i) %>" />
                        <a href="javascript:categorieFormSubmit(<%= i %>);"><%= categorie.get(i) %></a>
                    </form>
                </li>
                <% } %>
            </ul>
        </section>

        <hr>

        <section>
            <h1>Materiali</h1>
            <ul>
                <% for (i = 0; i < nummateriali; i++) { %>
                <li>
                    <form name="materialiForm<%= i %>" action="Dispatcher" method="post">
                        <input type="hidden" name="controllerAction" value="Catalogo.view" />
                        <input type="hidden" name="searchType" value="materiali" />
                        <input type="hidden" name="searchName" value="<%= materiali.get(i) %>" />
                        <a href="javascript:materialeFormSubmit(<%= i %>);"><%= materiali.get(i) %></a>
                    </form>
                </li>
                <% } %>
            </ul>
        </section>

        <hr>

        <section>
            <h1>Taglie</h1>
            <ul>
                <% for (i = 0; i < numtaglie; i++) { %>
                <li>
                    <form name="taglieForm<%= i %>" action="Dispatcher" method="post">
                        <input type="hidden" name="controllerAction" value="Catalogo.view" />
                        <input type="hidden" name="searchType" value="taglie" />
                        <input type="hidden" name="searchName" value="<%= taglie.get(i) %>" />
                        <a href="javascript:taglieFormSubmit(<%= i %>);"><%= taglie.get(i) %></a>
                    </form>
                </li>
                <% } %>
            </ul>
        </section>
    </aside>
    <!-- Immagine del prodotto -->
    <div id="product-info">
        <div>
            <img id="ProdImage" src="images/<%= prodotto.getImmagine() %>" alt="Visualizza prodotto" onclick="openModal();"/>
        </div>

        <div style="margin-left: 40px;">
            <span>Categoria: <%= prodotto.getCategoria() %></span>
            <span>Materiale: <%= prodotto.getMateriale() %></span>
            <span>Taglia: <%= prodotto.getTaglia() %></span>
            <span class="price">Prezzo: €<%= String.format("%.2f", prodotto.getPrezzo()) %></span>

            <section>
                <form name="carrelloForm" action="Dispatcher" method="post">
                    <input type="hidden" name="controllerAction" value="Catalogo.insert" />
                    <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>" />


                <div>
                    <label for="quantita">Quantità: </label>
                    <input type="number" id="quantita" name="quantita" value="1" min="1" max="<%=prodotto.getQuantita()%>" step="1" />
                </div>

                <div style="margin-top: 30px;">
                    <a href="javascript:carrelloSubmit(<%= prodotto.getId() %>);" id="ordina">Aggiungi al carrello</a>
                </div>
                </form>
            </section>
        </div>
    </div>

    <!-- Modal -->
    <div id="myModal" class="modal">
        <span class="close" onclick="closeModal()">&times;</span>
        <img class="modal-content" id="imgModal">
    </div>


<%--    <div id="product-info">--%>
<%--        <div>--%>
<%--            <img id="ProdImage" src="images/<%= prodotto.getImmagine() %>" alt="Visualizza prodotto" />--%>
<%--        </div>--%>

<%--        <div style="margin-left: 40px;">--%>
<%--            <span>Categoria: <%= prodotto.getCategoria() %></span>--%>
<%--            <span>Materiale: <%= prodotto.getMateriale() %></span>--%>
<%--            <span>Taglia: <%= prodotto.getTaglia() %></span>--%>
<%--            <span class="price">Prezzo: €<%= String.format("%.2f", prodotto.getPrezzo()) %></span>--%>

<%--            <section>--%>
<%--                <form name="carrelloForm" action="Dispatcher" method="post">--%>
<%--                    <input type="hidden" name="controllerAction" value="Catalogo.insert" />--%>
<%--                    <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>" />--%>
<%--                </form>--%>

<%--                <div>--%>
<%--                    <label for="quantita">Quantità: </label>--%>
<%--                    <input type="number" id="quantita" name="quantita" value="1" min="1" max="30" step="1" />--%>
<%--                </div>--%>

<%--                <div style="margin-top: 30px;">--%>
<%--                    <a href="javascript:carrelloSubmit(<%= prodotto.getId() %>);" id="ordina">Aggiungi al carrello</a>--%>
<%--                </div>--%>
<%--            </section>--%>
<%--        </div>--%>
<%--    </div>--%>

    <div class="descrizione">
        <p><b>Descrizione prodotto</b></p>
        <p><%= prodotto.getDescrizione() %></p>
    </div>

    <div style="clear: both;"></div>
</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>
<%--&lt;%&ndash;fine partefunzionante&ndash;%&gt;--%>

<%--&lt;%&ndash;<%@page session = "false"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@page import="model.session.mo.Carrello"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@page import="java.util.ArrayList"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@page import="model.session.mo.LoggedUser"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@page import="model.mo.Prodotto"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@page contentType="text/html" pageEncoding="UTF-8"%>&ndash;%&gt;--%>

<%--&lt;%&ndash;&lt;%&ndash;%>--%>
<%--&lt;%&ndash;    int i = 0;&ndash;%&gt;--%>
<%--&lt;%&ndash;    ArrayList<String> categorie = (ArrayList<String>) request.getAttribute("categoria");&ndash;%&gt;--%>
<%--&lt;%&ndash;    int numcategorie = (categorie != null) ? categorie.size() : 0;&ndash;%&gt;--%>

<%--&lt;%&ndash;    ArrayList<String> materiali = (ArrayList<String>) request.getAttribute("materiale");&ndash;%&gt;--%>
<%--&lt;%&ndash;    int nummateriali = (materiali != null) ? materiali.size() : 0;&ndash;%&gt;--%>

<%--&lt;%&ndash;    ArrayList<String> taglie = (ArrayList<String>) request.getAttribute("taglie");&ndash;%&gt;--%>
<%--&lt;%&ndash;    int numtaglie = (taglie != null) ? taglie.size() : 0;&ndash;%&gt;--%>

<%--&lt;%&ndash;    Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");&ndash;%&gt;--%>

<%--&lt;%&ndash;    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");&ndash;%&gt;--%>
<%--&lt;%&ndash;    boolean loggedOn = loggedOnAttr != null && loggedOnAttr;&ndash;%&gt;--%>

<%--&lt;%&ndash;    /*Carico i cookie*/&ndash;%&gt;--%>
<%--&lt;%&ndash;    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");&ndash;%&gt;--%>
<%--&lt;%&ndash;    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");&ndash;%&gt;--%>

<%--&lt;%&ndash;    String applicationMessage = (String) request.getAttribute("applicationMessage");&ndash;%&gt;--%>
<%--&lt;%&ndash;    String menuActiveLink = "Vista Prodotto";&ndash;%&gt;--%>
<%--&lt;%&ndash;%>&ndash;%&gt;--%>

<%--&lt;%&ndash;<!DOCTYPE html>&ndash;%&gt;--%>
<%--&lt;%&ndash;<html lang="it-IT">&ndash;%&gt;--%>
<%--&lt;%&ndash;<head>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <script language="javascript">&ndash;%&gt;--%>
<%--&lt;%&ndash;        var logged = <%=loggedOn%>;&ndash;%&gt;--%>

<%--&lt;%&ndash;        function searchProdoctByStringSubmit(){&ndash;%&gt;--%>
<%--&lt;%&ndash;            var f = document.searchProdoctByString;&ndash;%&gt;--%>
<%--&lt;%&ndash;            f.submit();&ndash;%&gt;--%>
<%--&lt;%&ndash;            return;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        function categorieFormSubmit(index){&ndash;%&gt;--%>
<%--&lt;%&ndash;            var f = document.forms["categorieForm" + index];&ndash;%&gt;--%>
<%--&lt;%&ndash;            f.submit();&ndash;%&gt;--%>
<%--&lt;%&ndash;            return;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        function materialeFormSubmit(index){&ndash;%&gt;--%>
<%--&lt;%&ndash;            var f = document.forms["materialeForm" + index];&ndash;%&gt;--%>
<%--&lt;%&ndash;            f.submit();&ndash;%&gt;--%>
<%--&lt;%&ndash;            return;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        function taglieFormSubmit(index){&ndash;%&gt;--%>
<%--&lt;%&ndash;            var f = document.forms["taglieForm" + index];&ndash;%&gt;--%>
<%--&lt;%&ndash;            f.submit();&ndash;%&gt;--%>
<%--&lt;%&ndash;            return;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        function carrelloSubmit(idProdotto){&ndash;%&gt;--%>
<%--&lt;%&ndash;            var f = document.carrelloForm;&ndash;%&gt;--%>
<%--&lt;%&ndash;            if(logged){&ndash;%&gt;--%>
<%--&lt;%&ndash;                f.idProdotto.value = idProdotto;&ndash;%&gt;--%>
<%--&lt;%&ndash;                alert("Prodotto inserito nel carrello");&ndash;%&gt;--%>
<%--&lt;%&ndash;                f.submit();&ndash;%&gt;--%>
<%--&lt;%&ndash;            }else{&ndash;%&gt;--%>
<%--&lt;%&ndash;                alert("Per inserire un prodotto nel carrello bisogna eseguire l'accesso");&ndash;%&gt;--%>
<%--&lt;%&ndash;            }&ndash;%&gt;--%>
<%--&lt;%&ndash;            return;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>
<%--&lt;%&ndash;    </script>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <style>&ndash;%&gt;--%>
<%--&lt;%&ndash;        img {&ndash;%&gt;--%>
<%--&lt;%&ndash;            float: left;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>

<%--&lt;%&ndash;        #ordina{&ndash;%&gt;--%>
<%--&lt;%&ndash;            padding: 5px 10px;&ndash;%&gt;--%>
<%--&lt;%&ndash;            background-color: #228b22;&ndash;%&gt;--%>
<%--&lt;%&ndash;            color: #ffffff;&ndash;%&gt;--%>
<%--&lt;%&ndash;            border: 1px solid #000000;&ndash;%&gt;--%>
<%--&lt;%&ndash;            border-radius: 8px;&ndash;%&gt;--%>
<%--&lt;%&ndash;            cursor: pointer;&ndash;%&gt;--%>
<%--&lt;%&ndash;            font-size: large;&ndash;%&gt;--%>
<%--&lt;%&ndash;            width: 100%;&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>
<%--&lt;%&ndash;    </style>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <%@include file="/include/htmlHead.jsp" %>&ndash;%&gt;--%>
<%--&lt;%&ndash;</head>&ndash;%&gt;--%>
<%--&lt;%&ndash;<body>&ndash;%&gt;--%>
<%--&lt;%&ndash;<header>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <%@include file="/include/HeaderUtente.jsp" %>&ndash;%&gt;--%>
<%--&lt;%&ndash;</header>&ndash;%&gt;--%>

<%--&lt;%&ndash;<hr>&ndash;%&gt;--%>

<%--&lt;%&ndash;<main>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <div class='nome'>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <%if(loggedOn){%>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <p>Benvenuto <%=ul.getNomeUtente()%> <%=ul.getCognome()%></p>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <%}else{%>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <p>Benvenuto, fai il login per procedere all'acquisto dei tuoi prodotti</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <%}%>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <!--BARRA LATERALE PER LA RICERCA DEI PRODOTTI-->&ndash;%&gt;--%>
<%--&lt;%&ndash;    <aside class="left_content">&ndash;%&gt;--%>

<%--&lt;%&ndash;        <section>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <h1>Categorie</h1>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <ul>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <%for(i = 0; i < numcategorie; i++){%>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <li>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <form name="categorieForm<%=i%>" action="Dispatcher" method="post">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="searchType" value="categoria"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="searchName" value="<%=categorie.get(i)%>"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <a href="javascript:categorieFormSubmit(<%=i%>);"><%=categorie.get(i)%></a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </li>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <%}%>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </ul>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </section>&ndash;%&gt;--%>

<%--&lt;%&ndash;        <hr>&ndash;%&gt;--%>

<%--&lt;%&ndash;        <section>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <h1>Materiali</h1>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <ul>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <%for(i = 0; i < nummateriali; i++){%>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <li>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <form name="materialiForm<%=i%>" action="Dispatcher" method="post">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="searchType" value="materiale"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="searchName" value="<%=materiali.get(i)%>"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <a href="javascript:materialeFormSubmit(<%=i%>);"><%=materiali.get(i)%></a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </li>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <%}%>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </ul>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </section>&ndash;%&gt;--%>

<%--&lt;%&ndash;        <hr>&ndash;%&gt;--%>

<%--&lt;%&ndash;        <section>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <h1>Taglie</h1>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <ul>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <%for(i = 0; i < numtaglie; i++){%>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <li>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <form name="taglieForm<%=i%>" action="Dispatcher" method="post">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="searchType" value="taglie"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="searchName" value="<%=taglie.get(i)%>"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <a href="javascript:taglieFormSubmit(<%=i%>);"><%=taglie.get(i)%></a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </li>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <%}%>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </ul>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </section>&ndash;%&gt;--%>

<%--&lt;%&ndash;    </aside>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <!--BARRA DI RICERCA LIBERA-->&ndash;%&gt;--%>
<%--&lt;%&ndash;    <section id="search">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <div class="searchBar">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <form name="searchProdoctByString" action="Dispatcher" method="post">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="text" id="searchName" name="searchName" maxlength="100" placeholder="Cerca...">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="hidden" name="searchType" value="searchString"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="hidden" name="controllerAction" value="Catalogo.view"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <a href="javascript:searchProdoctByStringSubmit();">CERCA</a>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </section>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <!--INFORMAZIONI PRODOTTO-->&ndash;%&gt;--%>
<%--&lt;%&ndash;    <div style="float: left; width: 88%;">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <div style="float: left; margin-left: 70px;">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <img id="ProdImage" src="images/<%=prodotto.getImmagine()%>" width="400" height="400" alt="Visualizza prodotto"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;        <div style="float: left; margin-left: 70px;">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <span>categoria: <%=prodotto.getCategoria()%></span>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <br/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <span>materiale: <%=prodotto.getMateriale()%></span>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <br/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <span>taglia: <%=prodotto.getTaglia()%></span>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <br/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <span>Prezzo: €<%=prodotto.getPrezzo()%></span>&ndash;%&gt;--%>

<%--&lt;%&ndash;            <!--FORM DI INSERIMENTO PRODOTTO NEL CARRELLO-->&ndash;%&gt;--%>
<%--&lt;%&ndash;            <section>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <form name="carrelloForm" action="Dispatcher" method="post">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="controllerAction" value="Catalogo.insert"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="hidden" name="idProdotto" value="<%=prodotto.getId()%>"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;                <div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <label for="quantita">Quantità: </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <input type="number" id="quantita" name="quantita" value="1" min="1" max="30" step="1"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;                <div style="margin-top: 70px;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <a href="javascript:carrelloSubmit(<%=prodotto.getId()%>);" id="ordina">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        Aggiungi al carrello&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </section>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <div class="descrizione">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <!--DESCRIZIONE PRODOTTO-->&ndash;%&gt;--%>
<%--&lt;%&ndash;        <p><b>Descrizione prodotto</b></p>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <br/>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <p><%=prodotto.getDescrizione()%></p>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <div style="clear: both;">&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;</main>&ndash;%&gt;--%>

<%--&lt;%&ndash;<%@include file="/include/footer.jsp" %>&ndash;%&gt;--%>

<%--&lt;%&ndash;</body>&ndash;%&gt;--%>
<%--&lt;%&ndash;</html>&ndash;%&gt;--%>
