package model.dao.mySQLJDBCImpl;

import java.sql.*;

import java.util.ArrayList;
import java.util.Date;

import model.dao.OrdineDAO;
import model.dao.exception.DuplicatedObjectException;

import model.mo.Buono;
import model.mo.Contiene;
import model.mo.Ordine;
import model.mo.Pagamento;
import model.mo.Utente;

/**
 *
 * @author Oscar Costanzelli
 */
public class OrdineDAOMySQLJDBCImpl implements OrdineDAO{

    private Connection connection;

    public OrdineDAOMySQLJDBCImpl(Connection connection){
        this.connection=connection;
    }

    /**
     *
     * Crea una nuova tupla di ordine nel DB
     * @param dataOrdine
     * @param statoOrdine
     * @param dataConsegna
     * @param nazione
     * @param citta
     * @param via
     * @param numeroCivico
     * @param CAP
     * @param pagamento
     * @param buono
     * @param utente
     * @param contiene
     * @return Ordine
     * @throws DuplicatedObjectException
     */

    public Ordine creaOrdine(Date dataOrdine,
                             String statoOrdine,
                             Date dataConsegna,
                             String nazione,

                             String citta,
                             String via,
                             long numeroCivico,
                             int CAP,
                             Pagamento pagamento,
                             Buono buono,
                             Utente utente,
                             ArrayList<Contiene> contiene) throws DuplicatedObjectException {

        PreparedStatement ps;
        Ordine ordine = new Ordine();
        ordine.setDataOrdine(dataOrdine);
        ordine.setStatoOrdine(statoOrdine);
        ordine.setDataConsegna(dataConsegna);
        ordine.setNazione(nazione);
        ordine.setCittà(citta);
        ordine.setVia(via);
        ordine.setNumeroCivico(numeroCivico);
        ordine.setCAP(CAP);
        ordine.setPagamento(pagamento);
        ordine.setBuono(buono);
        ordine.setUtente(utente);
        ordine.setContiene(contiene);

        try {
            /* Preparo la query per vedere se esiste già un ordine uguale */
            String sql = "SELECT id FROM ordine WHERE "
                    + "dataOrdine = ? AND statoOrdine = ? AND dataConsegna = ? AND "
                    + "nazione = ? AND citta = ? AND via = ? AND numeroCivico = ? AND "
                    + "CAP = ? AND utenteId = ? AND pagamentoId = ? AND buonoId = ?";

            ps = connection.prepareStatement(sql);
            int i = 1;
            ps.setDate(i++, convertJavaDateToSqlDate(ordine.getDataOrdine()));
            ps.setString(i++, ordine.getStatoOrdine());
            ps.setDate(i++, convertJavaDateToSqlDate(ordine.getDataConsegna()));
            ps.setString(i++, ordine.getNazione());
            ps.setString(i++, ordine.getCittà());
            ps.setString(i++, ordine.getVia());
            ps.setLong(i++, ordine.getNumeroCivico());
            ps.setInt(i++, ordine.getCAP());
            ps.setInt(i++, utente.getId());  // Assumendo che Utente abbia un metodo getId()
            ps.setInt(i++, pagamento.getId()); // Assumendo che Pagamento abbia un metodo getId()
            if (buono != null) {
                ps.setInt(i++, buono.getId()); // Assumendo che Buono abbia un metodo getId()
            } else {
                ps.setNull(i++, Types.INTEGER);
            }

            ResultSet resultSet = ps.executeQuery();
            boolean exist = resultSet.next();
            resultSet.close();

            /* Se esiste già un ordine, sollevo l'eccezione */
            if (exist) {
                throw new DuplicatedObjectException("OrdineDAOMySQLJDBCImpl.creaOrdine: Tentativo di inserimento di un ordine già esistente");
            }

            /* Se l'ordine non esiste, lo inserisco nel database */
            sql = "INSERT INTO ordine (statoOrdine, dataOrdine, dataConsegna, nazione, citta, via, "
                    + "numeroCivico, CAP, utenteId, pagamentoId, buonoId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            i = 1;
            ps.setString(i++, ordine.getStatoOrdine());
            ps.setDate(i++, convertJavaDateToSqlDate(ordine.getDataOrdine()));
            ps.setDate(i++, convertJavaDateToSqlDate(ordine.getDataConsegna()));
            ps.setString(i++, ordine.getNazione());
            ps.setString(i++, ordine.getCittà());
            ps.setString(i++, ordine.getVia());
            ps.setLong(i++, ordine.getNumeroCivico());
            ps.setInt(i++, ordine.getCAP());
            ps.setInt(i++, utente.getId());
            ps.setInt(i++, pagamento.getId());
            if (buono != null) {
                ps.setInt(i++, buono.getId());
            } else {
                ps.setNull(i++, Types.INTEGER);
            }

            ps.executeUpdate();

            /* Recupero l'ID generato automaticamente */
            resultSet = ps.getGeneratedKeys();
            if (resultSet.next()) {
                ordine.setId(resultSet.getInt(1)); // Imposta l'id generato nel prodotto
            }
            resultSet.close();

//            /* Inserisco i prodotti dell'ordine nella tabella 'contiene' */
//            sql = "INSERT INTO contiene (ordineId, prodottoId, quantita) VALUES (?, ?, ?)";
//            ps = connection.prepareStatement(sql);
//            for (Contiene c : contiene) {
//                ps.setInt(1, ordine.getId());
//                ps.setInt(2, c.getProdotto().getId()); // Assumendo che Prodotto abbia un metodo getId()
//                ps.setInt(3, c.getQuantita());
//                ps.addBatch();
//            }
//            ps.executeBatch();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return ordine;
    }

    private java.sql.Date convertJavaDateToSqlDate(java.util.Date date) {
        return new java.sql.Date(date.getTime());
    }

    /**
     *
     * Modifica lo stato dell'ordine nel DB
     * @param id
     * @param statoOrdine
     * @param dataOdierna
     */

    public void aggiornaStatoConData(int id,
                                     String statoOrdine,
                                     Date dataOdierna){
        PreparedStatement ps;
        try{
            String sql
                    = " UPDATE ordine "
                    + " SET "
                    + " statoOrdine = ?, "
                    + " dataConsegna = ? "
                    + " WHERE "
                    + " id = ? ";

            ps = connection.prepareStatement(sql);
            int i = 1;
            ps.setString(i++, statoOrdine);
            ps.setDate(i++, convertJavaDateToSqlDate(dataOdierna));
            ps.setInt(i++, id);

            ps.executeUpdate();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }
    }
    public void aggiornaStato(int id   ,
                              String statoOrdine){
        PreparedStatement ps;
        try{
            String sql
                    = " UPDATE ordine "
                    + " SET "
                    + "   statoOrdine = ? "
                    + " WHERE "
                    + "   id = ? ";

            ps = connection.prepareStatement(sql);
            int i = 1;
            ps.setString(i++, statoOrdine);
            ps.setInt(i++, id);

            ps.executeUpdate();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }
    }
    /**
     *
     * Recupera dal DB tutti gli ordini presenti
     * @return ArrayList di ordine
     */

    public ArrayList<Ordine> findOrdini() {
        PreparedStatement ps;
        Ordine ordine;
        ArrayList<Ordine> ordini = new ArrayList<Ordine>();

        try{
            /*
             *Prende tutti gli ordini nel DB in ordine di dataOrdine
             */
            String sql
                    = " SELECT * "
                    + " FROM ordine "
                    + " ORDER BY dataOrdine";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()) {
                ordine = read(resultSet);
                ordini.add(ordine);
            }

            resultSet.close();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }

        return ordini;
    }

    /**
     *
     * Recupera tutti gli ordini dal DB dell'utente con l'email passata come
     * parametro
     * @param email
     * @return ArrayList di Ordine
     */

    public ArrayList<Ordine> findByUtente(String email) {
        PreparedStatement ps;
        Ordine ordine;
        ArrayList<Ordine> ordini = new ArrayList<>();

        try {
            /*
             * Prende l'utenteId corrispondente all'email
             */
            String sql = "SELECT id FROM utente WHERE email = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet resultSet = ps.executeQuery();

            int utenteId = -1;
            if (resultSet.next()) {
                utenteId = resultSet.getInt("id");
            }
            resultSet.close();
            ps.close();

            if (utenteId == -1) {
                // Nessun utente trovato con quell'email
                return ordini; // Restituisci una lista vuota
            }

            /*
             * Prende tutti gli ordini dell'utente trovato nel DB in ordine di dataOrdine
             */
            sql = "SELECT * FROM ordine WHERE utenteId = ? ORDER BY dataOrdine";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, utenteId);

            resultSet = ps.executeQuery();

            while (resultSet.next()) {
                ordine = read(resultSet);
                ordini.add(ordine);
            }

            resultSet.close();
            ps.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return ordini;
    }


    /**
     *
     * Recupera dal DB il  dell'ultimo ordine inserito
     * @return long
     */

    /**
     *
     * Conta gli ordini effettuati dall'utente con l'email passata come parametro
     * @param email
     * @return int
     */

    public int contaOrdini(String email) {
        PreparedStatement ps;
        int numeroOrdini = 0;

        try {
            // Primo passo: Recupera l'utenteId usando l'email
            String sql = "SELECT id FROM utente WHERE email = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet resultSet = ps.executeQuery();

            int utenteId = -1;
            if (resultSet.next()) {
                utenteId = resultSet.getInt("id");
            }
            resultSet.close();
            ps.close();

            // Se l'utente non esiste, restituisci 0
            if (utenteId == -1) {
                return 0;
            }

            // Secondo passo: Conta gli ordini associati all'utenteId
            sql = "SELECT COUNT(*) AS numeroOrdini FROM ordine WHERE utenteId = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, utenteId);

            resultSet = ps.executeQuery();

            if (resultSet.next()) {
                numeroOrdini = resultSet.getInt("numeroOrdini");
            }

            resultSet.close();
            ps.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return numeroOrdini;
    }

    /*Leggo i vari campi del resultset e li carico in ordine*/
    protected Ordine read(ResultSet resultSet) {
        Ordine ordine = new Ordine();

        Pagamento pagamento = new Pagamento();
        ordine.setPagamento(pagamento);

        Utente utente = new Utente();
        ordine.setUtente(utente);

        Buono buono = new Buono();
        ordine.setBuono(buono);

        // Leggo l'ID dell'ordine
        try {
            ordine.setId(resultSet.getInt("id")); // Assumendo che l'ID dell'ordine sia memorizzato nella colonna "id"
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }


        // Leggo la data dell'ordine
        try {
            ordine.setDataOrdine(resultSet.getDate("dataOrdine"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        // Leggo lo stato dell'ordine
        try {
            ordine.setStatoOrdine(resultSet.getString("statoOrdine"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        // Leggo la data di consegna
        try {
            ordine.setDataConsegna(resultSet.getDate("dataConsegna"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        // Leggo la nazione
        try {
            ordine.setNazione(resultSet.getString("nazione"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        // Leggo la città
        try {
            ordine.setCittà(resultSet.getString("citta"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        // Leggo la via
        try {
            ordine.setVia(resultSet.getString("via"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        // Leggo il numero civico
        try {
            ordine.setNumeroCivico(resultSet.getLong("numeroCivico"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        // Leggo il CAP
        try {
            ordine.setCAP(resultSet.getInt("CAP"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        // Leggo l'utente associato all'ordine
        try {
            ordine.getUtente().setId(resultSet.getInt("utenteId"));  // Usa l'ID dell'utente
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        // Leggo il pagamento associato all'ordine
        try {
            pagamento.setId(resultSet.getInt("pagamentoId"));  // Usa l'ID del pagamento
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        // Leggo il buono associato all'ordine, se presente
        try {
            int buonoId = resultSet.getInt("buonoId");
            if (!resultSet.wasNull()) {
                buono.setId(buonoId);
            } else {
                ordine.setBuono(null);  // Se non c'è buono, imposta a null
            }
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        return ordine;
    }

}
