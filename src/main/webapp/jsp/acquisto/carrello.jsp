<%--
    Document   : carrello
    Created on : 21-lug-2024, 11.26.32
    Author     : Oscar Costanzelli
--%>

<%@page session="false"%>
<%@page import="model.mo.Prodotto"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.session.mo.Carrello"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Impostazione del titolo della pagina
    String menuActiveLink = "Carrello";
    request.setAttribute("menuActiveLink", menuActiveLink);

    // Recupero degli attributi dalla richiesta
    ArrayList<Prodotto> prodotti = (ArrayList<Prodotto>) request.getAttribute("prodotti");
    ArrayList<Boolean> disponibilita = (ArrayList<Boolean>) request.getAttribute("disponibilita");
    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");

    double prezzoTotale = 0.0;
    if (prodotti != null && carrello != null) {
        for (int i = 0; i < prodotti.size(); i++) {
            Prodotto p = prodotti.get(i);
            Carrello c = carrello.get(i);
            prezzoTotale += p.getPrezzo() * c.getQuantità(); // Corretto
        }
    }
    request.setAttribute("prezzoTotale", prezzoTotale); // Imposto prezzoTotale nella request

    boolean loggedOn = false;
    LoggedUser loggedUser = null;
    if (request.getAttribute("loggedUser") != null) {
        loggedUser = (LoggedUser) request.getAttribute("loggedUser");
        loggedOn = true;
    }

    String applicationMessage = (String) request.getAttribute("applicationMessage");
    request.setAttribute("applicationMessage", applicationMessage);
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

<hr>
<main class="container mt-4" id="carrello-content">
    <div class="mb-3" id="benvenuto-utente">
        <p id="messaggio-benvenuto">Benvenuto <strong id="nome-utente"><%= (loggedUser != null) ? loggedUser.getNomeUtente() + " " + loggedUser.getCognome() : "Utente" %></strong></p>
    </div>

    <% if (prodotti != null && prodotti.size() > 0) { %>
    <!-- Visualizzazione dei messaggi di errore -->
    <% if (applicationMessage != null && !applicationMessage.isEmpty()) { %>
    <div class="alert alert-danger">
        <%= applicationMessage %>
    </div>
    <% } %>

    <!-- LISTA PRODOTTI DEL CARRELLO DA VISUALIZZARE -->
    <div class="row">
        <div class="col-md-8">
            <table id="carrello-table" class="table table-bordered">
                <thead>
                <tr>
                    <th>Prodotto</th>
                    <th>Categoria</th>
                    <th>Taglia</th>
                    <th>Materiale</th>
                    <th>Disponibilità</th>
                    <th>Quantità</th>
                    <th>Prezzo Unitario</th>
                    <th>Prezzo Totale</th>
                    <th>Azione</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (int i = 0; i < prodotti.size(); i++) {
                        Prodotto prodotto = prodotti.get(i);
                        Carrello carrelloItem = carrello.get(i);
                        boolean isDisponibile = disponibilita.get(i);
                        double prezzoTotaleProdotto = prodotto.getPrezzo() * carrelloItem.getQuantità();
                %>
                <tr>
                    <td>
                        <form name="prodottoForm<%=i%>" action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">
                            <input type="hidden" name="controllerAction" value="Catalogo.viewProdotto"/>
                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>"/>
                            <a href="javascript:prodottoFormSubmit(<%=i%> '<%= prodotto.getId() %>');">
                                <img src="<%= pageContext.getServletContext().getContextPath() %>/images/<%= prodotto.getImmagine() %>" width="100" height="100" alt="Immagine <%= prodotto.getNomeProdotto() %>"/>
                            </a>
                        </form>
                        <br/>
                        <strong><%= prodotto.getNomeProdotto() %></strong>
                    </td>
                    <td><%= prodotto.getCategoria() %></td>
                    <td><%= prodotto.getTaglia() %></td>
                    <td><%= prodotto.getMateriale() %></td>
                    <td>
                        <% if (isDisponibile) { %>
                        <span style="color: green;">Disponibile</span>
                        <% } else { %>
                        <span style="color: red;">Non disponibile</span>
                        <% } %>
                    </td>
                    <td>
                        <%
                            // Limita la quantità selezionabile alla disponibilità o a 30, a seconda di quale sia minore
                            int quantitaDisponibile = prodotto.getQuantita(); // Assicurati che 'prodotti.get(i).getQuantita()' rappresenti la quantità disponibile
                            int selectMax = Math.min(quantitaDisponibile, 30); // Limita a 30 se necessario
                        %>
                        <form name="quantitaProdotto<%=i%>" action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">
                            <label for="quantita<%=i%>">Quantità: </label>
                            <select id="quantita<%=i%>" name="quantita" onchange="this.form.submit()">
                                <% for (int j = 1; j <= selectMax; j++) { %>
                                <option value="<%=j%>" <%= (j == carrelloItem.getQuantità()) ? "selected" : "" %>><%=j%></option>
                                <% } %>
                            </select>
                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>"/>
                            <input type="hidden" name="controllerAction" value="Acquisto.cambiaQuantita"/>
                        </form>
                    </td>
                    <td>€<%= String.format("%.2f", prodotto.getPrezzo()) %></td>
                    <td>€<%= String.format("%.2f", prezzoTotaleProdotto) %></td>
                    <td>
                        <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">
                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>"/>
                            <input type="hidden" name="controllerAction" value="Acquisto.rimuovi"/>
                            <input type="submit" value="Rimuovi" class="btn btn-danger btn-sm"/>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="col-md-4" id="dettagli-ordine">
            <h3>Dettagli Ordine</h3>
            <p><strong>Totale:</strong> €<%= String.format("%.2f", prezzoTotale) %></p>
            <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" class="mb-2">
                <input type="hidden" name="controllerAction" value="Acquisto.ordina"/>
                <input id="ordina-button" type="submit" value="Ordina" class="btn btn-success btn-block"/>
            </form>
            <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post">
                <input type="hidden" name="controllerAction" value="Acquisto.cancella"/>
                <input id="cancella-carrello-button" type="submit" value="Cancella Carrello" class="btn btn-danger btn-block"/>
            </form>
        </div>
    </div>
    <% } else { %>
    <div style="margin-top: 20px;" class="text-center">
        <h2>Carrello vuoto</h2>
        <p>Il tuo carrello è vuoto. Per aggiungere articoli al tuo carrello naviga su <a href="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher?controllerAction=Catalogo.view">FightinClass66</a> e, quando trovi un articolo che ti interessa, clicca su "Aggiungi al carrello".</p>
    </div>
    <% } %>
</main>

<jsp:include page="/include/footer.jsp" />
</body>
</html>

<%--&lt;%&ndash; --%>
<%--    Document   : carrello--%>
<%--    Created on : 21-lug-2024, 11.26.32--%>
<%--    Author     : Oscar Costanzelli--%>
<%--&ndash;%&gt;--%>

<%--<%@page session="false"%>--%>
<%--<%@page import="model.mo.Prodotto"%>--%>
<%--<%@page import="model.session.mo.LoggedUser"%>--%>
<%--<%@page import="java.util.ArrayList"%>--%>
<%--<%@page import="model.session.mo.Carrello"%>--%>
<%--<%@page contentType="text/html" pageEncoding="UTF-8"%>--%>

<%--<%--%>
<%--    // Impostazione del titolo della pagina--%>
<%--    String menuActiveLink = "Carrello";--%>
<%--    request.setAttribute("menuActiveLink", menuActiveLink);--%>

<%--    // Recupero degli attributi dalla richiesta--%>
<%--    ArrayList<Prodotto> prodotti = (ArrayList<Prodotto>) request.getAttribute("prodotti");--%>
<%--    ArrayList<Boolean> disponibilita = (ArrayList<Boolean>) request.getAttribute("disponibilita");--%>
<%--    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");--%>

<%--    double prezzoTotale = 0.0;--%>
<%--//    if (prodotti != null) {--%>
<%--//        for (Prodotto p : prodotti) {--%>
<%--//            prezzoTotale += p.getPrezzo() * ((Carrello) request.getAttribute("carrello")).getQuantità(); // Assicurati che Carrello abbia il metodo getQuantita()--%>
<%--//        }--%>
<%--//    }--%>
<%--    if (prodotti != null && carrello != null) {--%>
<%--        for (int i = 0; i < prodotti.size(); i++) {--%>
<%--            Prodotto p = prodotti.get(i);--%>
<%--            Carrello c = carrello.get(i);--%>
<%--            prezzoTotale += p.getPrezzo() * c.getQuantità(); // Assicurati che Carrello abbia il metodo getQuantita()--%>
<%--        }--%>
<%--    }--%>
<%--    request.setAttribute("prezzoTotale", prezzoTotale); // imposto prezzototale nella request http--%>

<%--    boolean loggedOn = false;--%>
<%--    LoggedUser loggedUser = null;--%>
<%--    if (request.getAttribute("loggedUser") != null) {--%>
<%--        loggedUser = (LoggedUser) request.getAttribute("loggedUser");--%>
<%--        loggedOn = true;--%>
<%--    }--%>

<%--//    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");--%>

<%--    String applicationMessage = (String) request.getAttribute("applicationMessage");--%>
<%--    request.setAttribute("applicationMessage", applicationMessage);--%>
<%--%>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="it">--%>

<%--<jsp:include page="/include/htmlHead.jsp" />--%>
<%--<body>--%>
<%--<header>--%>
<%--    <%--%>
<%--        if (loggedOn && loggedUser.isAdmin()) {--%>
<%--    %>--%>
<%--    <jsp:include page="/include/HeaderAdmin.jsp" />--%>
<%--    <%--%>
<%--    } else {--%>
<%--    %>--%>
<%--    <jsp:include page="/include/HeaderUtente.jsp" />--%>
<%--    <%--%>
<%--        }--%>
<%--    %>--%>
<%--    <style>--%>

<%--    </style>--%>
<%--</header>--%>

<%--<hr>--%>
<%--<main class="container mt-4" id="carrello-content">--%>
<%--    <div class="mb-3" id="benvenuto-utente">--%>
<%--        <p id="messaggio-benvenuto">Benvenuto <strong id="nome-utente"><%= (loggedUser != null) ? loggedUser.getNomeUtente() + " " + loggedUser.getCognome() : "Utente" %></strong></p>--%>
<%--    </div>--%>

<%--    <% if (prodotti != null && prodotti.size() > 0) { %>--%>
<%--    <!-- LISTA PRODOTTI DEL CARRELLO DA VISUALIZZARE -->--%>
<%--    <div class="row">--%>
<%--        <div class="col-md-8">--%>
<%--            <table id="carrello-table">--%>
<%--                <thead>--%>
<%--                <tr>--%>
<%--                    <th>Prodotto</th>--%>
<%--                    <th>Categoria</th>--%>
<%--                    <th>Taglia</th>--%>
<%--                    <th>Materiale</th>--%>
<%--                    <th>Disponibilità</th>--%>
<%--                    <th>Quantità</th>--%>
<%--                    <th>Prezzo Unitario</th>--%>
<%--                    <th>Prezzo Totale</th>--%>
<%--                    <th>Azione</th>--%>
<%--                </tr>--%>
<%--                </thead>--%>
<%--                <tbody>--%>
<%--                <%--%>
<%--                    for (int i = 0; i < prodotti.size(); i++) {--%>
<%--                        Prodotto prodotto = prodotti.get(i);--%>
<%--                        Carrello carrelloItem = carrello.get(i);--%>
<%--                        boolean isDisponibile = disponibilita.get(i);--%>
<%--                        double prezzoTotaleProdotto = prodotto.getPrezzo() * carrelloItem.getQuantità();--%>
<%--                %>--%>
<%--                <tr>--%>
<%--                    <td>--%>
<%--                        <form name="prodottoForm<%=i%>" action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">--%>
<%--                            <input type="hidden" name="controllerAction" value="Catalogo.viewProdotto"/>--%>
<%--                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>"/>--%>
<%--                            <a href="javascript:prodottoFormSubmit(<%=i%> '<%= prodotto.getId() %>');">--%>
<%--                                <img src="<%= pageContext.getServletContext().getContextPath() %>/images/<%= prodotto.getImmagine() %>" width="100" height="100" alt="Immagine <%= prodotto.getNomeProdotto() %>"/>--%>
<%--                            </a>--%>
<%--                        </form>--%>
<%--                        <br/>--%>
<%--                        <strong><%= prodotto.getNomeProdotto() %></strong>--%>
<%--                    </td>--%>
<%--                    <td><%= prodotto.getCategoria() %></td>--%>
<%--                    <td><%= prodotto.getTaglia() %></td>--%>
<%--                    <td><%= prodotto.getMateriale() %></td>--%>
<%--                    <td>--%>
<%--                        <% if (isDisponibile) { %>--%>
<%--                        <span style="color: green;">Disponibile</span>--%>
<%--                        <% } else { %>--%>
<%--                        <span style="color: red;">Non disponibile</span>--%>
<%--                        <% } %>--%>
<%--                    </td>--%>
<%--                    <td>--%>
<%--                        <%--%>
<%--                            int maxQuantita = prodotto.getQuantita() + carrelloItem.getProdotto().getQuantita();--%>
<%--                            int selectMax = Math.min(maxQuantita, 30); // Limita a 30 se necessario--%>
<%--                        %>--%>
<%--                        <form name="quantitaProdotto<%=i%>" action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">--%>
<%--                            <label for="quantita<%=i%>">Quantità: </label>--%>
<%--                            <select id="quantita<%=i%>" name="quantita" onchange="quantitaProdotto(<%=i%>)">--%>
<%--                                <% for (int j = 1; j <= selectMax; j++) { %>--%>
<%--                                <option value="<%=j%>" <%= (j == carrelloItem.getProdotto().getQuantita()) ? "selected" : "" %>><%=j%></option>--%>
<%--                                <% } %>--%>
<%--                            </select>--%>
<%--                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>"/>--%>
<%--                            <input type="hidden" name="controllerAction" value="Acquisto.cambiaQuantita"/>--%>
<%--                        </form>--%>
<%--&lt;%&ndash;                        <form name="quantitaProdotto<%=i%>" action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <label for="quantita<%=i%>">Quantità: </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <select id="quantita<%=i%>" name="quantita" onchange="quantitaProdotto(<%=i%>)">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <% for (int j = 1; j <= 30; j++) { %>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <option value="<%=j%>" <%= (j == carrelloItem.getQuantità()) ? "selected" : "" %>><%=j%></option>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <% } %>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </select>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <input type="hidden" name="controllerAction" value="Acquisto.cambiaQuantita"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </form>&ndash;%&gt;--%>
<%--                    </td>--%>
<%--                    <td>€<%= String.format("%.2f", prodotto.getPrezzo()) %></td>--%>
<%--                    <td>€<%= String.format("%.2f", prezzoTotaleProdotto) %></td>--%>
<%--                    <td>--%>
<%--                        <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">--%>
<%--                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>"/>--%>
<%--                            <input type="hidden" name="controllerAction" value="Acquisto.rimuovi"/>--%>
<%--                            <input type="submit" value="Rimuovi" class="btn btn-danger btn-sm"/>--%>
<%--                        </form>--%>
<%--                    </td>--%>
<%--                </tr>--%>
<%--                <% } %>--%>
<%--                </tbody>--%>
<%--            </table>--%>

<%--        </div>--%>

<%--        <div class="col-md-4" id="dettagli-ordine">--%>
<%--            <h3>Dettagli Ordine</h3>--%>
<%--            <p><strong>Totale:</strong> <span id="totale-ordine">€<%= String.format("%.2f", prezzoTotale) %></span></p>--%>
<%--            <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" class="mb-2">--%>
<%--                <input type="hidden" name="controllerAction" value="Acquisto.ordina"/>--%>
<%--                <input id="ordina-button" type="submit" value="Ordina"/>--%>
<%--            </form>--%>
<%--            <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post">--%>
<%--                <input type="hidden" name="controllerAction" value="Acquisto.cancella"/>--%>
<%--                <input id="cancella-carrello-button" type="submit" value="Cancella Carrello"/>--%>
<%--            </form>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <% } else { %>--%>
<%--    <div style="margin-top: 20px;" class="text-center">--%>
<%--        <h2>Carrello vuoto</h2>--%>
<%--        <p>Il tuo carrello è vuoto. Per aggiungere articoli al tuo carrello naviga su <a href="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher?controllerAction=Catalogo.view">FightinClass66</a> e, quando trovi un articolo che ti interessa, clicca su "Aggiungi al carrello".</p>--%>
<%--    </div>--%>
<%--    <% } %>--%>
<%--</main>--%>
<%--&lt;%&ndash;fine parte funzionante&ndash;%&gt;--%>
<%--&lt;%&ndash;<main class="container mt-4">&ndash;%&gt;--%>
<%--&lt;%&ndash;    <div class="mb-3" id="benvenuto-utente">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <p id="messaggio-benvenuto">Benvenuto <strong id="nome-utente"><%= (loggedUser != null) ? loggedUser.getNomeUtente() + " " + loggedUser.getCognome() : "Utente" %></strong></p>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <% if (prodotti != null && prodotti.size() > 0) { %>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <!-- LISTA PRODOTTI DEL CARRELLO DA VISUALIZZARE -->&ndash;%&gt;--%>
<%--&lt;%&ndash;    <div class="row">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <div class="col-md-8">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <table class="table table-bordered">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <thead>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <tr>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th>Prodotto</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th>Categoria</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th>Taglia</th> <!-- Aggiunto -->&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th>Materiale</th> <!-- Aggiunto -->&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th>Disponibilità</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th>Quantità</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th>Prezzo Unitario</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th>Prezzo Totale</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th>Azione</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </tr>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </thead>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <tbody>&ndash;%&gt;--%>
<%--&lt;%&ndash;                &lt;%&ndash;%>--%>
<%--&lt;%&ndash;                    for (int i = 0; i < prodotti.size(); i++) {&ndash;%&gt;--%>
<%--&lt;%&ndash;                        Prodotto prodotto = prodotti.get(i);&ndash;%&gt;--%>
<%--&lt;%&ndash;                        Carrello carrelloItem = carrello.get(i);&ndash;%&gt;--%>
<%--&lt;%&ndash;                        boolean isDisponibile = disponibilita.get(i);&ndash;%&gt;--%>
<%--&lt;%&ndash;                        double prezzoTotaleProdotto = prodotto.getPrezzo() * carrelloItem.getQuantità();&ndash;%&gt;--%>
<%--&lt;%&ndash;                %>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <tr>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <form name="prodottoForm<%=i%>" action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <input type="hidden" name="controllerAction" value="Catalogo.viewProdotto"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <a href="javascript:prodottoFormSubmit(<%=i%> '<%= prodotto.getId() %>');">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <img src="<%= pageContext.getServletContext().getContextPath() %>/images/<%= prodotto.getImmagine() %>" width="100" height="100" alt="Immagine <%= prodotto.getNomeProdotto() %>"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <br/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <strong><%= prodotto.getNomeProdotto() %></strong>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <td><%= prodotto.getCategoria() %></td> <!-- Categoria -->&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <td><%= prodotto.getTaglia() %></td>    <!-- Taglia -->&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <td><%= prodotto.getMateriale() %></td> <!-- Materiale -->&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <% if (isDisponibile) { %>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <span style="color: green;">Disponibile</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <% } else { %>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <span style="color: red;">Non disponibile</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <% } %>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <form name="quantitaProdotto<%=i%>" action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <label for="quantita<%=i%>">Quantità: </label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <select id="quantita<%=i%>" name="quantita" onchange="quantitaProdotto(<%=i%>)">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <% for (int j = 1; j <= 30; j++) { %>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <option value="<%=j%>" <%= (j == carrelloItem.getQuantità()) ? "selected" : "" %>><%=j%></option>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <% } %>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </select>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <input type="hidden" name="controllerAction" value="Acquisto.cambiaQuantita"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <td>€<%= String.format("%.2f", prodotto.getPrezzo()) %></td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <td>€<%= String.format("%.2f", prezzoTotaleProdotto) %></td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <input type="hidden" name="controllerAction" value="Acquisto.rimuovi"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <input type="submit" value="Rimuovi" class="btn btn-danger btn-sm"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </tr>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <% } %>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </tbody>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </table>&ndash;%&gt;--%>

<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;        <div class="col-md-4">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <h3>Dettagli Ordine</h3>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <p><strong>Totale:</strong> €<%= String.format("%.2f", prezzoTotale) %></p>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" class="mb-2">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="hidden" name="controllerAction" value="Acquisto.ordina"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="submit" value="Ordina" class="btn btn-success btn-block"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="hidden" name="controllerAction" value="Acquisto.cancella"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="submit" value="Cancella Carrello" class="btn btn-danger btn-block"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </form>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <% } else { %>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <div style="margin-top: 20px;" class="text-center">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <h2>Carrello vuoto</h2>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <p>Il tuo carrello è vuoto. Per aggiungere articoli al tuo carrello naviga su <a href="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher?controllerAction=Catalogo.view">FightinClass66</a> e, quando trovi un articolo che ti interessa, clicca su "Aggiungi al carrello".</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <% } %>&ndash;%&gt;--%>
<%--&lt;%&ndash;</main>&ndash;%&gt;--%>

<%--<jsp:include page="/include/footer.jsp" />--%>
<%--</body>--%>
<%--</html>--%>
