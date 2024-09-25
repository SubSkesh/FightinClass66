package model.dao;

import java.util.ArrayList;

import model.dao.exception.DuplicatedObjectException;
import model.mo.Contiene;
import model.mo.Prodotto;

/**
 * Interfaccia DAO per la gestione dei prodotti.
 */
public interface ProdottoDAO {

    /**
     * Crea un nuovo prodotto nel sistema.
     * @param nomeProdotto il nome del prodotto
     * @param categoria la categoria del prodotto (es. guantoni, paratibie, ecc.)
     * @param descrizione la descrizione del prodotto
     * @param immagine il percorso dell'immagine del prodotto
     * @param prezzo il prezzo del prodotto
     * @param quantita la quantità disponibile del prodotto
     * @param blocked flag che indica se il prodotto è bloccato (non disponibile per l'acquisto)
     * @param push flag che indica se il prodotto è in promozione o evidenziato
     * @return l'oggetto Prodotto creato
     * @throws DuplicatedObjectException se un prodotto con lo stesso codice esiste già
     */
    public Prodotto creaProdotto(String nomeProdotto, String categoria,
                                 String descrizione, String immagine,
                                 float prezzo, int quantita,
                                 boolean blocked, boolean push, Contiene[] contiene,String materiale,String taglia)
            throws DuplicatedObjectException, DuplicatedObjectException;

    /**
     * Aggiorna le informazioni di un prodotto esistente.
     * @param prodotto l'oggetto Prodotto da aggiornare
     * @throws DuplicatedObjectException se un prodotto con lo stesso codice esiste già
     */
    public void aggiorna(Prodotto prodotto) throws DuplicatedObjectException;

    /**
     * Blocca un prodotto, rendendolo non disponibile per l'acquisto.
     * @param id il codice del prodotto da bloccare
     */
    public void blocca(int id);

    /**
     * Sblocca un prodotto, rendendolo disponibile per l'acquisto.
     * @param id il codice del prodotto da sbloccare
     */
    public void sblocca( int id);

    /**
     * Trova tutti i nomi dei prodotti presenti nel database.
     * @return una lista di nomi di prodotti
     */
    public ArrayList<String> trovaNomiProdotti();

    /**
     * Trova tutte le categorie dei prodotti presenti nel database.
     * @return una lista di categorie di prodotti
     */
    public ArrayList<String> trovaCategorieProdotti();

    /**
     * Trova tutti i prodotti appartenenti a una determinata categoria.
     * @param categoria la categoria dei prodotti da trovare
     * @return una lista di prodotti appartenenti alla categoria specificata
     */
    public ArrayList<Prodotto> findByCategoria(String categoria);

    /**

    /**
     * Trova un prodotto in base alla sua chiave primaria.
     * @param id il codice del prodotto da trovare
     * @return l'oggetto Prodotto corrispondente, o null se non esiste
     */
    public Prodotto findByKey(int id);


    public ArrayList<Prodotto> findByTaglia(String taglia);
    public ArrayList<Prodotto> findByMateriale(String materiale);

    /**
     * Trova tutti i prodotti che sono in promozione (push).
     * @return una lista di prodotti in promozione
     */
    public ArrayList<Prodotto> findForPush();


    /**
     * Recupera tutti i prodotti presenti nel database.
     * @return una lista di tutti i prodotti
     */
    public ArrayList<Prodotto> trovaProdotti();

    public ArrayList<Prodotto> findByString(String search);

        /**
         * Trova la quantità disponibile di un prodotto in base alla sua chiave.
         * @param id il codice del prodotto da trovare
         * @return la quantità disponibile del prodotto
         */
    public int getQuantitaByKey(int id);

    public ArrayList<String> trovaTaglie();
    public ArrayList<String> trovaMateriali();
}
