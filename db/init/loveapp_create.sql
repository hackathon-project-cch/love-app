-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
-- Host: 127.0.0.1    Database: loveapp
-- Server version 8.0.42

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

-- Table structure for table `FaceShapes`
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
USE loveapp;
CREATE TABLE IF NOT EXISTS `FaceShapes` (
  `face_shape_id` varchar(36) NOT NULL,
  `face_shape_name` varchar(50) NOT NULL,
  PRIMARY KEY (`face_shape_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Dumping data for table `FaceShapes`
LOCK TABLES `FaceShapes` WRITE;
/*!40000 ALTER TABLE `FaceShapes` DISABLE KEYS */;
/*!40000 ALTER TABLE `FaceShapes` ENABLE KEYS */;
UNLOCK TABLES;

-- Table structure for table `Hairstyles`
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `Hairstyles` (
  `hairstyle_id` varchar(36) NOT NULL,
  `hairstyle_name` varchar(100) NOT NULL,
  `hair_image_path` varchar(255) NOT NULL,
  PRIMARY KEY (`hairstyle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Dumping data for table `Hairstyles`
LOCK TABLES `Hairstyles` WRITE;
/*!40000 ALTER TABLE `Hairstyles` DISABLE KEYS */;
/*!40000 ALTER TABLE `Hairstyles` ENABLE KEYS */;
UNLOCK TABLES;

-- Table structure for table `FaceShape_Hairstyle`
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `FaceShape_Hairstyle` (
  `link_id` varchar(36) NOT NULL,
  `face_shape_id` varchar(36) NOT NULL,
  `hairstyle_id` varchar(36) NOT NULL,
  PRIMARY KEY (`link_id`),
  UNIQUE KEY `uq_FSH` (`face_shape_id`, `hairstyle_id`),
  KEY `idx_face_shape` (`face_shape_id`),
  KEY `idx_hairstyle` (`hairstyle_id`),
  CONSTRAINT `fk_FSH_faceShape` FOREIGN KEY (`face_shape_id`) REFERENCES `FaceShapes` (`face_shape_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_FSH_hairstyle` FOREIGN KEY (`hairstyle_id`) REFERENCES `Hairstyles` (`hairstyle_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Dumping data for table `FaceShape_Hairstyle`
LOCK TABLES `FaceShape_Hairstyle` WRITE;
/*!40000 ALTER TABLE `FaceShape_Hairstyle` DISABLE KEYS */;
/*!40000 ALTER TABLE `FaceShape_Hairstyle` ENABLE KEYS */;
UNLOCK TABLES;

-- Table structure for table `Users`
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `Users` (
  `user_id` varchar(36) NOT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Dumping data for table `Users`
LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

-- Restore time zone and settings
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-28  0:04:58
LOCK TABLES `FaceShapes` WRITE;
/*!40000 ALTER TABLE `FaceShapes` DISABLE KEYS */;
INSERT INTO `FaceShapes` VALUES ('1','丸顔'),('2','面長'),('3','ホームベース型'),('4','卵型'),('5','逆三角形');
/*!40000 ALTER TABLE `FaceShapes` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `Hairstyles` WRITE;
/*!40000 ALTER TABLE `Hairstyles` DISABLE KEYS */;
INSERT INTO `Hairstyles` VALUES ('1','ツーブロック','/images/two_block_cut.jpg'),('10','アップバングミディアムショート','/images/up_bang_midium_cut.jpg'),('11','ウルフ','/images/wolf_cut.jpg'),('12','ハイレイヤーショート','/images/high_layered_short_cut.jpg'),('2','ソフトモヒカン','/images/soft_mohawk.jpg'),('3','マッシュ','/images/mash_cut.jpg'),('4','無造作パーマ','/images/messy_perm.jpg'),('5','ベリーショート','/images/very_short_cut.jpg'),('6','フェードカット','/images/fade_cut.jpg'),('7','ショートレイヤー','/images/short_layered_cut.jpg'),('8','アップバング','/images/up_bang_short_cut.jpg'),('9','ひし形ショート','/images/diamond_shaped_short_cut.jpg');
/*!40000 ALTER TABLE `Hairstyles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

LOCK TABLES `FaceShape_Hairstyle` WRITE;
/*!40000 ALTER TABLE `FaceShape_Hairstyle` DISABLE KEYS */;
INSERT INTO `FaceShape_Hairstyle` VALUES ('1','1','1'),('2','1','2'),('3','2','3'),('4','2','4'),('5','3','5'),('6','3','6'),('7','3','7'),('8','4','1'),('9','4','8'),('10','4','9'),('11','5','10'),('12','5','11'),('13','5','12');
/*!40000 ALTER TABLE `FaceShape_Hairstyle` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

INSERT INTO loveapp.Users (user_id, user_name, password) VALUES
('a001', 'alice', 'password123'),
('b002', 'bob', 'securepass456'),
('c003', 'charlie', 'qwerty789'),
('d004', 'david', 'litemein321'),
('e005', 'eve', 'mypassword999');