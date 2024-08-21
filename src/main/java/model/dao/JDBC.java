package model.dao;

import model.dao.exception.DuplicatedObjectException;
import model.dao.mySQLJDBCImpl.JDBCImpl;

/**
 * Classe astratta JDBC per la gestione delle transazioni e la fornitura dei DAO.
 */
public abstract class JDBC {

    // Costante per specificare l'implementazione MySQL
    public static final String MYSQLJDBCIMPL = "MySQLJDBCImpl";

    /* Metodi per la gestione delle transazioni */

    // Inizia una transazione
    public abstract void beginTransaction();

    // Conferma una transazione
    public abstract void commitTransaction();

    // Annulla una transazione
    public abstract void rollbackTransaction();

    // Chiude una transazione
    public abstract void closeTransaction();

    /* Metodi per ritornare i DAO */

    // Ritorna un'implementazione di BuonoDAO
    public abstract BuonoDAO getBuonoDAO();

    // Ritorna un'implementazione di ContieneDAO
    public abstract ContieneDAO getContieneDAO();

    // Ritorna un'implementazione di OrdineDAO
    public abstract OrdineDAO getOrdineDAO();

    // Ritorna un'implementazione di PagamentoDAO
    public abstract PagamentoDAO getPagamentoDAO();

    // Ritorna un'implementazione di ProdottoDAO
    public abstract ProdottoDAO getProdottoDAO();

    // Ritorna un'implementazione di UtenteDAO
    public abstract UtenteDAO getUtenteDAO();

    /**
     * Factory method per ottenere un'implementazione di JDBC.
     *
     * @param whichFactory Il tipo di implementazione richiesta.
     * @return Un'implementazione concreta di JDBCImpl.
     */
    public static JDBC getJDBC(String whichFactory) {
        if (whichFactory.equals(MYSQLJDBCIMPL)) {
            return new JDBCImpl();
        } else {
            return null;
        }
    }
}
