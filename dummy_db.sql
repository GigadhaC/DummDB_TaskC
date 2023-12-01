-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2023 at 05:24 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `taskcalendar`
--

-- --------------------------------------------------------

--
-- Table structure for table `calendar`
--

CREATE TABLE `calendar` (
  `calendar_id` int(11) NOT NULL,
  `calendar_title` varchar(20) NOT NULL,
  `calendar_week` char(3) NOT NULL,
  `calendar_month` char(3) NOT NULL,
  `calendar_year` int(11) NOT NULL,
  `calendar_description` varchar(255) DEFAULT NULL,
  `user_idn` int(11) NOT NULL,
  `sharing_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reminder`
--

CREATE TABLE `reminder` (
  `reminder_id` int(11) NOT NULL,
  `reminder_type` varchar(20) NOT NULL,
  `reminder_datetime` datetime NOT NULL,
  `user_idn` int(11) NOT NULL,
  `task_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sharing`
--

CREATE TABLE `sharing` (
  `sharing_id` int(11) NOT NULL,
  `sharing_type` varchar(10) NOT NULL,
  `sharing_recipient` varchar(25) NOT NULL,
  `sharing_toggle` bit(1) NOT NULL DEFAULT b'0',
  `user_idn` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `task`
--

CREATE TABLE `task` (
  `task_id` int(11) NOT NULL,
  `task_title` varchar(20) NOT NULL,
  `task_description` varchar(255) DEFAULT NULL,
  `task_created` datetime NOT NULL DEFAULT current_timestamp(),
  `task_duedatetime` datetime NOT NULL,
  `task_reminder_settings` bit(1) NOT NULL DEFAULT b'1',
  `task_status` varchar(5) NOT NULL,
  `task_overdue` char(1) NOT NULL DEFAULT 'O',
  `user_idn` int(11) NOT NULL,
  `calendar_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

CREATE TABLE `user_info` (
  `user_idn` int(11) NOT NULL,
  `user_email` varchar(25) NOT NULL,
  `user_password` varchar(20) NOT NULL,
  `user_fname` varchar(25) NOT NULL,
  `user_lname` varchar(15) NOT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_info`
--

INSERT INTO `user_info` (`user_idn`, `user_email`, `user_password`, `user_fname`, `user_lname`, `date_created`) VALUES
(1, 'test@gwapo.com', '123', 'Admini', 'asdfasdf', '2023-11-23 23:05:48');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `calendar`
--
ALTER TABLE `calendar`
  ADD PRIMARY KEY (`calendar_id`),
  ADD KEY `fk_calendar_user_idn` (`user_idn`),
  ADD KEY `fk_calendar_sharing_id` (`sharing_id`);

--
-- Indexes for table `reminder`
--
ALTER TABLE `reminder`
  ADD PRIMARY KEY (`reminder_id`),
  ADD KEY `fk_reminder_user_idn` (`user_idn`),
  ADD KEY `fk_reminder_task_id` (`task_id`);

--
-- Indexes for table `sharing`
--
ALTER TABLE `sharing`
  ADD PRIMARY KEY (`sharing_id`),
  ADD KEY `fk_sharing_user_idn` (`user_idn`);

--
-- Indexes for table `task`
--
ALTER TABLE `task`
  ADD PRIMARY KEY (`task_id`),
  ADD KEY `fk_task_user_idn` (`user_idn`),
  ADD KEY `fk_task_calendar_id` (`calendar_id`);

--
-- Indexes for table `user_info`
--
ALTER TABLE `user_info`
  ADD PRIMARY KEY (`user_idn`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `calendar`
--
ALTER TABLE `calendar`
  MODIFY `calendar_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reminder`
--
ALTER TABLE `reminder`
  MODIFY `reminder_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sharing`
--
ALTER TABLE `sharing`
  MODIFY `sharing_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `task`
--
ALTER TABLE `task`
  MODIFY `task_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_info`
--
ALTER TABLE `user_info`
  MODIFY `user_idn` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `calendar`
--
ALTER TABLE `calendar`
  ADD CONSTRAINT `fk_calendar_sharing_id` FOREIGN KEY (`sharing_id`) REFERENCES `sharing` (`sharing_id`),
  ADD CONSTRAINT `fk_calendar_user_idn` FOREIGN KEY (`user_idn`) REFERENCES `user_info` (`user_idn`);

--
-- Constraints for table `reminder`
--
ALTER TABLE `reminder`
  ADD CONSTRAINT `fk_reminder_task_id` FOREIGN KEY (`task_id`) REFERENCES `task` (`task_id`),
  ADD CONSTRAINT `fk_reminder_user_idn` FOREIGN KEY (`user_idn`) REFERENCES `user_info` (`user_idn`);

--
-- Constraints for table `sharing`
--
ALTER TABLE `sharing`
  ADD CONSTRAINT `fk_sharing_user_idn` FOREIGN KEY (`user_idn`) REFERENCES `user_info` (`user_idn`);

--
-- Constraints for table `task`
--
ALTER TABLE `task`
  ADD CONSTRAINT `fk_task_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `calendar` (`calendar_id`),
  ADD CONSTRAINT `fk_task_user_idn` FOREIGN KEY (`user_idn`) REFERENCES `user_info` (`user_idn`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
