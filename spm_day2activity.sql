-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 19, 2026 at 06:43 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `spm_day2activity`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `AccountID` int(11) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `HashedPassword` varchar(255) NOT NULL,
  `Type` varchar(10) NOT NULL DEFAULT 'Officer' CHECK (`Type` in ('Admin','Officer')),
  `Status` varchar(10) DEFAULT 'Enabled' CHECK (`Status` in ('Enabled','Disabled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`AccountID`, `Email`, `Username`, `HashedPassword`, `Type`, `Status`) VALUES
(1, 'user@user.com', 'user', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'Officer', 'Enabled'),
(2, 'admin@admin.com', 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Admin', 'Enabled'),
(3, 'user2@user.com', 'user2', '6025d18fe48abd45168528f18a82e265dd98d421a7084aa09f61b341703901a3', 'Officer', 'Enabled'),
(4, 'user3@user.com', 'user3', 'a28797cfda99eea7d27189343a75350fe5956dd0fd02e86bbb362a2ea5dc9d7d', 'Officer', 'Disabled');

-- --------------------------------------------------------

--
-- Table structure for table `activitylog`
--

CREATE TABLE `activitylog` (
  `ActivityID` int(11) NOT NULL,
  `TargetTable` varchar(50) NOT NULL,
  `TargetID` int(11) NOT NULL,
  `ActorAccountID` int(11) NOT NULL,
  `ActorType` varchar(10) NOT NULL,
  `ActivityType` varchar(10) NOT NULL,
  `ActivityTime` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activitylog`
--

INSERT INTO `activitylog` (`ActivityID`, `TargetTable`, `TargetID`, `ActorAccountID`, `ActorType`, `ActivityType`, `ActivityTime`) VALUES
(1, 'BarangayCensus', 1, 3, 'Officer', 'Update', '2026-02-19 08:38:55'),
(2, 'BarangayCensus', 102, 1, 'Officer', 'Create', '2026-02-19 08:41:37'),
(3, 'BarangayCensus', 102, 3, 'Officer', 'Disable', '2026-02-19 08:56:28'),
(4, 'Accounts', 4, 2, 'Admin', 'Create', '2026-02-19 09:14:49'),
(5, 'Accounts', 4, 2, 'Admin', 'Disable', '2026-02-19 09:15:25'),
(6, 'BarangayCensus', 25, 1, 'Officer', 'Update', '2026-02-19 10:33:55'),
(7, 'BarangayCensus', 25, 1, 'Officer', 'Update', '2026-02-19 10:34:09'),
(8, 'BarangayCensus', 25, 1, 'Officer', 'Update', '2026-02-19 11:57:14');

-- --------------------------------------------------------

--
-- Table structure for table `barangaycensus`
--

CREATE TABLE `barangaycensus` (
  `ID` int(11) NOT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `FirstName` varchar(50) DEFAULT NULL,
  `MiddleName` varchar(50) DEFAULT NULL,
  `Age` int(11) DEFAULT NULL,
  `Sex` char(1) DEFAULT NULL,
  `DateOfBirth` date DEFAULT NULL,
  `CivilStatus` varchar(20) DEFAULT NULL,
  `HouseNo` varchar(20) DEFAULT NULL,
  `StreetPurok` varchar(100) DEFAULT NULL,
  `BarangayAddress` varchar(50) DEFAULT NULL,
  `RoleInHH` varchar(30) DEFAULT NULL,
  `Education` varchar(50) DEFAULT NULL,
  `Occupation` varchar(50) DEFAULT NULL,
  `IPStatus` varchar(30) DEFAULT NULL,
  `PWD` varchar(30) DEFAULT NULL,
  `Beneficiary4Ps` varchar(5) DEFAULT NULL,
  `RegisteredVoter` varchar(5) DEFAULT NULL,
  `MonthlyIncome` decimal(10,2) DEFAULT NULL,
  `Status` varchar(10) DEFAULT 'Enabled' CHECK (`Status` in ('Enabled','Disabled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `barangaycensus`
--

INSERT INTO `barangaycensus` (`ID`, `LastName`, `FirstName`, `MiddleName`, `Age`, `Sex`, `DateOfBirth`, `CivilStatus`, `HouseNo`, `StreetPurok`, `BarangayAddress`, `RoleInHH`, `Education`, `Occupation`, `IPStatus`, `PWD`, `Beneficiary4Ps`, `RegisteredVoter`, `MonthlyIncome`, `Status`) VALUES
(1, 'Dela Cruz', 'Juan', 'Santos', 45, 'M', '0000-00-00', 'Married', '101', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Head', 'College Grad', 'Tricycle Driver', 'No', 'No', 'Yes', 'Yes', 12001.00, 'Enabled'),
(2, 'Dela Cruz', 'Maria', 'Reyes', 42, 'F', '1982-08-20', 'Married', '101', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Spouse', 'High School', 'Housewife', 'No', 'No', 'Yes', 'Yes', 0.00, 'Enabled'),
(3, 'Dela Cruz', 'Joshua', 'Reyes', 19, 'M', '2005-11-03', 'Single', '101', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Son', 'Undergrad', 'Service Crew', 'No', 'No', 'Yes', 'Yes', 8000.00, 'Enabled'),
(4, 'Dela Cruz', 'Angel', 'Reyes', 8, 'F', '2016-02-14', 'Single', '101', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Daughter', 'Elem Student', 'Student', 'No', 'No', 'Yes', 'No', 0.00, 'Enabled'),
(5, 'Bontoc', 'Jose', 'Ibaloi', 68, 'M', '1956-01-30', 'Widower', '102', 'Sitio Kawayan', 'Brgy. San Isidro', 'Head', 'Elementary', 'Pensioner', 'Yes (Igorot)', 'No', 'No', 'Yes', 6000.00, 'Enabled'),
(6, 'Reyes', 'Ana', 'Cruz', 28, 'F', '1996-09-15', 'Single', '103', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Head', 'College Grad', 'Call Center Agent', 'No', 'No', 'No', 'Yes', 25000.00, 'Enabled'),
(7, 'Santos', 'Pedro', 'Dizon', 35, 'M', '1989-03-22', 'Married', '104', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Head', 'Vocational', 'Construction Worker', 'No', 'Yes (Mobility)', 'No', 'Yes', 15000.00, 'Enabled'),
(8, 'Santos', 'Elena', 'Gomez', 33, 'F', '1991-07-08', 'Married', '104', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Spouse', 'High School', 'Sari-sari Store Owner', 'No', 'No', 'No', 'Yes', 5000.00, 'Enabled'),
(9, 'Santos', 'Kyle', 'Gomez', 10, 'M', '2014-01-15', 'Single', '104', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Son', 'Elem Student', 'Student', 'No', 'No', 'No', 'No', 0.00, 'Enabled'),
(10, 'Lim', 'Kevin', 'Tan', 22, 'M', '2002-12-01', 'Single', '105', 'Subd. Maharlika', 'Brgy. San Isidro', 'Boarder', 'College Grad', 'Accountant', 'No', 'No', 'No', 'No', 30000.00, 'Enabled'),
(11, 'Mangubat', 'Roberto', 'S.', 55, 'M', '1969-06-10', 'Separated', '106', 'Purok 4 Narra', 'Brgy. San Isidro', 'Head', 'High School', 'Barangay Tanod', 'No', 'No', 'No', 'Yes', 4000.00, 'Enabled'),
(12, 'Garcia', 'Ricardo', 'M.', 50, 'M', '1974-04-12', 'Married', '107', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Head', 'High School', 'Jeepney Driver', 'No', 'No', 'Yes', 'Yes', 14000.00, 'Enabled'),
(13, 'Garcia', 'Lorna', 'P.', 48, 'F', '1976-09-23', 'Married', '107', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Spouse', 'High School', 'Housewife', 'No', 'No', 'Yes', 'Yes', 0.00, 'Enabled'),
(14, 'Garcia', 'Rica', 'P.', 21, 'F', '2003-02-14', 'Single', '107', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Daughter', 'College Grad', 'Unemployed', 'No', 'No', 'Yes', 'Yes', 0.00, 'Enabled'),
(15, 'Garcia', 'Ricky', 'P.', 18, 'M', '2006-05-30', 'Single', '107', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Son', 'High School', 'Student', 'No', 'No', 'Yes', 'Yes', 0.00, 'Enabled'),
(16, 'Mendoza', 'Lito', 'B.', 62, 'M', '1962-11-05', 'Married', '108', 'Sitio Kawayan', 'Brgy. San Isidro', 'Head', 'Elementary', 'Farmer', 'No', 'No', 'Yes', 'Yes', 8000.00, 'Enabled'),
(17, 'Mendoza', 'Susan', 'C.', 60, 'F', '1964-08-19', 'Married', '108', 'Sitio Kawayan', 'Brgy. San Isidro', 'Spouse', 'Elementary', 'Housewife', 'No', 'No', 'Yes', 'Yes', 0.00, 'Enabled'),
(18, 'Bautista', 'Mark', 'L.', 30, 'M', '1994-01-12', 'Single', '109', 'Subd. Maharlika', 'Brgy. San Isidro', 'Head', 'College Grad', 'Nurse', 'No', 'No', 'No', 'Yes', 35000.00, 'Enabled'),
(19, 'Ocampo', 'Jasmine', 'T.', 29, 'F', '1995-03-14', 'Single', '109', 'Subd. Maharlika', 'Brgy. San Isidro', 'Live-in Partner', 'College Grad', 'Teacher', 'No', 'No', 'No', 'Yes', 28000.00, 'Enabled'),
(20, 'Yap', 'Chin', 'L.', 40, 'F', '1984-06-22', 'Widow', '110', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Head', 'College Grad', 'Online Seller', 'No', 'No', 'No', 'Yes', 20000.00, 'Enabled'),
(21, 'Yap', 'Timothy', 'L.', 15, 'M', '2009-02-10', 'Single', '110', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Son', 'High School', 'Student', 'No', 'No', 'No', 'No', 0.00, 'Enabled'),
(22, 'Villanueva', 'Eddie', 'J.', 58, 'M', '1966-12-05', 'Married', '111', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Head', 'Vocational', 'Electrician', 'No', 'No', 'No', 'Yes', 18000.00, 'Enabled'),
(23, 'Villanueva', 'Tess', 'K.', 55, 'F', '1969-07-20', 'Married', '111', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Spouse', 'High School', 'Housewife', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(24, 'Castro', 'Jun', 'P.', 25, 'M', '1999-05-05', 'Single', '112', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Head', 'College Grad', 'IT Specialist', 'No', 'No', 'No', 'Yes', 45000.00, 'Enabled'),
(25, 'Gonzales', 'Mario', 'D.', 47, 'M', '0000-00-00', 'Married', '113', 'Purok 4 Narra', 'Brgy. San Isidro', 'Others', 'High School', 'Others', 'No', 'No', 'No', 'No', 16000.00, 'Enabled'),
(26, 'Gonzales', 'Belen', 'F.', 45, 'F', '1979-02-14', 'Married', '113', 'Purok 4 Narra', 'Brgy. San Isidro', 'Spouse', 'High School', 'Factory Worker', 'No', 'No', 'No', 'Yes', 12000.00, 'Enabled'),
(27, 'Gonzales', 'Bea', 'F.', 12, 'F', '2012-08-30', 'Single', '113', 'Purok 4 Narra', 'Brgy. San Isidro', 'Daughter', 'Elem Student', 'Student', 'No', 'No', 'No', 'No', 0.00, 'Enabled'),
(28, 'Ramos', 'Fely', 'Q.', 72, 'F', '1952-01-01', 'Widow', '114', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Head', 'Elementary', 'Pensioner', 'No', 'Yes (Visual)', 'Yes', 'Yes', 5000.00, 'Enabled'),
(29, 'Ramos', 'Danilo', 'Q.', 45, 'M', '1979-06-15', 'Single', '114', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Son', 'High School', 'Carpenter', 'No', 'No', 'Yes', 'Yes', 10000.00, 'Enabled'),
(30, 'Salazar', 'Vic', 'H.', 38, 'M', '1986-09-09', 'Married', '115', 'Sitio Kawayan', 'Brgy. San Isidro', 'Head', 'High School', 'Fisherman', 'No', 'No', 'Yes', 'Yes', 7000.00, 'Enabled'),
(31, 'Salazar', 'Gina', 'M.', 36, 'F', '1988-12-05', 'Married', '115', 'Sitio Kawayan', 'Brgy. San Isidro', 'Spouse', 'High School', 'Fish Vendor', 'No', 'No', 'Yes', 'Yes', 4000.00, 'Enabled'),
(32, 'Salazar', 'Boyet', 'M.', 8, 'M', '2016-04-02', 'Single', '115', 'Sitio Kawayan', 'Brgy. San Isidro', 'Son', 'Elem Student', 'Student', 'No', 'No', 'Yes', 'No', 0.00, 'Enabled'),
(33, 'Domingo', 'Carlo', 'R.', 31, 'M', '1993-05-20', 'Single', '116', 'Subd. Maharlika', 'Brgy. San Isidro', 'Head', 'College Grad', 'Bank Teller', 'No', 'No', 'No', 'Yes', 22000.00, 'Enabled'),
(34, 'Pascual', 'Lando', 'E.', 65, 'M', '1959-03-15', 'Married', '117', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Head', 'High School', 'Retired Driver', 'No', 'No', 'No', 'Yes', 5000.00, 'Enabled'),
(35, 'Pascual', 'Minda', 'T.', 63, 'F', '1961-07-08', 'Married', '117', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Spouse', 'Elementary', 'Housewife', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(36, 'Flores', 'Rosa', 'Y.', 50, 'F', '1974-11-22', 'Separated', '118', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Head', 'High School', 'Domestic Helper', 'No', 'No', 'No', 'Yes', 8000.00, 'Enabled'),
(37, 'Flores', 'Jen', 'Y.', 17, 'F', '2007-01-10', 'Single', '118', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Daughter', 'High School', 'Student', 'No', 'No', 'No', 'No', 0.00, 'Enabled'),
(38, 'Aquino', 'Ben', 'G.', 29, 'M', '1995-04-18', 'Married', '119', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Head', 'College Grad', 'Police Officer', 'No', 'No', 'No', 'Yes', 35000.00, 'Enabled'),
(39, 'Aquino', 'Sarah', 'J.', 27, 'F', '1997-09-05', 'Married', '119', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Spouse', 'College Grad', 'Nurse', 'No', 'No', 'No', 'Yes', 30000.00, 'Enabled'),
(40, 'Aquino', 'Baby', 'J.', 2, 'F', '2022-02-14', 'Single', '119', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Daughter', 'None', 'None', 'No', 'No', 'No', 'No', 0.00, 'Enabled'),
(41, 'Navarro', 'Alex', 'P.', 41, 'M', '1983-08-30', 'Married', '120', 'Purok 4 Narra', 'Brgy. San Isidro', 'Head', 'Vocational', 'Mechanic', 'No', 'No', 'No', 'Yes', 15000.00, 'Enabled'),
(42, 'Navarro', 'Cathy', 'L.', 39, 'F', '1985-12-12', 'Married', '120', 'Purok 4 Narra', 'Brgy. San Isidro', 'Spouse', 'High School', 'Manicurist', 'No', 'No', 'No', 'Yes', 6000.00, 'Enabled'),
(43, 'Cortez', 'Romy', 'S.', 54, 'M', '1970-03-25', 'Widower', '121', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Head', 'Elementary', 'Laborer', 'No', 'No', 'Yes', 'Yes', 9000.00, 'Enabled'),
(44, 'Cortez', 'Toto', 'S.', 20, 'M', '2004-10-10', 'Single', '121', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Son', 'High School', 'Construction Helper', 'No', 'No', 'Yes', 'Yes', 7000.00, 'Enabled'),
(45, 'Valdez', 'Grace', 'M.', 26, 'F', '1998-05-15', 'Single', '122', 'Subd. Maharlika', 'Brgy. San Isidro', 'Head', 'College Grad', 'Virtual Assistant', 'No', 'No', 'No', 'Yes', 35000.00, 'Enabled'),
(46, 'Santiago', 'Manuel', 'K.', 60, 'M', '1964-07-01', 'Married', '123', 'Sitio Kawayan', 'Brgy. San Isidro', 'Head', 'Elementary', 'Farmer', 'No', 'No', 'Yes', 'Yes', 6000.00, 'Enabled'),
(47, 'Santiago', 'Lita', 'O.', 58, 'F', '1966-02-28', 'Married', '123', 'Sitio Kawayan', 'Brgy. San Isidro', 'Spouse', 'Elementary', 'Housewife', 'No', 'No', 'Yes', 'Yes', 0.00, 'Enabled'),
(48, 'Santiago', 'Nene', 'O.', 16, 'F', '2008-09-15', 'Single', '123', 'Sitio Kawayan', 'Brgy. San Isidro', 'Daughter', 'High School', 'Student', 'No', 'Yes (Psychosocial)', 'Yes', 'No', 0.00, 'Enabled'),
(49, 'Mercado', 'Dante', 'R.', 33, 'M', '1991-06-20', 'Married', '124', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Head', 'High School', 'Delivery Rider', 'No', 'No', 'No', 'Yes', 18000.00, 'Enabled'),
(50, 'Mercado', 'Joy', 'S.', 30, 'F', '1994-11-11', 'Married', '124', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Spouse', 'College Grad', 'Admin Assistant', 'No', 'No', 'No', 'Yes', 16000.00, 'Enabled'),
(51, 'Delos Santos', 'Pepe', 'A.', 70, 'M', '1954-04-05', 'Married', '125', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Head', 'Elementary', 'Pensioner', 'No', 'No', 'Yes', 'Yes', 5000.00, 'Enabled'),
(52, 'Delos Santos', 'Maria', 'C.', 68, 'F', '1956-08-22', 'Married', '125', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Spouse', 'Elementary', 'Pensioner', 'No', 'No', 'Yes', 'Yes', 5000.00, 'Enabled'),
(53, 'Ferrer', 'Allan', 'T.', 24, 'M', '2000-01-30', 'Single', '126', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Head', 'College Grad', 'Civil Engineer', 'No', 'No', 'No', 'Yes', 30000.00, 'Enabled'),
(54, 'Bautista', 'Cely', 'G.', 49, 'F', '1975-03-15', 'Single', '127', 'Purok 4 Narra', 'Brgy. San Isidro', 'Head', 'High School', 'Laundrywoman', 'No', 'No', 'Yes', 'Yes', 7000.00, 'Enabled'),
(55, 'Cruz', 'Tony', 'H.', 44, 'M', '1980-05-10', 'Married', '128', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Head', 'High School', 'Painter', 'No', 'No', 'No', 'Yes', 12000.00, 'Enabled'),
(56, 'Cruz', 'Mela', 'J.', 40, 'F', '1984-09-08', 'Married', '128', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Spouse', 'High School', 'Housewife', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(57, 'Cruz', 'Junior', 'J.', 14, 'M', '2010-12-25', 'Single', '128', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Son', 'High School', 'Student', 'No', 'No', 'No', 'No', 0.00, 'Enabled'),
(58, 'Magno', 'Efren', 'L.', 56, 'M', '1968-02-18', 'Separated', '129', 'Sitio Kawayan', 'Brgy. San Isidro', 'Head', 'Elementary', 'Mason', 'No', 'No', 'No', 'Yes', 10000.00, 'Enabled'),
(59, 'Roque', 'Sheryl', 'P.', 32, 'F', '1992-06-30', 'Single', '130', 'Subd. Maharlika', 'Brgy. San Isidro', 'Head', 'College Grad', 'HR Manager', 'No', 'No', 'No', 'Yes', 40000.00, 'Enabled'),
(60, 'Padilla', 'Robin', 'S.', 37, 'M', '1987-11-20', 'Married', '131', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Head', 'High School', 'Tricycle Driver', 'No', 'No', 'No', 'Yes', 11000.00, 'Enabled'),
(61, 'Padilla', 'Mariel', 'T.', 34, 'F', '1990-04-15', 'Married', '131', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Spouse', 'High School', 'Online Seller', 'No', 'No', 'No', 'Yes', 8000.00, 'Enabled'),
(62, 'De Guzman', 'Larry', 'V.', 66, 'M', '1958-08-08', 'Widower', '132', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Head', 'College Grad', 'Retired Teacher', 'No', 'No', 'No', 'Yes', 25000.00, 'Enabled'),
(63, 'De Guzman', 'Fe', 'V.', 28, 'F', '1996-01-05', 'Single', '132', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Daughter', 'College Grad', 'Nurse (Unemployed)', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(64, 'Sison', 'George', 'K.', 51, 'M', '1973-05-12', 'Married', '133', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Head', 'Vocational', 'Welder', 'No', 'No', 'No', 'Yes', 15000.00, 'Enabled'),
(65, 'Sison', 'Alma', 'L.', 48, 'F', '1976-10-20', 'Married', '133', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Spouse', 'High School', 'Housewife', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(66, 'Sison', 'Gio', 'L.', 18, 'M', '2006-03-30', 'Single', '133', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Son', 'High School', 'Student', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(67, 'Tolentino', 'Francis', 'M.', 42, 'M', '1982-09-09', 'Married', '134', 'Purok 4 Narra', 'Brgy. San Isidro', 'Head', 'High School', 'Vendor', 'No', 'No', 'Yes', 'Yes', 8000.00, 'Enabled'),
(68, 'Tolentino', 'Carla', 'N.', 38, 'F', '1986-12-12', 'Married', '134', 'Purok 4 Narra', 'Brgy. San Isidro', 'Spouse', 'High School', 'Vendor', 'No', 'No', 'Yes', 'Yes', 8000.00, 'Enabled'),
(69, 'Tolentino', 'Bea', 'N.', 5, 'F', '2019-07-01', 'Single', '134', 'Purok 4 Narra', 'Brgy. San Isidro', 'Daughter', 'None', 'None', 'No', 'No', 'Yes', 'No', 0.00, 'Enabled'),
(70, 'Pineda', 'Chito', 'R.', 23, 'M', '2001-02-14', 'Single', '135', 'Subd. Maharlika', 'Brgy. San Isidro', 'Boarder', 'College Grad', 'Graphic Designer', 'No', 'No', 'No', 'Yes', 25000.00, 'Enabled'),
(71, 'Arellano', 'Drew', 'B.', 39, 'M', '1985-05-05', 'Married', '136', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Head', 'College Grad', 'Business Owner', 'No', 'No', 'No', 'Yes', 50000.00, 'Enabled'),
(72, 'Arellano', 'Iya', 'V.', 36, 'F', '1988-08-08', 'Married', '136', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Spouse', 'College Grad', 'Co-Owner', 'No', 'No', 'No', 'Yes', 50000.00, 'Enabled'),
(73, 'Estrada', 'Joseph', 'E.', 75, 'M', '1949-04-19', 'Widower', '137', 'Sitio Kawayan', 'Brgy. San Isidro', 'Head', 'Elementary', 'Pensioner', 'No', 'Yes (Hearing)', 'Yes', 'Yes', 5000.00, 'Enabled'),
(74, 'Revilla', 'Bong', 'J.', 52, 'M', '1972-09-25', 'Married', '138', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Head', 'High School', 'Barangay Kagawad', 'No', 'No', 'No', 'Yes', 18000.00, 'Enabled'),
(75, 'Revilla', 'Lani', 'M.', 50, 'F', '1974-06-15', 'Married', '138', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Spouse', 'High School', 'Housewife', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(76, 'Revilla', 'Jolo', 'M.', 22, 'M', '2002-03-15', 'Single', '138', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Son', 'College Grad', 'Unemployed', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(77, 'Cayetano', 'Alan', 'P.', 46, 'M', '1978-10-28', 'Married', '139', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Head', 'College Grad', 'Lawyer', 'No', 'No', 'No', 'Yes', 80000.00, 'Enabled'),
(78, 'Cayetano', 'Pia', 'S.', 44, 'F', '1980-05-05', 'Married', '139', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Spouse', 'College Grad', 'Consultant', 'No', 'No', 'No', 'Yes', 60000.00, 'Enabled'),
(79, 'Villar', 'Mark', 'A.', 34, 'M', '1990-08-14', 'Single', '140', 'Subd. Maharlika', 'Brgy. San Isidro', 'Head', 'College Grad', 'Engineer', 'No', 'No', 'No', 'Yes', 45000.00, 'Enabled'),
(80, 'Go', 'Bong', 'T.', 48, 'M', '1976-06-15', 'Single', '141', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Head', 'High School', 'Driver', 'No', 'No', 'No', 'Yes', 13000.00, 'Enabled'),
(81, 'Duterte', 'Sara', 'Z.', 44, 'F', '1980-05-31', 'Separated', '142', 'Purok 4 Narra', 'Brgy. San Isidro', 'Head', 'College Grad', 'Teacher', 'No', 'No', 'No', 'Yes', 28000.00, 'Enabled'),
(82, 'Duterte', 'Baste', 'Z.', 15, 'M', '2009-02-01', 'Single', '142', 'Purok 4 Narra', 'Brgy. San Isidro', 'Son', 'High School', 'Student', 'No', 'No', 'No', 'No', 0.00, 'Enabled'),
(83, 'Marcos', 'Bong', 'R.', 60, 'M', '1964-09-13', 'Married', '143', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Head', 'College Grad', 'Architect', 'No', 'No', 'No', 'Yes', 55000.00, 'Enabled'),
(84, 'Marcos', 'Liza', 'A.', 58, 'F', '1966-08-21', 'Married', '143', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Spouse', 'College Grad', 'Lawyer', 'No', 'No', 'No', 'Yes', 65000.00, 'Enabled'),
(85, 'Robredo', 'Leni', 'G.', 56, 'F', '1968-04-23', 'Widow', '144', 'Sitio Kawayan', 'Brgy. San Isidro', 'Head', 'College Grad', 'NGO Worker', 'No', 'No', 'No', 'Yes', 30000.00, 'Enabled'),
(86, 'Robredo', 'Aika', 'G.', 28, 'F', '1996-01-15', 'Single', '144', 'Sitio Kawayan', 'Brgy. San Isidro', 'Daughter', 'College Grad', 'Researcher', 'No', 'No', 'No', 'Yes', 25000.00, 'Enabled'),
(87, 'Moreno', 'Isko', 'D.', 47, 'M', '1977-10-24', 'Married', '145', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Head', 'High School', 'Garbage Collector', 'No', 'No', 'Yes', 'Yes', 8000.00, 'Enabled'),
(88, 'Moreno', 'Dynee', 'D.', 45, 'F', '1979-05-18', 'Married', '145', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Spouse', 'High School', 'Street Sweeper', 'No', 'No', 'Yes', 'Yes', 6000.00, 'Enabled'),
(89, 'Pacquiao', 'Manny', 'D.', 45, 'M', '1978-12-17', 'Married', '146', 'Subd. Maharlika', 'Brgy. San Isidro', 'Head', 'Vocational', 'Baker', 'No', 'No', 'No', 'Yes', 15000.00, 'Enabled'),
(90, 'Pacquiao', 'Jinkee', 'J.', 44, 'F', '1980-01-12', 'Married', '146', 'Subd. Maharlika', 'Brgy. San Isidro', 'Spouse', 'High School', 'Housewife', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(91, 'Lacson', 'Ping', 'M.', 71, 'M', '1953-06-01', 'Married', '147', 'Purok 2 Gumamela', 'Brgy. San Isidro', 'Head', 'College Grad', 'Retired Police', 'No', 'No', 'No', 'Yes', 35000.00, 'Enabled'),
(92, 'Sotto', 'Tito', 'V.', 74, 'M', '1950-02-14', 'Married', '148', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Head', 'High School', 'Musician', 'No', 'No', 'No', 'Yes', 15000.00, 'Enabled'),
(93, 'Sotto', 'Helen', 'G.', 70, 'F', '1954-05-20', 'Married', '148', 'Purok 3 Ilang-ilang', 'Brgy. San Isidro', 'Spouse', 'High School', 'Housewife', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(94, 'Poe', 'Grace', 'S.', 50, 'F', '1974-09-03', 'Married', '149', 'Purok 4 Narra', 'Brgy. San Isidro', 'Head', 'College Grad', 'Teacher', 'No', 'No', 'No', 'Yes', 28000.00, 'Enabled'),
(95, 'Escudero', 'Chiz', 'L.', 52, 'M', '1972-10-10', 'Married', '150', 'Subd. Maharlika', 'Brgy. San Isidro', 'Head', 'College Grad', 'Lawyer', 'No', 'No', 'No', 'Yes', 90000.00, 'Enabled'),
(96, 'Escudero', 'Heart', 'O.', 38, 'F', '1986-02-14', 'Married', '150', 'Subd. Maharlika', 'Brgy. San Isidro', 'Spouse', 'College Grad', 'Artist', 'No', 'No', 'No', 'Yes', 50000.00, 'Enabled'),
(97, 'Binay', 'Jojo', 'T.', 78, 'M', '1946-11-11', 'Widower', '151', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Head', 'College Grad', 'Lawyer', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(98, 'Binay', 'Nancy', 'S.', 48, 'F', '1976-05-12', 'Single', '151', 'Purok 1 Acacia', 'Brgy. San Isidro', 'Daughter', 'College Grad', 'Accountant', 'No', 'No', 'No', 'Yes', 35000.00, 'Enabled'),
(99, 'Gordon', 'Dick', 'J.', 76, 'M', '1948-08-05', 'Married', '152', 'Sitio Kawayan', 'Brgy. San Isidro', 'Head', 'College Grad', 'Volunteer Worker', 'No', 'No', 'No', 'Yes', 0.00, 'Enabled'),
(100, 'Zubiri', 'Migz', 'F.', 53, 'M', '1971-04-13', 'Married', '153', 'Purok 5 Orchids', 'Brgy. San Isidro', 'Head', 'College Grad', 'Businessman', 'No', 'No', 'No', 'Yes', 100000.00, 'Enabled'),
(101, 'Gallego', 'Kevin Christopher', 'Castor', 21, 'M', '0000-00-00', 'Single', '12366', 'Blk 1 Purok 2 Matalino St', 'Sta. Ana', 'Son', 'College Graduate', 'AI Prompt Engineer', 'No', 'No', 'No', 'Yes', 18000.00, 'disabled'),
(102, 'Delos Reyes', 'Juan', 'Mid', 9, 'M', '2004-10-10', 'Married', '101', 'Purok 2', 'San Isidro', 'Father', 'College Graduate', 'Farmer', 'No', 'No', 'No', 'Yes', 18000.00, 'disabled');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`AccountID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `Username` (`Username`);

--
-- Indexes for table `activitylog`
--
ALTER TABLE `activitylog`
  ADD PRIMARY KEY (`ActivityID`);

--
-- Indexes for table `barangaycensus`
--
ALTER TABLE `barangaycensus`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `AccountID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `activitylog`
--
ALTER TABLE `activitylog`
  MODIFY `ActivityID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
