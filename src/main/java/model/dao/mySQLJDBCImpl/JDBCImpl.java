package model.dao.mySQLJDBCImpl;

import services.config.Configuration;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import model.dao.*;

/**
 * Implementazione della classe JDBC per la gestione delle connessioni e transazioni con MySQL.
 */
public class JDBCImpl extends JDBC {

    private Connection connection;

    /**
     * Stabilisce la connessione con il database e disabilita l'autocommit.
     */
    @Override
    public void beginTransaction() {
        try {
            Class.forName(Configuration.DATABASE_DRIVER);
            this.connection = DriverManager.getConnection(Configuration.DATABASE_URL);
            this.connection.setAutoCommit(false);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver non trovato: " + e.getMessage(), e);
        } catch (SQLException e) {
            throw new RuntimeException("Errore nella connessione al database: " + e.getMessage(), e);
        }
    }

    /**
     * Esegue il commit della transazione corrente.
     */
    @Override
    public void commitTransaction() {
        try {
            if (this.connection != null) {
                this.connection.commit();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel commit della transazione: " + e.getMessage(), e);
        }
    }

    /**
     * Esegue il rollback della transazione corrente.
     */
    @Override
    public void rollbackTransaction() {
        try {
            if (this.connection != null) {
                this.connection.rollback();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel rollback della transazione: " + e.getMessage(), e);
        }
    }

    /**
     * Chiude la connessione con il database.
     */
    @Override
    public void closeTransaction() {
        try {
            if (this.connection != null) {
                this.connection.close();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore nella chiusura della connessione: " + e.getMessage(), e);
        }
    }

    /**
     * Ritorna l'implementazione di BuonoDAO.
     */
    @Override
    public BuonoDAO getBuonoDAO() {
        return new BuonoDAOMySQLJDBCImpl(connection);
    }

    /**
     * Ritorna l'implementazione di ContieneDAO.
     */
    @Override
    public ContieneDAO getContieneDAO() {
        return new ContieneDAOMySQLJDBCImpl(connection);
    }

    /**
     * Ritorna l'implementazione di OrdineDAO.
     */
    @Override
    public OrdineDAO getOrdineDAO() {
        return new OrdineDAOMySQLJDBCImpl(connection);
    }

    /**
     * Ritorna l'implementazione di PagamentoDAO.
     */
    @Override
    public PagamentoDAO getPagamentoDAO() {
        return new PagamentoDAOMySQLJDBCImpl(connection);
    }

    /**
     * Ritorna l'implementazione di ProdottoDAO.
     */
    @Override
    public ProdottoDAO getProdottoDAO() {
        return new ProdottoDAOMySQLJDBCImpl(connection);
    }

    /**
     * Ritorna l'implementazione di UtenteDAO.
     */
    @Override
    public UtenteDAO getUtenteDAO() {
        return new UtenteDAOMySQLJDBCImpl(connection);
    }
}
