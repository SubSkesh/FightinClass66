<%--
    Document   : catalogo
    Created on : 5-mar-2020, 14.54.40
    Author     : Oscar Costanzelli
--%>

<%@page session = "false"%>
<%@page import="model.session.mo.LoggedUser"%>
<%@page import="model.mo.Prodotto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.session.mo.Carrello"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int i=0;

    ArrayList<String> categoriaProdotto = (ArrayList<String>) request.getAttribute("categorie");
    int numcat ;
    if(categoriaProdotto == null){
        numcat = 0;
    }else{
        numcat = categoriaProdotto.size();
    }

    ArrayList<String> materaiali = (ArrayList<String>) request.getAttribute("materiali");
    int nummat;
    if(materaiali == null){
        nummat = 0;
    }else{
        nummat = materaiali.size();
    }

    ArrayList<String> taglie = (ArrayList<String>) request.getAttribute("taglie");
    int numtaglie;
    if(taglie == null){
        numtaglie = 0;
    }else{
        numtaglie = taglie.size();
    }

    ArrayList<Prodotto> prodotti = (ArrayList<Prodotto>) request.getAttribute("prodotti");
    int numProdotto;
    if(prodotti == null){
        numProdotto = 0;
    }else{
        numProdotto = prodotti.size();
    }

 //   boolean loggedOn = (boolean) request.getAttribute("loggedOn");
    // Controllo se l'attributo "loggedOn" esiste nella richiesta
    Boolean loggedOnAttr = (Boolean) request.getAttribute("loggedOn");
    boolean loggedOn = loggedOnAttr != null && loggedOnAttr.booleanValue();  // Se null, impostato a false


    /*Carico i cookie*/
    LoggedUser ul = (LoggedUser) request.getAttribute("loggedUser");
    ArrayList<Carrello> carrello = (ArrayList<Carrello>) request.getAttribute("carrello");

    String applicationMessage = (String) request.getAttribute("applicationMessage");

    String menuActiveLink = "Catalogo";
%>
<!DOCTYPE html>
<html lang="it-IT">
<head>
    <script language="javascript">
        function prodottoFormSubmit(index, idProdotto){
            var f = document.forms["prodottoForm" + index];
            f.idProdotto.value = idProdotto;  // Valorizza l'id del prodotto
            f.submit();
            return;
        }

        function searchProdoctByStringSubmit(){
            var f = document.searchProdoctByString;
            f.submit();
            return;
        }

        function categorieSubmit(index){
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
            var f = document.forms["taglieiForm" + index];
            f.submit();
            return;
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
                <%for(i = 0; i < numcat; i++){%>
                <li>
                    <form name="categorieForm<%=i%>" action="Dispatcher" method="post">
                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>
                        <input type="hidden" name="searchType" value="categorie"/>
                        <input type="hidden" name="searchName" value="<%=categoriaProdotto.get(i)%>"/>
                        <a href="javascript:categorieSubmit(<%=i%>);"><%=categoriaProdotto.get(i)%></a>
                    </form>
                </li>
                <%}%>
            </ul>
        </section>

        <hr>

        <section>
            <h1>Materiali</h1>
            <ul>
                <%for(i = 0; i < nummat; i++){%>
                <li>
                    <form name="materialeForm<%=i%>" action="Dispatcher" method="post">
                        <input type="hidden" name="controllerAction" value="Catalogo.view"/>
                        <input type="hidden" name="searchType" value="materiali"/>
                        <input type="hidden" name="searchName" value="<%=materaiali.get(i)%>"/>
                        <a href="javascript:materialeFormSubmit(<%=i%>);"><%=materaiali.get(i)%></a>
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

    <div style="clear: right;"></div>

    <!--LISTA PRODOTTI DA VISUALIZZARE-->
    <%if(numProdotto == 0){%>
    <div  id ="attenzione"style='margin-top: 20px; margin-left: 163px;'>
        <h2>Attenzione</h2>
        <p>La ricerca effettuata non ha prodotto risultati. Per visionare il catalogo degli articoli naviga su <a href="Dispatcher?controllerAction=Catalogo.view">FightinClass66</a> e, quando trovi un articolo che ti interessa, clicca su "Aggiungi al carrello"</p>
    </div>
    <%}else{%>
    <section class="clearfix">
        <div style="float: left; width: 88%;">
            <%for (i = 0; i < numProdotto; i++) {%>
            <article>
                <div class="right_content">
                    <form name="prodottoForm<%=i%>" action="Dispatcher" method="post">
                        <input type="hidden" name="controllerAction" value="Catalogo.viewProdotto"/>
                        <input type="hidden" name="idProdotto"/>
                        <a href="javascript:prodottoFormSubmit(<%=i%>  <%=prodotti.get(i).getId()%>);">
                            <img src="images/<%=prodotti.get(i).getImmagine()%>" width="230" height="260" alt="Visualizza prodotto"/>
                        </a>
                    </form>
                    <span><b><%=prodotti.get(i).getNomeProdotto()%></b></span>
                    <br/>
                    <span>€<%=prodotti.get(i).getPrezzo()%></span>
                </div>
            </article>
            <%}%>
        </div>
    </section>
    <%}%>

</main>

<%@include file="/include/footer.jsp" %>

</body>

</html>
