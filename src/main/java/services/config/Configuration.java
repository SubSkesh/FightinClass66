package services.config;


import java.util.Calendar;
import java.util.logging.Level;
import model.dao.JDBC;

public class Configuration {

    /* DATABASE CONFIGURATION */
    public static final String DAO_IMPL = JDBC.MYSQLJDBCIMPL;
    public static final String DATABASE_DRIVER = "com.mysql.cj.jdbc.Driver";  // Aggiorna alla versione moderna del driver
    public static final String SERVER_TIMEZONE = Calendar.getInstance().getTimeZone().getID();
    public static final String DATABASE_URL = "jdbc:mysql://localhost/ecommerce?user=oskrrino&password=oscarinoanbbo00&serverTimezone=" + SERVER_TIMEZONE;

    /* LOGGER FILES CONFIGURATION */
    public static final String LOG_NAME = "Ecommerce_log.%g.%u.txt";
    public static final String DIR_LOG = System.getProperty("user.dir") + "/logs/" + LOG_NAME;  // Salva i log nella directory del progetto
    public static final Level GLOBAL_LOGGER_LEVEL = Level.ALL;
}
