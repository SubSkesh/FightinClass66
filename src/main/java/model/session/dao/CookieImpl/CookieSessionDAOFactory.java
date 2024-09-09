package model.session.dao.CookieImpl;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.session.dao.CarrelloDAO;


import model.session.dao.SessionDAOFactory;
import model.session.dao.LoggedUserDAO;

public class CookieSessionDAOFactory implements SessionDAOFactory {

    private HttpServletRequest request;
    private HttpServletResponse response;

    @Override
    public void initSession(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
    } //salviamo la request e la response per renderli disp per i DAO che li useranno per scrivere e leggere cookie

    @Override
    public LoggedUserDAO getLoggedUserDAO() {
        return new LoggedUserDAOCookieImpl(request, response);//Restituisce un'istanza di LoggedUserDAOCookieImpl, che gestisce l'utente loggato utilizzando i cookie.
    }

    @Override
    public CarrelloDAO getCarrelloDAO() {
        return new CarrelloDAOCookieImpl(request, response);//Restituisce un'istanza di CarrelloDAOCookieImpl, che gestisce il carrello dell'utente utilizzando i cookie.
    }
}
