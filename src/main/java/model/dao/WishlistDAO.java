package model.dao;

import model.dao.exception.DuplicatedObjectException;
import model.mo.Prodotto;
import model.mo.Utente;
import model.mo.Wishlist;

import java.util.List;

/**
 * Interfaccia DAO per la gestione della Wishlist.
 */
public interface WishlistDAO {

    /**
     * Aggiunge un prodotto alla wishlist di un utente.
     *
     * @param wishlist L'oggetto Wishlist da aggiungere.
     */
    public void aggiungiAWishlist(Wishlist wishlist);


    public Wishlist create(Utente utente, Prodotto prodotto) throws  DuplicatedObjectException;
    /**
     * Rimuove un prodotto dalla wishlist di un utente.
     *
     *
     */
    public void rimuoviDaWishlist(int idUtente,int idProdotto);

    /**
     * Trova tutte le wishlist di un utente.
     *
     * @param utenteId L'ID dell'utente.
     * @return Una lista di oggetti Wishlist.
     */
    public List<Wishlist> trovaWishlistByUtente(int utenteId);}


