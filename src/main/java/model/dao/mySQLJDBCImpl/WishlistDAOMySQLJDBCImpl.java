package model.dao.mySQLJDBCImpl;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;

import model.dao.WishlistDAO;
import model.dao.exception.DuplicatedObjectException;

import model.mo.Utente;
import model.mo.Prodotto;
import model.mo.Wishlist;
import org.apache.catalina.User;

public class WishlistDAOMySQLJDBCImpl implements WishlistDAO {
    Connection conn;

    public WishlistDAOMySQLJDBCImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public Wishlist create(
            Utente utente,
            Prodotto prodotto) throws DuplicatedObjectException {

        PreparedStatement ps;
        Wishlist wishlist = new Wishlist();
        wishlist.setUtente(utente);
        wishlist.setProdotto(prodotto);

        //provo a vedere se esite gia una tupla
        try {

            String sql
                    = " SELECT * "
                    + " FROM wishlist "
                    + " WHERE "
                    + " utenteId = ? AND"
                    + " prodottoId = ? ";

            ps = conn.prepareStatement(sql);
            int i = 1;
            ps.setLong(i++, wishlist.getUtente().getId());
            ps.setLong(i++, wishlist.getProdotto().getId());

            ResultSet resultSet = ps.executeQuery();

            boolean exist;
            exist = resultSet.next();
            resultSet.close();


            if (exist) {
                throw new DuplicatedObjectException("WishlistDAOJDBCImpl.create: Tentativo di inserimento di un elemento di wishlist già esistente.");
            }


            sql
                    = " INSERT INTO wishlist "
                    + "     (utenteId,"
                    + "     prodottoId)"
                    + " VALUES (?,?)";

            ps = conn.prepareStatement(sql);
            i = 1;
            ps.setLong(i++, wishlist.getUtente().getId());
            ps.setLong(i++, wishlist.getProdotto().getId());

            ps.executeUpdate();
            resultSet = ps.getGeneratedKeys();
            if (resultSet.next()) {
                wishlist.setId(resultSet.getInt(1));
            }
            resultSet.close();
        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }


        return wishlist;
    }
    public Wishlist remove( Utente utente, Prodotto prodotto) {

        PreparedStatement ps;
        Wishlist wishlist = new Wishlist();
        wishlist.setUtente(utente);
        wishlist.setProdotto(prodotto);

        try {

            // recupero il wishlist_id
            String sql
                    = " SELECT * "
                    + " FROM wishlist "
                    + " WHERE "
                    + " deleted ='0' AND "
                    + " userId = ? AND"
                    + " prodottoId = ?";

            ps = conn.prepareStatement(sql);
            int i = 1;
            ps.setLong(i++, wishlist.getUtente().getId());
            ps.setLong(i++, wishlist.getProdotto().getId());

            ResultSet resultSet = ps.executeQuery();
            resultSet.next();

            int existing_wishlist_id = (resultSet.getInt("id"));

            resultSet.close();

            sql
                    = " UPDATE wishlist "
                    + " SET "
                    + " deleted = 'Y' "
                    + " WHERE "
                    + "  id = ? ";

            ps = conn.prepareStatement(sql);
            i = 1;
            ps.setLong(i++, existing_wishlist_id);

            ps.executeUpdate();


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return wishlist;
    }

    public List<Wishlist> trovaWishlistByUtente(Utente user) {
        PreparedStatement ps = null;
        List<Wishlist> wishlistTuples = new ArrayList<>();
        try {
            Integer userId = user.getId();
            String sql = "SELECT * FROM wishlist WHERE deleted = '0' AND userId = ?";

            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet resultSet = ps.executeQuery();

            while (resultSet.next()) {
                Wishlist wishlist = read(resultSet);  // Assumendo che read sia un metodo che converte il ResultSet in un oggetto Wishlist
                wishlistTuples.add(wishlist);
            }

            resultSet.close();
        } catch (SQLException e) {
            throw new RuntimeException("Errore durante la ricerca della wishlist per l'utente: " + e.getMessage(), e);
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    throw new RuntimeException("Errore durante la chiusura del PreparedStatement: " + e.getMessage(), e);
                }
            }
        }

        return wishlistTuples;
    }
    Wishlist read(ResultSet rs) {
        Wishlist wishlist = new Wishlist();
        Utente user = new Utente();
        wishlist.setUtente(user);
        Prodotto prodotto = new Prodotto();
        wishlist.setProdotto(prodotto);

        try {
            wishlist.setId(rs.getInt("id"));
        } catch (SQLException sqle) {
        }
        try {
            wishlist.getUtente().setId(rs.getInt("utenteId"));
        } catch (SQLException sqle) {
        }
        try {
            wishlist.getProdotto().setId(rs.getInt("prodottoId"));
        } catch (SQLException sqle) {
        }
        try {
            wishlist.setDeleted(rs.getString("deleted").equals("Y"));
        } catch (SQLException sqle) {
        }
        return wishlist;
    }






}


