package model.session.dao.CookieImpl;

import model.session.dao.CarrelloDAO;
import model.session.mo.Carrello;
import model.mo.Prodotto;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;

/**
 * Implementazione dell'interfaccia CarrelloDAO utilizzando i cookie per memorizzare il carrello.
 */
public class CarrelloDAOCookieImpl implements CarrelloDAO {

    HttpServletRequest request;
    HttpServletResponse response;

    public CarrelloDAOCookieImpl(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
    }

    @Override
    public ArrayList<Carrello> crea(Prodotto prodotto, int quantita) {
        Carrello carrello = new Carrello();
        carrello.setProdotto(prodotto);
        carrello.setQuantità(quantita);

        ArrayList<Carrello> listaCarrello = new ArrayList<>();
        listaCarrello.add(carrello);

        Cookie cookie = new Cookie("carrello", encode(listaCarrello));//viene creato un nuovo cookie carrello
        cookie.setPath("/");//valido per tutto il dominio
        response.addCookie(cookie);//viene aggiunto il cookie alla risposta

        return listaCarrello;
    }

    @Override
    public void aggiungi(Prodotto prodotto, int quantita) {
        ArrayList<Carrello> listaCarrello = trova();
        boolean trovato = false;

        for (Carrello carrello : listaCarrello) {
            if (carrello.getProdotto().getId()==(prodotto.getId())) {
                carrello.setQuantità(carrello.getQuantità() + quantita);
                trovato = true;    //se trova un prodotto con lo stesso id aggiunge la quantità
                break;
            }
        }

        if (!trovato) {
            Carrello nuovoCarrello = new Carrello();
            nuovoCarrello.setProdotto(prodotto);
            nuovoCarrello.setQuantità(quantita);
            listaCarrello.add(nuovoCarrello);
        }

        Cookie cookie = new Cookie("carrello", encode(listaCarrello));
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    @Override
    public ArrayList<Carrello> rimuovi(Prodotto prodotto) {
        ArrayList<Carrello> listaCarrello = trova();

        listaCarrello.removeIf(carrello -> carrello.getProdotto().getId()==(prodotto.getId()));
        elimina(); //rimuove se ogni oggetto carrelo ha il codiceprodotto ufuale al prodotto passato

        if (!listaCarrello.isEmpty()) {
            Cookie cookie = new Cookie("carrello", encode(listaCarrello));
            cookie.setPath("/");
            response.addCookie(cookie);
        }

        return listaCarrello;
    }

    @Override
    public void elimina() {
        Cookie cookie = new Cookie("carrello", "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    @Override
    public ArrayList<Carrello> trova() {
        Cookie[] cookies = request.getCookies(); //recupera tutti i cookie dela request
        ArrayList<Carrello> carrello = new ArrayList<>();

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("carrello")) {
                    carrello = decode(cookie.getValue());
                }
            }
        }

        return carrello;
    }

    @Override
    public ArrayList<Carrello> modificaQuantita(Prodotto prodotto, int quantita) {
        ArrayList<Carrello> listaCarrello = trova();

        for (Carrello carrello : listaCarrello) {
            if (carrello.getProdotto().getId()==(prodotto.getId())) {
                carrello.setQuantità(quantita);
                break;//Omod
            }
        }

        Cookie cookie = new Cookie("carrello", encode(listaCarrello));
        cookie.setPath("/");
        response.addCookie(cookie);

        return listaCarrello;
    }

//    Il primo oggetto ha codiceProdotto = "A123" e quantità = 2.
//    Il secondo oggetto ha codiceProdotto = "B456" e quantità = 3.
//    Il risultato della chiamata a encode() su questa lista sarà:
//    "A123#2%B456#3"

    private String encode(ArrayList<Carrello> carrello) {
        StringBuilder encodedTemp = new StringBuilder();//classe che consente di costruire stringhe in modo efficiente
        for (Carrello item : carrello) {
            encodedTemp.append(item.getProdotto().getId())
                    .append("#")
                    .append(item.getQuantità())
                    .append("%");
        }

        return encodedTemp.substring(0, encodedTemp.length() - 1);//viene cancellato il carattere % finale
    }

    private ArrayList<Carrello> decode(String encoded) { //responsabile di tradurre una stringa enc nell'intero carrello utente
        ArrayList<Carrello> carrelli = new ArrayList<>();
        String[] values = encoded.split("%");

        for (String value : values) {
            carrelli.add(decodeAux(value));
        }

        return carrelli;
    }

    private Carrello decodeAux(String encoded) { //responsabile di tradurre una stringa enc in un carrello
        Carrello carrello = new Carrello();
        String[] values = encoded.split("#");

        // Crea un oggetto Prodotto e impostane il codice
        Prodotto prodotto = new Prodotto();
        prodotto.setId(Integer.parseInt(values[0]));

        carrello.setProdotto(prodotto);
        carrello.setQuantità(Integer.parseInt(values[1]));

        return carrello;
    }
}
