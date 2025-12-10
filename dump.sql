-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: mydb
-- ------------------------------------------------------
-- Server version	8.0.33

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
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Organic','Items grown or produced without the use of synthetic fertilizers or pesticides.'),(2,'Fresh','Items that are fresh and have not been processed or preserved.'),(3,'Seasonal','Items that are available only during specific seasons.'),(4,'Frozen','Items that are frozen to maintain freshness and prevent spoilage.'),(5,'Local','Items that are sourced locally.'),(6,'Imported','Items that are imported from other countries or regions.'),(7,'Gluten-Free','Items that do not contain gluten, suitable for people with gluten sensitivity.'),(8,'Low-Carb','Items that are low in carbohydrates, typically for low-carb diets.'),(9,'Vegan','Items that do not contain any animal-derived ingredients.'),(10,'High in Protein','Items that are rich in protein, typically for muscle building and repair.'),(11,'Low Fat','Items that are low in fat content, suitable for low-fat diets.'),(12,'High in Fiber','Items that are high in fiber, beneficial for digestion and health.');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fruits`
--

DROP TABLE IF EXISTS `fruits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fruits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `is_rotten` tinyint DEFAULT NULL,
  `is_ripe` tinyint DEFAULT NULL,
  `acquired_from` varchar(45) DEFAULT NULL,
  `color` varchar(45) DEFAULT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`id`,`category_id`),
  KEY `fk_Fruits_category1_idx` (`category_id`),
  CONSTRAINT `fk_Fruits_category1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fruits`
--

LOCK TABLES `fruits` WRITE;
/*!40000 ALTER TABLE `fruits` DISABLE KEYS */;
INSERT INTO `fruits` VALUES (1,'Apple',0,1,'Supermarket','Red',1),(2,'Banana',0,1,'Farmer\'s Market','Yellow',2),(3,'Orange',0,1,'Grocery Store','Orange',3),(4,'Strawberry',0,1,'Supermarket','Red',4),(5,'Grapes',0,1,'Imported','Purple',5),(6,'Pineapple',0,1,'Supermarket','Yellow',6),(7,'Mango',0,1,'Farmer\'s Market','Yellow',7),(8,'Peach',0,1,'Supermarket','Yellow',8),(9,'Blueberry',0,1,'Supermarket','Blue',9),(10,'Avocado',0,1,'Farmer\'s Market','Green',10),(11,'Pear',0,1,'Grocery Store','Green',11),(12,'Plum',0,1,'Supermarket','Purple',12),(13,'Watermelon',0,1,'Supermarket','Green',1),(14,'Lemon',0,1,'Grocery Store','Yellow',2),(15,'Apple',0,1,'Farmer\'s Market','Green',3),(16,'Kiwi',0,1,'Supermarket','Brown',4),(17,'Papaya',0,1,'Imported','Orange',5),(18,'Cantaloupe',0,1,'Supermarket','Orange',6),(19,'Cherries',0,1,'Farmer\'s Market','Red',7),(20,'Tangerine',0,1,'Supermarket','Orange',8);
/*!40000 ALTER TABLE `fruits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meats`
--

DROP TABLE IF EXISTS `meats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `is_rotten` tinyint DEFAULT NULL,
  `acquired_from` varchar(45) DEFAULT NULL,
  `halal` varchar(45) DEFAULT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`id`,`category_id`),
  KEY `fk_Meats_category_idx` (`category_id`),
  CONSTRAINT `fk_Meats_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meats`
--

LOCK TABLES `meats` WRITE;
/*!40000 ALTER TABLE `meats` DISABLE KEYS */;
INSERT INTO `meats` VALUES (1,'Chicken',0,'Supermarket','Halal',1),(2,'Beef',0,'Butcher','Non-Halal',2),(3,'Lamb',0,'Farmer\'s Market','Halal',3),(4,'Pork',1,'Supermarket','Non-Halal',4),(5,'Turkey',0,'Grocery Store','Halal',5),(6,'Fish',0,'Supermarket','Halal',6),(7,'Duck',0,'Butcher','Non-Halal',7),(8,'Veal',0,'Farmer\'s Market','Non-Halal',8),(9,'Rabbit',0,'Supermarket','Non-Halal',9),(10,'Goat',0,'Farmer\'s Market','Halal',10),(11,'Bacon',1,'Supermarket','Non-Halal',11),(12,'Ham',1,'Supermarket','Non-Halal',12),(13,'Chicken Wings',0,'Grocery Store','Halal',1),(14,'Beef Jerky',0,'Grocery Store','Non-Halal',2),(15,'Sausages',0,'Supermarket','Non-Halal',3),(16,'Salmon',0,'Imported','Halal',4),(17,'Mutton',0,'Butcher','Non-Halal',5),(18,'Tuna',0,'Supermarket','Halal',6),(19,'Lobster',1,'Grocery Store','Non-Halal',7);
/*!40000 ALTER TABLE `meats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vegetables`
--

DROP TABLE IF EXISTS `vegetables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vegetables` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `is_rotten` tinyint DEFAULT NULL,
  `acquired_from` varchar(45) DEFAULT NULL,
  `color` varchar(45) DEFAULT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`id`,`category_id`),
  KEY `fk_Vegetables_category1_idx` (`category_id`),
  CONSTRAINT `fk_Vegetables_category1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vegetables`
--

LOCK TABLES `vegetables` WRITE;
/*!40000 ALTER TABLE `vegetables` DISABLE KEYS */;
INSERT INTO `vegetables` VALUES (1,'Carrot',0,'Supermarket','Orange',1),(2,'Spinach',0,'Farmer\'s Market','Green',2),(3,'Potato',0,'Supermarket','Brown',3),(4,'Broccoli',0,'Grocery Store','Green',4),(5,'Tomato',0,'Supermarket','Red',5),(6,'Cucumber',0,'Farmer\'s Market','Green',6),(7,'Bell Pepper',0,'Supermarket','Green',7),(8,'Lettuce',0,'Grocery Store','Green',8),(9,'Cauliflower',0,'Supermarket','White',9),(10,'Onion',0,'Farmer\'s Market','Yellow',10),(11,'Garlic',0,'Grocery Store','White',11),(12,'Asparagus',0,'Supermarket','Green',12),(13,'Beetroot',0,'Supermarket','Red',1),(14,'Zucchini',0,'Farmer\'s Market','Green',2),(15,'Eggplant',0,'Grocery Store','Purple',3),(16,'Sweet Potato',0,'Supermarket','Orange',4),(17,'Kale',0,'Supermarket','Green',5),(18,'Brussels Sprouts',0,'Farmer\'s Market','Green',6),(19,'Peas',0,'Supermarket','Green',7);
/*!40000 ALTER TABLE `vegetables` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-23 14:21:11
