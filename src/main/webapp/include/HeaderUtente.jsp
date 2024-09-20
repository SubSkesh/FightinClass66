<header class="clearfix">
    <form name="logoutForm" action="${pageContext.request.contextPath}/Dispatcher" method="post">
        <input type="hidden" name="controllerAction" value="LogOn.logout"/>
    </form>

    <div style="height: 126px;">
        <nav class="navbar">
            <!-- Logo sulla sinistra -->
            <div class="logo">
                <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=Catalogo.view">
                    <img id="LogoWeb" src="${pageContext.request.contextPath}/images/FightinClass663.jpg"  alt="Torna alla Home Page" />
                </a>
            </div>
            <!-- Link del menu sulla destra -->
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
