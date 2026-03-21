-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 19, 2026 at 01:06 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sha_ntieb`
--

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `recipe_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ingredients`
--

CREATE TABLE `ingredients` (
  `id` int(11) NOT NULL,
  `name_ar` varchar(255) NOT NULL,
  `name_en` varchar(255) NOT NULL,
  `category` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ingredients`
--

INSERT INTO `ingredients` (`id`, `name_ar`, `name_en`, `category`) VALUES
(17, 'سميد الكسكس', 'couscous', 'حبوب'),
(18, 'جزر', 'carrots', 'خضروات'),
(19, 'بطاطس', 'potatoes', 'خضروات'),
(20, 'لفت', 'turnip', 'خضروات'),
(21, 'كوسة', 'zucchini', 'بقوليات'),
(22, 'حمص', 'chickpeas', ''),
(23, 'فريك', 'freekeh', 'حبوب'),
(24, 'لحم', 'meat', 'لحوم'),
(25, 'طماطم', 'tomato', 'خضروات'),
(26, 'بصل', 'onion', 'خضروات'),
(27, 'كزبرة', 'coriander', 'توابل'),
(28, 'دجاج', 'chicken', 'لحوم'),
(29, 'زيتون', 'olives', 'خضروات'),
(30, 'ليمون', 'lemon', 'فواكه'),
(31, 'ثوم', 'garlic', 'توابل'),
(32, 'زعفران', 'saffron', 'توابل'),
(33, 'كسكس', 'couscous', 'حبوب'),
(34, 'زيت', 'oil', 'دهون'),
(35, 'توابل', 'spices', 'توابل'),
(36, 'فرينة', 'flour', 'حبوب'),
(37, 'ماء', 'water', 'سوائل'),
(38, 'ملح', 'salt', 'توابل'),
(39, 'شحمة', 'lamb fat', 'لحم'),
(40, 'طماطم مصبرة', 'tomato paste', 'خضر'),
(41, 'هريسة', 'harissa', 'توابل'),
(42, 'كمون', 'cumin', 'توابل'),
(43, 'فلفل أسود', 'black pepper', 'توابل'),
(44, 'كرفس', 'celery', 'خضر'),
(45, 'سميد', 'semolina', 'حبوب'),
(46, 'تمر', 'dates', 'فواكه'),
(47, 'زبدة', 'butter', 'دهون'),
(48, 'قرفة', 'cinnamon', 'توابل'),
(49, 'فلفل', 'peppers', 'خضر'),
(50, 'زيت زيتون', 'olive oil', 'دهون'),
(51, 'عسل', 'honey', 'سكريات'),
(52, 'رشتة، حمص، لفت، دجاج', 'Rechta (traditional noodles)', 'حبوب،حبوب،خضر،لحوم'),
(53, 'سميد رطب', 'bell peppers', 'حبوب،حبوب،مادة كيميائية،ماء،مادة،فواكه،تحضيرة'),
(54, 'سكر', 'hot pepper', ''),
(55, 'خميرة', 'tomatoes', ''),
(56, 'ملح، موز،نوتيلا', 'olive oil', ''),
(57, 'دقيق الحمص', 'chickpea flour', 'حبوب'),
(58, 'بيض', 'eggs', 'لحوم'),
(59, 'فلفل حلو', 'bell peppers', 'خضروات'),
(60, 'فلفل حار', 'hot pepper', 'خضروات'),
(61, 'زيت الزيتون', 'olive oil', 'دهون');

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `recipe_id` int(11) NOT NULL,
  `score` int(11) DEFAULT NULL CHECK (`score` between 1 and 5),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`id`, `user_id`, `recipe_id`, `score`, `created_at`) VALUES
(2, 2, 4, 5, '2026-03-09 21:08:28');

-- --------------------------------------------------------

--
-- Table structure for table `recipes`
--

CREATE TABLE `recipes` (
  `id` int(11) NOT NULL,
  `name_ar` varchar(255) NOT NULL,
  `name_en` varchar(255) NOT NULL,
  `description_ar` text DEFAULT NULL,
  `description_en` text DEFAULT NULL,
  `preparation_ar` longtext NOT NULL,
  `preparation_en` longtext NOT NULL,
  `is_traditional` tinyint(1) DEFAULT 0,
  `prep_time` int(11) DEFAULT NULL,
  `difficulty` enum('easy','medium','hard') DEFAULT 'medium',
  `image_url` varchar(500) DEFAULT NULL,
  `rating` float DEFAULT 0,
  `rating_count` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `recipes`
--

INSERT INTO `recipes` (`id`, `name_ar`, `name_en`, `description_ar`, `description_en`, `preparation_ar`, `preparation_en`, `is_traditional`, `prep_time`, `difficulty`, `image_url`, `rating`, `rating_count`, `created_at`) VALUES
(4, 'كسكس بالخضر', 'Couscous with Vegetables', 'طبق تقليدي جزائري أصيل', 'Traditional Algerian dish', '\"سلقي الخضر ثم ضعي الكسكس على البخار\"', '\"Boil vegetables then steam couscous\"', 1, 90, 'medium', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpOQUd3dBAT8r16UaUmHAbpWzW3y0RkEmoxw&s', 5, 1, '2026-03-09 21:07:39'),
(5, 'شوربة فريك', 'Freekeh Soup', 'شوربة جزائرية تقليدية', 'Traditional Algerian soup', '\"اطبخي اللحم مع الفريك والخضر\"', '\"Cook meat with freekeh and vegetables\"', 1, 60, 'easy', 'https://www.echoroukonline.com/wp-content/uploads/2022/01/chorba.jpg', 0, 0, '2026-03-09 21:07:39'),
(6, 'طاجين الدجاج بالزيتون', 'Chicken Tagine with Olives', 'طاجين مغاربي لذيذ', 'Delicious Maghrebi tagine', 'تبّلي الدجاج ثم اطبخيه مع الزيتون والليمون', 'Season chicken then cook with olives and lemon', 1, 75, 'medium', 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400', 0, 0, '2026-03-09 21:07:40'),
(8, 'شوربة فريك', 'Freekeh Soup', 'شوربة جزائرية تقليدية', 'Traditional Algerian soup', '\"اطبخي اللحم مع الفريك والخضر\"', '\"Cook meat with freekeh and vegetables\"', 1, 60, 'easy', 'https://www.echoroukonline.com/wp-content/uploads/2022/01/chorba.jpg', 0, 0, '2026-03-18 11:40:47'),
(22, 'كسكس بالخضر و اللحم', 'couscous with vegetables and meat', 'طبق تقليدي جزائري أصيل', 'Traditional Algerian dish', 'نطيب اللحم مع البصل و الطماطم و الحمص و التوابل  ثم نضيف الخضر و نتركها تطهى نفور الكسكس ثلاث مرات ثم نقدمه مع المرق و الخضر', 'Cook the meat with onion, tomato, chickpeas, and spices Add vegetables and simmer. Steam the couscous three times, then serve with the sauce and vegetables', 1, 90, 'medium', 'https://i.ytimg.com/vi/PdBolqOVmS0/mqdefault.jpg', 0, 0, '2026-03-18 11:50:06'),
(23, 'مخلع ', 'Mekhalaa', 'خبز تقليدي من ولاية بشار محشي بالشحمة والبصل والتوابل ويطهى على الطاجين.', 'Traditional Bechar stuffed flatbread with lamb fat and spices', 'نحضر عجين من الفرينة والماء والملح، ثم نحضر الحشو بالبصل والشحمة والتوابل والطماطم المصبرة والهريسة. نحشي العجين ونبسطه ثم نطيبه فوق الطاجين أو في مقلاة حتى يتحمر من الجهتين.', 'Prepare a dough with flour, water, and salt. Prepare the filling with onion, lamb fat, spices, tomato paste and harissa. Stuff the dough, flatten it, then cook it on a pan or griddle until golden on both sides.', 1, 60, 'medium', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQlDVVvsLeI_ST_gG_Zk4BiAjtOA2X9Cb-pA&s', 0, 0, '2026-03-18 11:50:06'),
(24, 'حريرة جزائرية', 'Algerian Harira Soup', 'شوربة جزائرية تقليدية تُحضَّر بالطماطم والحمص والأعشاب والتوابل وتقدم ساخنة خاصة في رمضان.', 'Traditional Algerian soup with chickpeas and herbs', 'نقلي البصل مع الزيت ثم نضيف اللحم والطماطم والحمص والتوابل ونضيف الماء ونتركها تطهى، ثم نضيف الأعشاب وتقدم ساخنة.', 'Cook onion in oil, add meat, tomatoes, chickpeas and spices. Add water and simmer, then add herbs and serve hot.', 1, 80, 'medium', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtO2uUqF61Zkiaj-Y_VKmCjYPhBw4s-RsloQ&s', 0, 0, '2026-03-18 11:50:06'),
(25, 'رفيس التمر', 'Date Rfis Dessert', 'حلوى جزائرية تقليدية بالسميد والتمر تقدم خاصة في الجنوب الجزائري.', 'Traditional Algerian dessert made with semolina and dates.', 'نحمص السميد في المقلاة ثم نخلطه مع التمر والزبدة والقرفة حتى يصبح خليطًا متجانسًا ويقدم دافئًا.', 'Toast semolina, mix with dates, butter and cinnamon until combined, then serve warm', 1, 70, 'medium', 'https://img-global.cpcdn.com/recipes/9d28f8a6a713e0ce/1200x630cq80/photo.jpg', 0, 0, '2026-03-18 11:50:06'),
(26, 'سلطة مشوية', 'Grilled Algerian Salad', 'سلطة جزائرية تقليدية من الفلفل والطماطم المشوية مع الثوم وزيت الزيتون', 'Traditional Algerian grilled pepper and tomato salad', 'نشوي الفلفل والطماطم ثم نقشرها ونقطعها ونضيف الثوم وزيت الزيتون والملح ونخلط جيدًا', 'Grill peppers and tomatoes, peel them, chop them then mix with garlic, olive oil and salt', 1, 20, 'easy', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfL2clIyOo1Y1GzQILkLEnNOkDoAKGZ3mrBw&s', 0, 0, '2026-03-18 11:50:06'),
(27, 'مقروط التمر', 'Date Makroud', 'حلوى جزائرية تقليدية محشوة بالتمر ومصنوعة من السميد والعسل', 'Traditional Algerian dessert made of semolina filled with dates and dipped in honey', 'نخلط السميد مع الزبدة والماء ونحضر حشو التمر ثم نشكل المقروط ونقليه أو نخبزه ونغمره في العسل', 'Mix semolina with butter and water, prepare date filling, shape makroud then fry or bake and dip in honey', 1, 70, 'medium', 'https://i.ytimg.com/vi/HxzdDjgMM5I/maxresdefault.jpg', 0, 0, '2026-03-18 11:50:06'),
(28, 'رشتة', 'RECHTA', 'أكلة شعبية جزائرية', 'Algerian street food ', 'قومي بطهي الخضر مع الدجاج لتحصلي على مرق أبيض، تم قومي بطهي الرشتة على البخار .', 'Cook the vegetables with the chicken to obtain a white broth, then steam the rechta (traditional noodles).', 1, 40, 'easy', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5OZadYqgWmdznpoRNb_XGCDlm15pkarvQelHeA5PNSwWqxQRf-hHpaHmmBxns_CuSRuF-9qrxOKho1BC9QbyZOonw8dFcNME8wss4iDpoljLMhfw&s=10&ec=121584908', 0, 0, '2026-03-18 22:56:08'),
(29, 'كراب', 'crep', 'مقبلة عالمية', 'Iternational starter', 'ضعي مقدارا من الخليط على مقلاة فوق نار هادئة  لتحصلي على ورقة ،ثم ضعي فوقها الموز والشكولاطة', 'Put a portion of the batter into a pan over low heat to obtain a thin sheet, then place banana and chocolate on top.\n', 0, 30, 'easy', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJZA2jou9KayFrTzbtWHMy6GxBCyJVXsr0l2KDb4akKg&s&ec=121584908', 0, 0, '2026-03-18 22:56:08'),
(124, 'كارنتيكا ', 'Karantika', 'أكلة شعبية جزائرية', 'Algerian street food ', '\"اخلطي المكونات ثم اخبزيها في فرن ساخن\"', '\"Mix the ingredients then bake in a preheated oven\" ', 1, 90, 'easy', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvMDgyFuAg64Z8G31n3XzEV6I-mhqdcOUikw&s', 0, 0, '2026-03-18 23:01:17'),
(125, 'حميص', 'Hmiss', 'مقبلة جزائرية', 'Algerian starter', '\"اشوي الخضر ثم قطعيها و حمسيها في مقلاة\"', 'Grill the vegetables then saute them in a pan', 1, 30, 'easy', 'https://cuisinezavecdjouza.fr/wp-content/uploads/2019/03/poivrons-grilles-tomates-hmisse-photo-1.jpg', 0, 0, '2026-03-18 23:01:17'),
(126, 'بغرير', 'Baghrir', 'فطائر جزائرية معسلة', 'Algerian spongy pancakes', '\"اخلطي المكونات جيدا و دعيها تختمر ثم قومي بطهيها في مقلاة ساخنة و اسقها بالعسل عند التقديم\"', '\"mix the ingredients and let the dough rest then cook in a heated pan and serve with honey\"', 1, 10, 'easy', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExMWFhUXGRsaGBgYFx0gIBshGh8YHRsbHx8fICggHR0lHxoaITEiJSkrLi4uGCAzODMtNygtLisBCgoKDg0OGxAQGy8mICYtLS8tLS0tLTUvLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIALUBFwMBIgACEQEDEQH/xAAcAAACAgMBAQAAAAAAAAAAAAAEBQMGAAIHAQj/xABAEAACAQIEBAQDBgUBCAIDAAABAhEDIQAEEjEFIkFRBhNhcTKBkQcUI0Kh8FJiscHRMxVDU3KCkuHxJMI0orP/xAAaAQACAwEBAAAAAAAAAAAAAAACAwABBAUG/8QALxEAAgICAgIABQIFBQEAAAAAAAECEQMhEjEEQRMiMlFxYZEFgaGx8CNCYtHhFP/aAAwDAQACEQMRA', 0, 0, '2026-03-18 23:01:18');

-- --------------------------------------------------------

--
-- Table structure for table `recipe_ingredients`
--

CREATE TABLE `recipe_ingredients` (
  `id` int(11) NOT NULL,
  `recipe_id` int(11) NOT NULL,
  `ingredient_id` int(11) NOT NULL,
  `quantity` varchar(100) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `recipe_ingredients`
--

INSERT INTO `recipe_ingredients` (`id`, `recipe_id`, `ingredient_id`, `quantity`, `unit`) VALUES
(18, 4, 17, '500', 'غ'),
(19, 4, 18, '3', 'حبات'),
(20, 4, 19, '2', 'حبات'),
(21, 4, 20, '2', 'حبات'),
(22, 4, 21, '1', 'حبات،كوب'),
(23, 4, 22, '1', ''),
(24, 5, 23, '250', 'غ'),
(25, 5, 24, '500', 'غ'),
(26, 5, 25, '2', 'حبات'),
(27, 5, 26, '1', 'حبة'),
(28, 5, 27, '1', 'ملعقة'),
(29, 6, 28, '1', 'كلغ'),
(30, 6, 29, '200', 'غ'),
(31, 6, 30, '2', 'حبات'),
(32, 6, 26, '2', 'حبة'),
(33, 6, 31, '3', 'فصوص'),
(34, 6, 32, '1', 'ملعقة'),
(41, 8, 23, '250', 'غ'),
(42, 8, 24, '500', 'غ'),
(43, 8, 25, '2', 'حبات'),
(44, 8, 26, '1', 'حبة'),
(45, 8, 27, '1', 'ملعقة'),
(130, 22, 33, '500', 'غرام'),
(131, 22, 24, '400', 'غرام'),
(132, 22, 18, '2', 'حبة'),
(133, 22, 21, '2', 'حبة'),
(134, 22, 22, '150', 'غرام'),
(135, 22, 26, '1', 'حبة'),
(136, 22, 25, '2', 'حبتان'),
(137, 22, 34, '3', 'ملعقة كبيرة'),
(138, 22, 35, '1', 'مزيج'),
(139, 23, 36, '500', 'غرام،مل،ملعقة صغيرة،حبة،غرام،ملعقة كبيرة،ملعقة كبي'),
(140, 23, 37, '300', ''),
(141, 23, 38, '1', ''),
(142, 23, 26, '2', ''),
(143, 23, 39, '250', ''),
(144, 23, 40, '2', ''),
(145, 23, 41, '1', ''),
(146, 23, 42, '1', ''),
(147, 23, 43, '1', ''),
(148, 24, 24, '300', 'غرام'),
(149, 24, 22, '150', 'غرام'),
(150, 24, 25, '2', 'حبة'),
(151, 24, 26, '1', 'حبة'),
(152, 24, 27, '1', 'حزمة'),
(153, 24, 44, '1', 'حزمة'),
(154, 24, 34, '2', 'ملعقة كبيرة'),
(155, 24, 35, '1', 'مزيج'),
(156, 25, 45, '300', 'غرام'),
(157, 25, 46, '250', 'غرام'),
(158, 25, 47, '80', 'غرام'),
(159, 25, 48, '1', 'ملعقة صغيرة'),
(160, 26, 49, '4', 'حبة'),
(161, 26, 25, '3', 'حبة'),
(162, 26, 31, '2', 'فص'),
(163, 26, 50, '2', 'ملعقة كبيرة'),
(164, 26, 38, '1', 'ملعقة صغيرة'),
(165, 27, 45, '500', 'غرام'),
(166, 27, 46, '300', 'غرام'),
(167, 27, 47, '120', 'غرام'),
(168, 27, 51, '150', 'غرام'),
(169, 28, 52, '1،200،3،3', 'كلغ،غ،حبات،قطع'),
(170, 29, 53, '4', 'حبات'),
(171, 29, 54, '1', 'حبة'),
(172, 29, 55, '2', 'حبات'),
(173, 29, 37, '4', 'فصوص'),
(174, 29, 56, '3', 'ملاعق،حبات،خلطة'),
(175, 124, 57, '400', 'غ'),
(176, 124, 38, '1', 'ملعقة صغيرة'),
(177, 124, 34, '100', 'مل'),
(178, 124, 58, '1', 'حبة'),
(179, 124, 37, '2400', 'مل'),
(180, 124, 42, '1', 'ملعقة كبيرة'),
(181, 125, 59, '4', 'حبات'),
(182, 125, 60, '1', 'حبة'),
(183, 125, 25, '2', 'حبات'),
(184, 125, 31, '4', 'فصوص'),
(185, 125, 61, '3', 'ملاعق'),
(186, 126, 53, '2', 'كؤوس'),
(187, 126, 54, '1', 'ملعقة'),
(188, 126, 55, '1', 'ملعقة'),
(189, 126, 37, '3', 'كؤوس'),
(190, 126, 38, '1', 'ملعقة');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `hashed_password` varchar(255) NOT NULL,
  `is_admin` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `hashed_password`, `is_admin`, `is_active`, `created_at`) VALUES
(1, 'admin', 'admin@shantieb.dz', '$2b$12$placeholder_will_be_replaced', 1, 1, '2026-03-08 09:38:30'),
(2, 'younes', 'younes@gmail.com', '$2b$12$rw86xTV2q1zHi3ncDN/N.u3TQiZ4GzcDr3kSB/lBuex7l.pbnDTgm', 1, 1, '2026-03-08 10:57:14'),
(3, 'aicha', 'aicha@gmail.com', '$2b$12$N8ho8HJSaBdVLFaNYR1Ohu/6gdX6m2/z99cHsZ0nLqZCNfU1AVG6K', 0, 1, '2026-03-18 23:04:07');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `recipe_id` (`recipe_id`);

--
-- Indexes for table `ingredients`
--
ALTER TABLE `ingredients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `recipe_id` (`recipe_id`);

--
-- Indexes for table `recipes`
--
ALTER TABLE `recipes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `recipe_ingredients`
--
ALTER TABLE `recipe_ingredients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `recipe_id` (`recipe_id`),
  ADD KEY `ingredient_id` (`ingredient_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ingredients`
--
ALTER TABLE `ingredients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `recipes`
--
ALTER TABLE `recipes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=220;

--
-- AUTO_INCREMENT for table `recipe_ingredients`
--
ALTER TABLE `recipe_ingredients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=191;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `recipe_ingredients`
--
ALTER TABLE `recipe_ingredients`
  ADD CONSTRAINT `recipe_ingredients_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `recipe_ingredients_ibfk_2` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
