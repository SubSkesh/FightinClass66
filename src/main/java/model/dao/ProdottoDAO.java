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
    public Prodotto creaProdotto(String nomeProdotto, String categoria, String codiceProdotto,
                                 String descrizione, String immagine,
                                 float prezzo, long quantita,
                                 boolean blocked, boolean push, Contiene[] contiene)
            throws DuplicatedObjectException, DuplicatedObjectException;

    /**
     * Aggiorna le informazioni di un prodotto esistente.
     * @param prodotto l'oggetto Prodotto da aggiornare
     * @throws DuplicatedObjectException se un prodotto con lo stesso codice esiste già
     */
    public void aggiorna(Prodotto prodotto) throws DuplicatedObjectException;

    /**
     * Blocca un prodotto, rendendolo non disponibile per l'acquisto.
     * @param codiceProdotto il codice del prodotto da bloccare
     */
    public void blocca(String codiceProdotto);

    /**
     * Sblocca un prodotto, rendendolo disponibile per l'acquisto.
     * @param codiceProdotto il codice del prodotto da sbloccare
     */
    public void sblocca(String codiceProdotto);

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
     * @param codiceProdotto il codice del prodotto da trovare
     * @return l'oggetto Prodotto corrispondente, o null se non esiste
     */
    public Prodotto findByKey(String codiceProdotto);

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

    /**
     * Trova la quantità disponibile di un prodotto in base alla sua chiave.
     * @param codiceProdotto il codice del prodotto da trovare
     * @return la quantità disponibile del prodotto
     */
    public long getQuantitaByKey(String codiceProdotto);
}
