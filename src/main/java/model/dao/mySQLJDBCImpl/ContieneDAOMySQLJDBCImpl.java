package model.dao.mySQLJDBCImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.dao.ContieneDAO;
import model.dao.exception.DuplicatedObjectException;
import model.mo.Contiene;
import model.mo.Ordine;
import model.mo.Prodotto;

public class ContieneDAOMySQLJDBCImpl implements ContieneDAO {

    private Connection connection;

    public ContieneDAOMySQLJDBCImpl(Connection connection){
        this.connection = connection;
    }

    /**
     * Crea una nuova tupla nella tabella contiene del DB.
     *
     * @param ordineId
     * @param prodottoId
     * @param quantitaOrdine
     * @return Contiene
     * @throws DuplicatedObjectException
     */
    @Override
    public Contiene creaContiene(int ordineId, int prodottoId, int quantitaOrdine) throws DuplicatedObjectException {
        PreparedStatement ps;
        Contiene contiene = new Contiene();

        Ordine ordine = new Ordine();
        ordine.setId(ordineId);
        contiene.setOrdine(ordine);

        Prodotto prodotto = new Prodotto();
        prodotto.setId(prodottoId);
        contiene.setProdotto(prodotto);
        contiene.setQuantitàOrdine(quantitaOrdine);

        try {
            // Preparo la query per vedere se esiste già una tupla contiene uguale
            String sql = "SELECT * FROM contiene WHERE ordineId = ? AND prodottoId = ? AND quantitaOrdine = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, ordineId);
            ps.setInt(2, prodottoId);
            ps.setLong(3, quantitaOrdine);

            ResultSet resultSet = ps.executeQuery();
            boolean exist = resultSet.next();
            resultSet.close();

            if (exist) {
                throw new DuplicatedObjectException("ContieneDAOMySQLJDBCImpl.creaContiene: Tentativo di inserimento di una tupla contiene già esistente");
            }

            // Se non esiste, inserisco la nuova tupla
            sql = "INSERT INTO contiene (ordineId, prodottoId, quantitaOrdine) VALUES (?, ?, ?)";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, ordineId);
            ps.setInt(2, prodottoId);
            ps.setLong(3, quantitaOrdine);

            ps.executeUpdate();
            ps.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return contiene;
    }

    /**
     * Trova tutte le righe di contiene associate a un ordine specifico.
     *
     * @param ordineId
     * @return ArrayList di Contiene
     */
    @Override
    public ArrayList<Contiene> findContieneByOrdine(int ordineId) {
        PreparedStatement ps;
        Contiene contiene;
        ArrayList<Contiene> contieneArray = new ArrayList<>();

        try {
            String sql = "SELECT * FROM contiene WHERE ordineId = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, ordineId);

            ResultSet resultSet = ps.executeQuery();

            while (resultSet.next()) {
                contiene = read(resultSet);
                contieneArray.add(contiene);
            }

            resultSet.close();
            ps.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return contieneArray;
    }

    /**
     * Legge i vari campi del result set e li carica nell'oggetto Contiene.
     */
    protected Contiene read(ResultSet resultSet) {
        Contiene contiene = new Contiene();

        Ordine ordine = new Ordine();
        contiene.setOrdine(ordine);

        Prodotto prodotto = new Prodotto();
        contiene.setProdotto(prodotto);

        try {
            // Leggo l'ID del prodotto
            contiene.getProdotto().setId(resultSet.getInt("prodottoId"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        try {
            // Leggo l'ID dell'ordine
            contiene.getOrdine().setId(resultSet.getInt("ordineId"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        try {
            // Leggo la quantità
            contiene.setQuantitaOrdine(resultSet.getLong("quantitaOrdine"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        return contiene;
    }
}
