CREATE DATABASE ecommerce;

USE ecommerce;

CREATE TABLE Utente (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        nomeUtente VARCHAR(50),
                        cognome VARCHAR(50),
                        email VARCHAR(100),
                        password VARCHAR(100),
                        genere VARCHAR(10),
                        nazione VARCHAR(50),
                        citta VARCHAR(50),
                        via VARCHAR(100),
                        numeroCivico VARCHAR(10),
                        CAP INT,
                        admin BOOLEAN,
                        blocked BOOLEAN
);

CREATE TABLE Prodotto (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          nomeProdotto VARCHAR(100),
                          categoria VARCHAR(50),
                          descrizione TEXT,
                          immagine VARCHAR(255),
                          quantita INT,
                          codiceProdotto VARCHAR(50), -- Identificatore univoco commerciale del prodotto
                          prezzo DECIMAL(10, 2),
                          blocked BOOLEAN, -- Indica se il prodotto è bloccato (non disponibile per l'acquisto)
                          push BOOLEAN -- Indica se il prodotto è in promozione o evidenziato
);

CREATE TABLE Ordine (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        statoOrdine VARCHAR(50),
                        dataOrdine DATE,
                        dataConsegna DATE,
                        codiceOrdine VARCHAR(50),
                        utenteId INT,
                        FOREIGN KEY (utenteId) REFERENCES Utente(id)
);

CREATE TABLE Pagamento (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           statoPagamento VARCHAR(50),
                           cartaPagamento VARCHAR(50),
                           dataRichiestaPagamento DATE,
                           dataPagamento DATE,
                           codicePagamento VARCHAR(50),
                           importo DECIMAL(10, 2),
                           utenteId INT,
                           ordineId INT,
                           FOREIGN KEY (utenteId) REFERENCES Utente(id),
                           FOREIGN KEY (ordineId) REFERENCES Ordine(id)
);

CREATE TABLE Buono (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       dataScadenza DATE,
                       nomeBuono VARCHAR(50),
                       sconto INT,
                       codiceBuono VARCHAR(50),
                       eliminato BOOLEAN,
                       usato BOOLEAN,
                       ordineId INT,
                       FOREIGN KEY (ordineId) REFERENCES Ordine(id)
);

CREATE TABLE Contiene (
                          prodottoId INT,
                          ordineId INT,
                          quantitaOrdine INT,
                          PRIMARY KEY (prodottoId, ordineId),
                          FOREIGN KEY (prodottoId) REFERENCES Prodotto(id),
                          FOREIGN KEY (ordineId) REFERENCES Ordine(id)
);

CREATE TABLE Wishlist (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          utenteId INT,
                          prodottoId INT,
                          FOREIGN KEY (utenteId) REFERENCES Utente(id),
                          FOREIGN KEY (prodottoId) REFERENCES Prodotto(id)
);
