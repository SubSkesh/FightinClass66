package model.session.dao;

import java.util.ArrayList;
import model.session.mo.Carrello;
import model.mo.Prodotto;

/**
 * Interfaccia per la gestione del Carrello nella sessione di un utente.
 */
public interface CarrelloDAO {

    /**
     * Crea una nuova voce nel carrello per un prodotto specifico.
     *
     * @param prodotto Oggetto Prodotto da aggiungere.
     * @param quantita Quantità del prodotto da aggiungere.
     * @return Una lista aggiornata degli articoli nel carrello.
     */
    public ArrayList<Carrello> crea(Prodotto prodotto, int quantita);

    /**
     * Aggiunge una quantità a un prodotto esistente nel carrello.
     *
     * @param prodotto Oggetto Prodotto da aggiungere.
     * @param quantita Quantità aggiuntiva del prodotto.
     */
    public void aggiungi(Prodotto prodotto, int quantita);

    /**
     * Rimuove un prodotto specifico dal carrello.
     *
     * @param prodotto Oggetto Prodotto da rimuovere.
     * @return Una lista aggiornata degli articoli nel carrello.
     */
    public ArrayList<Carrello> rimuovi(Prodotto prodotto);

    /**
     * Elimina tutti i prodotti dal carrello.
     */
    public void elimina();

    /**
     * Trova tutti i prodotti nel carrello.
     *
     * @return Una lista di tutti gli articoli presenti nel carrello.
     */
    public ArrayList<Carrello> trova();

    /**
     * Modifica la quantità di un prodotto nel carrello.
     *
     * @param prodotto Oggetto Prodotto da aggiornare.
     * @param quantita La nuova quantità del prodotto.
     * @return Una lista aggiornata degli articoli nel carrello.
     */
    public ArrayList<Carrello> modificaQuantita(Prodotto prodotto, int quantita);
}
