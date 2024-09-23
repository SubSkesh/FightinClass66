<header class="clearfix">
    <form name="logoutForm" action="${pageContext.request.contextPath}/Dispatcher" method="post">
        <input type="hidden" name="controllerAction" value="LogOn.logout"/>
    </form>

    <div style="height: 126px;">
        <nav class="navbar">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=HomeAdmin.view">
                    <img id="LogoWeb" src="${pageContext.request.contextPath}/images/FightinClass663.jpg" width="370" height="105" alt="Torna alla Home Page"/>
                </a>
            </div>
            <div class="barra">
                <div class="admin">
                    <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=Ordini.view">ORDINI</a>
                </div>
                <div class="admin">
                    <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=UtentiManagement.view">UTENTI</a>
                </div>
                <div class="admin">
                    <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=ProdottoManagement.view">MAGAZZINO</a>
                </div>
                <div class="admin">
                    <a href="${pageContext.request.contextPath}/Dispatcher?controllerAction=BuonoManagement.view">BUONI</a>
                </div>
                <div class="admin">
                    <a href="javascript:logoutForm.submit()">LOGOUT</a>
                </div>
            </div>
        </nav>
    </div>
</header>
