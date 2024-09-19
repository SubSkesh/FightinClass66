<!-- includes/HeaderUtente.jsp -->
<header class="clearfix"><!-- Defining the header section of the page -->

    <form name="logoutForm" action="${pageContext.request.contextPath}/Dispatcher" method="post">
        <input type="hidden" name="controllerAction" value="LogOn.logout"/>
    </form>

    <div style="height: 126px;">
        <nav class="clearfix">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=Catalogo.view">
                    <img id="LogoWeb" src="${pageContext.request.contextPath}/images/FightinClass66.jpg" width="300" height="100" alt="Torna alla Home Page"/>
                </a>
            </div>
            <div class="barra">
                <div class="utente">
                    <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=Catalogo.view">CATALOGO</a>
                </div>
                <div class="utente">
                    <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=Acquisto.view">CARRELLO</a>
                </div>
                <div class="utente">
                    <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=Ordini.view">I MIEI ORDINI</a>
                </div>
                <div class="utente">
                    <a href="javascript:logoutForm.submit()">LOGOUT</a>
                </div>
            </div>
        </nav>
    </div>

</header>
