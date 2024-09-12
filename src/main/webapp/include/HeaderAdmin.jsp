<%--
  Created by IntelliJ IDEA.
  User: Oscar Costanzelli
  Date: 12/09/2024
  Time: 16:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Defining the header section of the page for Admin -->
<header class="clearfix">

    <!-- Form per il logout, usando il Dispatcher per invocare il controller di logout -->
    <form name="logoutForm" action="Dispatcher" method="post">
        <input type="hidden" name="controllerAction" value="LogOn.logout"/>
    </form>

    <div style="height: 126px;">
        <nav class="clearfix">
            <!-- Logo che reindirizza alla home dell'admin -->
            <div class="logo">
                <a href="Dispatcher?controllerAction=HomeAdmin.view">
                    <img id="LogoWeb" src="${pageContext.request.contextPath}/images/result.png"
                         width="370" height="105" alt="Torna alla Home Page"/>
                </a>
            </div>

            <!-- Barra di navigazione per l'admin -->
            <div class="barra">
                <div class="admin">
                    <a href="Dispatcher?controllerAction=Ordini.view">ORDINI</a>
                </div>
                <div class="admin">
                    <a href="Dispatcher?controllerAction=UtentiManagement.view">UTENTI</a>
                </div>
                <div class="admin">
                    <a href="Dispatcher?controllerAction=ProdottoManagement.view">MAGAZZINO</a>
                </div>
                <div class="admin">
                    <a href="Dispatcher?controllerAction=BuonoManagement.view">BUONI</a>
                </div>
                <div class="admin">
                    <a href="javascript:logoutForm.submit()">LOGOUT</a>
                </div>
            </div>
        </nav>
    </div>

</header>
