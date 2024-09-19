<%@page session = "false"%>
<%@page import="model.session.mo.Carrello"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="model.mo.Prodotto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int i = 0;
    ArrayList<String> categorie = (ArrayList<String>) request.getAttribute("categoria");
    int numcategorie = (categorie != null) ? categorie.size() : 0;

    ArrayList<String> materiali = (ArrayList<String>) request.getAttribute("materiale");
    int nummateriali = (materiali != null) ? materiali.size() : 0;

    ArrayList<String> taglie = (ArrayList<String>) request.getAttribute("taglie");
    int numtaglie = (taglie != null) ? taglie.size() : 0;

    Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");

    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = loggedOnAttr != null && loggedOnAttr;

    /*Carico i cookie*/
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

        function searchProdoctByStringSubmit(){
            var f = document.searchProdoctByString;
            f.submit();
            return;
        }

        function categorieFormSubmit(index){
            var f = document.forms["categorieForm" + index];
            f.submit();
            return;
        }

        function materialeFormSubmit(index){
            var f = document.forms["materialeForm" + index];
            f.submit();
            return;
        }

        function taglieFormSubmit(index){
            var f = document.forms["taglieForm" + index];
            f.submit();
            return;
        }

        function carrelloSubmit(idProdotto){
            var f = document.carrelloForm;
            if(logged){
                f.idProdotto.value = idProdotto;
                alert("Prodotto inserito nel carrello");
                f.submit();
            }else{
                alert("Per inserire un prodotto nel carrello bisogna eseguire l'accesso");
            }
            return;
        }
    </script>

    <style>
        img {
            float: left;
        }

        #ordina{
            padding: 5px 10px;
            background-color: #228b22;
            color: #ffffff;
            border: 1px solid #000000;
            border-radius: 8px;
            cursor: pointer;
            font-size: large;
            width: 100%;
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
        <%if(loggedOn){%>
        <p>Benvenuto <%=ul.getNomeUtente()%> <%=ul.getCognome()%></p>
        <%}else{%>
        <p>Benvenuto, fai il login per procedere all'acquisto dei tuoi prodotti</p>
        <%}%>
    </div>

    <!--BARRA LATERALE PER LA RICERCA DEI PRODOTTI-->
    <aside class="left_content">

        <section>
            <h1>Categorie</h1>
            <ul>
                <%for(i = 0; i < numcategorie; i++){%>
                <li>
                    <form name="categorieForm<%=i%>" action="Dispatcher" method="post">
                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>
                        <input type="hidden" name="searchType" value="categoria"/>
                        <input type="hidden" name="searchName" value="<%=categorie.get(i)%>"/>
                        <a href="javascript:categorieFormSubmit(<%=i%>);"><%=categorie.get(i)%></a>
                    </form>
                </li>
                <%}%>
            </ul>
        </section>

        <hr>

        <section>
            <h1>Materiali</h1>
            <ul>
                <%for(i = 0; i < nummateriali; i++){%>
                <li>
                    <form name="materialiForm<%=i%>" action="Dispatcher" method="post">
                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>
                        <input type="hidden" name="searchType" value="materiale"/>
                        <input type="hidden" name="searchName" value="<%=materiali.get(i)%>"/>
                        <a href="javascript:materialeFormSubmit(<%=i%>);"><%=materiali.get(i)%></a>
                    </form>
                </li>
                <%}%>
            </ul>
        </section>

        <hr>

        <section>
            <h1>Taglie</h1>
            <ul>
                <%for(i = 0; i < numtaglie; i++){%>
                <li>
                    <form name="taglieForm<%=i%>" action="Dispatcher" method="post">
                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>
                        <input type="hidden" name="searchType" value="taglie"/>
                        <input type="hidden" name="searchName" value="<%=taglie.get(i)%>"/>
                        <a href="javascript:taglieFormSubmit(<%=i%>);"><%=taglie.get(i)%></a>
                    </form>
                </li>
                <%}%>
            </ul>
        </section>

    </aside>

    <!--BARRA DI RICERCA LIBERA-->
    <section id="search">
        <div class="searchBar">
            <form name="searchProdoctByString" action="Dispatcher" method="post">
                <input type="text" id="searchName" name="searchName" maxlength="100" placeholder="Cerca...">
                <input type="hidden" name="searchType" value="searchString"/>
                <input type="hidden" name="controllerAction" value="Catalogo.view"/>
                <a href="javascript:searchProdoctByStringSubmit();">CERCA</a>
            </form>
        </div>
    </section>

    <!--INFORMAZIONI PRODOTTO-->
    <div style="float: left; width: 88%;">
        <div style="float: left; margin-left: 70px;">
            <img id="ProdImage" src="images/<%=prodotto.getImmagine()%>" width="400" height="400" alt="Visualizza prodotto"/>
        </div>

        <div style="float: left; margin-left: 70px;">
            <span>categoria: <%=prodotto.getCategoria()%></span>
            <br/>
            <span>materiale: <%=prodotto.getMateriale()%></span>
            <br/>
            <span>taglia: <%=prodotto.getTaglia()%></span>
            <br/>
            <span>Prezzo: €<%=prodotto.getPrezzo()%></span>

            <!--FORM DI INSERIMENTO PRODOTTO NEL CARRELLO-->
            <section>
                <div>
                    <form name="carrelloForm" action="Dispatcher" method="post">
                        <input type="hidden" name="controllerAction" value="Catalogo.insert"/>
                        <input type="hidden" name="idProdotto" value="<%=prodotto.getId()%>"/>
                    </form>
                </div>

                <div>
                    <label for="quantita">Quantità: </label>
                    <input type="number" id="quantita" name="quantita" value="1" min="1" max="30" step="1"/>
                </div>

                <div style="margin-top: 70px;">
                    <a href="javascript:carrelloSubmit(<%=prodotto.getId()%>);" id="ordina">
                        Aggiungi al carrello
                    </a>
                </div>
                </form>
            </section>
        </div>

    </div>

    <div class="descrizione">
        <!--DESCRIZIONE PRODOTTO-->
        <p><b>Descrizione prodotto</b></p>
        <br/>
        <p><%=prodotto.getDescrizione()%></p>
    </div>
    </div>

    <div style="clear: both;">
    </div>

</main>

<%@include file="/include/footer.jsp" %>

</body>
</html>
