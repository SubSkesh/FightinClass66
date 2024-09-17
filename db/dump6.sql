-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `buono`
--

DROP TABLE IF EXISTS `buono`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buono` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dataScadenza` date DEFAULT NULL,
  `nomeBuono` varchar(50) DEFAULT NULL,
  `sconto` int DEFAULT NULL,
  `codiceBuono` varchar(50) DEFAULT NULL,
  `eliminato` tinyint(1) DEFAULT NULL,
  `usato` tinyint(1) DEFAULT NULL,
  `ordineId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `buono_pk` (`codiceBuono`),
  KEY `ordineId` (`ordineId`),
  CONSTRAINT `buono_ibfk_1` FOREIGN KEY (`ordineId`) REFERENCES `ordine` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buono`
--

LOCK TABLES `buono` WRITE;
/*!40000 ALTER TABLE `buono` DISABLE KEYS */;
/*!40000 ALTER TABLE `buono` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contiene`
--

DROP TABLE IF EXISTS `contiene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contiene` (
  `prodottoId` int NOT NULL,
  `ordineId` int NOT NULL,
  `quantitaOrdine` int DEFAULT NULL,
  PRIMARY KEY (`prodottoId`,`ordineId`),
  KEY `ordineId` (`ordineId`),
  CONSTRAINT `contiene_ibfk_1` FOREIGN KEY (`prodottoId`) REFERENCES `prodotto` (`id`),
  CONSTRAINT `contiene_ibfk_2` FOREIGN KEY (`ordineId`) REFERENCES `ordine` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contiene`
--

LOCK TABLES `contiene` WRITE;
/*!40000 ALTER TABLE `contiene` DISABLE KEYS */;
/*!40000 ALTER TABLE `contiene` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordine`
--

DROP TABLE IF EXISTS `ordine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `statoOrdine` varchar(50) DEFAULT NULL,
  `dataOrdine` date DEFAULT NULL,
  `dataConsegna` date DEFAULT NULL,
  `codiceOrdine` varchar(50) DEFAULT NULL,
  `utenteId` int DEFAULT NULL,
  `nazione` varchar(50) DEFAULT NULL,
  `citta` varchar(50) DEFAULT NULL,
  `via` varchar(100) DEFAULT NULL,
  `numeroCivico` int DEFAULT NULL,
  `CAP` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_codiceOrdine` (`codiceOrdine`),
  KEY `utenteId` (`utenteId`),
  CONSTRAINT `ordine_ibfk_1` FOREIGN KEY (`utenteId`) REFERENCES `utente` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordine`
--

LOCK TABLES `ordine` WRITE;
/*!40000 ALTER TABLE `ordine` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagamento`
--

DROP TABLE IF EXISTS `pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagamento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `statoPagamento` varchar(50) DEFAULT NULL,
  `cartaPagamento` varchar(50) DEFAULT NULL,
  `dataRichiestaPagamento` date DEFAULT NULL,
  `dataPagamento` date DEFAULT NULL,
  `importo` decimal(10,2) DEFAULT NULL,
  `utenteId` int DEFAULT NULL,
  `ordineId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `utenteId` (`utenteId`),
  KEY `ordineId` (`ordineId`),
  CONSTRAINT `pagamento_ibfk_1` FOREIGN KEY (`utenteId`) REFERENCES `utente` (`id`),
  CONSTRAINT `pagamento_ibfk_2` FOREIGN KEY (`ordineId`) REFERENCES `ordine` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamento`
--

LOCK TABLES `pagamento` WRITE;
/*!40000 ALTER TABLE `pagamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prodotto`
--

DROP TABLE IF EXISTS `prodotto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prodotto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nomeProdotto` varchar(100) DEFAULT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `descrizione` text,
  `immagine` varchar(255) DEFAULT NULL,
  `quantita` int DEFAULT NULL,
  `prezzo` decimal(10,2) DEFAULT NULL,
  `blocked` tinyint(1) DEFAULT NULL,
  `push` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prodotto`
--

LOCK TABLES `prodotto` WRITE;
/*!40000 ALTER TABLE `prodotto` DISABLE KEYS */;
/*!40000 ALTER TABLE `prodotto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nomeUtente` varchar(50) DEFAULT NULL,
  `cognome` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `genere` varchar(10) DEFAULT NULL,
  `nazione` varchar(50) DEFAULT NULL,
  `citta` varchar(50) DEFAULT NULL,
  `via` varchar(100) DEFAULT NULL,
  `numeroCivico` varchar(10) DEFAULT NULL,
  `CAP` int DEFAULT NULL,
  `admin` tinyint(1) DEFAULT NULL,
  `blocked` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `utente_pk` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `utenteId` int DEFAULT NULL,
  `prodottoId` int DEFAULT NULL,
  `deleted` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_wishlist` (`utenteId`,`prodottoId`),
  KEY `prodottoId` (`prodottoId`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`utenteId`) REFERENCES `utente` (`id`),
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`prodottoId`) REFERENCES `prodotto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-16 14:29:07
