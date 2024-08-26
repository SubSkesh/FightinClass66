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
     * @param codiceProdotto
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
    public Prodotto creaProdotto(String nomeProdotto, String categoria, String codiceProdotto,
                                 String descrizione, String immagine,
                                 float prezzo, long quantita,
                                 boolean blocked, boolean push)
            throws DuplicatedObjectException {
        PreparedStatement ps;
        Prodotto prodotto = new Prodotto();
        prodotto.setNomeProdotto(nomeProdotto);
        prodotto.setCategoria(categoria);
        prodotto.setDescrizione(descrizione);
        prodotto.setImmagine(immagine);
        prodotto.setQuantita(quantita);
        prodotto.setCodiceProdotto(codiceProdotto);
        prodotto.setPrezzo(prezzo);
        prodotto.setBlocked(blocked);
        prodotto.setPush(push);

        try {
            // Verifica se esiste già un prodotto con lo stesso codiceProdotto nel database
            String sql = "SELECT codiceProdotto FROM prodotto WHERE codiceProdotto = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, prodotto.getCodiceProdotto());

            ResultSet resultSet = ps.executeQuery();
            boolean exist = resultSet.next();
            resultSet.close();

            // Se esiste già un prodotto con lo stesso codiceProdotto, lancia un'eccezione
            if (exist) {
                throw new DuplicatedObjectException("ProdottoDAOJDBCImpl.creaProdotto: Tentativo di inserimento di un prodotto già esistente con questo codice.");
            }

            // Inserisce il nuovo prodotto nel database
            sql = "INSERT INTO prodotto (nomeProdotto, categoria, descrizione, immagine, quantita, codiceProdotto, prezzo, blocked, push) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            int i = 1;
            ps.setString(i++, prodotto.getNomeProdotto());
            ps.setString(i++, prodotto.getCategoria());
            ps.setString(i++, prodotto.getDescrizione());
            ps.setString(i++, prodotto.getImmagine());
            ps.setLong(i++, prodotto.getQuantita());
            ps.setString(i++, prodotto.getCodiceProdotto());
            ps.setFloat(i++, prodotto.getPrezzo());
            ps.setString(i++, prodotto.isBlocked() ? "S" : "N");
            ps.setString(i++, prodotto.isPush() ? "S" : "N");
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

    @Override
    public void aggiorna(Prodotto prodotto) throws DuplicatedObjectException {
        PreparedStatement ps;
        try {
            /*
             * Preparo la query per vedere se nel DB esiste già un prodotto uguale
             * a quello che voglio aggiornare
             */
            String sql
                    = "SELECT codiceProdotto "
                    + "FROM prodotto "
                    + "WHERE nomeProdotto = ? AND "
                    + "categoria = ? AND "
                    + "descrizione = ? AND "
                    + "immagine = ? AND "
                    + "quantita = ? AND "
                    + "prezzo = ?";

            ps = connection.prepareStatement(sql);
            int i = 1;
            ps.setString(i++, prodotto.getNomeProdotto());
            ps.setString(i++, prodotto.getCategoria());
            ps.setString(i++, prodotto.getDescrizione());
            ps.setString(i++, prodotto.getImmagine());
            ps.setLong(i++, prodotto.getQuantita());
            ps.setFloat(i++, prodotto.getPrezzo());

            ResultSet resultSet = ps.executeQuery();

            boolean exist;
            exist = resultSet.next();
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
                    + "push = ? "
                    + "WHERE codiceProdotto = ?";

            ps = connection.prepareStatement(sql);
            i = 1;
            ps.setString(i++, prodotto.getNomeProdotto());
            ps.setString(i++, prodotto.getCategoria());
            ps.setString(i++, prodotto.getDescrizione());
            ps.setString(i++, prodotto.getImmagine());
            ps.setLong(i++, prodotto.getQuantita());
            ps.setString(i++, prodotto.isBlocked() ? "S" : "N");
            ps.setString(i++, prodotto.isPush() ? "S" : "N");
            ps.setString(i++, prodotto.getCodiceProdotto());

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    /**
     *
     * Setta come bloccato un prodotto nel DB
     * @param codiceProdotto
     */
    @Override
    public void blocca(long codiceProdotto) {
        PreparedStatement ps;
        try{
            String sql
                    = " UPDATE prodotto "
                    + " SET blocked = 'S' "
                    + " WHERE "
                    + " codiceProdotto = ?";

            ps = connection.prepareStatement(sql);
            ps.setLong(1, codiceProdotto);
            ps.executeUpdate();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }
    }

    /**
     *
     * Setta come sbloccato un prodotto nel DB
     * @param codiceProdotto
     */
    @Override
    public void sblocca(long codiceProdotto) {
        PreparedStatement ps;
        try{
            String sql
                    = " UPDATE prodotto "
                    + " SET blocked = 'N' "
                    + " WHERE "
                    + " codiceProdotto = ?";

            ps = connection.prepareStatement(sql);
            ps.setLong(1, codiceProdotto);
            ps.executeUpdate();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }
    }

    /**
     *
     * Recupera dal DB tutte le carte presenti
     * @return ArrayList di String
     */

    public ArrayList<String> trovaNomeCarte(){
        PreparedStatement ps;
        String nomeCarta;
        ArrayList<String> nomeCarte = new ArrayList<String>();

        try{
            /*
             *Prendo tutte le carte esistenti in ordine alfabetico una volta sola
             */
            String sql
                    = " SELECT DISTINCT nomeCarta "
                    + " FROM prodotto "
                    + " ORDER BY nomeCarta ";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()){
                nomeCarta = resultSet.getString("nomeCarta");
                nomeCarte.add(nomeCarta);
            }

            resultSet.close();
            ps.close();
        }catch(SQLException sqle){
            throw new RuntimeException(sqle);
        }

        return nomeCarte;
    }

    /**
     *
     * Recupera dal DB tutti i tipi di carta presenti
     * @return ArrayList di String
     */

    public ArrayList<String> trovaTipoCarte(){
        PreparedStatement ps;
        String tipoCarta;
        ArrayList<String> tipoCarte = new ArrayList<String>();

        try{
            /*
             *Prendo tutti i tipi esistenti in ordine alfabetico una volta sola
             */
            String sql
                    = " SELECT DISTINCT tipoCarta "
                    + " FROM prodotto "
                    + " ORDER BY tipoCarta ";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()){
                tipoCarta = resultSet.getString("tipoCarta");
                tipoCarte.add(tipoCarta);
            }

            resultSet.close();
            ps.close();
        }catch(SQLException sqle){
            throw new RuntimeException(sqle);
        }

        return tipoCarte;
    }

    /**
     *
     * Recupera dal DB tutte le diverse rarità presenti
     * @return ArrayList di String
     */
    @Override
    public ArrayList<String> trovaRare(){
        PreparedStatement ps;
        String rarita;
        ArrayList<String> rare = new ArrayList<String>();

        try{
            /*
             *Prendo tutte le rarità esistenti in ordine alfabetico una volta sola
             */
            String sql
                    = " SELECT DISTINCT rarita "
                    + " FROM prodotto "
                    + " ORDER BY rarita ";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()){
                rarita = resultSet.getString("rarita");
                rare.add(rarita);
            }

            resultSet.close();
            ps.close();
        }catch(SQLException sqle){
            throw new RuntimeException(sqle);
        }

        return rare;
    }

    /**
     *
     * Recupera dal DB tutte le edizioni presenti
     * @return ArrayList di String
     */
    @Override
    public ArrayList<String> trovaEdizioni(){
        PreparedStatement ps;
        String edizione;
        ArrayList<String> edizioni = new ArrayList<String>();

        try{
            /*
             *Prendo tutte le edizioni esistenti in ordine alfabetico una volta sola
             */
            String sql
                    = " SELECT DISTINCT edizione "
                    + " FROM prodotto "
                    + " ORDER BY edizione ";

            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while(resultSet.next()){
                edizione = resultSet.getString("edizione");
                edizioni.add(edizione);
            }

            resultSet.close();
            ps.close();
        }catch(SQLException sqle){
            throw new RuntimeException(sqle);
        }

        return edizioni;
    }

    /**
     *
     * Recupera dal DB tutti i prodotti appartenenti all'edizione specificata
     * @param edizione
     * @return ArrayList di Prodotto
     */

    public ArrayList<Prodotto> findByEdizione(String edizione) {
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
                    + " WHERE edizione = ? AND blocked = 'N' ";

            ps = connection.prepareStatement(sql);
            ps.setString(1, edizione);

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
     * Recupera dal DB tutti i prodotti del tipo specificato
     * @param tipoCarta
     * @return ArrayList di Prodotto
     */
    @Override
    public ArrayList<Prodotto> findByTipoCarta(String tipoCarta) {
        PreparedStatement ps;
        Prodotto prodotto;
        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();

        try{
            /*
             *Prende tutti i prodotti del tipo specificato
             */
            String sql
                    = " SELECT * "
                    + " FROM prodotto "
                    + " WHERE tipoCarta = ? AND Blocked = 'N' ";

            ps = connection.prepareStatement(sql);
            ps.setString(1, tipoCarta);

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
     * Recupera dal DB tutti i prodotti della rarità specificata
     * @param rarita
     * @return ArrayList di Prodotto
     */
    @Override
    public ArrayList<Prodotto> findByRarità(String rarita) {
        PreparedStatement ps;
        Prodotto prodotto;
        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();

        try{
            /*
             *Prende tutti i prodotti in base alla rarità specificata
             */
            String sql
                    = " SELECT * "
                    + " FROM prodotto "
                    + " WHERE rarita = ? AND blocked = 'N' ";

            ps = connection.prepareStatement(sql);
            ps.setString(1, rarita);

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
     * Recupera dal DB tutti i prodotti che soddisfano la stringa di ricerca search
     * @param search
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
            String sql
                    = " SELECT * "
                    + " FROM prodotto "
                    + " WHERE nomeCarta LIKE '%" +search+ "%' OR"
                    + " tipoCarta LIKE '%" +search+ "%' OR"
                    + " rarita LIKE '%" +search+ "%' OR"
                    + " edizione LIKE '%" +search+ "%' OR"
                    + " testo LIKE '%" +search+ "%'"
                    + " AND Blocked = 'N' ";

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
     * Recupera dal DB il prodotto con il codiceProdotto specificato
     * @param codiceProdotto
     * @return Prodotto
     */
    @Override
    public Prodotto findByKey(Long codiceProdotto){
        PreparedStatement ps;
        Prodotto prodotto = null;

        try{
            /*
             *Prende il prodotto con la chiave specificata
             */
            String sql
                    = " SELECT * "
                    + " FROM prodotto "
                    + " WHERE codiceProdotto = ?";

            ps = connection.prepareStatement(sql);
            ps.setLong(1, codiceProdotto);

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
                    + " WHERE push = 'S' AND blocked = 'N'";

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

    /**
     *
     * Recupera dal DB il codice dell'ultimo prodotto inserito
     * @return long
     */


    /*Leggo i vari campi del resultset e li carico in prodotto*/
    protected Prodotto read(ResultSet resultSet){
        Prodotto prodotto = new Prodotto();

        /*Leggo il codice*/
        try {
            prodotto.setCodiceProdotto(resultSet.getLong("codiceProdotto"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo il nome*/
        try {
            prodotto.setNomeCarta(resultSet.getString("nomeCarta"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo il tipo*/
        try {
            prodotto.setTipoCarta(resultSet.getString("tipoCarta"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo prezzo*/
        try {
            prodotto.setPrezzo(resultSet.getFloat("prezzo"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo rarità*/
        try {
            prodotto.setRarità(resultSet.getString("rarita"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo edizione*/
        try {
            prodotto.setEdizione(resultSet.getString("edizione"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo l'immagine*/
        try {
            prodotto.setImmagine(resultSet.getString("immagine"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo la descrizione*/
        try {
            prodotto.setTesto(resultSet.getString("testo"));
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo blocked*/
        try {
            if(resultSet.getString("blocked").equals("S")){
                prodotto.setBlocked(true);
            }else{
                prodotto.setBlocked(false);
            }
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        /*Leggo push*/
        try {
            if(resultSet.getString("push").equals("S")){
                prodotto.setPush(true);
            }else{
                prodotto.setPush(false);
            }
        }catch(SQLException sqle){
            System.out.println(sqle.getMessage());
        }

        return prodotto;
    }

    public long getQuantitàByKey(long codiceProdotto){
        PreparedStatement ps;
        long quantita = 0;

        try{
            /*
             *Prende la disponibilità di magazzino in base al codiceProdotto
             */
            String sql
                    = " SELECT quantita "
                    + " FROM prodotto "
                    + " WHERE codiceProdotto = ? ";

            ps = connection.prepareStatement(sql);
            ps.setLong(1, codiceProdotto);


            ResultSet resultSet = ps.executeQuery();

            if(resultSet.next()) {
                quantita = resultSet.getLong("quantita");
            }

            resultSet.close();
            ps.close();

        }catch(SQLException e){
            throw new RuntimeException(e);
        }

        return quantita;
    }

}
