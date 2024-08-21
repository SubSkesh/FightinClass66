package services.logservice;

import services.config.Configuration;

import java.io.IOException;
import java.util.logging.*;

/**
 * Classe LogService che gestisce la configurazione e la creazione di un logger per il progetto.
 * Questo logger è utilizzato per registrare messaggi di log in un file di log specifico.
 */
public class LogService {

    // Istanza di Logger condivisa nell'applicazione
    private static Logger applicationLogger;

    // Costruttore vuoto, non necessitiamo di istanze di LogService
    public LogService() {
    }

    /**
     * Metodo che ritorna il logger configurato per l'applicazione.
     * Se il logger non esiste, viene creato e configurato.
     *
     * @return Logger configurato per l'applicazione.
     */
    public static Logger getLogger() {
        // Formatter per i log (definisce il formato dei messaggi nel file di log)
        SimpleFormatter formatterTxt;

        // Handler per gestire il file in cui i log saranno scritti
        Handler fileHandler;

        try {
            // Verifica se il logger esiste già
            if (applicationLogger == null) {

                // Creazione del logger con il nome specificato in Configuration
                applicationLogger = Logger.getLogger(Configuration.LOG_NAME);

                // Configurazione del file di log, con la possibilità di aggiungere i log alla fine del file (append = true)
                fileHandler = new FileHandler(Configuration.DIR_LOG, true);

                // Configurazione del formato dei messaggi di log
                formatterTxt = new SimpleFormatter();
                fileHandler.setFormatter(formatterTxt);

                // Aggiunge il file handler al logger
                applicationLogger.addHandler(fileHandler);

                // Imposta il livello di log globale (quali tipi di messaggi devono essere loggati)
                applicationLogger.setLevel(Configuration.GLOBAL_LOGGER_LEVEL);

                // Impedisce al logger di inviare i messaggi di log al gestore padre (che potrebbe essere la console)
                applicationLogger.setUseParentHandlers(false);
            }

        } catch (IOException e) {
            // In caso di errore durante la creazione del logger, lo registra con un livello SEVERE
            if (applicationLogger != null) {
                applicationLogger.log(Level.SEVERE, "Errore nella creazione del logger", e);
            } else {
                e.printStackTrace();
            }
        }

        return applicationLogger;
    }

}
