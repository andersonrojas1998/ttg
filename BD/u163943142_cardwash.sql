-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 12-09-2023 a las 21:56:08
-- Versión del servidor: 10.6.12-MariaDB-cll-lve
-- Versión de PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `u163943142_cardwash`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_cant_sales_user` (IN `idUser` INT, IN `estado` INT)   SELECT  tb2.id AS no_venta,tb2.nombre_cliente, pq.nombre combo,tb2.precio_venta_paquete precio_venta,tb2.porcentaje_paquete porcentaje,tpvh.descripcion vehiculo, tb2.fecha_pago,tb2.fecha as fecha_venta
from venta AS tb2 
INNER JOIN detalle_paquete  dtp on tb2.id_detalle_paquete=dtp.id 
INNER JOIN paquete  pq ON dtp.id_paquete=pq.id
INNER JOIN tipo_vehiculo tpvh ON dtp.id_tipo_vehiculo=tpvh.id
 WHERE  tb2.id_usuario=idUser AND tb2.id_estado_venta=estado$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_expenses` (IN `month` INT)   SELECT IFNULL(ROUND(SUM(tb2.precio_venta_paquete*tb2.porcentaje_paquete/100)),0) egreso, 'Pago empleados' concepto 
from venta AS tb2  
WHERE  DATE_FORMAT(tb2.fecha,'%m')= month 
AND tb2.id_detalle_paquete IS NOT NULL  AND tb2.id_estado_venta=2 AND DATE_FORMAT(tb2.fecha,'%Y') = YEAR(CURDATE())
UNION ALL
SELECT  c.importe_total egreso ,c.compracol  concepto from compra c 
WHERE c.estado_id=2 AND  DATE_FORMAT(c.fecha_emision,'%m')=month AND DATE_FORMAT(c.fecha_emision,'%Y') = YEAR(CURDATE())$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_expenses_month` (IN `MONTH` INT)   SELECT IFNULL(SUM(c.importe_total),0) egreso,
(SELECT IFNULL(SUM(ROUND(tb2.precio_venta_paquete*tb2.porcentaje_paquete/100)),0) egreso
from venta AS tb2  
WHERE  DATE_FORMAT(tb2.fecha,'%m')= MONTH
AND tb2.id_detalle_paquete IS NOT NULL  AND tb2.id_estado_venta=2 AND DATE_FORMAT(tb2.fecha,'%Y') = YEAR(CURDATE()) ) nomina
from compra c 
WHERE c.estado_id=2 AND  DATE_FORMAT(c.fecha_emision,'%m')=month AND DATE_FORMAT(c.fecha_emision,'%Y') = YEAR(CURDATE())$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_groupSalesProduct` (IN `sp_id_venta` INT)   SELECT DISTINCT(dcp.id_producto), prd.nombre producto,  dvp.id_venta, dvp.precio_venta, (dvp.precio_venta*sum(dvp.cantidad)) total_venta,sum(dvp.cantidad) cantidad_vendida FROM detalle_venta_productos dvp
inner join  detalle_compra_productos dcp on dvp.id_detalle_producto=dcp.id_detalle_compra
INNER join producto prd on  dcp.id_producto=prd.id
where id_venta=sp_id_venta
GROUP by dcp.id_producto$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_incomexproduct` (IN `month` INT)   SELECT    ROUND(SUM(dvp.margen_ganancia*dvp.cantidad)) gananciasxproducto 
from venta AS vt
INNER JOIN detalle_venta_productos dvp ON vt.id=dvp.id_venta
WHERE   
DATE_FORMAT(vt.fecha,'%m')=month  AND  DATE_FORMAT(vt.fecha,'%Y') = YEAR(CURDATE())$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_incomexproduct_day` (IN `fechaini` DATE, IN `fechafin` DATE)   SELECT    ROUND(SUM(dvp.margen_ganancia*dvp.cantidad)) gananciasxproducto 
from venta AS vt
INNER JOIN detalle_venta_productos dvp ON vt.id=dvp.id_venta
WHERE   
DATE_FORMAT(vt.fecha,'%Y-%m-%d')  >= fechaini  AND DATE_FORMAT(vt.fecha,'%Y-%m-%d') <= fechafin$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_incomexsales` (IN `fechaini` DATE, IN `fechafin` DATE)   SELECT  IFNULL(sum(vt.precio_venta_paquete),0) as total_venta, count(*) cantidad FROM venta vt WHERE vt.id_detalle_paquete IS NOT NULL 
AND DATE_FORMAT(vt.fecha,'%Y-%m-%d')  >= fechaini  AND DATE_FORMAT(vt.fecha,'%Y-%m-%d') <= fechafin$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_incomexservice` (IN `month` INT)   SELECT  
IFNULL(SUM(ROUND(tb2.precio_venta_paquete) - ROUND(tb2.precio_venta_paquete*tb2.porcentaje_paquete/100)),0) gananciasxservicio 
from venta AS tb2 
WHERE    
DATE_FORMAT(tb2.fecha,'%m')=month
AND tb2.id_detalle_paquete IS NOT NULL AND DATE_FORMAT(tb2.fecha,'%Y') = YEAR(CURDATE())$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_incomexservice_day` (IN `fechaini` DATE, IN `fechafin` DATE)   SELECT  
IFNULL(SUM(ROUND(tb2.precio_venta_paquete) - ROUND(tb2.precio_venta_paquete*tb2.porcentaje_paquete/100)),0) gananciasxservicio  
from venta AS tb2 
WHERE    
(DATE_FORMAT(tb2.fecha,'%Y-%m-%d')  >= fechaini  AND DATE_FORMAT(tb2.fecha,'%Y-%m-%d') <= fechafin )
AND tb2.id_detalle_paquete IS NOT NULL$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_products` (IN `area` VARCHAR(20))   SELECT  pd.nombre producto,m.nombre marca ,tp.descripcion tipo_producto,CONCAT(um.nombre,' - ' ,um.abreviatura) as unidad_medida,ps.nombre presentacion,ar.nombre area,
(SELECT  IFNULL(SUM(dc.cantidad),0) from detalle_compra_productos dc WHERE dc.id_producto=pd.id) - (SELECT    IFNULL(SUM(dv.cantidad),0) from detalle_compra_productos dc  INNER join detalle_venta_productos dv  ON dc.id_detalle_compra=dv.id_detalle_producto WHERE dc.id_producto=pd.id ) cant_disponible, 
pd.id,pd.id_tipo_producto,pd.id_marca,pd.id_unidad_medida,pd.id_presentacion,pd.precio_venta,pd.imagen
FROM  producto  pd
INNER JOIN marca m ON pd.id_marca=m.id
INNER JOIN tipo_producto tp ON pd.id_tipo_producto=tp.id
INNER JOIN unidad_medida um ON pd.id_unidad_medida=um.id
INNER JOIN presentacion ps ON pd.id_presentacion=ps.id
INNER JOIN area ar ON pd.id_area=ar.id
WHERE ar.id IN(area)$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_products_all` ()   SELECT  pd.nombre producto,m.nombre marca ,tp.descripcion tipo_producto,CONCAT(um.nombre,' - ' ,um.abreviatura) as unidad_medida,ps.nombre presentacion,ar.nombre area,
(SELECT  IFNULL(SUM(dc.cantidad),0) from detalle_compra_productos dc WHERE dc.id_producto=pd.id) - (SELECT    IFNULL(SUM(dv.cantidad),0) from detalle_compra_productos dc  INNER join detalle_venta_productos dv  ON dc.id_detalle_compra=dv.id_detalle_producto WHERE dc.id_producto=pd.id ) cant_disponible,
pd.id,pd.id_tipo_producto,pd.id_marca,pd.id_unidad_medida,pd.id_presentacion,pd.precio_venta,pd.imagen
FROM  producto  pd
INNER JOIN marca m ON pd.id_marca=m.id
INNER JOIN tipo_producto tp ON pd.id_tipo_producto=tp.id
INNER JOIN unidad_medida um ON pd.id_unidad_medida=um.id
INNER JOIN presentacion ps ON pd.id_presentacion=ps.id
INNER JOIN area ar ON pd.id_area=ar.id$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_salesxday` (IN `day` INT)   SELECT COUNT(id) cantidadxdia FROM venta   WHERE  DATE_FORMAT(fecha,'%m') =MONTH(CURRENT_DATE())  AND  DATE_FORMAT(fecha,'%Y') = YEAR(CURDATE()) AND   DATE_FORMAT(fecha,'%d') =day   AND id_detalle_paquete IS NOT NULL$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_salesxmonth` (IN `month` INT)   SELECT COUNT(id) cantidadxmes FROM venta   WHERE  DATE_FORMAT(fecha,'%m') =month  AND  DATE_FORMAT(fecha,'%Y') = YEAR(CURDATE())  AND id_detalle_paquete IS NOT NULL$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_salesxuser` ()   SELECT tb1.id id_user, tb1.identificacion,tb1.name,
(SeLECT count(tb2.id) from venta AS tb2 WHERE  tb1.id=tb2.id_usuario AND tb2.id_detalle_paquete IS NOT NULL) cant_servicios,
(SeLECT count(tb2.id) from venta AS tb2 WHERE  tb1.id=tb2.id_usuario AND tb2.id_estado_venta=1 AND tb2.id_detalle_paquete IS NOT NULL) pendiente, 
(SeLECT  ROUND(SUM(tb2.precio_venta_paquete*tb2.porcentaje_paquete/100)) from venta AS tb2  WHERE  tb1.id=tb2.id_usuario AND tb2.id_estado_venta=1) pend_pago
from users AS  tb1$$

CREATE DEFINER=`u163943142_adrojas`@`127.0.0.1` PROCEDURE `sp_sell_prd_stock` (IN `param_id_product` INT)   SELECT 
dcp.id_detalle_compra,
dcp.cantidad cant_compra_prd,
dcp.precio_compra,
(SELECT IFNULL(SUM(dv.cantidad),0) from  detalle_venta_productos dv  WHERE dv.id_detalle_producto = dcp.id_detalle_compra) cant_ventas_realizadas,
IFNULL((dcp.cantidad) - (SELECT   IFNULL(SUM(dv.cantidad),0) from  detalle_venta_productos dv  WHERE dv.id_detalle_producto = dcp.id_detalle_compra),0) restante  
from 
detalle_compra_productos dcp INNER join producto pd on dcp.id_producto=pd.id
where dcp.id_producto=param_id_product
AND   IFNULL((dcp.cantidad) - (SELECT   IFNULL(SUM(dv.cantidad),0) from  detalle_venta_productos dv  WHERE dv.id_detalle_producto = dcp.id_detalle_compra),0)  <> 0
ORDER BY restante  DESC$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `area`
--

CREATE TABLE `area` (
  `id` int(11) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `area`
--

INSERT INTO `area` (`id`, `nombre`, `created_at`, `updated_at`) VALUES
(1, 'Lubriteca', '2023-06-16 16:38:40', '2023-06-16 16:38:40'),
(2, 'Lavadero', '2023-06-16 16:38:40', '2023-06-16 16:38:40'),
(3, 'Tienda', '2023-06-16 16:39:01', '2023-06-16 16:39:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compra`
--

CREATE TABLE `compra` (
  `id` int(11) NOT NULL,
  `reg_op` varchar(45) DEFAULT NULL,
  `fecha_emision` datetime DEFAULT NULL,
  `compracol` varchar(45) DEFAULT NULL,
  `fecha_vencimiento` datetime DEFAULT NULL,
  `no_comprobante` varchar(45) DEFAULT NULL,
  `id_proveedor` varchar(45) DEFAULT NULL,
  `id_proveedor_nombre` varchar(80) NOT NULL,
  `razon_social_proveedor` varchar(120) DEFAULT NULL,
  `descuentos_iva` varchar(45) DEFAULT NULL,
  `importe_total` varchar(45) DEFAULT NULL,
  `condiciones_id` int(11) DEFAULT NULL,
  `estado_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `compra`
--

INSERT INTO `compra` (`id`, `reg_op`, `fecha_emision`, `compracol`, `fecha_vencimiento`, `no_comprobante`, `id_proveedor`, `id_proveedor_nombre`, `razon_social_proveedor`, `descuentos_iva`, `importe_total`, `condiciones_id`, `estado_id`, `created_at`, `updated_at`) VALUES
(1, '001', '2023-07-16 00:00:00', 'INVENTARIO INICIAL', NULL, '001', '000000', 'INVENTARIO', 'Natural', '0', '1500000', 1, 1, '2023-07-16 14:06:12', '2023-08-17 16:04:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `condiciones`
--

CREATE TABLE `condiciones` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `condiciones`
--

INSERT INTO `condiciones` (`id`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'default', '2023-06-21 18:46:58', '2023-06-21 18:46:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_compra_productos`
--

CREATE TABLE `detalle_compra_productos` (
  `id_detalle_compra` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `id_compra` int(11) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio_compra` float DEFAULT NULL,
  `precio_venta` float DEFAULT NULL,
  `referencia` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `detalle_compra_productos`
--

INSERT INTO `detalle_compra_productos` (`id_detalle_compra`, `id_producto`, `id_compra`, `cantidad`, `precio_compra`, `precio_venta`, `referencia`, `created_at`, `updated_at`) VALUES
(66, 1, 1, 60, 25000, NULL, NULL, '2023-08-17 16:04:35', '2023-08-17 16:04:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_paquete`
--

CREATE TABLE `detalle_paquete` (
  `id` int(11) NOT NULL,
  `precio_venta` int(11) DEFAULT NULL,
  `porcentaje` int(11) DEFAULT NULL,
  `id_tipo_vehiculo` int(11) NOT NULL,
  `id_paquete` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `detalle_paquete`
--

INSERT INTO `detalle_paquete` (`id`, `precio_venta`, `porcentaje`, `id_tipo_vehiculo`, `id_paquete`, `created_at`, `updated_at`) VALUES
(10, 35000, 40, 1, 7, '2023-06-22 22:35:18', '2023-06-22 22:35:18'),
(11, 45000, 40, 2, 7, '2023-06-22 22:35:45', '2023-06-22 22:35:45'),
(12, 45000, 40, 1, 8, '2023-06-22 22:36:45', '2023-06-22 22:36:45'),
(13, 55000, 40, 2, 8, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(14, 55000, 40, 1, 9, '2023-06-22 22:38:43', '2023-06-22 22:38:43'),
(15, 65000, 40, 2, 9, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(16, 60000, 40, 1, 10, '2023-06-22 22:40:16', '2023-06-22 22:40:16'),
(17, 70000, 40, 2, 10, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(18, 75000, 40, 1, 11, '2023-06-22 22:42:17', '2023-06-22 22:42:17'),
(19, 85000, 40, 2, 11, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(20, 95000, 40, 1, 12, '2023-06-22 22:45:14', '2023-06-22 22:45:14'),
(21, 105000, 40, 2, 12, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(22, 155000, 40, 1, 13, '2023-06-22 22:47:54', '2023-06-22 22:47:54'),
(23, 165000, 40, 2, 13, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(24, 30000, 40, 1, 14, '2023-06-22 22:53:48', '2023-06-22 22:53:48'),
(25, 30000, 40, 2, 14, '2023-06-22 22:54:11', '2023-06-22 22:54:11'),
(26, 50000, 40, 1, 15, '2023-06-22 22:55:02', '2023-06-22 22:55:02'),
(27, 50000, 40, 2, 15, '2023-06-22 22:55:22', '2023-06-22 22:55:22'),
(28, 300000, 40, 1, 16, '2023-06-22 22:57:53', '2023-06-22 22:57:53'),
(29, 350000, 40, 2, 16, '2023-06-22 22:58:26', '2023-06-22 22:58:26'),
(30, 200000, 40, 1, 17, '2023-06-22 22:59:31', '2023-06-22 22:59:31'),
(31, 250000, 40, 2, 17, '2023-06-22 22:59:51', '2023-06-22 22:59:51'),
(32, 14000, 40, 3, 7, '2023-06-22 23:00:39', '2023-06-22 23:00:39'),
(33, 16000, 40, 3, 8, '2023-06-22 23:01:24', '2023-06-22 23:01:24'),
(34, 20000, 40, 3, 9, '2023-06-22 23:02:26', '2023-06-22 23:02:26'),
(35, 30000, 40, 3, 10, '2023-06-22 23:03:48', '2023-06-22 23:03:48'),
(36, 50000, 40, 3, 13, '2023-06-22 23:04:47', '2023-06-22 23:04:47'),
(37, 20000, 40, 1, 18, '2023-07-12 14:32:19', '2023-07-12 14:32:19'),
(38, 35000, 40, 2, 18, '2023-07-12 14:34:35', '2023-07-12 14:35:06'),
(39, 18000, 40, 1, 19, '2023-08-31 19:03:50', '2023-08-31 19:03:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_venta_productos`
--

CREATE TABLE `detalle_venta_productos` (
  `id` int(11) NOT NULL,
  `id_venta` int(11) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `id_detalle_producto` int(11) NOT NULL,
  `precio_venta` float DEFAULT NULL,
  `margen_ganancia` float DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `egresos_concepto`
--

CREATE TABLE `egresos_concepto` (
  `id` int(11) NOT NULL,
  `concepto` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `egresos_concepto`
--

INSERT INTO `egresos_concepto` (`id`, `concepto`, `created_at`, `updated_at`) VALUES
(1, 'Seguridad', '2023-06-06 17:57:57', '2023-06-06 17:57:57'),
(2, 'Servicios Publicos', '2023-06-06 17:57:57', '2023-06-06 17:57:57'),
(3, 'Shampo', '2023-06-06 17:58:20', '2023-06-06 17:58:20'),
(4, 'Llantil', '2023-06-06 17:58:20', '2023-06-06 17:58:20'),
(5, 'Desengrasante', '2023-06-06 17:58:35', '2023-06-06 17:58:35'),
(6, 'Cera', '2023-06-06 17:58:35', '2023-06-06 17:58:35'),
(7, 'Grafito', '2023-06-06 17:58:56', '2023-06-06 17:58:56'),
(8, 'Acido Nitrico', '2023-06-06 17:58:56', '2023-06-06 17:58:56'),
(9, 'Desmanchadora', '2023-06-06 17:59:11', '2023-06-06 17:59:11'),
(10, 'ACPM', '2023-06-06 17:59:11', '2023-06-06 17:59:11'),
(11, 'Varsol', '2023-06-06 17:59:30', '2023-06-06 17:59:30'),
(12, 'Implementos Aseo ', '2023-06-06 17:59:30', '2023-06-06 17:59:30'),
(13, 'Porcentaje Seguridad Lavadores', '2023-06-06 17:59:44', '2023-06-06 17:59:44'),
(14, 'Servicio Internet', '2023-06-06 17:59:44', '2023-06-06 17:59:44'),
(15, 'Aceite Hidraulico para gatos ', '2023-06-06 17:59:59', '2023-06-06 17:59:59'),
(16, 'Aseadora', '2023-06-06 17:59:59', '2023-06-06 17:59:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `egresos_mensuales`
--

CREATE TABLE `egresos_mensuales` (
  `id` int(11) NOT NULL,
  `fecha` date DEFAULT NULL,
  `id_concepto` int(11) NOT NULL,
  `total_egreso` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

CREATE TABLE `estado` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`id`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'Compra', '2023-06-06 14:01:49', '2023-06-06 14:01:49'),
(2, 'Gasto', '2023-06-06 14:01:49', '2023-06-06 14:01:49');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado_venta`
--

CREATE TABLE `estado_venta` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='	';

--
-- Volcado de datos para la tabla `estado_venta`
--

INSERT INTO `estado_venta` (`id`, `nombre`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'Pendiente por pagar', NULL, '2023-06-06 14:02:07', '2023-06-06 14:02:07'),
(2, 'Servicio pagado', NULL, '2023-06-06 14:02:07', '2023-06-06 14:02:07'),
(3, 'Venta Productos', 'Venta Productos', '2023-06-06 14:02:18', '2023-06-06 14:02:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marca`
--

CREATE TABLE `marca` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `marca`
--

INSERT INTO `marca` (`id`, `nombre`, `estado`, `created_at`, `updated_at`) VALUES
(1, 'generica', 1, '2023-06-06 20:48:11', '2023-06-06 20:48:11'),
(2, 'poker', 1, '2023-06-22 23:57:19', '2023-06-22 23:57:19'),
(3, 'colombina', 1, '2023-06-28 05:11:50', '2023-06-28 05:11:50'),
(5, 'fritoley', 1, '2023-07-02 19:17:42', '2023-07-02 19:17:42'),
(8, 'coexito', 1, '2023-07-12 12:23:17', '2023-07-12 12:23:17'),
(9, 'kixx', 1, '2023-07-12 12:59:44', '2023-07-12 12:59:44'),
(10, 'chevron', 1, '2023-07-12 13:03:16', '2023-07-12 13:03:16'),
(11, 'terpel', 1, '2023-07-12 13:06:20', '2023-07-12 13:06:20'),
(12, 'mobil', 1, '2023-07-12 13:08:51', '2023-07-12 13:08:51'),
(13, 'coll rides', 1, '2023-07-12 13:11:05', '2023-07-12 13:11:05'),
(14, 'premier', 1, '2023-07-28 13:26:26', '2023-07-28 13:26:26'),
(15, 'motul', 1, '2023-07-28 14:11:42', '2023-07-28 14:11:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paquete`
--

CREATE TABLE `paquete` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `color` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `paquete`
--

INSERT INTO `paquete` (`id`, `nombre`, `color`, `created_at`, `updated_at`) VALUES
(7, 'combo 1', '#00b0eb,#000000,#ffffff', '2023-06-22 22:33:01', '2023-06-22 22:33:01'),
(8, 'combo 2', '#8ed7f8,#000000,#ffffff', '2023-06-22 22:36:11', '2023-06-22 22:36:11'),
(9, 'combo 3', '#a3cc32,#000000,#ffffff', '2023-06-22 22:38:11', '2023-06-22 22:38:11'),
(10, 'combo 4', '#8ed7f8,#000000,#ffffff', '2023-06-22 22:39:35', '2023-06-22 22:39:35'),
(11, 'combo 5', '#fdf204,#000000,#ffffff', '2023-06-22 22:41:18', '2023-06-22 22:41:18'),
(12, 'combo 6', '#00b0eb,#000000,#ffffff', '2023-06-22 22:44:04', '2023-06-22 22:44:04'),
(13, 'combo full', '#a3cc32,#000000,#ffffff', '2023-06-22 22:46:25', '2023-06-22 22:46:25'),
(14, 'servicio de brillado basico', '#fdf204,#000000,#ffffff', '2023-06-22 22:49:11', '2023-06-22 22:49:11'),
(15, 'servicio de brillado premium', '#00b0eb,#000000,#ffffff', '2023-06-22 22:54:40', '2023-06-22 22:54:40'),
(16, 'porcelanizada', '#8ed7f8,#000000,#ffffff', '2023-06-22 22:56:39', '2023-06-22 22:56:39'),
(17, 'desmantelada', '#8ed7f8,#000000,#ffffff', '2023-06-22 22:59:17', '2023-06-22 22:59:17'),
(18, 'lavada sencilla', '#a3cc32,#000000,#ffffff', '2023-07-12 14:29:29', '2023-07-12 14:29:29'),
(19, 'lavada sencilla taxi', '#00b0eb,#000000,#ffffff', '2023-08-31 19:02:46', '2023-08-31 19:02:46');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `presentacion`
--

CREATE TABLE `presentacion` (
  `id` int(11) NOT NULL,
  `nombre` varchar(80) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `presentacion`
--

INSERT INTO `presentacion` (`id`, `nombre`, `created_at`, `updated_at`) VALUES
(1, 'Unidad', '2023-06-06 15:50:42', '2023-06-06 15:50:42'),
(2, 'C', '2023-06-06 16:01:16', '2023-06-06 16:01:16'),
(3, 'M', '2023-06-06 16:01:16', '2023-06-06 16:01:16'),
(4, '800', '2023-06-16 16:43:04', '2023-06-16 16:43:04'),
(5, '900', '2023-06-16 16:43:04', '2023-06-16 16:43:04'),
(6, '1000', '2023-06-16 16:43:15', '2023-06-16 16:43:15'),
(7, '1100', '2023-06-16 16:43:15', '2023-06-16 16:43:15'),
(8, '500', '2023-06-16 16:46:50', '2023-06-16 16:46:50'),
(9, '330', '2023-06-22 23:55:37', '2023-06-22 23:55:37'),
(10, '250', '2023-06-22 23:55:53', '2023-06-22 23:55:53'),
(11, '750', '2023-06-22 23:56:19', '2023-06-22 23:56:19'),
(12, '1', '2023-07-12 18:45:39', '2023-07-12 18:45:39'),
(13, '2', '2023-07-12 18:45:39', '2023-07-12 18:45:39');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `id_marca` int(11) NOT NULL,
  `id_tipo_producto` int(11) NOT NULL,
  `id_unidad_medida` int(11) NOT NULL,
  `id_presentacion` int(11) NOT NULL,
  `id_area` int(11) NOT NULL,
  `cant_stock` int(11) DEFAULT 0,
  `cant_stock_mov` int(11) NOT NULL DEFAULT 0,
  `precio_venta` float NOT NULL DEFAULT 0,
  `imagen` varchar(80) NOT NULL DEFAULT '/images/product-default1.png	',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`id`, `nombre`, `id_marca`, `id_tipo_producto`, `id_unidad_medida`, `id_presentacion`, `id_area`, `cant_stock`, `cant_stock_mov`, `precio_venta`, `imagen`, `created_at`, `updated_at`) VALUES
(1, '1402', 8, 1, 1, 1, 1, 157, 0, 30000, '/images/product-default1.png	', '2023-07-11 17:14:25', '2023-08-17 16:04:35'),
(2, '111', 8, 1, 1, 1, 1, 24, 0, 31000, '/images/product-default1.png	', '2023-07-12 12:23:45', '2023-08-11 16:54:15'),
(3, '14476', 8, 1, 4, 1, 1, 14, 0, 0, '/images/product-default1.png	', '2023-07-12 12:32:48', '2023-07-28 14:28:55'),
(4, '58', 8, 1, 1, 1, 1, 43, 0, 58000, '/images/product-default1.png	', '2023-07-12 12:34:40', '2023-08-17 12:39:06'),
(5, '1406', 8, 1, 1, 1, 1, 17, 0, 0, '/images/product-default1.png	', '2023-07-12 12:36:12', '2023-08-11 16:52:50'),
(6, '3603', 8, 1, 1, 1, 1, 22, 0, 0, '/images/product-default1.png	', '2023-07-12 12:37:32', '2023-08-11 16:52:50'),
(7, '18', 8, 1, 1, 1, 1, 28, 0, 0, '/images/product-default1.png	', '2023-07-12 12:38:09', '2023-08-11 16:52:50'),
(8, '223', 8, 1, 1, 1, 1, 5, 0, 0, '/images/product-default1.png	', '2023-07-12 12:39:01', '2023-07-16 14:06:15'),
(9, '1616', 8, 1, 1, 1, 1, 12, 0, 0, '/images/product-default1.png	', '2023-07-12 12:39:40', '2023-07-28 14:28:55'),
(10, '323', 8, 1, 1, 1, 1, 11, 0, 0, '/images/product-default1.png	', '2023-07-12 12:40:06', '2023-07-28 14:28:55'),
(11, '73', 8, 1, 1, 1, 1, 7, 0, 0, '/images/product-default1.png	', '2023-07-12 12:40:38', '2023-07-16 14:06:15'),
(12, '52', 8, 1, 1, 1, 1, 6, 0, 0, '/images/product-default1.png	', '2023-07-12 12:41:32', '2023-07-28 14:28:55'),
(13, '4050', 8, 1, 1, 1, 1, 7, 0, 0, '/images/product-default1.png	', '2023-07-12 12:41:58', '2023-07-16 14:06:15'),
(14, '85674 -CHEV TRACKER / CRUZE', 8, 1, 1, 1, 1, 0, 0, 0, '/images/product-default1.png	', '2023-07-12 12:42:50', '2023-07-12 12:42:50'),
(15, 'AGUA DE BATERIA', 8, 5, 1, 1, 1, 0, 0, 0, '/images/product-default1.png	', '2023-07-12 12:52:32', '2023-07-12 12:52:32'),
(16, 'KIXX 5W-30', 9, 11, 5, 1, 1, 5, 0, 0, '/images/product-default1.png	', '2023-07-12 13:01:31', '2023-07-28 14:50:03'),
(17, 'KIXX 10W-30', 9, 11, 5, 1, 1, 8, 0, 0, '/images/product-default1.png	', '2023-07-12 13:02:30', '2023-07-28 13:52:58'),
(18, 'SUPREME 10W-30', 10, 11, 5, 1, 1, 3, 0, 0, '/images/product-default1.png	', '2023-07-12 13:03:31', '2023-07-16 14:06:13'),
(19, 'HAVOLINE 20W-50', 10, 11, 5, 1, 1, 3, 0, 0, '/images/product-default1.png	', '2023-07-12 13:04:05', '2023-07-16 14:06:14'),
(20, 'TERPEL 20W-50 MULTIGRADO', 11, 11, 5, 1, 1, 3, 0, 0, '/images/product-default1.png	', '2023-07-12 13:06:27', '2023-07-16 14:06:15'),
(21, 'MOBIL SUPER 1000 20W-50', 12, 11, 5, 1, 1, 3, 0, 0, '/images/product-default1.png	', '2023-07-12 13:08:57', '2023-07-16 14:06:15'),
(22, 'COLL RIDES REFRIGERANTE', 13, 12, 3, 1, 1, 12, 0, 0, '/images/product-default1.png	', '2023-07-12 13:11:22', '2023-07-27 15:04:24'),
(23, 'HIDRAULICO 68', 14, 13, 3, 6, 1, 12, 0, 0, '/images/product-default1.png	', '2023-07-28 13:27:29', '2023-07-28 13:49:58'),
(24, 'motul 20w-50 2000', 15, 11, 5, 1, 1, 4, 0, 0, '/images/product-default1.png	', '2023-07-28 14:12:18', '2023-07-28 14:18:45'),
(25, 'moTUL 10W-30', 15, 11, 5, 1, 1, 4, 0, 0, '/images/product-default1.png	', '2023-07-28 14:13:01', '2023-07-28 14:18:45'),
(26, 'ACEITE COEXITO 20W-50', 8, 11, 5, 1, 1, 4, 0, 0, '/images/product-default1.png	', '2023-07-28 14:30:20', '2023-07-28 14:39:25'),
(27, 'ACEITE COEXITO 10W-30', 8, 11, 5, 1, 1, 4, 0, 15000, '/images/product-default1.png	', '2023-07-28 14:30:51', '2023-08-11 16:12:40'),
(28, 'LIQUIDO DE FRENOS DOT 3', 8, 14, 1, 1, 1, 24, 0, 0, '/images/product-default1.png	', '2023-07-28 14:32:03', '2023-07-28 14:40:43'),
(29, 'KIXX 5W-30 CUARTO', 9, 11, 3, 1, 1, 3, 0, 0, '/images/product-default1.png	', '2023-07-28 14:44:05', '2023-07-28 14:47:57'),
(30, 'KIXX 10W-30 CUARTO', 9, 11, 3, 1, 1, 3, 0, 0, '/images/product-default1.png	', '2023-07-28 14:44:42', '2023-07-28 14:47:57'),
(31, 'KIXX 20W-50 CUARTO', 9, 11, 3, 1, 1, 3, 0, 0, '/images/product-default1.png	', '2023-07-28 14:45:16', '2023-07-28 14:47:57'),
(32, 'COCA-COLA', 3, 6, 4, 4, 3, 15, 0, 2500, '/images/product-default1.png	', '2023-08-11 16:25:43', '2023-08-11 16:27:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `level` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `name`, `slug`, `description`, `level`, `created_at`, `updated_at`) VALUES
(1, 'Administrador', 'ADMIN', NULL, 1, NULL, NULL),
(10, 'Vendedor Tienda', 'Tienda', NULL, 1, NULL, NULL),
(11, 'Vendedor Lavadero', 'Supervisor', NULL, 1, NULL, NULL),
(12, 'Lavador', 'Lavador', NULL, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role_user`
--

CREATE TABLE `role_user` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `role_user`
--

INSERT INTO `role_user` (`id`, `role_id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 1, 2, NULL, NULL),
(5, 12, 3, '2023-05-11 21:38:21', '2023-05-11 21:38:21'),
(6, 1, 4, '2023-05-12 01:47:06', '2023-05-12 01:47:06'),
(7, 11, 5, '2023-05-12 04:58:18', '2023-05-12 04:58:18'),
(8, 10, 6, '2023-05-13 07:09:22', '2023-05-13 07:09:22'),
(9, 12, 7, '2023-06-22 23:13:24', '2023-06-22 23:13:24'),
(10, 12, 8, '2023-06-22 23:14:13', '2023-06-22 23:14:13'),
(11, 12, 9, '2023-06-22 23:14:59', '2023-06-22 23:14:59'),
(12, 12, 10, '2023-06-22 23:15:46', '2023-06-22 23:15:46'),
(13, 12, 11, '2023-06-22 23:16:08', '2023-06-22 23:16:08'),
(14, 12, 12, '2023-06-22 23:16:36', '2023-06-22 23:16:36'),
(15, 11, 13, '2023-06-22 23:21:32', '2023-06-22 23:21:32'),
(16, 10, 14, '2023-06-28 05:17:49', '2023-06-28 05:17:49'),
(17, 1, 15, '2023-07-12 11:07:27', '2023-07-12 11:07:27'),
(18, 12, 16, '2023-07-18 10:16:44', '2023-07-18 10:16:44'),
(19, 10, 18, '2023-08-28 14:51:18', '2023-08-28 14:51:18'),
(20, 11, 19, '2023-08-28 14:54:04', '2023-08-28 14:54:04'),
(21, 12, 20, '2023-08-28 15:17:58', '2023-08-28 15:17:58'),
(22, 12, 21, '2023-08-30 15:30:58', '2023-08-30 15:30:58'),
(23, 12, 22, '2023-09-01 19:02:32', '2023-09-01 19:02:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio`
--

CREATE TABLE `servicio` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `servicio`
--

INSERT INTO `servicio` (`id`, `nombre`, `created_at`, `updated_at`) VALUES
(1, 'Lavada', '2023-06-06 14:54:25', '2023-06-06 14:54:25'),
(2, 'Aspirada', '2023-06-06 14:54:25', '2023-06-06 14:54:25'),
(3, 'Brillada', '2023-06-06 14:54:43', '2023-06-06 14:54:43'),
(4, 'Silicona llantil', '2023-06-06 14:54:43', '2023-06-06 14:54:43'),
(5, 'Lavada Motor', '2023-06-06 14:54:55', '2023-06-06 14:54:55'),
(6, 'Desmanchada', '2023-06-06 14:55:29', '2023-06-06 14:55:29'),
(7, 'Rasqueteada', '2023-06-06 14:55:29', '2023-06-06 14:55:29'),
(8, 'Ducha grafitada', '2023-06-06 14:57:58', '2023-06-06 14:57:58'),
(9, 'Carteras baul', '2023-06-06 14:57:58', '2023-06-06 14:57:58'),
(10, 'Techo', '2023-06-06 14:58:55', '2023-06-06 14:58:55'),
(11, 'Alfombra', '2023-06-06 14:58:55', '2023-06-06 14:58:55'),
(12, 'Hidratación partes negras', '2023-06-06 14:59:10', '2023-06-06 14:59:10'),
(13, 'Porcelanizada', '2023-06-22 22:57:32', '2023-06-22 22:57:32'),
(14, 'Desmantelada', '2023-06-22 22:57:32', '2023-06-22 22:57:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio_paquete`
--

CREATE TABLE `servicio_paquete` (
  `id` int(11) NOT NULL,
  `id_servicio` int(11) NOT NULL,
  `id_paquete` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `servicio_paquete`
--

INSERT INTO `servicio_paquete` (`id`, `id_servicio`, `id_paquete`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2023-06-06 20:08:02', '2023-06-06 20:08:02'),
(2, 2, 1, '2023-06-06 20:08:02', '2023-06-06 20:08:02'),
(3, 3, 1, '2023-06-06 20:08:02', '2023-06-06 20:08:02'),
(4, 4, 1, '2023-06-06 20:08:02', '2023-06-06 20:08:02'),
(5, 1, 2, '2023-06-06 20:09:08', '2023-06-06 20:09:08'),
(6, 2, 2, '2023-06-06 20:09:08', '2023-06-06 20:09:08'),
(7, 3, 2, '2023-06-06 20:09:08', '2023-06-06 20:09:08'),
(8, 4, 2, '2023-06-06 20:09:08', '2023-06-06 20:09:08'),
(9, 1, 3, '2023-06-06 20:40:52', '2023-06-06 20:40:52'),
(10, 2, 3, '2023-06-06 20:40:52', '2023-06-06 20:40:52'),
(11, 3, 3, '2023-06-06 20:40:52', '2023-06-06 20:40:52'),
(12, 4, 3, '2023-06-06 20:40:52', '2023-06-06 20:40:52'),
(13, 5, 3, '2023-06-06 20:40:52', '2023-06-06 20:40:52'),
(14, 1, 4, '2023-06-06 20:41:28', '2023-06-06 20:41:28'),
(15, 2, 4, '2023-06-06 20:41:29', '2023-06-06 20:41:29'),
(16, 3, 4, '2023-06-06 20:41:29', '2023-06-06 20:41:29'),
(17, 4, 4, '2023-06-06 20:41:29', '2023-06-06 20:41:29'),
(18, 5, 4, '2023-06-06 20:41:29', '2023-06-06 20:41:29'),
(23, 1, 5, '2023-06-10 20:17:40', '2023-06-10 20:17:40'),
(24, 2, 5, '2023-06-10 20:17:40', '2023-06-10 20:17:40'),
(25, 3, 5, '2023-06-10 20:17:40', '2023-06-10 20:17:40'),
(26, 4, 5, '2023-06-10 20:17:40', '2023-06-10 20:17:40'),
(27, 5, 5, '2023-06-10 20:17:40', '2023-06-10 20:17:40'),
(28, 1, 6, '2023-06-10 20:17:40', '2023-06-10 20:17:40'),
(29, 2, 6, '2023-06-10 20:17:40', '2023-06-10 20:17:40'),
(30, 3, 6, '2023-06-10 20:17:40', '2023-06-10 20:17:40'),
(31, 4, 6, '2023-06-10 20:17:40', '2023-06-10 20:17:40'),
(32, 5, 6, '2023-06-10 20:17:40', '2023-06-10 20:17:40'),
(33, 1, 7, '2023-06-10 20:26:53', '2023-06-10 20:26:53'),
(34, 3, 7, '2023-06-10 20:26:53', '2023-06-10 20:26:53'),
(35, 4, 7, '2023-06-10 20:26:53', '2023-06-10 20:26:53'),
(40, 1, 10, '2023-06-22 22:35:45', '2023-06-22 22:35:45'),
(41, 2, 10, '2023-06-22 22:35:45', '2023-06-22 22:35:45'),
(42, 3, 10, '2023-06-22 22:35:45', '2023-06-22 22:35:45'),
(43, 4, 10, '2023-06-22 22:35:45', '2023-06-22 22:35:45'),
(44, 1, 11, '2023-06-22 22:35:45', '2023-06-22 22:35:45'),
(45, 2, 11, '2023-06-22 22:35:45', '2023-06-22 22:35:45'),
(46, 3, 11, '2023-06-22 22:35:45', '2023-06-22 22:35:45'),
(47, 4, 11, '2023-06-22 22:35:45', '2023-06-22 22:35:45'),
(53, 1, 12, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(54, 2, 12, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(55, 3, 12, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(56, 4, 12, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(57, 5, 12, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(58, 1, 13, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(59, 2, 13, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(60, 3, 13, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(61, 4, 13, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(62, 5, 13, '2023-06-22 22:37:14', '2023-06-22 22:37:14'),
(68, 1, 14, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(69, 2, 14, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(70, 3, 14, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(71, 4, 14, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(72, 6, 14, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(73, 1, 15, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(74, 2, 15, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(75, 3, 15, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(76, 4, 15, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(77, 6, 15, '2023-06-22 22:39:18', '2023-06-22 22:39:18'),
(86, 1, 16, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(87, 2, 16, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(88, 3, 16, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(89, 4, 16, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(90, 7, 16, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(91, 8, 16, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(92, 6, 16, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(93, 5, 16, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(94, 1, 17, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(95, 2, 17, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(96, 3, 17, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(97, 4, 17, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(98, 7, 17, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(99, 8, 17, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(100, 6, 17, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(101, 5, 17, '2023-06-22 22:40:59', '2023-06-22 22:40:59'),
(109, 1, 18, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(110, 2, 18, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(111, 3, 18, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(112, 4, 18, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(113, 7, 18, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(114, 8, 18, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(115, 6, 18, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(116, 1, 19, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(117, 2, 19, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(118, 3, 19, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(119, 4, 19, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(120, 7, 19, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(121, 8, 19, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(122, 6, 19, '2023-06-22 22:43:26', '2023-06-22 22:43:26'),
(129, 1, 20, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(130, 2, 20, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(131, 3, 20, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(132, 4, 20, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(133, 8, 20, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(134, 9, 20, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(135, 1, 21, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(136, 2, 21, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(137, 3, 21, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(138, 4, 21, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(139, 8, 21, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(140, 9, 21, '2023-06-22 22:46:01', '2023-06-22 22:46:01'),
(153, 1, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(154, 2, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(155, 3, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(156, 4, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(157, 5, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(158, 6, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(159, 7, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(160, 8, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(161, 9, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(162, 10, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(163, 11, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(164, 12, 22, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(165, 1, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(166, 2, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(167, 3, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(168, 4, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(169, 5, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(170, 6, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(171, 7, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(172, 8, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(173, 9, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(174, 10, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(175, 11, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(176, 12, 23, '2023-06-22 22:48:20', '2023-06-22 22:48:20'),
(178, 3, 24, '2023-06-22 22:54:11', '2023-06-22 22:54:11'),
(179, 3, 25, '2023-06-22 22:54:11', '2023-06-22 22:54:11'),
(181, 3, 26, '2023-06-22 22:55:22', '2023-06-22 22:55:22'),
(182, 3, 27, '2023-06-22 22:55:22', '2023-06-22 22:55:22'),
(184, 13, 28, '2023-06-22 22:58:26', '2023-06-22 22:58:26'),
(185, 13, 29, '2023-06-22 22:58:26', '2023-06-22 22:58:26'),
(187, 14, 30, '2023-06-22 22:59:51', '2023-06-22 22:59:51'),
(188, 14, 31, '2023-06-22 22:59:51', '2023-06-22 22:59:51'),
(189, 1, 32, '2023-06-22 23:00:40', '2023-06-22 23:00:40'),
(190, 4, 32, '2023-06-22 23:00:40', '2023-06-22 23:00:40'),
(191, 1, 33, '2023-06-22 23:01:24', '2023-06-22 23:01:24'),
(192, 4, 33, '2023-06-22 23:01:24', '2023-06-22 23:01:24'),
(193, 3, 33, '2023-06-22 23:01:24', '2023-06-22 23:01:24'),
(194, 1, 34, '2023-06-22 23:02:26', '2023-06-22 23:02:26'),
(195, 4, 34, '2023-06-22 23:02:26', '2023-06-22 23:02:26'),
(196, 3, 34, '2023-06-22 23:02:26', '2023-06-22 23:02:26'),
(197, 6, 34, '2023-06-22 23:02:26', '2023-06-22 23:02:26'),
(198, 1, 35, '2023-06-22 23:03:48', '2023-06-22 23:03:48'),
(199, 4, 35, '2023-06-22 23:03:48', '2023-06-22 23:03:48'),
(200, 3, 35, '2023-06-22 23:03:48', '2023-06-22 23:03:48'),
(201, 1, 36, '2023-06-22 23:04:47', '2023-06-22 23:04:47'),
(202, 4, 36, '2023-06-22 23:04:47', '2023-06-22 23:04:47'),
(203, 13, 36, '2023-06-22 23:04:47', '2023-06-22 23:04:47'),
(219, 1, 37, '2023-07-12 14:35:06', '2023-07-12 14:35:06'),
(220, 2, 37, '2023-07-12 14:35:06', '2023-07-12 14:35:06'),
(221, 4, 37, '2023-07-12 14:35:06', '2023-07-12 14:35:06'),
(222, 1, 38, '2023-07-12 14:35:06', '2023-07-12 14:35:06'),
(223, 2, 38, '2023-07-12 14:35:06', '2023-07-12 14:35:06'),
(224, 4, 38, '2023-07-12 14:35:06', '2023-07-12 14:35:06'),
(225, 1, 39, '2023-08-31 19:03:51', '2023-08-31 19:03:51'),
(226, 2, 39, '2023-08-31 19:03:52', '2023-08-31 19:03:52'),
(227, 4, 39, '2023-08-31 19:03:52', '2023-08-31 19:03:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `system_menu`
--

CREATE TABLE `system_menu` (
  `id` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `logo` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `system_menu`
--

INSERT INTO `system_menu` (`id`, `nombre`, `logo`, `created_at`, `updated_at`) VALUES
(1, 'Inventario', 'mdi mdi-package', '2023-08-11 21:02:36', '2023-08-11 21:02:36'),
(2, 'Compras', 'mdi mdi-package', '2021-06-11 19:46:42', '2021-06-11 19:46:42'),
(3, 'Usuarios', 'mdi mdi-face-profile', '2023-06-05 21:18:43', '2023-06-05 21:18:43'),
(4, 'Reportes', 'mdi mdi-chart-line', '2023-06-05 21:18:49', '2023-06-05 21:18:49'),
(5, 'Ventas', 'mdi mdi-cash-multiple', '2023-06-05 21:20:10', '2023-06-05 21:20:10'),
(6, 'Pagos', 'mdi mdi-square-inc-cash', '2023-06-05 21:14:13', '2023-06-05 21:14:13'),
(7, 'Servicios', 'mdi mdi-format-list-bulleted-type', '2023-06-22 22:32:32', '2023-06-22 22:32:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `system_menu_role`
--

CREATE TABLE `system_menu_role` (
  `id_role` int(10) UNSIGNED DEFAULT NULL,
  `id_menu` int(10) UNSIGNED DEFAULT NULL,
  `id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `system_menu_role`
--

INSERT INTO `system_menu_role` (`id_role`, `id_menu`, `id`) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(1, 4, 4),
(1, 5, 5),
(1, 6, 6),
(1, 7, 7),
(1, 8, 8),
(11, 5, 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `system_submenu`
--

CREATE TABLE `system_submenu` (
  `id` int(10) UNSIGNED NOT NULL,
  `id_menu` int(10) UNSIGNED DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  `permiso_requerido` varchar(100) DEFAULT NULL,
  `logo` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `system_submenu`
--

INSERT INTO `system_submenu` (`id`, `id_menu`, `nombre`, `url`, `permiso_requerido`, `logo`, `created_at`, `updated_at`) VALUES
(1, 1, 'Productos', '/producto', NULL, 'mdi mdi-chevron-double-right', '2023-08-11 21:31:58', '2023-08-11 21:31:58'),
(2, 2, 'Inicio', '/compra', NULL, 'mdi mdi-chevron-double-right', '2021-10-21 09:30:44', '2021-10-21 09:30:44'),
(3, 3, 'Inicio', '/usuarios/inicio', NULL, 'mdi mdi-chevron-double-right', '2023-05-11 15:59:18', '2023-05-11 15:59:18'),
(4, 3, ' Registro personal', '/usuarios/creacion', NULL, 'mdi mdi-chevron-double-right', '2023-05-11 16:44:33', '2023-05-11 16:44:33'),
(5, 4, 'Ingreso vs Egresos', '/reports/Ingreso-Egreso', NULL, 'mdi mdi-chevron-double-right', '2023-06-06 00:16:38', '2023-06-06 00:16:38'),
(7, 4, 'Utilidad por Mes', '/reports/utilidad-mes', NULL, 'mdi mdi-chevron-double-right', '2023-06-08 22:09:09', '2023-06-08 22:09:09'),
(8, 5, 'Listado ventas', '/venta', NULL, 'mdi mdi-chevron-double-right', '2023-06-22 22:25:35', '2023-06-22 22:25:35'),
(9, 6, 'Usuarios', '/usuarios/ventas', NULL, 'mdi mdi-chevron-double-right', '2023-06-05 21:23:32', '2023-06-05 21:23:32'),
(10, 7, 'Inicio', '/servicio', NULL, 'mdi mdi-chevron-double-right', '2023-06-06 19:06:51', '2023-06-06 19:06:51'),
(11, 4, 'Ventas por Servicio', '/reports/ventas-servicio', NULL, 'mdi mdi-chevron-double-right', '2023-06-08 21:55:17', '2023-06-08 21:55:17'),
(12, 5, 'Generar venta', '/venta/create', NULL, 'mdi mdi-car-wash', '2023-06-22 22:26:47', '2023-06-22 22:26:47'),
(13, 5, 'Generar venta tienda', '/venta/create-market', NULL, 'mdi mdi-shopping ', '2023-06-22 22:26:47', '2023-06-22 22:26:47');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_producto`
--

CREATE TABLE `tipo_producto` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `tipo_producto`
--

INSERT INTO `tipo_producto` (`id`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'filtro aceite', '2023-06-06 20:47:23', '2023-06-06 20:47:23'),
(2, 'filtros aire', '2023-06-06 20:59:01', '2023-06-06 20:59:01'),
(3, 'lubricante cadena', '2023-06-06 20:59:47', '2023-06-06 20:59:47'),
(4, 'elevador octanaje', '2023-06-06 21:00:42', '2023-06-06 21:00:42'),
(5, 'agua bateria', '2023-06-06 21:04:18', '2023-06-06 21:04:18'),
(6, 'Bebidas', '2023-06-10 19:25:41', '2023-06-10 19:25:41'),
(7, 'mecato', '2023-06-22 23:52:03', '2023-06-22 23:52:03'),
(8, 'dulceria', '2023-06-28 05:11:35', '2023-06-28 05:11:35'),
(9, 'mecato', '2023-07-02 19:17:16', '2023-07-02 19:17:16'),
(11, 'aceite', '2023-07-12 12:53:21', '2023-07-12 12:53:21'),
(12, 'refrigerante verde', '2023-07-12 13:10:39', '2023-07-12 13:10:39'),
(13, 'aceite hidraulico', '2023-07-28 13:26:13', '2023-07-28 13:26:13'),
(14, 'liquido de frenos', '2023-07-28 14:31:38', '2023-07-28 14:31:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_vehiculo`
--

CREATE TABLE `tipo_vehiculo` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `imagen` varchar(45) DEFAULT NULL,
  `nomenclatura` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `tipo_vehiculo`
--

INSERT INTO `tipo_vehiculo` (`id`, `descripcion`, `imagen`, `nomenclatura`, `created_at`, `updated_at`) VALUES
(1, 'AUTOMOVIL', '/images/car.png', 'C', '2023-06-06 14:10:04', '2023-06-06 14:10:04'),
(2, 'CAMIONETA', '/images//pickup_truck.png', 'C', '2023-06-06 14:10:04', '2023-06-06 14:10:04'),
(3, 'MOTO', '/images/moto1.png', 'M', '2023-06-06 14:10:16', '2023-06-06 14:10:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `unidad_medida`
--

CREATE TABLE `unidad_medida` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `abreviatura` varchar(45) DEFAULT NULL,
  `estado` int(11) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `unidad_medida`
--

INSERT INTO `unidad_medida` (`id`, `nombre`, `abreviatura`, `estado`, `created_at`, `updated_at`) VALUES
(1, 'Unidad', 'Ud', 1, '2023-06-06 15:48:53', '2023-06-06 15:48:53'),
(2, 'Mililitros', 'ML', 1, '2023-06-06 15:48:53', '2023-06-06 15:48:53'),
(3, 'Litro', 'Lt', 1, '2023-06-16 16:41:35', '2023-06-16 16:41:35'),
(4, 'CM', 'CM', 1, '2023-06-22 23:54:59', '2023-06-22 23:54:59'),
(5, 'Galon', 'gal', 1, '2023-07-12 18:44:37', '2023-07-12 18:44:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `identificacion` varchar(45) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `estado` bigint(20) DEFAULT 1,
  `password` varchar(255) DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `direccion` varchar(60) DEFAULT NULL,
  `telefono` varchar(25) DEFAULT NULL,
  `celular` varchar(25) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` varchar(10) DEFAULT NULL,
  `lugar_expedicion` varchar(60) DEFAULT NULL,
  `cargo` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `identificacion`, `name`, `estado`, `password`, `remember_token`, `email`, `created_at`, `updated_at`, `direccion`, `telefono`, `celular`, `fecha_nacimiento`, `genero`, `lugar_expedicion`, `cargo`) VALUES
(3, '18783367', 'José Antonio Rondon marchan', 1, '$2y$10$U38o/XXteupYntiTC2TONOzPz/m.N5GrHhWxFH2VYvu1QEx1UfjYy', 'QlkDw6hDT6ZYJDUE77F68RvCYqG1XemV463mFvczTTcaZGKJGnkEs5KfzURg', '', NULL, NULL, NULL, NULL, '', NULL, 'M', NULL, '12'),
(7, '26161240', 'Luis Eduardo granada Cardenas', 1, '$2y$10$YYtPc5F1kNTmhMbX0MsCjuor6PurERBs/EX3q93GduteFVH8I6cqe', 'a64sYSHCW1iGdXnheQFxXb8nPRhtkdXznWTS0s14b5pNhn1Fwn2M01owJ1sP', 'a@g.com', NULL, NULL, NULL, NULL, '0', '1970-01-01', 'M', NULL, '12'),
(8, '1118300165', 'Jhoan estiven montilla valencia', 1, '$2y$10$WscmCd.D1dMxoBWJPrCSBuik91HapXQssxEM7xk65psjQ8709fLle', NULL, 'a@a.com', NULL, NULL, NULL, NULL, '0', '1970-01-01', 'M', NULL, '12'),
(9, '26460567', 'Jaciel Isaac Gutiérrez green', 1, '$2y$10$91JmoU9tVD3GEdCuGptAZ.dJg6xsselxYTNlsbh3ihUBfNRaj5qKu', NULL, 'a@a.com', NULL, NULL, NULL, NULL, '0', '1970-01-01', 'M', NULL, '12'),
(10, '1116259644', 'Miguel Ángel zapata Betancourt', 1, '$2y$10$bSUbaolAKNhQ6TD5aqi4hurV3QiQJMY.3apKPWQERoPPuIs9hOC.a', NULL, 'j@a.com', NULL, NULL, NULL, NULL, '0', '1970-01-01', 'M', NULL, '12'),
(11, '30764925', 'Dylan yovaniher vivas Hernandez', 1, '$2y$10$P4y196D5eknc9mB7p87f1.GliQpPl/4CjzI35/KWOQ/e7hN3Xe99G', NULL, 'j@prueba.com', NULL, NULL, NULL, NULL, '0', '1970-01-01', 'M', NULL, '12'),
(12, '10472265', 'Alberto arboleda Ortiz', 1, '$2y$10$l1dN3offM4V2PbXD9xLSkehWz3Z3GKUScIvZhIFdK7iIisE11OrMK', NULL, 'j@prueba.com', NULL, NULL, NULL, NULL, '0', '1970-01-01', 'M', NULL, '12'),
(13, '1111111', 'vendedor lavadero', 0, '$2y$10$jbWrS6mxOH8Jfhdh3GU49Ox5cP1svfXN0GB6AnsDVl2boodYlMGA2', '7V15k2OOVajJAWmhGFAMjZEsMCtGFYWqb1ktj5vyCPDtdTQdTSLXyXYCBqOU', 'j@prueba.com', NULL, NULL, NULL, NULL, '0', '1970-01-01', 'M', NULL, '11'),
(14, '222222', 'Vendedor Tienda', 1, '$2y$10$DH.LlMhjAHAI1DGVHluDQ.VNIruW45FFw5Hv0E98hGxIQpBt7YW8q', NULL, 'j@g.com', NULL, NULL, NULL, '3160414788', '0', '2010-07-22', 'M', 'CALI', '10'),
(15, '1144189073', 'Jorge andres diaz cruz', 1, '$2y$10$udriLVQXjTSonVx6A4MYYurNTErUPvWDgsI/s8BKcmkHIMah4xMAq', 'RCqwoqSrRYqM8RzzpsWGPySBRm8Waj6peLsTZgvRo1XXblNtMxi2lyBShw9K', 'j@prueba.com', NULL, NULL, NULL, NULL, '0', '1969-12-31', 'M', NULL, '1'),
(16, '14036722', 'Enrique diaz', 1, '$2y$10$4QyrhLFX0QozgO0.IFeU..W5UZOTPgblxtKjVeW35QhU57Y9hDTRu', NULL, 'diazrondonhectorenrrique@gnail.com', NULL, NULL, 'Manzama10casa 77', NULL, '3143148800', '1977-05-14', 'M', 'Venezuela', '12'),
(17, '000', 'Sin Prestador', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '12'),
(18, '29505900', 'olga cecilia galeano rojas', 1, '$2y$10$O6Mwro316ghAdt3UY7.i1On9k135jMfd0NmJLBzYQnaK/zBUuO9DG', NULL, 'olgagaleano1978@hotmail.com', NULL, NULL, 'calle 57 an #2fn -41', NULL, '3128375719', '1978-12-02', 'F', 'florida', '10'),
(19, '1113623378', 'luis miguel cataño jimenez', 1, '$2y$10$Rj8qOcHBo4kGNVX0amX.OuMcG8vR46VPsH4T4yhaDkJufOYgQ46ya', 'szwVlH6EQChMMCFuvMd3ud7cDsLUrXzFpQZwbM6MnKFg3vqJe2tXxAtBn0R2', 'lumicaji86@gmail.com', NULL, NULL, 'calle 32b#3619', NULL, '3173800589', '1986-11-06', 'M', 'palmira', '11'),
(20, '16916512', 'jhon fredy narvaez rincon', 1, '$2y$10$swVrKxUB.cdsn9q9BMGLv.kQQYamIw81i4FiSbw54G22V9eJPaeX.', NULL, 'andres_19_0@hotmail.com', NULL, NULL, NULL, NULL, '3188063981', '1980-02-24', 'M', 'cali', '12'),
(21, '55208040', 'rocio julith perdomo', 1, '$2y$10$jkNUBVNMiImMF9UK3uLxTePq97KNVKoXz7tc0i07UIlXYhkJqGjES', NULL, 'andres_19_0@hotmail.com', NULL, NULL, 'sector 4', NULL, '3243997333', '1983-02-23', 'F', 'acevedo huila', '12'),
(22, '1106516121', 'dilas stiven reina zapata', 1, '$2y$10$b6WsFNc2xyimvywVN2AQ5.T3Btwqp1hu/G6Dmhp7L90.P.FRu17bS', NULL, 'dilanestiven1989@gmail.com', NULL, NULL, 'manzana 11 casa 40', NULL, '3165495343', '2007-05-25', 'M', 'cali', '12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `id` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `nombre_cliente` varchar(80) NOT NULL,
  `placa` varchar(45) DEFAULT NULL,
  `numero_telefono` varchar(45) DEFAULT NULL,
  `id_detalle_paquete` int(11) DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_estado_venta` int(11) NOT NULL COMMENT '1 = Pendiente por pagar , 2 = Servicio pagado , 3 = Venta Productos',
  `fecha_pago` datetime DEFAULT NULL,
  `total_venta` float NOT NULL,
  `precio_venta_paquete` float NOT NULL,
  `porcentaje_paquete` int(11) NOT NULL,
  `updated_at` datetime DEFAULT current_timestamp(),
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `venta`
--

INSERT INTO `venta` (`id`, `fecha`, `nombre_cliente`, `placa`, `numero_telefono`, `id_detalle_paquete`, `id_usuario`, `id_estado_venta`, `fecha_pago`, `total_venta`, `precio_venta_paquete`, `porcentaje_paquete`, `updated_at`, `created_at`) VALUES
(12, '2023-08-28 03:23:49', 'Oscar', 'ANQ82E', '3166896629', 32, 20, 2, '2023-08-28 06:37:03', 14000, 14000, 40, '2023-08-28 15:23:49', '2023-08-28 15:23:49'),
(13, '2023-08-28 03:28:03', 'Luis', 'KCJ97', '3146570535', 32, 10, 2, '2023-08-28 07:12:27', 14000, 14000, 40, '2023-08-28 15:28:03', '2023-08-28 15:28:03'),
(14, '2023-08-28 03:32:11', 'Alwx', 'MMF 082', '3167456265', 14, 12, 2, '2023-08-28 07:12:49', 55000, 55000, 40, '2023-08-28 15:32:11', '2023-08-28 15:32:11'),
(15, '2023-08-28 03:33:26', 'Jose rubiamo', 'FQE04F', '3219954642', 32, 20, 2, '2023-08-28 06:37:03', 14000, 14000, 40, '2023-08-28 15:33:26', '2023-08-28 15:33:26'),
(16, '2023-08-28 03:35:12', 'David', 'MSY927', '3158222759', 34, 16, 2, '2023-08-28 06:24:56', 20000, 20000, 40, '2023-08-28 15:35:12', '2023-08-28 15:35:12'),
(17, '2023-08-28 03:37:00', 'Albaro luis', 'HBE12A', '3182644534', 32, 3, 2, '2023-08-28 06:23:20', 14000, 14000, 40, '2023-08-28 15:37:00', '2023-08-28 15:37:00'),
(18, '2023-08-28 03:42:34', 'Andres', 'UBS114', '3226869903', 25, 11, 2, '2023-08-28 06:31:20', 30000, 30000, 40, '2023-08-28 15:42:34', '2023-08-28 15:42:34'),
(19, '2023-08-28 03:48:52', 'Carlos', 'DVG43F', '3153506067', 32, 12, 2, '2023-08-28 07:12:49', 14000, 14000, 40, '2023-08-28 15:48:52', '2023-08-28 15:48:52'),
(20, '2023-08-28 03:50:26', 'Estiven', 'JDZ55G', '3206183438', 32, 20, 2, '2023-08-28 06:37:03', 14000, 14000, 40, '2023-08-28 15:50:26', '2023-08-28 15:50:26'),
(21, '2023-08-28 03:52:49', 'Jhon eider', 'FUS28F', '3161915558', 32, 3, 2, '2023-08-28 06:23:20', 14000, 14000, 40, '2023-08-28 15:52:49', '2023-08-28 15:52:49'),
(22, '2023-08-28 03:54:21', 'Marina perez', 'WGQ15C', '3183943562', 33, 10, 2, '2023-08-28 07:12:27', 16000, 16000, 40, '2023-08-28 15:54:21', '2023-08-28 15:54:21'),
(23, '2023-08-28 03:55:35', 'Yessica', 'JIF46F', '3117176150', 33, 20, 2, '2023-08-28 06:37:03', 16000, 16000, 40, '2023-08-28 15:55:35', '2023-08-28 15:55:35'),
(24, '2023-08-28 03:57:55', 'Orlando garca', 'GSZ297', '3207215958', 25, 10, 2, '2023-08-28 07:12:27', 30000, 30000, 40, '2023-08-28 15:57:55', '2023-08-28 15:57:55'),
(25, '2023-08-28 04:01:08', 'Gonzalo martinez', 'ESY92F', '3182216798', 34, 3, 2, '2023-08-28 06:23:20', 20000, 20000, 40, '2023-08-28 16:01:08', '2023-08-28 16:01:08'),
(26, '2023-08-28 04:02:37', 'Ewduar', 'AJI66E', '3226384975', 32, 3, 2, '2023-08-28 06:23:20', 14000, 14000, 40, '2023-08-28 16:02:37', '2023-08-28 16:02:37'),
(27, '2023-08-28 04:04:32', 'SEBASTIAn giraldo', 'LXM92', '3152146885', 17, 11, 2, '2023-08-28 06:31:20', 70000, 70000, 40, '2023-08-28 16:04:32', '2023-08-28 16:04:32'),
(28, '2023-08-28 04:05:46', 'Sabastian giraldo', 'LXM932', '3152146885', 17, 11, 2, '2023-08-28 06:31:20', 70000, 70000, 40, '2023-08-28 16:05:46', '2023-08-28 16:05:46'),
(29, '2023-08-28 04:07:16', 'Camilo vargas', 'RMW424', '3126569727', 37, 12, 2, '2023-08-28 07:12:49', 20000, 20000, 40, '2023-08-28 16:07:16', '2023-08-28 16:07:16'),
(30, '2023-08-28 04:08:17', 'Luis Carlos gomez', 'DTP670', '3158774079', 37, 16, 2, '2023-08-28 06:24:56', 20000, 20000, 40, '2023-08-28 16:08:17', '2023-08-28 16:08:17'),
(31, '2023-08-28 04:09:30', 'Cristián Cerón', 'VWE09G', '3152852989', 34, 3, 2, '2023-08-28 06:23:20', 20000, 20000, 40, '2023-08-28 16:09:30', '2023-08-28 16:09:30'),
(32, '2023-08-28 04:11:13', 'Carlos', 'MKP932', '3025896746', 37, 10, 2, '2023-08-28 07:12:27', 20000, 20000, 40, '2023-08-28 16:11:13', '2023-08-28 16:11:13'),
(33, '2023-08-28 04:12:18', 'Alberto', 'MLR96G', '3137891996', 32, 20, 2, '2023-08-28 06:37:03', 14000, 14000, 40, '2023-08-28 16:12:18', '2023-08-28 16:12:18'),
(34, '2023-08-28 04:13:36', 'Alejandro', 'KNA02G', '3214569807', 34, 3, 2, '2023-08-28 06:23:20', 20000, 20000, 40, '2023-08-28 16:13:36', '2023-08-28 16:13:36'),
(35, '2023-08-28 04:14:57', 'Andrea garcia', 'VGR559', '3102943647', 10, 16, 2, '2023-08-28 06:24:56', 35000, 35000, 40, '2023-08-28 16:14:57', '2023-08-28 16:14:57'),
(36, '2023-08-28 04:45:52', 'Gustavo restrepo', 'RIY219', '3107211908', NULL, 20, 1, NULL, 0, 0, 0, '2023-08-28 16:45:52', '2023-08-28 16:45:52'),
(37, '2023-08-28 05:09:33', 'Jose rubiano', 'JIN302', '3219954642', 37, 3, 2, '2023-08-28 06:23:20', 20000, 20000, 40, '2023-08-28 17:09:33', '2023-08-28 17:09:33'),
(38, '2023-08-28 05:10:35', 'Gustavo', 'PSQ32G', '3145963462', 33, 10, 2, '2023-08-28 07:12:27', 16000, 16000, 40, '2023-08-28 17:10:35', '2023-08-28 17:10:35'),
(39, '2023-08-28 05:11:49', 'Alejandra', 'DUE15F', '3145034615', 33, 11, 2, '2023-08-28 06:31:20', 16000, 16000, 40, '2023-08-28 17:11:49', '2023-08-28 17:11:49'),
(40, '2023-08-28 06:04:51', 'Maeacucho', 'CLU 15 C', '3166256386', 32, 3, 2, '2023-08-28 06:23:20', 14000, 14000, 40, '2023-08-28 18:04:51', '2023-08-28 18:04:51'),
(41, '2023-08-28 06:05:38', 'Julio', 'IFX 16B', '3178461870', 32, 12, 2, '2023-08-28 07:12:49', 14000, 14000, 40, '2023-08-28 18:05:38', '2023-08-28 18:05:38'),
(42, '2023-08-28 06:34:46', 'Harol', 'GJL 423', '312546389', 26, 20, 2, '2023-08-28 06:37:03', 50000, 50000, 40, '2023-08-28 18:34:46', '2023-08-28 18:34:46'),
(43, '2023-08-29 09:58:00', 'Ricardo rosriguez', 'CLE69G', '3104309979', 32, 20, 2, '2023-08-29 05:40:07', 14000, 14000, 40, '2023-08-29 09:58:00', '2023-08-29 09:58:00'),
(44, '2023-08-29 09:59:29', 'Diego davila', 'KLN078', '3162368041', 32, 16, 2, '2023-08-30 06:15:23', 14000, 14000, 40, '2023-08-29 09:59:29', '2023-08-29 09:59:29'),
(45, '2023-08-29 10:00:33', 'Luis ZAPATa', 'JFS078', '3142482022', 37, 12, 2, '2023-08-29 05:40:58', 20000, 20000, 40, '2023-08-29 10:00:33', '2023-08-29 10:00:33'),
(46, '2023-08-29 10:57:55', 'Taller', 'PBL79C', '3206753934', 32, 3, 2, '2023-08-29 05:38:54', 14000, 14000, 40, '2023-08-29 10:57:55', '2023-08-29 10:57:55'),
(47, '2023-08-29 12:19:56', 'Luis Alfredo', 'FLQ465', '314765363', 16, 10, 2, '2023-08-29 05:39:43', 60000, 60000, 40, '2023-08-29 12:19:56', '2023-08-29 12:19:56'),
(48, '2023-08-29 12:27:56', 'Katalina', 'LKY246', '3162381668', 38, 10, 2, '2023-08-29 05:39:43', 35000, 35000, 40, '2023-08-29 12:27:56', '2023-08-29 12:27:56'),
(49, '2023-08-29 12:46:49', 'Jorman', 'NZR96G', '3002213698', 32, 3, 2, '2023-08-29 05:38:54', 14000, 14000, 40, '2023-08-29 12:46:49', '2023-08-29 12:46:49'),
(50, '2023-08-29 03:14:11', 'KATErine loaiza', 'CWO562', '319220266', 10, 12, 2, '2023-08-29 05:40:58', 35000, 35000, 40, '2023-08-29 15:14:11', '2023-08-29 15:14:11'),
(51, '2023-08-29 04:53:15', 'Jwferson', 'THD34F', '3015695579', 32, 20, 2, '2023-08-29 05:40:07', 14000, 14000, 40, '2023-08-29 16:53:15', '2023-08-29 16:53:15'),
(52, '2023-08-30 03:13:39', 'Cristián', 'HMP079', '3153698372', 38, 12, 2, '2023-08-30 06:34:58', 35000, 35000, 40, '2023-08-30 15:13:39', '2023-08-30 15:13:39'),
(53, '2023-08-30 03:16:23', 'Juan', 'DDZ 842', '3153698372', 11, 20, 2, '2023-08-30 06:33:58', 45000, 45000, 40, '2023-08-30 15:16:23', '2023-08-30 15:16:23'),
(54, '2023-08-30 03:17:33', 'Alberto', 'NCK 526', '3153698372', 37, 3, 2, '2023-08-30 06:37:18', 20000, 20000, 40, '2023-08-30 15:17:33', '2023-08-30 15:17:33'),
(55, '2023-08-30 03:18:20', 'Daniel', 'HMO 770', '3013382764', 37, 12, 2, '2023-08-30 06:34:58', 20000, 20000, 40, '2023-08-30 15:18:20', '2023-08-30 15:18:20'),
(56, '2023-08-30 03:19:16', 'Killy', 'OSY 39F', '3157705627', 32, 10, 2, '2023-08-30 06:49:31', 14000, 14000, 40, '2023-08-30 15:19:16', '2023-08-30 15:19:16'),
(57, '2023-08-30 03:20:07', 'Jhon', 'FNZ 58E', '3103602637', 33, 11, 2, '2023-08-30 06:35:16', 16000, 16000, 40, '2023-08-30 15:20:07', '2023-08-30 15:20:07'),
(58, '2023-08-30 03:20:54', 'Leidy', 'KRJ32F', '3133931211', 32, 9, 2, '2023-08-30 06:37:58', 14000, 14000, 40, '2023-08-30 15:20:54', '2023-08-30 15:20:54'),
(59, '2023-08-30 03:21:42', 'Esthepanie', 'RRO096', '3157895247', 32, 3, 2, '2023-08-30 06:37:18', 14000, 14000, 40, '2023-08-30 15:21:42', '2023-08-30 15:21:42'),
(60, '2023-08-30 03:22:36', 'Juan camilo', 'HBL 957', '3104045493', 37, 20, 2, '2023-08-30 06:33:58', 20000, 20000, 40, '2023-08-30 15:22:36', '2023-08-30 15:22:36'),
(61, '2023-08-30 03:23:42', 'Kevin', 'DRR 623', '3127169219', 16, 10, 2, '2023-08-30 06:49:31', 60000, 60000, 40, '2023-08-30 15:23:42', '2023-08-30 15:23:42'),
(62, '2023-08-30 03:25:57', 'Nestor', 'CPM 772', '3165308950', 37, 3, 2, '2023-08-30 06:37:18', 20000, 20000, 40, '2023-08-30 15:25:57', '2023-08-30 15:25:57'),
(63, '2023-08-30 03:35:08', 'Luis', 'IVP 101', '3154316045', 37, 11, 2, '2023-08-30 06:35:16', 20000, 20000, 40, '2023-08-30 15:35:08', '2023-08-30 15:35:08'),
(64, '2023-08-30 03:46:23', 'Javier', 'DSL 50G', '3104911429', 32, 9, 2, '2023-08-30 06:37:58', 14000, 14000, 40, '2023-08-30 15:46:23', '2023-08-30 15:46:23'),
(65, '2023-08-30 03:59:55', 'SERGIo', 'LSQ 460', '3207211496', 10, 20, 2, '2023-08-30 06:33:58', 35000, 35000, 40, '2023-08-30 15:59:55', '2023-08-30 15:59:55'),
(66, '2023-08-30 04:02:20', 'Daniela', 'XRG 74F', '3175989153', 32, 10, 2, '2023-08-30 06:49:31', 14000, 14000, 40, '2023-08-30 16:02:20', '2023-08-30 16:02:20'),
(67, '2023-08-30 04:22:26', 'Eduardo', 'GND 78F', '316625686', 32, 11, 2, '2023-08-30 06:35:16', 14000, 14000, 40, '2023-08-30 16:22:26', '2023-08-30 16:22:26'),
(68, '2023-08-30 04:28:02', 'Luis Fernando', 'OOG 39G', '3203224081', 33, 9, 2, '2023-08-30 06:37:58', 16000, 16000, 40, '2023-08-30 16:28:02', '2023-08-30 16:28:02'),
(69, '2023-08-30 05:02:27', 'Willian', 'IVQ058', '3054728439', 20, 10, 2, '2023-08-30 06:49:31', 95000, 95000, 40, '2023-08-30 17:02:27', '2023-08-30 17:02:27'),
(70, '2023-08-30 05:09:50', 'Brandon', 'AEI 39D', '3128831046', 32, 11, 2, '2023-08-30 06:35:16', 14000, 14000, 40, '2023-08-30 17:09:50', '2023-08-30 17:09:50'),
(71, '2023-08-30 05:22:11', 'Leidy', 'HML 463', '3188203653', 37, 12, 2, '2023-08-30 06:34:58', 20000, 20000, 40, '2023-08-30 17:22:11', '2023-08-30 17:22:11'),
(72, '2023-08-30 05:59:52', 'Sandra', 'GDW 74G', '3104628630', 32, 20, 2, '2023-08-30 06:33:58', 14000, 14000, 40, '2023-08-30 17:59:52', '2023-08-30 17:59:52'),
(73, '2023-08-31 08:19:34', 'Estiven', 'JTN725', '3114355368', 37, 20, 2, '2023-08-31 07:00:48', 20000, 20000, 40, '2023-08-31 08:19:34', '2023-08-31 08:19:34'),
(74, '2023-08-31 08:22:49', 'José sineatera', 'FHY62B', '3176802961', 32, 16, 2, '2023-08-31 07:09:38', 14000, 14000, 40, '2023-08-31 08:22:49', '2023-08-31 08:22:49'),
(75, '2023-08-31 09:09:06', 'Freddy londoño', 'KID253', '3154123858', 10, 21, 2, '2023-08-31 06:53:45', 35000, 35000, 40, '2023-08-31 09:09:06', '2023-08-31 09:09:06'),
(76, '2023-08-31 09:11:52', 'Luis llanos', 'JFW849', '3165774550', 16, 11, 2, '2023-08-31 07:26:14', 60000, 60000, 40, '2023-08-31 09:11:52', '2023-08-31 09:11:52'),
(77, '2023-08-31 09:45:22', 'Esteban guzman', 'IVP626', '3057124654', 11, 9, 2, '2023-08-31 07:30:28', 45000, 45000, 40, '2023-08-31 09:45:22', '2023-08-31 09:45:22'),
(78, '2023-08-31 09:48:09', 'Marcos', 'DVO93F', '3162568509', 32, 10, 2, '2023-08-31 07:45:34', 14000, 14000, 40, '2023-08-31 09:48:09', '2023-08-31 09:48:09'),
(79, '2023-08-31 10:15:09', 'Maira', 'PXQ45F', '3132944866', 32, 3, 2, '2023-08-31 06:57:52', 14000, 14000, 40, '2023-08-31 10:15:09', '2023-08-31 10:15:09'),
(80, '2023-08-31 11:27:08', 'Jerson', 'TBQ20E', '3122488532', 32, 16, 2, '2023-08-31 07:09:38', 14000, 14000, 40, '2023-08-31 11:27:08', '2023-08-31 11:27:08'),
(81, '2023-08-31 11:32:06', 'Yefwrson ramires', 'KVP033', '3146211632', 37, 10, 2, '2023-08-31 07:45:34', 20000, 20000, 40, '2023-08-31 11:32:06', '2023-08-31 11:32:06'),
(82, '2023-08-31 11:47:22', 'Yeferson', 'HEY621', '3042525038', 16, 21, 2, '2023-08-31 06:53:45', 60000, 60000, 40, '2023-08-31 11:47:22', '2023-08-31 11:47:22'),
(83, '2023-08-31 11:53:03', 'Henao', 'KDT641', '3216452233', 16, 20, 2, '2023-08-31 07:00:48', 60000, 60000, 40, '2023-08-31 11:53:03', '2023-08-31 11:53:03'),
(84, '2023-08-31 11:56:32', 'Clara isabel', 'IZL003', '3103726387', 10, 16, 2, '2023-08-31 07:09:38', 35000, 35000, 40, '2023-08-31 11:56:32', '2023-08-31 11:56:32'),
(85, '2023-08-31 12:16:08', 'Michael diaz', 'LSU288', '3113506644', 19, 3, 2, '2023-08-31 06:57:52', 85000, 85000, 40, '2023-08-31 12:16:08', '2023-08-31 12:16:08'),
(86, '2023-08-31 12:44:06', 'Royer reyes', 'DVV55A', '3135493362', 32, 9, 2, '2023-08-31 07:30:28', 14000, 14000, 40, '2023-08-31 12:44:06', '2023-08-31 12:44:06'),
(87, '2023-08-31 01:04:58', 'Cecilia quijano', 'IPY318', '3218429831', 16, 11, 2, '2023-08-31 07:26:14', 60000, 60000, 40, '2023-08-31 13:04:58', '2023-08-31 13:04:58'),
(88, '2023-08-31 01:12:04', 'Ronalt reyws', 'CZW874', '3188916823', NULL, 17, 1, NULL, 0, 0, 0, '2023-08-31 13:12:04', '2023-08-31 13:12:04'),
(89, '2023-08-31 01:39:16', 'Ronat', 'CZW874', '3188916823', 37, 3, 2, '2023-08-31 06:57:52', 20000, 20000, 40, '2023-08-31 13:39:16', '2023-08-31 13:39:16'),
(90, '2023-08-31 01:43:03', 'Cecilia quijano', 'IPY318', '3218429831', 16, 11, 2, '2023-08-31 07:26:14', 60000, 60000, 40, '2023-08-31 13:43:03', '2023-08-31 13:43:03'),
(91, '2023-08-31 02:49:56', 'Edwin', 'ENU 360', '3182968446', 37, 10, 2, '2023-08-31 07:45:34', 20000, 20000, 40, '2023-08-31 14:49:56', '2023-08-31 14:49:56'),
(92, '2023-08-31 03:52:01', 'Hernbdo', 'RKQ804', '3142076691', 37, 20, 2, '2023-08-31 07:00:48', 20000, 20000, 40, '2023-08-31 15:52:01', '2023-08-31 15:52:01'),
(93, '2023-08-31 04:12:16', 'Jose', 'HEL341', '3107332266', 37, 16, 2, '2023-08-31 07:09:38', 20000, 20000, 40, '2023-08-31 16:12:16', '2023-08-31 16:12:16'),
(94, '2023-08-31 04:18:08', 'Ricardo narvaes', 'EUL55E', '3207158035', 32, 21, 2, '2023-08-31 06:53:45', 14000, 14000, 40, '2023-08-31 16:18:08', '2023-08-31 16:18:08'),
(95, '2023-08-31 04:29:02', 'Jose ramires', 'DEI72D', '3209474564', 32, 11, 2, '2023-08-31 07:26:14', 14000, 14000, 40, '2023-08-31 16:29:02', '2023-08-31 16:29:02'),
(96, '2023-08-31 04:41:16', 'Jhonathan maldonado', 'GSL592', '3106252973', 10, 9, 2, '2023-08-31 07:30:28', 35000, 35000, 40, '2023-08-31 16:41:16', '2023-08-31 16:41:16'),
(97, '2023-08-31 04:58:41', 'Estefany', 'TYD85F', '3158479316', 33, 21, 2, '2023-08-31 06:53:45', 16000, 16000, 40, '2023-08-31 16:58:41', '2023-08-31 16:58:41'),
(98, '2023-08-31 07:05:30', 'MIGUEL', 'VCG039', '3002223754', 39, 16, 2, '2023-08-31 07:09:38', 18000, 18000, 40, '2023-08-31 19:05:30', '2023-08-31 19:05:30'),
(99, '2023-08-31 07:07:14', 'JAIRO', 'MGR-58D', '3204879852', 33, 16, 2, '2023-08-31 07:09:38', 16000, 16000, 40, '2023-08-31 19:07:14', '2023-08-31 19:07:14'),
(100, '2023-08-31 07:42:04', 'DIEGO', 'XBO 54F', '3164251510', 32, 10, 2, '2023-08-31 07:45:34', 14000, 14000, 40, '2023-08-31 19:42:04', '2023-08-31 19:42:04'),
(101, '2023-09-01 07:51:24', 'Cristián asadero', 'QHR230', '3177508993', 10, 3, 2, '2023-09-01 06:38:56', 35000, 35000, 40, '2023-09-01 07:51:24', '2023-09-01 07:51:24'),
(102, '2023-09-01 07:55:01', 'Andrés Ospina', 'GSU376', '3233493730', 10, 20, 2, '2023-09-01 06:56:03', 35000, 35000, 40, '2023-09-01 07:55:01', '2023-09-01 07:55:01'),
(103, '2023-09-01 08:20:22', 'Daniel', 'QFR75E', '3136019724', 32, 12, 2, '2023-09-01 06:54:05', 14000, 14000, 40, '2023-09-01 08:20:22', '2023-09-01 08:20:22'),
(104, '2023-09-01 08:41:01', 'Leby plaza', 'ZBJ53D', '3233887952', 32, 21, 2, '2023-09-01 07:07:23', 14000, 14000, 40, '2023-09-01 08:41:01', '2023-09-01 08:41:01'),
(105, '2023-09-01 08:46:41', 'Carlos carvajal', 'RXG14G', '3153427106', 32, 16, 2, '2023-09-01 07:05:18', 14000, 14000, 40, '2023-09-01 08:46:41', '2023-09-01 08:46:41'),
(106, '2023-09-01 09:02:18', 'Leopoldo sapiensa', 'HQV919', '3124415139', 17, 10, 2, '2023-09-01 07:14:26', 70000, 70000, 40, '2023-09-01 09:02:18', '2023-09-01 09:02:18'),
(107, '2023-09-01 09:02:31', 'Leopoldo sapiensa', 'HQV919', '3124415139', 17, 10, 2, '2023-09-01 07:14:26', 70000, 70000, 40, '2023-09-01 09:02:31', '2023-09-01 09:02:31'),
(108, '2023-09-01 09:12:20', 'Libardo roseeo', 'DSN327', '2602441', 16, 11, 2, '2023-09-01 06:41:22', 60000, 60000, 40, '2023-09-01 09:12:20', '2023-09-01 09:12:20'),
(109, '2023-09-01 09:15:09', 'Emerson gomez', 'MYO59C', '3146900758', 33, 22, 2, '2023-09-01 07:36:42', 16000, 16000, 40, '2023-09-01 09:15:09', '2023-09-01 09:15:09'),
(110, '2023-09-01 09:46:21', 'Yeraldim', 'JJX93F', '3215468987', 32, 9, 2, '2023-09-01 06:40:45', 14000, 14000, 40, '2023-09-01 09:46:21', '2023-09-01 09:46:21'),
(111, '2023-09-01 10:34:37', 'Albwrto', 'LEW103', '3022467641', 10, 20, 2, '2023-09-01 06:56:03', 35000, 35000, 40, '2023-09-01 10:34:37', '2023-09-01 10:34:37'),
(112, '2023-09-01 11:31:19', 'Felipe', 'JBA84G', '3216547889', 32, 16, 2, '2023-09-01 07:05:18', 14000, 14000, 40, '2023-09-01 11:31:19', '2023-09-01 11:31:19'),
(113, '2023-09-01 11:39:58', 'Andrés miranda', 'LWO73E', '3137101102', 32, 12, 2, '2023-09-01 06:54:05', 14000, 14000, 40, '2023-09-01 11:39:58', '2023-09-01 11:39:58'),
(114, '2023-09-01 11:59:03', 'Alexander', 'QTA06F', '3242080042', 32, 20, 2, '2023-09-01 06:56:03', 14000, 14000, 40, '2023-09-01 11:59:03', '2023-09-01 11:59:03'),
(115, '2023-09-01 01:25:36', 'Pelusa amigo', 'AMY46E', '3245968584', 32, 10, 2, '2023-09-01 07:14:26', 14000, 14000, 40, '2023-09-01 13:25:36', '2023-09-01 13:25:36'),
(116, '2023-09-01 01:27:57', 'Luis alberto', 'AXG61F', '3136819163', 33, 12, 2, '2023-09-01 06:54:05', 16000, 16000, 40, '2023-09-01 13:27:57', '2023-09-01 13:27:57'),
(117, '2023-09-01 02:34:57', 'Yeison', 'JBP11D', '3160465130', 33, 10, 2, '2023-09-01 07:14:26', 16000, 16000, 40, '2023-09-01 14:34:57', '2023-09-01 14:34:57'),
(118, '2023-09-01 03:07:48', 'Maria', 'GDQ60E', '3156399601', 32, 21, 2, '2023-09-01 07:07:23', 14000, 14000, 40, '2023-09-01 15:07:48', '2023-09-01 15:07:48'),
(119, '2023-09-01 03:13:54', 'Nathaly', 'UWV 45E', '3122138180', 33, 16, 2, '2023-09-01 07:05:18', 16000, 16000, 40, '2023-09-01 15:13:54', '2023-09-01 15:13:54'),
(120, '2023-09-01 03:15:54', 'Dani', 'JIX 033', '3174829137', 37, 12, 2, '2023-09-01 06:54:05', 20000, 20000, 40, '2023-09-01 15:15:54', '2023-09-01 15:15:54'),
(121, '2023-09-01 03:33:04', 'Kebni', 'IPV90F', '3116455522', 33, 22, 2, '2023-09-01 07:36:42', 16000, 16000, 40, '2023-09-01 15:33:04', '2023-09-01 15:33:04'),
(122, '2023-09-01 03:53:32', 'Roberto cortez', 'JDG58G', '3158789825', 34, 21, 2, '2023-09-01 07:07:23', 20000, 20000, 40, '2023-09-01 15:53:32', '2023-09-01 15:53:32'),
(123, '2023-09-01 04:41:57', 'Ewduardo', 'JZD932', '3217611957', 37, 10, 2, '2023-09-01 07:14:26', 20000, 20000, 40, '2023-09-01 16:41:57', '2023-09-01 16:41:57'),
(124, '2023-09-01 04:59:07', 'Makita colombiano sas', 'EQZ521', '3132243250', 19, 3, 2, '2023-09-01 06:38:56', 85000, 85000, 40, '2023-09-01 16:59:07', '2023-09-01 16:59:07'),
(125, '2023-09-01 05:03:34', 'Esteban', 'ADW66E', '3162920865', 32, 12, 2, '2023-09-01 06:54:05', 14000, 14000, 40, '2023-09-01 17:03:34', '2023-09-01 17:03:34'),
(126, '2023-09-01 05:16:56', 'Jenifer', 'SFR15C', '3216194575', 32, 20, 2, '2023-09-01 06:56:03', 14000, 14000, 40, '2023-09-01 17:16:56', '2023-09-01 17:16:56'),
(127, '2023-09-01 05:18:41', 'Argenis', 'MKX09G', '3122335270', 32, 21, 2, '2023-09-01 07:07:23', 14000, 14000, 40, '2023-09-01 17:18:41', '2023-09-01 17:18:41'),
(128, '2023-09-01 05:21:39', 'Fernando', 'UBS 079', '3117249027', 37, 22, 2, '2023-09-01 07:36:42', 20000, 20000, 40, '2023-09-01 17:21:39', '2023-09-01 17:21:39'),
(129, '2023-09-01 05:41:43', 'Rocío', 'CFD 134', '3128602219', 37, 10, 2, '2023-09-01 07:14:26', 20000, 20000, 40, '2023-09-01 17:41:43', '2023-09-01 17:41:43'),
(130, '2023-09-01 06:24:27', 'Rocio', 'QRH 21F', '3125480678', 32, 20, 2, '2023-09-01 06:56:03', 14000, 14000, 40, '2023-09-01 18:24:27', '2023-09-01 18:24:27'),
(131, '2023-09-01 06:44:07', 'edinson', 'CKF 895', '3178602070', 37, 16, 2, '2023-09-01 07:05:18', 20000, 20000, 40, '2023-09-01 18:44:07', '2023-09-01 18:44:07'),
(132, '2023-09-01 06:52:14', 'miguel', 'CMF-71G', '3234567812', 33, 12, 2, '2023-09-01 06:54:05', 16000, 16000, 40, '2023-09-01 18:52:14', '2023-09-01 18:52:14'),
(133, '2023-09-01 07:03:56', 'jhon', 'FPQ.48F', '3123908856', 32, 16, 2, '2023-09-01 07:05:18', 14000, 14000, 40, '2023-09-01 19:03:56', '2023-09-01 19:03:56'),
(134, '2023-09-01 07:34:21', 'karolina', 'MMQ-08G', '3023104892', 32, 22, 2, '2023-09-01 07:36:42', 14000, 14000, 40, '2023-09-01 19:34:21', '2023-09-01 19:34:21'),
(135, '2023-09-02 08:44:10', 'Guillermo', 'ZAA692', '3239964643', 37, 20, 2, '2023-09-03 04:42:22', 20000, 20000, 40, '2023-09-02 08:44:10', '2023-09-02 08:44:10'),
(136, '2023-09-02 08:46:09', 'Camilo', 'IQS67E', '3206671286', 33, 21, 2, '2023-09-03 04:42:57', 16000, 16000, 40, '2023-09-02 08:46:09', '2023-09-02 08:46:09'),
(137, '2023-09-02 09:17:37', 'Panaderia', 'SXY30', '3215698475', 32, 3, 2, '2023-09-03 04:33:22', 14000, 14000, 40, '2023-09-02 09:17:37', '2023-09-02 09:17:37'),
(138, '2023-09-02 09:19:24', 'Maximiliano', 'QST64F', '3163405154', 32, 12, 2, '2023-09-03 04:35:29', 14000, 14000, 40, '2023-09-02 09:19:24', '2023-09-02 09:19:24'),
(139, '2023-09-02 09:38:31', 'Sofia', 'PRN19G', '3226118631', 34, 16, 2, '2023-09-03 04:35:57', 20000, 20000, 40, '2023-09-02 09:38:31', '2023-09-02 09:38:31'),
(140, '2023-09-02 09:44:15', 'Brayan', 'UEI68D', '3116834484', 32, 11, 2, '2023-09-03 04:35:06', 14000, 14000, 40, '2023-09-02 09:44:15', '2023-09-02 09:44:15'),
(141, '2023-09-02 09:44:24', 'Brayan', 'UEI68D', '3116834484', 32, 11, 2, '2023-09-03 04:35:06', 14000, 14000, 40, '2023-09-02 09:44:24', '2023-09-02 09:44:24'),
(142, '2023-09-02 10:28:53', 'Jhon esison', 'SGO70F', '3235215257', 32, 20, 2, '2023-09-03 04:42:22', 14000, 14000, 40, '2023-09-02 10:28:53', '2023-09-02 10:28:53'),
(143, '2023-09-02 10:30:52', 'Alberto', 'IDM76A', '3233220912', 32, 16, 2, '2023-09-03 04:35:57', 14000, 14000, 40, '2023-09-02 10:30:52', '2023-09-02 10:30:52'),
(144, '2023-09-02 10:48:45', 'Valería rios', 'HQC88G', '3128266617', 32, 12, 2, '2023-09-03 04:35:29', 14000, 14000, 40, '2023-09-02 10:48:45', '2023-09-02 10:48:45'),
(145, '2023-09-02 11:03:02', 'Lizet', 'HNL59F', '3183771256', 32, 3, 2, '2023-09-03 04:33:22', 14000, 14000, 40, '2023-09-02 11:03:02', '2023-09-02 11:03:02'),
(146, '2023-09-02 11:10:55', 'Rubwn valencia', 'ACS48D', '3215913308', 32, 11, 2, '2023-09-03 04:35:06', 14000, 14000, 40, '2023-09-02 11:10:55', '2023-09-02 11:10:55'),
(147, '2023-09-02 11:23:28', 'David santos', 'CBZ980', '3157769155', 37, 20, 2, '2023-09-03 04:42:22', 20000, 20000, 40, '2023-09-02 11:23:28', '2023-09-02 11:23:28'),
(148, '2023-09-02 11:37:24', 'Juan fernando', 'WMW247', '3124339462', 39, 16, 2, '2023-09-03 04:35:57', 18000, 18000, 40, '2023-09-02 11:37:24', '2023-09-02 11:37:24'),
(149, '2023-09-02 11:41:08', 'Dimar bermudez', 'OJT81D', '3116975323', 33, 9, 2, '2023-09-03 04:33:50', 16000, 16000, 40, '2023-09-02 11:41:08', '2023-09-02 11:41:08'),
(150, '2023-09-02 11:46:53', 'JHOAn', 'UEJ06F', '3154013785', 34, 12, 2, '2023-09-03 04:35:29', 20000, 20000, 40, '2023-09-02 11:46:53', '2023-09-02 11:46:53'),
(151, '2023-09-02 12:00:51', 'Jhon jarol', 'UBS698  -12312', '3218663131', 37, 10, 2, '2023-09-03 04:34:42', 20000, 20000, 40, '2023-09-02 12:00:51', '2023-09-02 12:00:51'),
(152, '2023-09-02 12:04:50', 'Leydi verdugo', 'WVW42D', '3022596760', 34, 11, 2, '2023-09-03 04:35:06', 20000, 20000, 40, '2023-09-02 12:04:50', '2023-09-02 12:04:50'),
(153, '2023-09-02 12:16:43', 'Eider delgado', 'FZX048', '3105337065', 38, 3, 2, '2023-09-03 04:33:22', 35000, 35000, 40, '2023-09-02 12:16:43', '2023-09-02 12:16:43'),
(154, '2023-09-02 12:26:31', 'Diego trujillo', 'IPZ609', '3186269281', 37, 21, 2, '2023-09-03 04:42:57', 20000, 20000, 40, '2023-09-02 12:26:31', '2023-09-02 12:26:31'),
(155, '2023-09-02 12:47:19', 'Oscar garzon', 'OFI20C', '3167460493', 34, 9, 2, '2023-09-03 04:33:50', 20000, 20000, 40, '2023-09-02 12:47:19', '2023-09-02 12:47:19'),
(156, '2023-09-02 12:55:59', 'Liña Fernanda graldo', 'CLX71G', '3122349883', 34, 20, 2, '2023-09-03 04:42:22', 20000, 20000, 40, '2023-09-02 12:55:59', '2023-09-02 12:55:59'),
(157, '2023-09-02 01:09:40', 'Estivwn', 'LYU243', '3204965663', 10, 16, 2, '2023-09-03 04:35:57', 35000, 35000, 40, '2023-09-02 13:09:40', '2023-09-02 13:09:40'),
(158, '2023-09-02 01:18:25', 'Francisco', 'HNF94F', '3206652213', 34, 12, 2, '2023-09-03 04:35:29', 20000, 20000, 40, '2023-09-02 13:18:25', '2023-09-02 13:18:25'),
(159, '2023-09-02 01:57:39', 'Juan savia', 'TYG19F', '3152081231', 33, 11, 2, '2023-09-03 04:51:00', 16000, 16000, 40, '2023-09-02 13:57:39', '2023-09-02 13:57:39'),
(160, '2023-09-02 02:19:07', 'Jaime', 'IPM666', '3105011629', 10, 9, 2, '2023-09-03 04:33:50', 35000, 35000, 40, '2023-09-02 14:19:07', '2023-09-02 14:19:07'),
(161, '2023-09-02 02:40:34', 'Jordi', 'JBA61G', '3158439375', 33, 21, 2, '2023-09-03 04:42:57', 16000, 16000, 40, '2023-09-02 14:40:34', '2023-09-02 14:40:34'),
(162, '2023-09-02 02:42:25', 'Tereza', 'RBQ10E', '3125858070', 32, 12, 2, '2023-09-03 04:35:29', 14000, 14000, 40, '2023-09-02 14:42:25', '2023-09-02 14:42:25'),
(163, '2023-09-02 03:10:02', 'Alexander largo', 'PXZ23F', '3186506269', 32, 11, 2, '2023-09-03 04:35:06', 14000, 14000, 40, '2023-09-02 15:10:02', '2023-09-02 15:10:02'),
(164, '2023-09-02 03:16:49', 'Alejansro', 'COY33F', '3207679501', 34, 9, 2, '2023-09-03 04:33:50', 20000, 20000, 40, '2023-09-02 15:16:49', '2023-09-02 15:16:49'),
(165, '2023-09-02 03:18:04', 'Cristián diaz', 'NCH23F', '3207130620', 32, 21, 2, '2023-09-03 04:42:57', 14000, 14000, 40, '2023-09-02 15:18:04', '2023-09-02 15:18:04'),
(166, '2023-09-02 03:21:34', 'Alberto', 'DEL138', '3215649875', 10, 12, 2, '2023-09-03 04:35:29', 35000, 35000, 40, '2023-09-02 15:21:34', '2023-09-02 15:21:34'),
(167, '2023-09-02 03:32:12', 'Jimena', 'KHZ580', '3156864485', 32, 20, 2, '2023-09-03 04:42:22', 14000, 14000, 40, '2023-09-02 15:32:12', '2023-09-02 15:32:12'),
(168, '2023-09-02 03:41:42', 'Andrés ribera', 'DEM52D', '3243528207', 35, 20, 2, '2023-09-03 04:42:22', 30000, 30000, 40, '2023-09-02 15:41:42', '2023-09-02 15:41:42'),
(169, '2023-09-02 03:45:24', 'Fernando', 'YBE64C', '3107952847', 32, 16, 2, '2023-09-03 04:35:57', 14000, 14000, 40, '2023-09-02 15:45:24', '2023-09-02 15:45:24'),
(170, '2023-09-02 03:49:02', 'MARia pelusa', 'HMK056', '3206067018', 32, 10, 2, '2023-09-03 04:34:42', 14000, 14000, 40, '2023-09-02 15:49:02', '2023-09-02 15:49:02'),
(171, '2023-09-02 03:51:28', 'Mafia pelusa', 'PSE226', '3206067018', 32, 10, 2, '2023-09-03 04:34:42', 14000, 14000, 40, '2023-09-02 15:51:28', '2023-09-02 15:51:28'),
(172, '2023-09-02 04:07:49', 'ELBIs murilo', 'KRF15F', '3122414884', 32, 20, 2, '2023-09-03 04:42:22', 14000, 14000, 40, '2023-09-02 16:07:49', '2023-09-02 16:07:49'),
(173, '2023-09-02 04:16:34', 'Hernan arango', 'WDD01F', '3017699010', 33, 21, 2, '2023-09-03 04:42:57', 16000, 16000, 40, '2023-09-02 16:16:34', '2023-09-02 16:16:34'),
(174, '2023-09-02 04:18:17', 'Cliwn albwrto', 'MUB56 NMAX', '3215649876', 32, 12, 2, '2023-09-03 04:35:29', 14000, 14000, 40, '2023-09-02 16:18:17', '2023-09-02 16:18:17'),
(175, '2023-09-02 04:19:21', 'Cliente pelusa mecanico', 'JPE19E', '3215468975', 32, 10, 2, '2023-09-03 04:34:42', 14000, 14000, 40, '2023-09-02 16:19:21', '2023-09-02 16:19:21'),
(176, '2023-09-02 04:53:44', 'Dilan', 'FSQ97E', '3113509035', 33, 16, 2, '2023-09-03 04:35:57', 16000, 16000, 40, '2023-09-02 16:53:44', '2023-09-02 16:53:44'),
(177, '2023-09-02 05:00:02', 'Andrés cortes', 'LYR075', '3206490368', 37, 9, 2, '2023-09-03 04:33:50', 20000, 20000, 40, '2023-09-02 17:00:02', '2023-09-02 17:00:02'),
(178, '2023-09-02 05:01:51', 'Andrés cortes', 'LYR075', '3206490368', 37, 9, 2, '2023-09-03 04:33:50', 20000, 20000, 40, '2023-09-02 17:01:51', '2023-09-02 17:01:51'),
(179, '2023-09-02 05:11:02', 'Perrera', 'PRR346', '3214569632', 25, 3, 2, '2023-09-03 04:33:22', 30000, 30000, 40, '2023-09-02 17:11:02', '2023-09-02 17:11:02'),
(180, '2023-09-02 05:21:05', 'Mauricio', 'PRB73G', '3013655485', 32, 16, 2, '2023-09-03 04:35:57', 14000, 14000, 40, '2023-09-02 17:21:05', '2023-09-02 17:21:05'),
(181, '2023-09-02 05:22:52', 'Diana orejuela', 'FRA87F', '3177638760', 32, 10, 2, '2023-09-03 04:34:42', 14000, 14000, 40, '2023-09-02 17:22:52', '2023-09-02 17:22:52'),
(182, '2023-09-02 05:29:09', 'Diego ordoñes', 'UBP885', '3125295539', 37, 20, 2, '2023-09-03 04:42:22', 20000, 20000, 40, '2023-09-02 17:29:09', '2023-09-02 17:29:09'),
(183, '2023-09-02 06:25:58', 'Eduardo', 'HEL640', '3113318012', 20, 3, 2, '2023-09-03 04:33:22', 95000, 95000, 40, '2023-09-02 18:25:58', '2023-09-02 18:25:58'),
(184, '2023-09-02 06:37:17', 'olgas', 'MMN345', '323456786', 32, 21, 2, '2023-09-03 04:42:57', 14000, 14000, 40, '2023-09-02 18:37:17', '2023-09-02 18:37:17'),
(185, '2023-09-02 06:48:07', 'jorge', 'GTY34G', '324578678', 35, 11, 2, '2023-09-03 04:35:06', 30000, 30000, 40, '2023-09-02 18:48:07', '2023-09-02 18:48:07');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `compra`
--
ALTER TABLE `compra`
  ADD PRIMARY KEY (`id`,`estado_id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_compra_condiciones1_idx` (`condiciones_id`),
  ADD KEY `fk_compra_estado1_idx` (`estado_id`);

--
-- Indices de la tabla `condiciones`
--
ALTER TABLE `condiciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `detalle_compra_productos`
--
ALTER TABLE `detalle_compra_productos`
  ADD PRIMARY KEY (`id_detalle_compra`),
  ADD KEY `fk_producto_has_compra_compra1_idx` (`id_compra`),
  ADD KEY `fk_producto_has_compra_producto1_idx` (`id_producto`);

--
-- Indices de la tabla `detalle_paquete`
--
ALTER TABLE `detalle_paquete`
  ADD PRIMARY KEY (`id`,`id_tipo_vehiculo`,`id_paquete`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_paquete_tipo_vehiculo1_idx` (`id_tipo_vehiculo`),
  ADD KEY `fk_paquete_paquete1_idx` (`id_paquete`);

--
-- Indices de la tabla `detalle_venta_productos`
--
ALTER TABLE `detalle_venta_productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `fk_venta_has_detalle_compra_productos_venta1_idx` (`id_venta`),
  ADD KEY `fk_detalle_venta_productos_producto1_idx` (`id_detalle_producto`) USING BTREE;

--
-- Indices de la tabla `egresos_concepto`
--
ALTER TABLE `egresos_concepto`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `egresos_mensuales`
--
ALTER TABLE `egresos_mensuales`
  ADD PRIMARY KEY (`id`,`id_concepto`),
  ADD KEY `fk_egresos_mensuales_egresos_concepto1_idx` (`id_concepto`);

--
-- Indices de la tabla `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `estado_venta`
--
ALTER TABLE `estado_venta`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `marca`
--
ALTER TABLE `marca`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `paquete`
--
ALTER TABLE `paquete`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `presentacion`
--
ALTER TABLE `presentacion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id`,`id_tipo_producto`,`id_unidad_medida`),
  ADD KEY `fk_producto_marca_idx` (`id_marca`),
  ADD KEY `fk_producto_tipo_producto1_idx` (`id_tipo_producto`),
  ADD KEY `fk_producto_unidad_medida1_idx` (`id_unidad_medida`),
  ADD KEY `fk_producto_presentacion1_idx` (`id_presentacion`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_slug_unique` (`slug`);

--
-- Indices de la tabla `role_user`
--
ALTER TABLE `role_user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `role_user_role_id_index` (`role_id`),
  ADD KEY `role_user_user_id_index` (`user_id`);

--
-- Indices de la tabla `servicio`
--
ALTER TABLE `servicio`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `servicio_paquete`
--
ALTER TABLE `servicio_paquete`
  ADD PRIMARY KEY (`id`,`id_paquete`),
  ADD KEY `fk_servicio_tipo_vehiculo_servicio1_idx` (`id_servicio`),
  ADD KEY `fk_servicio_tipo_vehiculo_paquete1_idx` (`id_paquete`);

--
-- Indices de la tabla `system_menu`
--
ALTER TABLE `system_menu`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `system_menu_role`
--
ALTER TABLE `system_menu_role`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_role` (`id_role`),
  ADD KEY `id_menu` (`id_menu`);

--
-- Indices de la tabla `system_submenu`
--
ALTER TABLE `system_submenu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_menu` (`id_menu`),
  ADD KEY `permiso_requerido` (`permiso_requerido`);

--
-- Indices de la tabla `tipo_producto`
--
ALTER TABLE `tipo_producto`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tipo_vehiculo`
--
ALTER TABLE `tipo_vehiculo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `unidad_medida`
--
ALTER TABLE `unidad_medida`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`id`,`id_estado_venta`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_venta_detalle_paquete1_idx` (`id_detalle_paquete`),
  ADD KEY `fk_venta_estado_venta1_idx` (`id_estado_venta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `area`
--
ALTER TABLE `area`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `compra`
--
ALTER TABLE `compra`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `condiciones`
--
ALTER TABLE `condiciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `detalle_compra_productos`
--
ALTER TABLE `detalle_compra_productos`
  MODIFY `id_detalle_compra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT de la tabla `detalle_paquete`
--
ALTER TABLE `detalle_paquete`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT de la tabla `detalle_venta_productos`
--
ALTER TABLE `detalle_venta_productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `egresos_mensuales`
--
ALTER TABLE `egresos_mensuales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `estado`
--
ALTER TABLE `estado`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `estado_venta`
--
ALTER TABLE `estado_venta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `marca`
--
ALTER TABLE `marca`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `paquete`
--
ALTER TABLE `paquete`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `presentacion`
--
ALTER TABLE `presentacion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `role_user`
--
ALTER TABLE `role_user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `servicio`
--
ALTER TABLE `servicio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `servicio_paquete`
--
ALTER TABLE `servicio_paquete`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=228;

--
-- AUTO_INCREMENT de la tabla `system_menu`
--
ALTER TABLE `system_menu`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `system_menu_role`
--
ALTER TABLE `system_menu_role`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `system_submenu`
--
ALTER TABLE `system_submenu`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `tipo_producto`
--
ALTER TABLE `tipo_producto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `tipo_vehiculo`
--
ALTER TABLE `tipo_vehiculo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `unidad_medida`
--
ALTER TABLE `unidad_medida`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `venta`
--
ALTER TABLE `venta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `compra`
--
ALTER TABLE `compra`
  ADD CONSTRAINT `fk_compra_condiciones1` FOREIGN KEY (`condiciones_id`) REFERENCES `condiciones` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_compra_estado1` FOREIGN KEY (`estado_id`) REFERENCES `estado` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_paquete`
--
ALTER TABLE `detalle_paquete`
  ADD CONSTRAINT `fk_paquete_paquete1` FOREIGN KEY (`id_paquete`) REFERENCES `paquete` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_paquete_tipo_vehiculo1` FOREIGN KEY (`id_tipo_vehiculo`) REFERENCES `tipo_vehiculo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
