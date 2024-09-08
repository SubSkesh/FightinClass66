package controller;

import services.config.Configuration;
import java.util.ArrayList;
import java.util.Date;
import java.util.Calendar;
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
                Prodotto prodotto = prodottoDAO.findByKey(carrello.getProdotto().getId());
                prodotti.add(prodotto);
            }

            // Calcola la disponibilità dei prodotti e il prezzo totale del carrello
            ArrayList<Boolean> disponibilita = new ArrayList<>();
            double prezzoTotale = 0;

            for (int i = 0; i < prodotti.size(); i++) {
                Prodotto prodotto = prodotti.get(i);
                int quantitaDisponibile = (int)prodottoDAO.getQuantitaByKey(prodotto.getId());

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
            Prodotto prodotto = prodottoDAO.findByKey(Integer.parseInt(request.getParameter("idProdotto")));

            // Recupera il carrello dell'utente dalla sessione (cookie)
            CarrelloDAO carrelloDAO = sessionDAO.getCarrelloDAO();
            carrelli = carrelloDAO.modificaQuantita(prodotto, Integer.parseInt(request.getParameter("quantita")));

            // Calcola la disponibilità dei prodotti e il prezzo totale del carrello
            ArrayList<Boolean> disponibilita = new ArrayList<>();

            for (Carrello carrello : carrelli) {
                Prodotto prodottoCarrello = carrello.getProdotto();
                int quantitaDisponibile =(int) prodottoDAO.getQuantitaByKey(prodottoCarrello.getId());

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
            // Inizializzazione della sessione e recupero del LoggedUser dal cookie
            sessionDAO = new CookieSessionDAOFactory();
            sessionDAO.initSession(request, response);

            LoggedUserDAO loggedUserDAO = sessionDAO.getLoggedUserDAO();
            loggedUser = loggedUserDAO.trova();

            // Apertura di una connessione al database
            jdbc = JDBC.getJDBC(Configuration.DAO_IMPL);
            jdbc.beginTransaction();

            // Recupero del Prodotto dal database tramite il suo codice prodotto
            ProdottoDAO prodottoDAO = jdbc.getProdottoDAO();
            Prodotto prodottoDaRimuovere = prodottoDAO.findByKey(Integer.parseInt(request.getParameter("idProdotto")));

            // Rimozione del prodotto dal carrello
            CarrelloDAO carrelloDAO = sessionDAO.getCarrelloDAO();
            carrelli = carrelloDAO.rimuovi(prodottoDaRimuovere);

            // Recupero di tutti i prodotti nel carrello aggiornato
            for (Carrello carrello : carrelli) {
                prodotti.add(prodottoDAO.findByKey(carrello.getProdotto().getId()));
            }

            ArrayList<Boolean> disponibilitaProdotti = new ArrayList<>();

            // Controllo della disponibilità dei prodotti
            for (int i = 0; i < prodotti.size(); i++) {
                if (carrelli.get(i).getQuantità() <= prodottoDAO.getQuantitaByKey(prodotti.get(i).getId())) {
                    disponibilitaProdotti.add(Boolean.TRUE);
                } else {
                    disponibilitaProdotti.add(Boolean.FALSE);
                }
            }

            // Calcolo del prezzo totale del carrello
            for (int i = 0; i < prodotti.size(); i++) {
                prezzoTotale += prodotti.get(i).getPrezzo() * carrelli.get(i).getQuantità();
            }

            // Arrotondamento del prezzo alla seconda cifra decimale
            prezzoTotale = Math.round(prezzoTotale * 100.0) / 100.0;

            // Commit della transazione
            jdbc.commitTransaction();

            // Settaggio degli attributi per la vista
            request.setAttribute("prezzoTotale", prezzoTotale);
            request.setAttribute("disponibilitaProdotti", disponibilitaProdotti);
            request.setAttribute("prodotti", prodotti);
            request.setAttribute("carrello", carrelli);
            request.setAttribute("loggedOn", loggedUser != null);
            request.setAttribute("loggedUser", loggedUser);
            request.setAttribute("viewUrl", "acquisto/carrello");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Errore nel Controller Acquisto - Rimozione", e);
            try {
                if (jdbc != null) {
                    jdbc.rollbackTransaction();
                }
            } catch (Throwable t) {
                // Ignora
            }
            throw new RuntimeException(e);
        } finally {
            try {
                if (jdbc != null) {
                    jdbc.closeTransaction();
                }
            } catch (Throwable t) {
                // Ignora
            }
        }
    }
    /*Metodo per cancellare l'intero carrello, carrello.jsp*/
    public static void cancella(HttpServletRequest request, HttpServletResponse response) {
        SessionDAOFactory sessionDAO;
        LoggedUser ul;
        double prezzo = 0;

        Logger logger = LogService.printLog();
        try {
            /*Creo la sessione*/
            sessionDAO = new CookieSessionDAOFactory();
            sessionDAO.initSession(request, response);

            /*Recupero il cookie utente*/
            LoggedUserDAO ulDAO = sessionDAO.getLoggedUserDAO();
            ul = ulDAO.trova();

            /*Elimino il cookie carrello*/
            CarrelloDAO carrelloDAO = sessionDAO.getCarrelloDAO();
            carrelloDAO.elimina();

            /*Setto gli attributi del viewModel*/
            request.setAttribute("prezzo", prezzo);
            request.setAttribute("loggedOn", ul != null);
            request.setAttribute("loggedUser", ul);
            request.setAttribute("viewUrl", "acquisto/carrello");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Controller Error", e);
            throw new RuntimeException(e);
        }
    }
    public static void ordina(HttpServletRequest request, HttpServletResponse response) {
        SessionDAOFactory sessionDAO;
        LoggedUser loggedUser;
        ArrayList<Carrello> carrelli = new ArrayList<Carrello>();

        JDBC jdbc = null;
        Logger logger = LogService.printLog();

        try {
            // Inizializzazione della sessione e recupero del LoggedUser dal cookie
            sessionDAO = new CookieSessionDAOFactory();
            sessionDAO.initSession(request, response);

            LoggedUserDAO loggedUserDAO = sessionDAO.getLoggedUserDAO();
            loggedUser = loggedUserDAO.trova();

            // Recupero del carrello dall'utente
            CarrelloDAO carrelloDAO = sessionDAO.getCarrelloDAO();
            carrelli = carrelloDAO.trova();

            // Connessione al database e inizio della transazione
            jdbc = JDBC.getJDBC( Configuration.DAO_IMPL);
            jdbc.beginTransaction();

            // Recupero dei dettagli dei prodotti nel carrello
            ArrayList<Prodotto> prodotti = new ArrayList<>();
            ProdottoDAO prodottoDAO = jdbc.getProdottoDAO();

            // Estrai ogni prodotto dal DB e verifica la disponibilità
            for (Carrello carrello : carrelli) {
                Prodotto prodotto = prodottoDAO.findByKey(carrello.getProdotto().getId());
                prodotti.add(prodotto);
            }

            boolean disponibilità = true;

            // Verifica se la quantità richiesta eccede la disponibilità o se il prodotto è bloccato
            for (int i = 0; i < carrelli.size(); i++) {
                if (carrelli.get(i).getQuantità() > prodottoDAO.getQuantitaByKey(carrelli.get(i).getProdotto().getId())
                        || prodotti.get(i).isBlocked()) {
                    disponibilità = false;
                    break;  // Se un prodotto non è disponibile, non ha senso continuare
                }
            }

            // Se uno o più prodotti non sono disponibili, mostra di nuovo il carrello con un messaggio di errore
            if (!disponibilità) {
                commonView(jdbc, sessionDAO, request);
                request.setAttribute("viewUrl", "acquisto/carrello");
                request.setAttribute("applicationMessage", "Uno o più prodotti non sono disponibili per l'acquisto");
            } else {
                // Tutti i prodotti sono disponibili, vai alla pagina di pagamento
                request.setAttribute("carrello", carrelli);
                request.setAttribute("viewUrl", "acquisto/pagamento");
            }

            jdbc.commitTransaction();

            // Imposta i parametri della vista per l'utente loggato
            request.setAttribute("loggedOn", loggedUser != null);
            request.setAttribute("loggedUser", loggedUser);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Errore Controller Acquisto - Ordina", e);
            try {
                if (jdbc != null) {
                    jdbc.rollbackTransaction();
                }
            } catch (Throwable t) {
                logger.log(Level.SEVERE, "Errore durante il rollback", t);
            }
            throw new RuntimeException(e);
        } finally {
            try {
                if (jdbc != null) {
                    jdbc.closeTransaction();
                }
            } catch (Throwable t) {
                logger.log(Level.SEVERE, "Errore durante la chiusura della transazione", t);
            }
        }
    }
    public static void procedi(HttpServletRequest request, HttpServletResponse response) {
        SessionDAOFactory sessionDAO;
        LoggedUser loggedUser;
        ArrayList<Carrello> carrelli = new ArrayList<>(); // Lista degli articoli nel carrello
        String applicationMessage = null; // Messaggio per eventuali errori

        JDBC jdbc = null; // Connessione al database
        Logger logger = LogService.printLog(); // Logger per tracciare eventuali errori

        try {
            // Inizializza la sessione e recupera l'utente loggato dal cookie
            sessionDAO = new CookieSessionDAOFactory();
            sessionDAO.initSession(request, response);

            LoggedUserDAO loggedUserDAO = sessionDAO.getLoggedUserDAO(); // DAO per l'utente loggato
            loggedUser = loggedUserDAO.trova(); // Recupera l'utente loggato

            // Recupera il carrello dell'utente loggato
            CarrelloDAO carrelloDAO = sessionDAO.getCarrelloDAO();
            carrelli = carrelloDAO.trova(); // Ottiene i prodotti presenti nel carrello

            // Inizia la transazione con il database
            jdbc = JDBC.getJDBC(Configuration.DAO_IMPL);
            jdbc.beginTransaction();

            BuonoDAO buonoDAO = jdbc.getBuonoDAO();
            Buono buono = null;
            boolean validità = true;

            // Controlla se è stato inserito un buono e verifica la sua validità
            if (Long.parseLong(request.getParameter("codiceBuono")) != 0) {
                validità = buonoDAO.checkValidità(request.getParameter("codiceBuono")); // Controlla validità del buono
                buono = buonoDAO.findBuonoByKey(request.getParameter("codiceBuono")); // Trova il buono per chiave
            }

            if (validità) {
                // Se il buono è valido, recupera i dati dell'ordine
                String cartaPagamento = request.getParameter("cartaPagamento");
                String nazione = request.getParameter("nazione");
                String citta = request.getParameter("citta");
                String via = request.getParameter("via");
                long numeroCivico = Long.parseLong(request.getParameter("numeroCivico"));
                int CAP = Integer.parseInt(request.getParameter("CAP"));
                double prezzo = 0;

                // Recupera i prodotti del carrello dal database per calcolare il prezzo totale
                ProdottoDAO prodottoDAO = jdbc.getProdottoDAO();
                ArrayList<Prodotto> prodotti = new ArrayList<>();
                for (Carrello carrello : carrelli) {
                    prodotti.add(prodottoDAO.findByKey(carrello.getProdotto().getId())); // Trova ogni prodotto nel DB
                }

                // Calcola il prezzo totale del carrello
                for (int i = 0; i < prodotti.size(); i++) {
                    prezzo += prodotti.get(i).getPrezzo() * carrelli.get(i).getQuantità(); // Moltiplica il prezzo per la quantità
                }

                // Se c'è un buono, calcola lo sconto e applicalo al prezzo
                if (buono != null) {
                    double sconto = (prezzo / 100) * buono.getSconto();
                    prezzo -= sconto; // Applica lo sconto
                }

                // Arrotonda il prezzo alla seconda cifra decimale
                prezzo = Math.round(prezzo * 100.0) / 100.0;

                // Imposta gli attributi per la vista di riepilogo
                request.setAttribute("cartaPagamento", cartaPagamento);
                request.setAttribute("nazione", nazione);
                request.setAttribute("citta", citta);
                request.setAttribute("via", via);
                request.setAttribute("numeroCivico", numeroCivico);
                request.setAttribute("CAP", CAP);
                request.setAttribute("prezzo", prezzo);
                request.setAttribute("prodotti", prodotti);
                request.setAttribute("buonoPresente", buono != null);
                request.setAttribute("buono", buono);
                request.setAttribute("viewUrl", "acquisto/riepilogo");

            } else {
                // Se il buono non è valido, ritorna alla pagina di pagamento con un messaggio di errore
                applicationMessage = "Buono non valido";
                request.setAttribute("applicationMessage", applicationMessage);
                request.setAttribute("viewUrl", "acquisto/pagamento");
            }

            // Commit della transazione
            jdbc.commitTransaction();

            // Imposta gli attributi per il viewModel
            request.setAttribute("loggedOn", loggedUser != null);
            request.setAttribute("loggedUser", loggedUser);
            request.setAttribute("carrello", carrelli);

        } catch (Exception e) {
            // Gestione degli errori, rollback della transazione in caso di eccezioni
            logger.log(Level.SEVERE, "Errore nel controller Acquisto", e);
            try {
                if (jdbc != null) {
                    jdbc.rollbackTransaction();
                }
            } catch (Throwable t) {
                // Ignora gli errori durante il rollback
            }
            throw new RuntimeException(e); // Rilancia l'eccezione
        } finally {
            try {
                // Chiude la transazione e la connessione al database
                if (jdbc != null) {
                    jdbc.closeTransaction();
                }
            } catch (Throwable t) {
                // Ignora gli errori durante la chiusura della transazione
            }
        }
    }

    public static void paga(HttpServletRequest request, HttpServletResponse response) {
        SessionDAOFactory sessionDAO;
        LoggedUser ul;
        ArrayList<Carrello> carrelli = new ArrayList<>();
        String applicationMessage = null;

        JDBC jdbc = null;

        Logger logger = LogService.printLog();
        try {
            // Inizializzo la sessione e recupero l'utente loggato
            sessionDAO = new CookieSessionDAOFactory();
            sessionDAO.initSession(request, response);

            LoggedUserDAO ulDAO = sessionDAO.getLoggedUserDAO();
            ul = ulDAO.trova();

            // Recupero il carrello dell'utente
            CarrelloDAO carrelloDAO = sessionDAO.getCarrelloDAO();
            carrelli = carrelloDAO.trova();

            // Apro la connessione al database
            jdbc = JDBC.getJDBC(Configuration.DAO_IMPL);
            jdbc.beginTransaction();

            boolean disponibilità = true;
            ArrayList<Prodotto> prodotti = new ArrayList<>();
            ProdottoDAO prodottoDAO = jdbc.getProdottoDAO();

            // Estraggo i prodotti dal carrello
            for (Carrello carrello : carrelli) {
                prodotti.add(prodottoDAO.findByKey(carrello.getProdotto().getId()));
            }

            // Controllo disponibilità
            for (int i = 0; i < carrelli.size(); i++) {
                if (carrelli.get(i).getQuantità() > prodottoDAO.getQuantitaByKey(carrelli.get(i).getProdotto().getId())
                        || prodotti.get(i).isBlocked()) {
                    disponibilità = false;
                }
            }

            if (disponibilità) {
                Buono buono = null;
                BuonoDAO buonoDAO = jdbc.getBuonoDAO();

                // Controllo se l'utente ha inserito un buono
                String buonoPresente = request.getParameter("buonoPresente");
                if (buonoPresente != null && buonoPresente.equals("S")) {
                    // Se presente, carico il buono dal database
                    buono = buonoDAO.findBuonoByKey(request.getParameter("codiceBuono"));
                }

                // Carico l'utente loggato
                UtenteDAO utenteDAO = jdbc.getUtenteDAO();
                Utente utente = utenteDAO.findByEmail(ul.getEmail());

                // Creo il pagamento
                Pagamento pagamento = null;
                PagamentoDAO pagamentoDAO = jdbc.getPagamentoDAO();
                java.util.Date dataOdierna = new Date();

                try {
                    pagamento = pagamentoDAO.creaPagamento("confermato", request.getParameter("cartaPagamento"), dataOdierna,
                            dataOdierna, Float.parseFloat(request.getParameter("prezzo")), utente, null);
                } catch (DuplicatedObjectException doe) {
                    applicationMessage = "Pagamento già esistente";
                    logger.log(Level.INFO, "Tentativo di inserimento di un pagamento già esistente");
                }

                // Creo l'ordine
                OrdineDAO ordineDAO = jdbc.getOrdineDAO();
                Ordine ordine = null;
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.DATE, 3);  // Data di consegna

                try {
                    ordine = ordineDAO.creaOrdine(dataOdierna, "In preparazione", cal.getTime(), request.getParameter("nazione"),
                            request.getParameter("citta"), request.getParameter("via"), Long.parseLong(request.getParameter("numeroCivico")),
                            Integer.parseInt(request.getParameter("CAP")), pagamento, buono, utente, null);
                } catch (DuplicatedObjectException doe) {
                    applicationMessage = "Ordine già esistente";
                    logger.log(Level.INFO, "Tentativo di inserimento di un ordine già esistente");
                }

                // Aggiungo i prodotti all'ordine
                ContieneDAO contieneDAO = jdbc.getContieneDAO();
                for (Carrello carrello : carrelli) {
                    contieneDAO.creaContiene(ordine.getId(), carrello.getProdotto().getId(), carrello.getQuantità());
                }

                // Aggiorno la giacenza dei prodotti
                for (Carrello carrello : carrelli) {
                    Prodotto prodotto = prodottoDAO.findByKey(carrello.getProdotto().getId());
                    prodotto.setQuantita( prodottoDAO.getQuantitaByKey(carrello.getProdotto().getId()) - carrello.getQuantità());
                    prodottoDAO.aggiorna(prodotto);
                }

                // Se un buono è stato utilizzato, lo marco come usato
                if (buono != null) {
                    buono.setUsato(true);
                    buonoDAO.aggiorna(buono);
                }

                // Cancello il carrello dell'utente
                carrelloDAO.elimina();
                applicationMessage = "Ordine avvenuto con successo";
                request.setAttribute("prezzo", 0);

            } else {
                // Se la disponibilità è cambiata, l'ordine non può essere eseguito
                applicationMessage = "Disponibilità modificata durante la transazione, impossibile procedere all'ordine";
                commonView(jdbc, sessionDAO, request);
            }

            jdbc.commitTransaction();

            request.setAttribute("loggedOn", ul != null);
            request.setAttribute("loggedUser", ul);
            request.setAttribute("applicationMessage", applicationMessage);
            request.setAttribute("viewUrl", "acquisto/carrello");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Errore Controller Acquisto", e);
            try {
                if (jdbc != null) {
                    jdbc.rollbackTransaction();
                }
            } catch (Throwable t) {
                // Ignora eccezioni durante il rollback
            }
            throw new RuntimeException(e);
        } finally {
            try {
                if (jdbc != null) {
                    jdbc.closeTransaction();
                }
            } catch (Throwable t) {
                // Ignora eccezioni durante la chiusura
            }
        }
    }

    public static void commonView(JDBC jdbc, SessionDAOFactory sessionDAO, HttpServletRequest request) {
        /*Recupero il cookie carrello*/
        ArrayList<Carrello> carrelli = new ArrayList<Carrello>();
        CarrelloDAO carrelloDAO = sessionDAO.getCarrelloDAO();
        carrelli = carrelloDAO.trova();
        double prezzo = 0;

        ArrayList<Prodotto> prodotti = new ArrayList<Prodotto>();

        ProdottoDAO prodottoDAO = jdbc.getProdottoDAO();

        /*Estraggo i prodotti dal DB*/
        for (Carrello carrello : carrelli) {
            prodotti.add(prodottoDAO.findByKey(carrello.getProdotto().getId()));
        }

        ArrayList<Boolean> disponibilità = new ArrayList<Boolean>();

        /*Mappo le disponibilità dei prodotti*/
        for (int j = 0; j < prodotti.size(); j++) {
            if (carrelli.get(j).getQuantità() < prodottoDAO.getQuantitaByKey(carrelli.get(j).getidProdotto()) && !prodotti.get(j).isBlocked()) {
                disponibilità.add(Boolean.TRUE);
            } else {
                disponibilità.add(Boolean.FALSE);
            }
        }

        /*Calcolo il prezzo totale del carrello*/
        for (int i = 0; i < prodotti.size(); i++) {
            prezzo += prodotti.get(i).getPrezzo() * carrelli.get(i).getQuantità();
        }

        /*Arrotondo il prezzo alla seconda cifra decimale*/
        prezzo = Math.round(prezzo * 100.0) / 100.0;

        /*Setto gli attributi del viewModel*/
        request.setAttribute("prezzo", prezzo);
        request.setAttribute("disponibilita", disponibilità);
        request.setAttribute("prodotti", prodotti);
        request.setAttribute("carrello", carrelli);

    }

    //add here
}
