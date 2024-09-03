package controller;

import services.config.Configuration;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.dao.*;
import model.dao.exception.DuplicatedObjectException;

import model.session.dao.*;
import model.session.dao.CookieImpl.*;
import model.session.mo.*;

import model.mo.*;

import services.logservice.LogService;

public class Acquisto {

    private Acquisto() {
    }

    public static void view(HttpServletRequest request, HttpServletResponse response) {
        SessionDAOFactory sessionDAO;
        LoggedUser loggedUser;

        JDBC jdbc = null;
        Logger logger = LogService.printLog();

        try {
            // Inizializzazione della sessione e recupero del LoggedUser dal cookie
            sessionDAO = new CookieSessionDAOFactory();
            sessionDAO.initSession(request, response);

            LoggedUserDAO loggedUserDAO = sessionDAO.getLoggedUserDAO();
            loggedUser = loggedUserDAO.trova();

            // Inizializzazione della connessione JDBC
            jdbc = JDBC.getJDBC(Configuration.DAO_IMPL);
            jdbc.beginTransaction();

            // Recupera il carrello dell'utente dalla sessione (cookie)
            CarrelloDAO carrelloDAO = sessionDAO.getCarrelloDAO();
            ArrayList<Carrello> carrelli = carrelloDAO.trova();

            // Recupera i prodotti dal database utilizzando il ProdottoDAO
            ProdottoDAO prodottoDAO = jdbc.getProdottoDAO();
            ArrayList<Prodotto> prodotti = new ArrayList<>();

            for (Carrello carrello : carrelli) {
                Prodotto prodotto = prodottoDAO.findByKey(carrello.getProdotto().getCodiceProdotto());
                prodotti.add(prodotto);
            }

            // Calcola la disponibilità dei prodotti e il prezzo totale del carrello
            ArrayList<Boolean> disponibilita = new ArrayList<>();
            double prezzoTotale = 0;

            for (int i = 0; i < prodotti.size(); i++) {
                Prodotto prodotto = prodotti.get(i);
                int quantitaDisponibile = (int)prodottoDAO.getQuantitaByKey(prodotto.getCodiceProdotto());

                if (carrelli.get(i).getQuantità() <= quantitaDisponibile && !prodotto.isBlocked()) {
                    disponibilita.add(Boolean.TRUE);
                } else {
                    disponibilita.add(Boolean.FALSE);
                }

                prezzoTotale += prodotto.getPrezzo() * carrelli.get(i).getQuantità();
            }

            // Arrotonda il prezzo alla seconda cifra decimale
            prezzoTotale = Math.round(prezzoTotale * 100.0) / 100.0;

            jdbc.commitTransaction();

            // Imposta gli attributi per la view
            request.setAttribute("prezzoTotale", prezzoTotale);
            request.setAttribute("disponibilita", disponibilita);
            request.setAttribute("prodotti", prodotti);
            request.setAttribute("carrello", carrelli);
            request.setAttribute("loggedOn", loggedUser != null);
            request.setAttribute("loggedUser", loggedUser);
            request.setAttribute("viewUrl", "acquisto/carrello");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Errore Controller Acquisto", e);
            try {
                if (jdbc != null) {
                    jdbc.rollbackTransaction();
                }
            } catch (Throwable t) {
                // Log or handle the rollback error
            }
            throw new RuntimeException(e);
        } finally {
            try {
                if (jdbc != null) {
                    jdbc.closeTransaction();
                }
            } catch (Throwable t) {
                // Log or handle the close transaction error
            }
        }
    }
    public static void cambiaQuantita(HttpServletRequest request, HttpServletResponse response) {
        SessionDAOFactory sessionDAO;
        LoggedUser loggedUser;
        ArrayList<Carrello> carrelli;
        ArrayList<Prodotto> prodotti = new ArrayList<>();
        double prezzoTotale = 0;

        JDBC jdbc = null;
        Logger logger = LogService.printLog();

        try {
            // Inizializzazione della sessione e recupero del LoggedUser dal cookie
            sessionDAO = new CookieSessionDAOFactory();
            sessionDAO.initSession(request, response);

            LoggedUserDAO loggedUserDAO = sessionDAO.getLoggedUserDAO();
            loggedUser = loggedUserDAO.trova();

            // Inizializzazione della connessione JDBC
            jdbc = JDBC.getJDBC(Configuration.DAO_IMPL);
            jdbc.beginTransaction();

            // Recupera il prodotto dal database
            ProdottoDAO prodottoDAO = jdbc.getProdottoDAO();
            Prodotto prodotto = prodottoDAO.findByKey(request.getParameter("codiceProdotto"));

            // Recupera il carrello dell'utente dalla sessione (cookie)
            CarrelloDAO carrelloDAO = sessionDAO.getCarrelloDAO();
            carrelli = carrelloDAO.modificaQuantita(prodotto, Integer.parseInt(request.getParameter("quantita")));

            // Calcola la disponibilità dei prodotti e il prezzo totale del carrello
            ArrayList<Boolean> disponibilita = new ArrayList<>();

            for (Carrello carrello : carrelli) {
                Prodotto prodottoCarrello = carrello.getProdotto();
                int quantitaDisponibile =(int) prodottoDAO.getQuantitaByKey(prodottoCarrello.getCodiceProdotto());

                if (carrello.getQuantità() <= quantitaDisponibile && !prodottoCarrello.isBlocked()) {
                    disponibilita.add(Boolean.TRUE);
                } else {
                    disponibilita.add(Boolean.FALSE);
                }

                prezzoTotale += prodottoCarrello.getPrezzo() * carrello.getQuantità();
            }

            // Arrotonda il prezzo alla seconda cifra decimale
            prezzoTotale = Math.round(prezzoTotale * 100.0) / 100.0;

            jdbc.commitTransaction();

            // Imposta gli attributi per la view
            request.setAttribute("prezzoTotale", prezzoTotale);
            request.setAttribute("disponibilita", disponibilita);
            request.setAttribute("prodotti", prodotti);
            request.setAttribute("carrello", carrelli);
            request.setAttribute("loggedOn", loggedUser != null);
            request.setAttribute("loggedUser", loggedUser);
            request.setAttribute("viewUrl", "acquisto/carrello");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Errore Controller Acquisto - cambiaQuantita", e);
            try {
                if (jdbc != null) {
                    jdbc.rollbackTransaction();
                }
            } catch (Throwable t) {
                // Log or handle the rollback error
            }
            throw new RuntimeException(e);
        } finally {
            try {
                if (jdbc != null) {
                    jdbc.closeTransaction();
                }
            } catch (Throwable t) {
                // Log or handle the close transaction error
            }
        }
    }
    public static void rimuovi(HttpServletRequest request, HttpServletResponse response) {
        SessionDAOFactory sessionDAO;
        LoggedUser loggedUser;
        ArrayList<Carrello> carrelli = new ArrayList<>();
        ArrayList<Prodotto> prodotti = new ArrayList<>();
        double prezzoTotale = 0;

        JDBC jdbc = null;
        Logger logger = LogService.printLog();

        try {
            // Inizializzazione della sessione e recupero del LoggedUser
            sessionDAO = new CookieSessionDAOFactory();
            sessionDAO.initSession(request, response);

            LoggedUserDAO loggedUserDAO = sessionDAO.getLoggedUserDAO();
            loggedUser = loggedUserDAO.trova();

            // Recupero del carrello dell'utente e rimozione del prodotto
            CarrelloDAO carrelloDAO = sessionDAO.getCarrelloDAO();
            ProdottoDAO prodottoDAO = jdbc.getProdottoDAO();

            // Recupera il prodotto da rimuovere usando il codice prodotto dalla richiesta
            Prodotto prodotto = prodottoDAO.findByKey(request.getParameter("codiceProdotto"));
            carrelli = carrelloDAO.rimuovi(prodotto);

            // Inizializzazione della connessione JDBC
            jdbc = JDBC.getJDBC(Configuration.DAO_IMPL);
            jdbc.beginTransaction();

            // Recupero dei prodotti rimanenti nel carrello
            for (Carrello carrello : carrelli) {
                prodotti.add(prodottoDAO.findByKey(carrello.getProdotto().getCodiceProdotto()));
            }

            ArrayList<Boolean> disponibilita = new ArrayList<>();

            // Verifica della disponibilità dei prodotti
            for (Carrello carrello : carrelli) {
                Prodotto prodottoCarrello = carrello.getProdotto();
                int quantitaDisponibile = prodottoDAO.getQuantitaByKey(prodottoCarrello.getCodiceProdotto());

                if (carrello.getQuantità() <= quantitaDisponibile && !prodottoCarrello.isBlocked()) {
                    disponibilita.add(Boolean.TRUE);
                } else {
                    disponibilita.add(Boolean.FALSE);
                }

                prezzoTotale += prodottoCarrello.getPrezzo() * carrello.getQuantità();
            }

            // Arrotondamento del prezzo totale
            prezzoTotale = Math.round(prezzoTotale * 100.0) / 100.0;

            jdbc.commitTransaction();

            // Impostazione degli attributi per la vista
            request.setAttribute("prezzoTotale", prezzoTotale);
            request.setAttribute("disponibilita", disponibilita);
            request.setAttribute("prodotti", prodotti);
            request.setAttribute("carrello", carrelli);
            request.setAttribute("loggedOn", loggedUser != null);
            request.setAttribute("loggedUser", loggedUser);
            request.setAttribute("viewUrl", "acquisto/carrello");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Errore Controller Acquisto - rimuovi", e);
            try {
                if (jdbc != null) {
                    jdbc.rollbackTransaction();
                }
            } catch (Throwable t) {
                // Log or handle the rollback error
            }
            throw new RuntimeException(e);
        } finally {
            try {
                if (jdbc != null) {
                    jdbc.closeTransaction();
                }
            } catch (Throwable t) {
                // Log or handle the close transaction error
            }
        }
    }



    //add here
}
