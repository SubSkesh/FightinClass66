package model.dao.mySQLJDBCImpl;

import java.sql.*;

import java.util.ArrayList;

import model.dao.ProdottoDAO;
import model.dao.exception.DuplicatedObjectException;

import model.mo.Contiene;
import model.mo.Prodotto;

/**
 *
 */
public class ProdottoDAOMySQLJDBCImpl implements ProdottoDAO{


    private Connection connection;

    public ProdottoDAOMySQLJDBCImpl(Connection connection){
        this.connection=connection;
    }

    /**
     *
     * Crea una nuova tupla di prodotto nel DB
     * @param nomeProdotto
     * @param categoria
     * @param descrizione
     *
       @param immagine
     * @param prezzo
     * @param quantita
     * @param blocked
     * @param push
     * @return Prodotto
     * @throws DuplicatedObjectException
     */
    @Override
    public Prodotto creaProdotto(String nomeProdotto, String categoria,
                                 String descrizione, String immagine,
                                 float prezzo, int quantita,
                                 boolean blocked, boolean push, Contiene[] contiene, String materiale, String taglia)
            throws DuplicatedObjectException {
        PreparedStatement ps;
        Prodotto prodotto = new Prodotto();
        prodotto.setNomeProdotto(nomeProdotto);
        prodotto.setCategoria(categoria);
        prodotto.setDescrizione(descrizione);
        prodotto.setImmagine(immagine);
        prodotto.setQuantita(quantita);
        prodotto.setPrezzo(prezzo);
        prodotto.setBlocked(blocked);
        prodotto.setPush(push);
        prodotto.setContiene(contiene);
        prodotto.setMateriale(materiale);
        prodotto.setTaglia(taglia);

        try {
            // Verifica se esiste già un prodotto con lo stesso codiceProdotto nel database
            String sql = "SELECT id FROM prodotto WHERE id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, prodotto.getId());

            ResultSet resultSet = ps.executeQuery();
            boolean exist = resultSet.next();
            resultSet.close();

            // Se esiste già un prodotto con lo stesso codiceProdotto, lancia un'eccezione
            if (exist) {
                throw new DuplicatedObjectException("ProdottoDAOJDBCImpl.creaProdotto: Tentativo di inserimento di un prodotto già esistente con questo codice.");
            }

            // Inserisce il nuovo prodotto nel database
            sql = "INSERT INTO prodotto (nomeProdotto, categoria, descrizione, immagine, quantita, prezzo, blocked, push,materiale,taglia) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?,?,?)";
            ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            int i = 1;
            ps.setString(i++, prodotto.getNomeProdotto());
            ps.setString(i++, prodotto.getCategoria());
            ps.setString(i++, prodotto.getDescrizione());
            ps.setString(i++, prodotto.getImmagine());
            ps.setInt(i++, prodotto.getQuantita());
            ps.setFloat(i++, prodotto.getPrezzo());
            ps.setString(i++, prodotto.isBlocked() ? "1" : "0");
            ps.setString(i++, prodotto.isPush() ? "1" : "0");
            ps.setString(i++, prodotto.getMateriale());
            ps.setString(i++, prodotto.getTaglia());
            ps.executeUpdate();

            // Recupera il valore dell'ID generato automaticamente
            resultSet = ps.getGeneratedKeys();
            if (resultSet.next()) {
                prodotto.setId(resultSet.getInt(1)); // Imposta l'id generato nel prodotto
            }
            resultSet.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return prodotto;
    }

    /**
     *
     * Modifica i valori di un prodotto nel DB controllando che non venga duplicato
     * @param prodotto
     * @throws DuplicatedObjectException
     */

//    @Override
//    public void aggiorna(Prodotto prodotto) throws DuplicatedObjectException {
//        PreparedStatement ps;
//        try {
//            /*
//             * Preparo la query per vedere se nel DB esiste già un prodotto uguale
//             * a quello che voglio aggiornare
//             */
//            String sql
//                    = "SELECT id "
//                    + "FROM prodotto "
//                    + "WHERE nomeProdotto = ? AND "
//                    + "categoria = ? AND "
//                    + "descrizione = ? AND "
//                    + "immagine = ? AND "
//                    + "quantita = ? AND "
//                    + "prezzo = ? AND "
//                    + "materiale = ? AND "
//                    + "taglia = ?";
//            ps = connection.prepareStatement(sql);
//            int i = 1;
//            ps.setString(i++, prodotto.getNomeProdotto());
//            ps.setString(i++, prodotto.getCategoria());
//            ps.setString(i++, prodotto.getDescrizione());
//            ps.setString(i++, prodotto.getImmagine());
//            ps.setLong(i++, prodotto.getQuantita());
//            ps.setFloat(i++, prodotto.getPrezzo());
//            ps.setString(i++, prodotto.getMateriale());
//            ps.setString(i++, prodotto.getTaglia());
//
//            ResultSet resultSet = ps.executeQuery();
//
//            boolean exist;
//            exist = resultSet.next();
//            resultSet.close();
//
//            /*
//             * Se exist è true vuol dire che il prodotto esiste già, quindi sollevo
//             * l'eccezione DuplicatedObjectException e la gestisco
//             */
//            if (exist) {
//                throw new DuplicatedObjectException("ProdottoDAOMySQLJDBCImpl.aggiorna: Tentativo di aggiornamento di un prodotto già esistente");
//            }
//
//            /*
//             * Se sono arrivato qui il prodotto non esiste nel DB quindi creo la
//             * query per aggiornarlo
//             */
//
//            sql = "UPDATE prodotto "
//                    + "SET nomeProdotto = ?, "
//                    + "categoria = ?, "
//                    + "descrizione = ?, "
//                    + "immagine = ?, "
//                    + "quantita = ?, "
//                    + "blocked = ?, "
//                    + "push = ?, "
//                    + "materiale = ?,"
//                    + "taglia = ?"
//                    + "WHERE id = ?";
//
//            ps = connection.prepareStatement(sql);
//            i = 1;
//            ps.setString(i++, prodotto.getNomeProdotto());
//            ps.setString(i++, prodotto.getCategoria());
//            ps.setString(i++, prodotto.getDescrizione());
//            ps.setString(i++, prodotto.getImmagine());
//            ps.setLong(i++, prodotto.getQuantita());
//            ps.setBoolean(i++, prodotto.isBlocked());
//            ps.setBoolean(i++, prodotto.isPush());
//            ps.setString(i++, prodotto.getMateriale());
//            ps.setString(i++, prodotto.getTaglia());
//            ps.setInt(i++, prodotto.getId());
//
//            ps.executeUpdate();
//
//        } catch (SQLException e) {
//            throw new RuntimeException(e);
//        }
//    }
    @Override
    public void aggiorna(Prodotto prodotto) throws DuplicatedObjectException {
        PreparedStatement ps;
        try {
            /*
             * Preparo la query per vedere se nel DB esiste già un prodotto uguale
             * a quello che voglio aggiornare, escludendo l'id corrente.
             */

            String sql = "SELECT id "
                    + "FROM prodotto "
                    + "WHERE nomeProdotto = ? AND "
                    + "categoria = ? AND "
                    + "descrizione = ? AND "
                    + "immagine = ? AND "
                    + "quantita = ? AND "
                    + "prezzo = ? AND "
                    + "materiale = ? AND "
                    + "taglia = ? AND "
                    + "id != ?";

            ps = connection.prepareStatement(sql);
            int i = 1;
            ps.setString(i++, prodotto.getNomeProdotto());
            ps.setString(i++, prodotto.getCategoria());
            ps.setString(i++, prodotto.getDescrizione());
            ps.setString(i++, prodotto.getImmagine());
            ps.setLong(i++, prodotto.getQuantita());
            ps.setFloat(i++, prodotto.getPrezzo());
            ps.setString(i++, prodotto.getMateriale());
            ps.setString(i++, prodotto.getTaglia());
            ps.setInt(i++, prodotto.getId());

            ResultSet resultSet = ps.executeQuery();

            boolean exist = resultSet.next();
            resultSet.close();

            /*
             * Se exist è true vuol dire che il prodotto esiste già, quindi sollevo
             * l'eccezione DuplicatedObjectException e la gestisco
             */
            if (exist) {
                throw new DuplicatedObjectException("ProdottoDAOMySQLJDBCImpl.aggiorna: Tentativo di aggiornamento di un prodotto già esistente");
            }

            /*
             * Se sono arrivato qui il prodotto non esiste nel DB quindi creo la
             * query per aggiornarlo
             */

            sql = "UPDATE prodotto "
                    + "SET nomeProdotto = ?, "
                    + "categoria = ?, "
                    + "descrizione = ?, "
                    + "immagine = ?, "
                    + "quantita = ?, "
                    + "blocked = ?, "
                    + "push = ?, "
                    + "materiale = ?, "
                    + "taglia = ? "
                    + "WHERE id = ?";

            ps = connection.prepareStatement(sql);
            i = 1;
            ps.setString(i++, prodotto.getNomeProdotto());
            ps.setString(i++, prodotto.getCategoria());
            ps.setString(i++, prodotto.getDescrizione());
            ps.setString(i++, prodotto.getImmagine());
            ps.setLong(i++, prodotto.getQuantita());
            ps.setBoolean(i++, prodotto.isBlocked());
            ps.setBoolean(i++, prodotto.isPush());
            ps.setString(i++, prodotto.getMateriale());
            ps.setString(i++, prodotto.getTaglia());
            ps.setInt(i++, prodotto.getId());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Aggiornamento del prodotto fallito, nessuna riga modificata.");
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }



    /**
     *
     * Setta come bloccato un prodotto nel DB
     * @param id
     *
     *
     *
     */
//    @Override
//    public void blocca(int id) {
//        PreparedStatement ps;
//        try{
//            String sql
//                    = " UPDATE prodotto "
//                    + " SET blocked = '1' "
//                    + " WHERE "
//                    + " id = ?";
//
//            ps = connection.prepareStatement(sql);
//            ps.setInt(1, id);
//            ps.executeUpdate();
//            ps.close();
//
//        }catch(SQLException e){
//            throw new RuntimeException(e);
//        }
//    }
//
//    /**
//     *
//     * Setta come sbloccato un prodotto nel DB
//     * @param id
//     */
//    @Override
//    public void sblocca(int id) {
//        PreparedStatement ps;
//        try{
//            String sql
//                    = " UPDATE prodotto "
//                    + " SET blocked = '0' "
//                    + " WHERE "
//                    + " id = ?";
//
//            ps = connection.prepareStatement(sql);
//            ps.setInt(1, id);
//            ps.executeUpdate();
//            ps.close();
//
//        }catch(SQLException e){
//            throw new RuntimeException(e);
//        }
//    }

    /**
     *
     * Recupera dal DB tutte le carte presenti
     * @return ArrayList di String
     */
    @Override
    public void blocca(int id) {
        try{
            String sql = "UPDATE prodotto SET blocked = ? WHERE id = ?";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setBoolean(1, true);
                ps.setInt(2, id);
                int rowsUpdated = ps.executeUpdate();
                if(rowsUpdated == 0){
                    throw new SQLException("Nessun prodotto trovato con ID: " + id);
                }
            }
        } catch(SQLException e){
            throw new RuntimeException(e);
        }
    }

    @Override
    public void sblocca(int id) {
        try{
            String sql = "UPDATE prodotto SET blocked = ? WHERE id = ?";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setBoolean(1, false);
                ps.setInt(2, id);
                int rowsUpdated = ps.executeUpdate();
                if(rowsUpdated == 0){
                    throw new SQLException("Nessun prodotto trovato con ID: " + id);
                }
            }
        } catch(SQLException e){
            throw new RuntimeException(e);
        }
    }


    public ArrayList<String> trovaNomiProdotti(){
        PreparedStatement ps;
        String nomeProdotto;
        ArrayList<String> nomeProdotti = new ArrayList<String>();

        try{
            /*
             *Prendo tutte le carte esistenti in ordine alfabetico una volta sola
             */
            String sql
                    = " SELECT DISTINCT nomeProdotto "
                    + " FROM prodotto "
                    + " ORDER BY nomeProdotto ";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()){
                nomeProdotto = resultSet.getString("nomeProdotto");
                nomeProdotti.add(nomeProdotto);
            }

            resultSet.close();
            ps.close();
        }catch(SQLException sqle){
            throw new RuntimeException(sqle);
        }

        return nomeProdotti;
    }

    /**
     *
     * Recupera dal DB tutti i tipi di categoria presenti
     * @return ArrayList di String
     */

    public ArrayList<String> trovaCategorieProdotti(){
        PreparedStatement ps;
        String tipoCategoria;
        ArrayList<String> tipoCategorie = new ArrayList<String>();

        try{
            /*
             *Prendo tutti i tipi esistenti in ordine alfabetico una volta sola
             */
            String sql
                    = " SELECT DISTINCT categoria "
                    + " FROM prodotto "
                    + " ORDER BY categoria ";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()){
                tipoCategoria = resultSet.getString("categoria");
                tipoCategorie.add(tipoCategoria);
            }

            resultSet.close();
            ps.close();
        }catch(SQLException sqle){
            throw new RuntimeException(sqle);
        }

        return tipoCategorie;
    }

    /**
     *
     * @return ArrayList di String
     */
    @Override
        public ArrayList<String> trovaTaglie(){
        PreparedStatement ps;
       String taglia;
        ArrayList<String> taglie = new ArrayList<String>();
//
        try{
            /*
             *Prendo tutte le rarità esistenti in ordine alfabetico una volta sola
             */
            String sql
                    = " SELECT DISTINCT taglia "
                    + " FROM prodotto "
                    + " ORDER BY taglia ";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()){
                taglia = resultSet.getString("taglia");
                taglie.add(taglia);
            }

            resultSet.close();
            ps.close();
        }catch(SQLException sqle){
            throw new RuntimeException(sqle);
        }

        return taglie;
    }
    @Override
    public ArrayList<String> trovaMateriali(){
        PreparedStatement ps;
        String materiale;
        ArrayList<String> materiali = new ArrayList<String>();
//
        try{
            /*
             *Prendo tutte le rarità esistenti in ordine alfabetico una volta sola
             */
            String sql
                    = " SELECT DISTINCT materiale "
                    + " FROM prodotto "
                    + " ORDER BY materiale ";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()){
                materiale = resultSet.getString("materiale");
                materiali.add(materiale);
            }

            resultSet.close();
            ps.close();
        }catch(SQLException sqle){
            throw new RuntimeException(sqle);
        }

        return materiali;
    }
//
//    /**
//     *
//     * Recupera dal DB tutte le edizioni presenti
//     * @return ArrayList di String
//     */
//    @Override
//    public ArrayList<String> trovaEdizioni(){
//        PreparedStatement ps;
//        String edizione;
//        ArrayList<String> edizioni = new ArrayList<String>();
//
//        try{
//            /*
//             *Prendo tutte le edizioni esistenti in ordine alfabetico una volta sola
//             */
//            String sql
//                    = " SELECT DISTINCT edizione "
//                    + " FROM prodotto "
//                    + " ORDER BY edizione ";
//
//            ps = connection.prepareStatement(sql);
//
//            ResultSet resultSet = ps.executeQuery();
//
//            while(resultSet.next()){
//                edizione = resultSet.getString("edizione");
//                edizioni.add(edizione);
//            }
//
//            resultSet.close();
//            ps.close();
//        }catch(SQLException sqle){
//            throw new RuntimeException(sqle);
//        }
//
//        return edizioni;
//    }
//
//    /**
//     *
//     * Recupera dal DB tutti i prodotti appartenenti all'edizione specificata
//     * @param edizione
//     * @return ArrayList di Prodotto
//     */

    public ArrayList<Prodotto> findByCategoria(String categoria) {
        PreparedStatement ps;
        Prodotto prodotto;
        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();

        try{
            /*
             *Prende tutti i prodotti dell'edizione specificata
             */
            String sql
                    = " SELECT * "
                    + " FROM prodotto "
                    + " WHERE categoria = ? AND blocked = '0' ";

            ps = connection.prepareStatement(sql);
            ps.setString(1, categoria);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()) {
                prodotto = read(resultSet);
                prodotti.add(prodotto);
            }

            resultSet.close();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }

        return prodotti;
    }
    public ArrayList<Prodotto> findByTaglia(String taglia) {
        PreparedStatement ps;
        Prodotto prodotto;
        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();

        try{
            /*
             *Prende tutti i prodotti dell'edizione specificata
             */
            String sql
                    = " SELECT * "
                    + " FROM prodotto "
                    + " WHERE taglia = ? AND blocked = '0' ";

            ps = connection.prepareStatement(sql);
            ps.setString(1, taglia);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()) {
                prodotto = read(resultSet);
                prodotti.add(prodotto);
            }

            resultSet.close();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }

        return prodotti;
    }
    public ArrayList<Prodotto> findByMateriale(String materiale) {
        PreparedStatement ps;
        Prodotto prodotto;
        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();

        try{
            /*
             *Prende tutti i prodotti dell'edizione specificata
             */
            String sql
                    = " SELECT * "
                    + " FROM prodotto "
                    + " WHERE materiale = ? AND blocked = '0' ";

            ps = connection.prepareStatement(sql);
            ps.setString(1, materiale);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()) {
                prodotto = read(resultSet);
                prodotti.add(prodotto);
            }

            resultSet.close();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }

        return prodotti;
    }


//    @Override
//    public ArrayList<Prodotto> findByTipoCarta(String tipoCarta) {
//        PreparedStatement ps;
//        Prodotto prodotto;
//        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();
//
//        try{
//            /*
//             *Prende tutti i prodotti del tipo specificato
//             */
//            String sql
//                    = " SELECT * "
//                    + " FROM prodotto "
//                    + " WHERE tipoCarta = ? AND Blocked = 'N' ";
//
//            ps = connection.prepareStatement(sql);
//            ps.setString(1, tipoCarta);
//
//            ResultSet resultSet = ps.executeQuery();
//
//            while(resultSet.next()) {
//                prodotto = read(resultSet);
//                prodotti.add(prodotto);
//            }
//
//            resultSet.close();
//            ps.close();
//
//        }catch(SQLException e){
//            throw new RuntimeException(e);
//        }
//
//        return prodotti;
//    }
//
//    /**
//     *
//     * Recupera dal DB tutti i prodotti della rarità specificata
//     * @param rarita
//     * @return ArrayList di Prodotto
//     */
//    @Override
//    public ArrayList<Prodotto> findByRarità(String rarita) {
//        PreparedStatement ps;
//        Prodotto prodotto;
//        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();
//
//        try{
//            /*
//             *Prende tutti i prodotti in base alla rarità specificata
//             */
//            String sql
//                    = " SELECT * "
//                    + " FROM prodotto "
//                    + " WHERE rarita = ? AND blocked = 'N' ";
//
//            ps = connection.prepareStatement(sql);
//            ps.setString(1, rarita);
//
//            ResultSet resultSet = ps.executeQuery();
//
//            while(resultSet.next()) {
//                prodotto = read(resultSet);
//                prodotti.add(prodotto);
//            }
//
//            resultSet.close();
//            ps.close();
//
//        }catch(SQLException e){
//            throw new RuntimeException(e);
//        }
//
//        return prodotti;
//    }
//
//    /**
//     *
//     * Recupera dal DB tutti i prodotti che soddisfano la stringa di ricerca search
//     * @param search
//     * @return ArrayList di Prodotto
//     */
//    @Override
//    public ArrayList<Prodotto> findByString(String search) {
//        PreparedStatement ps;
//        Prodotto prodotto;
//        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();
//
//        try{
//            /*
//             *Prende tutti i prodotti in base alla stringa specificata
//             */
//            String sql
//                    = " SELECT * "
//                    + " FROM prodotto "
//                    + " WHERE nomeCarta LIKE '%" +search+ "%' OR"
//                    + " tipoCarta LIKE '%" +search+ "%' OR"
//                    + " rarita LIKE '%" +search+ "%' OR"
//                    + " edizione LIKE '%" +search+ "%' OR"
//                    + " testo LIKE '%" +search+ "%'"
//                    + " AND Blocked = 'N' ";
//
//            ps = connection.prepareStatement(sql);
//
//            ResultSet resultSet = ps.executeQuery();
//
//            while(resultSet.next()) {
//                prodotto = read(resultSet);
//                prodotti.add(prodotto);
//            }
//
//            resultSet.close();
//            ps.close();
//
//        }catch(SQLException e){
//            throw new RuntimeException(e);
//        }
//
//        return prodotti;
//    }
//
//    /**
//     *
//     * Recupera dal DB il prodotto con il codiceProdotto specificato
//     * @param codiceProdotto
//     * @return Prodotto

    @Override
    public Prodotto findByKey(int id){
        PreparedStatement ps;
        Prodotto prodotto = null;

        try{
            /*
             *Prende il prodotto con la chiave specificata
             */
            String sql
                    = " SELECT * "
                    + " FROM prodotto "
                    + " WHERE id = ?";

            ps = connection.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet resultSet = ps.executeQuery();

            if(resultSet.next()) {
                prodotto = read(resultSet);
            }

            resultSet.close();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }

        return prodotto;
    }

    /**
     *
     * Recupera dal DB tutti i prodotti inseriti nella vetrina di push in home
     * page da parte dell'admin
     * @return ArrayList di Prodotto
     */
    @Override
    public ArrayList<Prodotto> findForPush() {
        PreparedStatement ps;
        Prodotto prodotto;
        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();

        try{
            /*
             *Prende tutti i prodotti in vetrina
             */
            String sql
                    = " SELECT * "
                    + " FROM prodotto "
                    + " WHERE push = '1' AND blocked = '0'";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()) {
                prodotto = read(resultSet);
                prodotti.add(prodotto);
            }

            resultSet.close();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }

        return prodotti;
    }

    /**
     *
     * Recupera dal DB tutti i prodotti presenti
     * @return ArrayList di Prodotto
     */
    @Override
    public ArrayList<Prodotto> trovaProdotti(){
        PreparedStatement ps;
        Prodotto prodotto;
        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();

        try{
            /*
             *Prende tutti i prodotti nel DB
             */
            String sql
                    = " SELECT * "
                    + " FROM prodotto ";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()) {
                prodotto = read(resultSet);
                prodotti.add(prodotto);
            }

            resultSet.close();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }

        return prodotti;
    }
         /* @param search
         * @return ArrayList di Prodotto
         */
    @Override
    public ArrayList<Prodotto> findByString(String search) {
        PreparedStatement ps;
        Prodotto prodotto;
        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();

        try{
            /*
             *Prende tutti i prodotti in base alla stringa specificata
             */
            String sql = "SELECT * "
                    + "FROM prodotto "
                    + "WHERE (nomeProdotto LIKE '%" + search + "%' "
                    + "OR categoria LIKE '%" + search + "%' "
                    + "OR descrizione LIKE '%" + search + "%') "
                    + "AND Blocked = '0'";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()) {
                prodotto = read(resultSet);
                prodotti.add(prodotto);
            }

            resultSet.close();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }

        return prodotti;
    }
    /**
     *
     * Recupera dal DB il codice dell'ultimo prodotto inserito
     * @return long
     */



    /*Leggo i vari campi del resultset e li carico in prodotto*/
    protected Prodotto read(ResultSet resultSet){
        Prodotto prodotto = new Prodotto();
        /*leggo l'id del db*/
        try {
            prodotto.setId(resultSet.getInt("id"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }



        /*Leggo il nome*/
        try {
            prodotto.setNomeProdotto(resultSet.getString("nomeProdotto"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo la categoria*/
        try {
            prodotto.setCategoria(resultSet.getString("categoria"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo prezzo*/
        try {
            prodotto.setPrezzo(resultSet.getFloat("prezzo"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo descrizione*/
        try {
            prodotto.setDescrizione(resultSet.getString("descrizione"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo materiale*/
        try {
            prodotto.setMateriale(resultSet.getString("materiale"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo taglia*/
        try {
            prodotto.setTaglia(resultSet.getString("taglia"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }



        /*Leggo l'immagine*/
        try {
            prodotto.setImmagine(resultSet.getString("immagine"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }
        /*Leggo l'immagine*/
        try {
            prodotto.setQuantita(resultSet.getInt("quantita"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }



        /*Leggo blocked*/
        try {
            if(resultSet.getBoolean("blocked")){
                prodotto.setBlocked(true);
            }else{
                prodotto.setBlocked(false);
            }
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }


        /*Leggo push*/
        try {
            if(resultSet.getBoolean("push")){
                prodotto.setPush(true);
            }else{
                prodotto.setPush(false);
            }
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        return prodotto;
    }

    public int getQuantitaByKey(int id){
        PreparedStatement ps;
        int quantita = 0;

        try{
            /*
             *Prende la disponibilità di magazzino in base al codiceProdotto
             */
            String sql
                    = " SELECT quantita "
                    + " FROM prodotto "
                    + " WHERE id = ? ";

            ps = connection.prepareStatement(sql);
            ps.setInt(1, id);


            ResultSet resultSet = ps.executeQuery();

            if(resultSet.next()) {
                quantita = resultSet.getInt("quantita");
            }

            resultSet.close();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }

        return quantita;
    }

}
