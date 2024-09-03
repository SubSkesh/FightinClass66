package model.dao;

import model.dao.exception.DuplicatedObjectException;
import model.mo.Prodotto;
import model.mo.Utente;
import model.mo.Wishlist;
import org.apache.catalina.User;

import java.util.List;

/**
 * Interfaccia DAO per la gestione della Wishlist.
 */
public interface WishlistDAO {

    /**
     * Aggiunge un prodotto alla wishlist di un utente.
     *
     */


    public Wishlist create(Utente utente, Prodotto prodotto) throws  DuplicatedObjectException;
    /**
     * Rimuove un prodotto dalla wishlist di un utente.
     *
     *
     */
    public Wishlist remove(Utente utente,Prodotto prodotto);
    /**
     * Trova tutte le wishlist di un utente.
     *
     * @param user l'utente.
     * @return Una lista di oggetti Wishlist.
     */
    public List<Wishlist> trovaWishlistByUtente(Utente user);}


