package model.dao.mySQLJDBCImpl;

import java.sql.*;

import java.util.ArrayList;

import model.dao.WishlistDAO;
import model.dao.exception.DuplicatedObjectException;

import model.mo.Utente;
import model.mo.Prodotto;
import model.mo.Wishlist;

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
                    + "     prodottoId,"
                    + "     deleted "
                    + "   ) "
                    + " VALUES (?,?,'N')";

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
                    + " deleted ='N' AND "
                    + " user_id = ? AND"
                    + " wine_id = ?";

            ps = conn.prepareStatement(sql);
            int i = 1;
            ps.setLong(i++, wishlist.getUser().getUserId());
            ps.setLong(i++, wishlist.getWine().getWineId());

            ResultSet resultSet = ps.executeQuery();
            resultSet.next();

            Long existing_wishlist_id = (resultSet.getLong("wishlist_id"));

            resultSet.close();

            sql
                    = " UPDATE wishlist "
                    + " SET "
                    + " deleted = 'Y' "
                    + " WHERE "
                    + "  wishlist_id = ? ";

            ps = conn.prepareStatement(sql);
            i = 1;
            ps.setLong(i++, existing_wishlist_id);

            ps.executeUpdate();


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return wishlist;
    }


}


