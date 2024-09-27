

    <%--
        Document   : catalogo
        Created on : 5-mar-2024, 14.54.40
        Author     : Oscar Costanzelli
    --%>

    <%@page session="false"%>
    <%@page import="model.session.mo.LoggedUser"%>
    <%@page import="model.mo.Prodotto"%>
    <%@page import="java.util.ArrayList"%>
    <%@page import="model.session.mo.Carrello"%>
    <%@page contentType="text/html" pageEncoding="UTF-8"%>

    <%
        int i = 0;

        ArrayList<String> categoriaProdotto = (ArrayList<String>) request.getAttribute("categorie");
        int numcat = (categoriaProdotto == null) ? 0 : categoriaProdotto.size();

        ArrayList<String> materiali = (ArrayList<String>) request.getAttribute("materiali");
        int nummat = (materiali == null) ? 0 : materiali.size();

        ArrayList<String> taglie = (ArrayList<String>) request.getAttribute("taglie");
        int numtaglie = (taglie == null) ? 0 : taglie.size();

        ArrayList<Prodotto> prodotti = (ArrayList<Prodotto>) request.getAttribute("prodotti");
        int numProdotto = (prodotti == null) ? 0 : prodotti.size();

        Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
        boolean loggedOn = (loggedOnAttr != null && loggedOnAttr.booleanValue());

        LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
        ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");

        String applicationMessage = (String) request.getAttribute("applicationMessage");
        String menuActiveLink = "Catalogo";
    %>

    <!DOCTYPE html>
    <html lang="it-IT">
    <head>
        <script language="javascript">
            function prodottoFormSubmit(index, idProdotto) {
                var f = document.forms["prodottoForm" + index];
                f.idProdotto.value = idProdotto;
                f.submit();
                return;
            }

            function searchProductByStringSubmit() {
                var f = document.searchProductByString;
                f.submit();
                return;
            }

            function categorieSubmit(index) {
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

            function submitControllerAction() {
                document.getElementById('loginForm').submit();
            }
        </script>

        <%@include file="/include/htmlHead.jsp" %>
    </head>
    <body>
    <header>
        <%@include file="/include/HeaderUtente.jsp" %>
    </header>

    <hr>

    <main>
        <form id="loginForm" action="Dispatcher" method="post">
            <input type="hidden" name="controllerAction" value="LogOn.view"/>
        </form>

        <% if (!loggedOn) { %>
        <div class='nome' onclick="submitControllerAction()" style="cursor: pointer;">
            <p>Benvenuto, fai il login per procedere all'acquisto dei tuoi prodotti</p>
        </div>
        <% } else { %>
        <div class='nome' style="cursor: default;">
            <p>Benvenuto <%= ul.getNomeUtente() %> <%= ul.getCognome() %></p>
        </div>
        <% } %>

        <!-- BARRA LATERALE PER LA RICERCA DEI PRODOTTI -->
        <aside class="left_content">
            <section>
                <h1>Categorie</h1>
                <ul>
                    <% for(i = 0; i < numcat; i++) { %>
                    <li>
                        <form name="categorieForm<%=i%>" action="Dispatcher" method="post">
                            <input type="hidden" name="controllerAction" value="Catalogo.view"/>
                            <input type="hidden" name="searchType" value="categorie"/>
                            <input type="hidden" name="searchName" value="<%=categoriaProdotto.get(i)%>"/>
                            <a href="javascript:categorieSubmit(<%=i%>);"><%=categoriaProdotto.get(i)%></a>
                        </form>
                    </li>
                    <% } %>
                </ul>
            </section>

            <hr>

            <section>
                <h1>Materiali</h1>
                <ul>
                    <% for(i = 0; i < nummat; i++) { %>
                    <li>
                        <form name="materialeForm<%=i%>" action="Dispatcher" method="post">
                            <input type="hidden" name="controllerAction" value="Catalogo.view"/>
                            <input type="hidden" name="searchType" value="materiali"/>
                            <input type="hidden" name="searchName" value="<%=materiali.get(i)%>"/>
                            <a href="javascript:materialeFormSubmit(<%=i%>);"><%=materiali.get(i)%></a>
                        </form>
                    </li>
                    <% } %>
                </ul>
            </section>

            <hr>

            <section>
                <h1>Taglie</h1>
                <ul>
                    <% for(i = 0; i < numtaglie; i++) { %>
                    <li>
                        <form name="taglieForm<%=i%>" action="Dispatcher" method="post">
                            <input type="hidden" name="controllerAction" value="Catalogo.view"/>
                            <input type="hidden" name="searchType" value="taglie"/>
                            <input type="hidden" name="searchName" value="<%=taglie.get(i)%>"/>
                            <a href="javascript:taglieFormSubmit(<%=i%>);"><%=taglie.get(i)%></a>
                        </form>
                    </li>
                    <% } %>
                </ul>
            </section>
        </aside>

        <!-- BARRA DI RICERCA -->
        <section id="search">
            <div class="searchBar">
                <form name="searchProductByString" action="Dispatcher" method="post">
                    <input type="text" id="searchName" name="searchName" maxlength="100" placeholder="Cerca...">
                    <input type="hidden" name="searchType" value="searchString"/>
                    <input type="hidden" name="controllerAction" value="Catalogo.view"/>
                    <a href="javascript:searchProductByStringSubmit();">CERCA</a>
                </form>
            </div>
        </section>

        <div style="clear: right;"></div>

        <!-- LISTA PRODOTTI DEL CATALOGO -->
        <% if (numProdotto == 0) { %>
        <div id="attenzione" style="margin-top: 20px; margin-left: 163px;">
            <h2>Attenzione</h2>
            <p>La ricerca effettuata non ha prodotto risultati. Per visionare il catalogo degli articoli, visita <a href="Dispatcher?controllerAction=Catalogo.view">FightinClass66</a> e aggiungi gli articoli al carrello.</p>
        </div>
        <% } else { %>
        <section class="catalogo-container">
            <% for (i = 0; i < numProdotto; i++) { %>
            <div class="catalogo-item">
                <form name="prodottoForm<%=i%>" action="Dispatcher" method="post">
                    <input type="hidden" name="controllerAction" value="Catalogo.viewProdotto"/>
                    <input type="hidden" name="idProdotto"/>
                    <a href="javascript:prodottoFormSubmit(<%=i%>, <%=prodotti.get(i).getId()%>);">
                        <img src="images/<%=prodotti.get(i).getImmagine()%>" alt="Visualizza prodotto"/>
                    </a>
                </form>
                <h3><%=prodotti.get(i).getNomeProdotto()%></h3>
                <p>€<%= String.format("%.2f", prodotti.get(i).getPrezzo()) %></p>
<%--                <a href="#" class="button">Aggiungi al Carrello</a>--%>
            </div>
            <% } %>
        </section>
        <% } %>

    </main>

    <%@include file="/include/footer.jsp" %>

    </body>
    </html>

    <%--&lt;%&ndash;--%>
    <%--    Document   : catalogo--%>
    <%--    Created on : 5-mar-2020, 14.54.40--%>
    <%--    Author     : Oscar Costanzelli--%>
    <%--&ndash;%&gt;--%>

    <%--<%@page session="false"%>--%>
    <%--<%@page import="model.session.mo.LoggedUser"%>--%>
    <%--<%@page import="model.mo.Prodotto"%>--%>
    <%--<%@page import="java.util.ArrayList"%>--%>
    <%--<%@page import="model.session.mo.Carrello"%>--%>
    <%--<%@page contentType="text/html" pageEncoding="UTF-8"%>--%>

    <%--<%--%>
    <%--    int i = 0;--%>

    <%--    ArrayList<String> categoriaProdotto = (ArrayList<String>) request.getAttribute("categorie");--%>
    <%--    int numcat;--%>
    <%--    if(categoriaProdotto == null){--%>
    <%--        numcat = 0;--%>
    <%--    } else{--%>
    <%--        numcat = categoriaProdotto.size();--%>
    <%--    }--%>

    <%--    ArrayList<String> materaiali = (ArrayList<String>) request.getAttribute("materiali");--%>
    <%--    int nummat;--%>
    <%--    if(materaiali == null){--%>
    <%--        nummat = 0;--%>
    <%--    } else{--%>
    <%--        nummat = materaiali.size();--%>
    <%--    }--%>

    <%--    ArrayList<String> taglie = (ArrayList<String>) request.getAttribute("taglie");--%>
    <%--    int numtaglie;--%>
    <%--    if(taglie == null){--%>
    <%--        numtaglie = 0;--%>
    <%--    } else{--%>
    <%--        numtaglie = taglie.size();--%>
    <%--    }--%>

    <%--    ArrayList<Prodotto> prodotti = (ArrayList<Prodotto>) request.getAttribute("prodotti");--%>
    <%--    int numProdotto;--%>
    <%--    if(prodotti == null){--%>
    <%--        numProdotto = 0;--%>
    <%--    } else{--%>
    <%--        numProdotto = prodotti.size();--%>
    <%--    }--%>

    <%--    // Controllo se l'attributo "loggedOn" esiste nella richiesta--%>
    <%--    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");--%>
    <%--    boolean loggedOn = loggedOnAttr != null && loggedOnAttr.booleanValue();  // Se null, impostato a false--%>

    <%--    /* Carico i cookie */--%>
    <%--    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");--%>
    <%--    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");--%>

    <%--    String applicationMessage = (String) request.getAttribute("applicationMessage");--%>

    <%--    String menuActiveLink = "Catalogo";--%>
    <%--%>--%>
    <%--<!DOCTYPE html>--%>
    <%--<html lang="it-IT">--%>
    <%--<head>--%>
    <%--    <script language="javascript">--%>
    <%--        function prodottoFormSubmit(index, idProdotto){--%>
    <%--            var f = document.forms["prodottoForm" + index];--%>
    <%--            f.idProdotto.value = idProdotto;  // Valorizza l'id del prodotto--%>
    <%--            f.submit();--%>
    <%--            return;--%>
    <%--        }--%>

    <%--        function searchProdoctByStringSubmit(){--%>
    <%--            var f = document.searchProdoctByString;--%>
    <%--            f.submit();--%>
    <%--            return;--%>
    <%--        }--%>

    <%--        function categorieSubmit(index){--%>
    <%--            var f = document.forms["categorieForm" + index];--%>
    <%--            f.submit();--%>
    <%--            return;--%>
    <%--        }--%>

    <%--        function materialeFormSubmit(index){--%>
    <%--            var f = document.forms["materialeForm" + index];--%>
    <%--            f.submit();--%>
    <%--            return;--%>
    <%--        }--%>

    <%--        function taglieFormSubmit(index){--%>
    <%--            var f = document.forms["taglieForm" + index];--%>
    <%--            f.submit();--%>
    <%--            return;--%>
    <%--        }--%>

    <%--        // Funzione per inviare il form al click del div (solo per utenti non loggati)--%>
    <%--        function submitControllerAction() {--%>
    <%--            document.getElementById('loginForm').submit();  // Invia il form al server--%>
    <%--        }--%>
    <%--    </script>--%>

    <%--    <%@include file="/include/htmlHead.jsp" %>--%>

    <%--</head>--%>
    <%--<body>--%>
    <%--<header>--%>
    <%--    <%@include file="/include/HeaderUtente.jsp" %>--%>
    <%--</header>--%>

    <%--<hr>--%>

    <%--<main>--%>
    <%--    <form id="loginForm" action="Dispatcher" method="post">--%>
    <%--        <input type="hidden" name="controllerAction" value="LogOn.view" />--%>
    <%--    </form>--%>

    <%--    <!-- Modifica del div 'nome' per il redirect al click solo se non loggato -->--%>
    <%--    <% if (!loggedOn) { %>--%>
    <%--    <div class='nome' onclick="submitControllerAction()" style="cursor: pointer;">--%>
    <%--        <p>Benvenuto, fai il login per procedere all'acquisto dei tuoi prodotti</p>--%>
    <%--    </div>--%>
    <%--    <% } else { %>--%>
    <%--    <div class='nome' style="cursor: default;">--%>
    <%--        <p>Benvenuto <%= ul.getNomeUtente() %> <%= ul.getCognome() %></p>--%>
    <%--    </div>--%>
    <%--    <% } %>--%>

    <%--    <!--BARRA LATERALE PER LA RICERCA DEI PRODOTTI-->--%>
    <%--    <aside class="left_content">--%>

    <%--        <section>--%>
    <%--            <h1>Categorie</h1>--%>
    <%--            <ul>--%>
    <%--                <% for(i = 0; i < numcat; i++){ %>--%>
    <%--                <li>--%>
    <%--                    <form name="categorieForm<%=i%>" action="Dispatcher" method="post">--%>
    <%--                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>--%>
    <%--                        <input type="hidden" name="searchType" value="categorie"/>--%>
    <%--                        <input type="hidden" name="searchName" value="<%=categoriaProdotto.get(i)%>"/>--%>
    <%--                        <a href="javascript:categorieSubmit(<%=i%>);"><%=categoriaProdotto.get(i)%></a>--%>
    <%--                    </form>--%>
    <%--                </li>--%>
    <%--                <% } %>--%>
    <%--            </ul>--%>
    <%--        </section>--%>

    <%--        <hr>--%>

    <%--        <section>--%>
    <%--            <h1>Materiali</h1>--%>
    <%--            <ul>--%>
    <%--                <% for(i = 0; i < nummat; i++){ %>--%>
    <%--                <li>--%>
    <%--                    <form name="materialeForm<%=i%>" action="Dispatcher" method="post">--%>
    <%--                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>--%>
    <%--                        <input type="hidden" name="searchType" value="materiali"/>--%>
    <%--                        <input type="hidden" name="searchName" value="<%=materaiali.get(i)%>"/>--%>
    <%--                        <a href="javascript:materialeFormSubmit(<%=i%>);"><%=materaiali.get(i)%></a>--%>
    <%--                    </form>--%>
    <%--                </li>--%>
    <%--                <% } %>--%>
    <%--            </ul>--%>
    <%--        </section>--%>

    <%--        <hr>--%>

    <%--        <section>--%>
    <%--            <h1>Taglie</h1>--%>
    <%--            <ul>--%>
    <%--                <% for(i = 0; i < numtaglie; i++){ %>--%>
    <%--                <li>--%>
    <%--                    <form name="taglieForm<%=i%>" action="Dispatcher" method="post">--%>
    <%--                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>--%>
    <%--                        <input type="hidden" name="searchType" value="taglie"/>--%>
    <%--                        <input type="hidden" name="searchName" value="<%=taglie.get(i)%>"/>--%>
    <%--                        <a href="javascript:taglieFormSubmit(<%=i%>);"><%=taglie.get(i)%></a>--%>
    <%--                    </form>--%>
    <%--                </li>--%>
    <%--                <% } %>--%>
    <%--            </ul>--%>
    <%--        </section>--%>

    <%--    </aside>--%>

    <%--    <!--BARRA DI RICERCA LIBERA-->--%>
    <%--    <section id="search">--%>
    <%--        <div class="searchBar">--%>
    <%--            <form name="searchProdoctByString" action="Dispatcher" method="post">--%>
    <%--                <input type="text" id="searchName" name="searchName" maxlength="100" placeholder="Cerca...">--%>
    <%--                <input type="hidden" name="searchType" value="searchString"/>--%>
    <%--                <input type="hidden" name="controllerAction" value="Catalogo.view"/>--%>
    <%--                <a href="javascript:searchProdoctByStringSubmit();">CERCA</a>--%>
    <%--            </form>--%>
    <%--        </div>--%>
    <%--    </section>--%>

    <%--    <div style="clear: right;"></div>--%>

    <%--    <!--LISTA PRODOTTI DA VISUALIZZARE-->--%>
    <%--    <% if(numProdotto == 0){ %>--%>
    <%--    <div id="attenzione" style="margin-top: 20px; margin-left: 163px;">--%>
    <%--        <h2>Attenzione</h2>--%>
    <%--        <p>La ricerca effettuata non ha prodotto risultati. Per visionare il catalogo degli articoli naviga su <a href="Dispatcher?controllerAction=Catalogo.view">FightinClass66</a> e, quando trovi un articolo che ti interessa, clicca su "Aggiungi al carrello"</p>--%>
    <%--    </div>--%>
    <%--    <% } else { %>--%>
    <%--    <section class="clearfix">--%>
    <%--        <div style="float: left; width: 88%;">--%>
    <%--            <% for (i = 0; i < numProdotto; i++) { %>--%>
    <%--            <article>--%>
    <%--                <div class="right_content">--%>
    <%--                    <form name="prodottoForm<%=i%>" action="Dispatcher" method="post">--%>
    <%--                        <input type="hidden" name="controllerAction" value="Catalogo.viewProdotto"/>--%>
    <%--                        <input type="hidden" name="idProdotto"/>--%>
    <%--                        <a href="javascript:prodottoFormSubmit(<%=i%> <%=prodotti.get(i).getId()%>);">--%>
    <%--                            <img src="images/<%=prodotti.get(i).getImmagine()%>" width="230" height="260" alt="Visualizza prodotto"/>--%>
    <%--                        </a>--%>
    <%--                    </form>--%>
    <%--                    <span><b><%=prodotti.get(i).getNomeProdotto()%></b></span>--%>
    <%--                    <br/>--%>
    <%--                    <span>€<%=prodotti.get(i).getPrezzo()%></span>--%>
    <%--                </div>--%>
    <%--            </article>--%>
    <%--            <% } %>--%>
    <%--        </div>--%>
    <%--    </section>--%>
    <%--    <% } %>--%>

    <%--</main>--%>

    <%--<%@include file="/include/footer.jsp" %>--%>

    <%--</body>--%>

    <%--</html>--%>
    <%--s--%>
    <%--&lt;%&ndash;-----------------------------------------------------------------%>
    <%--&lt;%&ndash;    Document   : catalogo&ndash;%&gt;--%>
    <%--&lt;%&ndash;    Created on : 5-mar-2020, 14.54.40&ndash;%&gt;--%>
    <%--&lt;%&ndash;    Author     : Oscar Costanzelli&ndash;%&gt;--%>
    <%--&lt;%&ndash;&ndash;%&gt;&ndash;%&gt;--%>

    <%--&lt;%&ndash;<%@page session = "false"%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<%@page import="model.session.mo.LoggedUser"%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<%@page import="model.mo.Prodotto"%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<%@page import="java.util.ArrayList"%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<%@page import="model.session.mo.Carrello"%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<%@page contentType="text/html" pageEncoding="UTF-8"%>&ndash;%&gt;--%>

    <%--&lt;%&ndash;&lt;%&ndash;%>--%>
    <%--&lt;%&ndash;    int i=0;&ndash;%&gt;--%>

    <%--&lt;%&ndash;    ArrayList<String> categoriaProdotto = (ArrayList<String>) request.getAttribute("categorie");&ndash;%&gt;--%>
    <%--&lt;%&ndash;    int numcat ;&ndash;%&gt;--%>
    <%--&lt;%&ndash;    if(categoriaProdotto == null){&ndash;%&gt;--%>
    <%--&lt;%&ndash;        numcat = 0;&ndash;%&gt;--%>
    <%--&lt;%&ndash;    }else{&ndash;%&gt;--%>
    <%--&lt;%&ndash;        numcat = categoriaProdotto.size();&ndash;%&gt;--%>
    <%--&lt;%&ndash;    }&ndash;%&gt;--%>

    <%--&lt;%&ndash;    ArrayList<String> materaiali = (ArrayList<String>) request.getAttribute("materiali");&ndash;%&gt;--%>
    <%--&lt;%&ndash;    int nummat;&ndash;%&gt;--%>
    <%--&lt;%&ndash;    if(materaiali == null){&ndash;%&gt;--%>
    <%--&lt;%&ndash;        nummat = 0;&ndash;%&gt;--%>
    <%--&lt;%&ndash;    }else{&ndash;%&gt;--%>
    <%--&lt;%&ndash;        nummat = materaiali.size();&ndash;%&gt;--%>
    <%--&lt;%&ndash;    }&ndash;%&gt;--%>

    <%--&lt;%&ndash;    ArrayList<String> taglie = (ArrayList<String>) request.getAttribute("taglie");&ndash;%&gt;--%>
    <%--&lt;%&ndash;    int numtaglie;&ndash;%&gt;--%>
    <%--&lt;%&ndash;    if(taglie == null){&ndash;%&gt;--%>
    <%--&lt;%&ndash;        numtaglie = 0;&ndash;%&gt;--%>
    <%--&lt;%&ndash;    }else{&ndash;%&gt;--%>
    <%--&lt;%&ndash;        numtaglie = taglie.size();&ndash;%&gt;--%>
    <%--&lt;%&ndash;    }&ndash;%&gt;--%>

    <%--&lt;%&ndash;    ArrayList<Prodotto> prodotti = (ArrayList<Prodotto>) request.getAttribute("prodotti");&ndash;%&gt;--%>
    <%--&lt;%&ndash;    int numProdotto;&ndash;%&gt;--%>
    <%--&lt;%&ndash;    if(prodotti == null){&ndash;%&gt;--%>
    <%--&lt;%&ndash;        numProdotto = 0;&ndash;%&gt;--%>
    <%--&lt;%&ndash;    }else{&ndash;%&gt;--%>
    <%--&lt;%&ndash;        numProdotto = prodotti.size();&ndash;%&gt;--%>
    <%--&lt;%&ndash;    }&ndash;%&gt;--%>

    <%--&lt;%&ndash; //   boolean loggedOn = (boolean) request.getAttribute("loggedOn");&ndash;%&gt;--%>
    <%--&lt;%&ndash;    // Controllo se l'attributo "loggedOn" esiste nella richiesta&ndash;%&gt;--%>
    <%--&lt;%&ndash;    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");&ndash;%&gt;--%>
    <%--&lt;%&ndash;    boolean loggedOn = loggedOnAttr != null && loggedOnAttr.booleanValue();  // Se null, impostato a false&ndash;%&gt;--%>


    <%--&lt;%&ndash;    /*Carico i cookie*/&ndash;%&gt;--%>
    <%--&lt;%&ndash;    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");&ndash;%&gt;--%>
    <%--&lt;%&ndash;    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");&ndash;%&gt;--%>

    <%--&lt;%&ndash;    String applicationMessage = (String) request.getAttribute("applicationMessage");&ndash;%&gt;--%>

    <%--&lt;%&ndash;    String menuActiveLink = "Catalogo";&ndash;%&gt;--%>
    <%--&lt;%&ndash;%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<!DOCTYPE html>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<html lang="it-IT">&ndash;%&gt;--%>
    <%--&lt;%&ndash;<head>&ndash;%&gt;--%>
    <%--&lt;%&ndash;    <script language="javascript">&ndash;%&gt;--%>
    <%--&lt;%&ndash;        function prodottoFormSubmit(index, idProdotto){&ndash;%&gt;--%>
    <%--&lt;%&ndash;            var f = document.forms["prodottoForm" + index];&ndash;%&gt;--%>
    <%--&lt;%&ndash;            f.idProdotto.value = idProdotto;  // Valorizza l'id del prodotto&ndash;%&gt;--%>
    <%--&lt;%&ndash;            f.submit();&ndash;%&gt;--%>
    <%--&lt;%&ndash;            return;&ndash;%&gt;--%>
    <%--&lt;%&ndash;        }&ndash;%&gt;--%>

    <%--&lt;%&ndash;        function searchProdoctByStringSubmit(){&ndash;%&gt;--%>
    <%--&lt;%&ndash;            var f = document.searchProdoctByString;&ndash;%&gt;--%>
    <%--&lt;%&ndash;            f.submit();&ndash;%&gt;--%>
    <%--&lt;%&ndash;            return;&ndash;%&gt;--%>
    <%--&lt;%&ndash;        }&ndash;%&gt;--%>

    <%--&lt;%&ndash;        function categorieSubmit(index){&ndash;%&gt;--%>
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
    <%--&lt;%&ndash;            var f = document.forms["taglieiForm" + index];&ndash;%&gt;--%>
    <%--&lt;%&ndash;            f.submit();&ndash;%&gt;--%>
    <%--&lt;%&ndash;            return;&ndash;%&gt;--%>
    <%--&lt;%&ndash;        }&ndash;%&gt;--%>
    <%--&lt;%&ndash;        // Funzione per inviare il form al click del div&ndash;%&gt;--%>
    <%--&lt;%&ndash;        function submitControllerAction() {&ndash;%&gt;--%>
    <%--&lt;%&ndash;            document.getElementById('loginForm').submit();  // Invia il form al server&ndash;%&gt;--%>
    <%--&lt;%&ndash;        }&ndash;%&gt;--%>
    <%--&lt;%&ndash;    </script>&ndash;%&gt;--%>

    <%--&lt;%&ndash;    <%@include file="/include/htmlHead.jsp" %>&ndash;%&gt;--%>

    <%--&lt;%&ndash;</head>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<body>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<header>&ndash;%&gt;--%>
    <%--&lt;%&ndash;    <%@include file="/include/HeaderUtente.jsp" %>&ndash;%&gt;--%>
    <%--&lt;%&ndash;</header>&ndash;%&gt;--%>

    <%--&lt;%&ndash;<hr>&ndash;%&gt;--%>

    <%--&lt;%&ndash;<main>&ndash;%&gt;--%>
    <%--&lt;%&ndash;    <form id="loginForm" action="Dispatcher" method="post">&ndash;%&gt;--%>
    <%--&lt;%&ndash;        <input type="hidden" name="controllerAction" value="LogOn.view" />&ndash;%&gt;--%>
    <%--&lt;%&ndash;    </form>&ndash;%&gt;--%>

    <%--&lt;%&ndash;    <!-- Modifica del div 'nome' per il redirect al click -->&ndash;%&gt;--%>
    <%--&lt;%&ndash;    <div class='nome' onclick="submitControllerAction()">&ndash;%&gt;--%>
    <%--&lt;%&ndash;        <%if(loggedOn){%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;        <p>Benvenuto <%=ul.getNomeUtente()%> <%=ul.getCognome()%></p>&ndash;%&gt;--%>
    <%--&lt;%&ndash;        <%}else{%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;&lt;%&ndash;        <% request.setAttribute("opzione","R");%>&ndash;%&gt;&ndash;%&gt;--%>
    <%--&lt;%&ndash;        <p>Benvenuto, fai il login per procedere all'acquisto dei tuoi prodotti</p>&ndash;%&gt;--%>
    <%--&lt;%&ndash;        <%}%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

    <%--&lt;%&ndash;    <!--BARRA LATERALE PER LA RICERCA DEI PRODOTTI-->&ndash;%&gt;--%>
    <%--&lt;%&ndash;    <aside class="left_content">&ndash;%&gt;--%>

    <%--&lt;%&ndash;        <section>&ndash;%&gt;--%>
    <%--&lt;%&ndash;            <h1>Categorie</h1>&ndash;%&gt;--%>
    <%--&lt;%&ndash;            <ul>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                <%for(i = 0; i < numcat; i++){%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                <li>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                    <form name="categorieForm<%=i%>" action="Dispatcher" method="post">&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <input type="hidden" name="searchType" value="categorie"/>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <input type="hidden" name="searchName" value="<%=categoriaProdotto.get(i)%>"/>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <a href="javascript:categorieSubmit(<%=i%>);"><%=categoriaProdotto.get(i)%></a>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                    </form>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                </li>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                <%}%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;            </ul>&ndash;%&gt;--%>
    <%--&lt;%&ndash;        </section>&ndash;%&gt;--%>

    <%--&lt;%&ndash;        <hr>&ndash;%&gt;--%>

    <%--&lt;%&ndash;        <section>&ndash;%&gt;--%>
    <%--&lt;%&ndash;            <h1>Materiali</h1>&ndash;%&gt;--%>
    <%--&lt;%&ndash;            <ul>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                <%for(i = 0; i < nummat; i++){%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                <li>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                    <form name="materialeForm<%=i%>" action="Dispatcher" method="post">&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <input type="hidden" name="searchType" value="materiali"/>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <input type="hidden" name="searchName" value="<%=materaiali.get(i)%>"/>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <a href="javascript:materialeFormSubmit(<%=i%>);"><%=materaiali.get(i)%></a>&ndash;%&gt;--%>
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

    <%--&lt;%&ndash;    <div style="clear: right;"></div>&ndash;%&gt;--%>

    <%--&lt;%&ndash;    <!--LISTA PRODOTTI DA VISUALIZZARE-->&ndash;%&gt;--%>
    <%--&lt;%&ndash;    <%if(numProdotto == 0){%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;    <div  id ="attenzione"style='margin-top: 20px; margin-left: 163px;'>&ndash;%&gt;--%>
    <%--&lt;%&ndash;        <h2>Attenzione</h2>&ndash;%&gt;--%>
    <%--&lt;%&ndash;        <p>La ricerca effettuata non ha prodotto risultati. Per visionare il catalogo degli articoli naviga su <a href="Dispatcher?controllerAction=Catalogo.view">FightinClass66</a> e, quando trovi un articolo che ti interessa, clicca su "Aggiungi al carrello"</p>&ndash;%&gt;--%>
    <%--&lt;%&ndash;    </div>&ndash;%&gt;--%>
    <%--&lt;%&ndash;    <%}else{%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;    <section class="clearfix">&ndash;%&gt;--%>
    <%--&lt;%&ndash;        <div style="float: left; width: 88%;">&ndash;%&gt;--%>
    <%--&lt;%&ndash;            <%for (i = 0; i < numProdotto; i++) {%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;            <article>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                <div class="right_content">&ndash;%&gt;--%>
    <%--&lt;%&ndash;                    <form name="prodottoForm<%=i%>" action="Dispatcher" method="post">&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <input type="hidden" name="controllerAction" value="Catalogo.viewProdotto"/>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <input type="hidden" name="idProdotto"/>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        <a href="javascript:prodottoFormSubmit(<%=i%>  <%=prodotti.get(i).getId()%>);">&ndash;%&gt;--%>
    <%--&lt;%&ndash;                            <img src="images/<%=prodotti.get(i).getImmagine()%>" width="230" height="260" alt="Visualizza prodotto"/>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                        </a>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                    </form>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                    <span><b><%=prodotti.get(i).getNomeProdotto()%></b></span>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                    <br/>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                    <span>€<%=prodotti.get(i).getPrezzo()%></span>&ndash;%&gt;--%>
    <%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
    <%--&lt;%&ndash;            </article>&ndash;%&gt;--%>
    <%--&lt;%&ndash;            <%}%>&ndash;%&gt;--%>
    <%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
    <%--&lt;%&ndash;    </section>&ndash;%&gt;--%>
    <%--&lt;%&ndash;    <%}%>&ndash;%&gt;--%>

    <%--&lt;%&ndash;</main>&ndash;%&gt;--%>

    <%--&lt;%&ndash;<%@include file="/include/footer.jsp" %>&ndash;%&gt;--%>

    <%--&lt;%&ndash;</body>&ndash;%&gt;--%>

    <%--&lt;%&ndash;</html>&ndash;%&gt;--%>
