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
    double prezzoTotale = 0.0;
    if (prodotti != null) {
        for (Prodotto p : prodotti) {
            prezzoTotale += p.getPrezzo() * ((Carrello) request.getAttribute("carrello")).getQuantità(); // Assicurati che Carrello abbia il metodo getQuantita()
        }
    }
    request.setAttribute("prezzoTotale", prezzoTotale); // imposto prezzototale nella request http

    boolean loggedOn = false;
    LoggedUser loggedUser = null;
    if (request.getAttribute("loggedUser") != null) {
        loggedUser = (LoggedUser) request.getAttribute("loggedUser");
        loggedOn = true;
    }

    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");

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

<main class="container mt-4">
    <div class="mb-3">
        <p>Benvenuto <strong><%= (loggedUser != null) ? loggedUser.getNomeUtente() + " " + loggedUser.getCognome() : "Utente" %></strong></p>
    </div>

    <% if (prodotti != null && prodotti.size() > 0) { %>
    <!-- LISTA PRODOTTI DEL CARRELLO DA VISUALIZZARE -->
    <div class="row">
        <div class="col-md-8">
            <table class="table table-bordered">
                <thead>
                <tr>
                    <th>Prodotto</th>
                    <th>Categoria</th>
                    <th>Taglia</th> <!-- Aggiunto -->
                    <th>Materiale</th> <!-- Aggiunto -->
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
                    <td><%= prodotto.getCategoria() %></td> <!-- Categoria -->
                    <td><%= prodotto.getTaglia() %></td>    <!-- Taglia -->
                    <td><%= prodotto.getMateriale() %></td> <!-- Materiale -->
                    <td>
                        <% if (isDisponibile) { %>
                        <span style="color: green;">Disponibile</span>
                        <% } else { %>
                        <span style="color: red;">Non disponibile</span>
                        <% } %>
                    </td>
                    <td>
                        <form name="quantitaProdotto<%=i%>" action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" style="display:inline;">
                            <label for="quantita<%=i%>">Quantità: </label>
                            <select id="quantita<%=i%>" name="quantita" onchange="quantitaProdotto(<%=i%>)">
                                <% for (int j = 1; j <= 30; j++) { %>
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

        <div class="col-md-4">
            <h3>Dettagli Ordine</h3>
            <p><strong>Totale:</strong> €<%= String.format("%.2f", prezzoTotale) %></p>
            <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post" class="mb-2">
                <input type="hidden" name="controllerAction" value="Acquisto.ordina"/>
                <input type="submit" value="Ordina" class="btn btn-success btn-block"/>
            </form>
            <form action="<%= pageContext.getServletContext().getContextPath() %>/Dispatcher" method="post">
                <input type="hidden" name="controllerAction" value="Acquisto.cancella"/>
                <input type="submit" value="Cancella Carrello" class="btn btn-danger btn-block"/>
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
