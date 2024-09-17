<!-- includes/HeaderUtente.jsp -->
<header class="clearfix"><!-- Defining the header section of the page -->

    <form name="logoutForm" action="${pageContext.request.contextPath}/Dispatcher" method="post">
        <input type="hidden" name="controllerAction" value="LogOn.logout"/>
    </form>

    <div style="height: 126px;">
        <nav class="clearfix">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=Catalogo.view">
                    <img id="LogoWeb" src="${pageContext.request.contextPath}/images/FightinClass66.png" width="370" height="105" alt="Torna alla Home Page"/>
                </a>
            </div>
            <div class="barra">
                <div class="utente">
                    <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=Catalogo.view">CATALOGO</a>
                </div>
                <div class="utente">
                    <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=Carrello.view">CARRELLO</a>
                </div>
                <div class="utente">
                    <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=Ordini.viewUtente">I MIEI ORDINI</a>
                </div>
                <div class="utente">
                    <a href="javascript:logoutForm.submit()">LOGOUT</a>
                </div>
            </div>
        </nav>
    </div>

</header>
