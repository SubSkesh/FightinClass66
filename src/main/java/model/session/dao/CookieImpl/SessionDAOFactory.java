    package model.session.dao.CookieImpl;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    /**
     * Interfaccia per la creazione di DAO specifici per la sessione utente.
     */
    public interface SessionDAOFactory {

        /**
         * Inizializza la sessione utente.
         *
         * @param request La richiesta HTTP corrente.
         * @param response La risposta HTTP corrente.
         */
        public void initSession(HttpServletRequest request, HttpServletResponse response);

        /**
         * Restituisce un DAO per la gestione dell'utente loggato.
         *
         * @return Un'istanza di LoggedUserDAO.
         */
        public LoggedUserDAO getLoggedUserDAO();

        /**
         * Restituisce un DAO per la gestione del carrello degli acquisti.
         *
         * @return Un'istanza di CarrelloDAO.
         */
        public CarrelloDAO getCarrelloDAO();
    }