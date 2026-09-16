-- =========================================
-- BoAt Sales Data Analysis
-- File: 01_create_tables.sql
-- Purpose: Create database and create project tables 
-- =========================================

create database boAt_sales;  -- Create Database

use boat_sales;

-- Create customer_ details table
CREATE TABLE customer_details (
    CustomerID INT PRIMARY KEY,
    SignupDate DATE,
    Gender ENUM('Male', 'Female'),
    AgeBand ENUM('18-24', '25-34', '35-44', '45+'),
    Segment ENUM(
        'Young Professional',
        'Student',
        'Family Buyer',
        'Gamer',
        'Working Professional',
        'Gift Buyer'
    ),
    Tier ENUM('Tier-1', 'Tier-2', 'Tier-3'),
    City VARCHAR(50),
    State VARCHAR(50),
    Region ENUM('North', 'South', 'East', 'West', 'Central'),
    PreferredChannel VARCHAR(50),
    ActivityWeight DECIMAL(10,4)
);

-- Create Delivery_Partner_Data table
CREATE TABLE Delivery_Partner_Data (
    DeliveryPartnerID INT PRIMARY KEY,
    PartnerName VARCHAR(50),
    HomeCity VARCHAR(50),
    Region ENUM('North', 'South', 'East', 'West', 'Central'),
    VehicleType VARCHAR(30),
    Rating DECIMAL(2,1),
    ExperienceYears INT
);

-- Create Product_Details table
CREATE TABLE Product_Details (
    ProductID INT PRIMARY KEY,
    Brand VARCHAR(50) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    SubCategory VARCHAR(100) NOT NULL,
    ProductName VARCHAR(150) NOT NULL,
    HeroFlag BOOLEAN NOT NULL DEFAULT FALSE,
    LaunchYear YEAR NOT NULL,
    MRP DECIMAL(10,2) NOT NULL,
    CostPrice DECIMAL(10,2) NOT NULL,
    PopularityWeight DECIMAL(10,8),
    DemandCluster VARCHAR(20)
);

-- Create Sales_Channel table
CREATE TABLE Sales_Channel (
    ChannelID INT PRIMARY KEY,
    ChannelName VARCHAR(100) NOT NULL UNIQUE,
    ChannelType VARCHAR(50) NOT NULL,
    ChannelScope VARCHAR(50) NOT NULL,
    RegionScope VARCHAR(50) NOT NULL,
    BaseShare DECIMAL(5,4) NOT NULL
);

-- Create Sales_Data table
CREATE TABLE Sales_Data (
    SalesID INT NOT NULL PRIMARY KEY,
    OrderDate DATE NOT NULL,
    OrderHour TINYINT NOT NULL,

    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    ChannelID INT NOT NULL,
    DeliveryPartnerID INT NOT NULL,

    Quantity INT NOT NULL,

    GrossMRPValue DECIMAL(12,2) NOT NULL,
    DiscountPct DECIMAL(5,4) NOT NULL,
    DiscountAmount DECIMAL(12,2) NOT NULL,
    SellingPrice DECIMAL(12,2) NOT NULL,
    NetSales DECIMAL(12,2) NOT NULL,

    GSTRate DECIMAL(5,2) NOT NULL,
    GSTAmount DECIMAL(12,2) NOT NULL,

    COGS DECIMAL(12,2) NOT NULL,
    ShippingCost DECIMAL(10,2) NOT NULL,
    Profit DECIMAL(12,2) NOT NULL,

    PaymentMethod ENUM(
        'UPI',
        'Credit/Debit Card',
        'COD',
        'NetBanking',
        'Wallet'
    ) NOT NULL,

    OrderStatus ENUM(
        'Delivered',
        'Returned',
        'Cancelled'
    ) NOT NULL,

    CancellationReason VARCHAR(100) NULL,
    ReturnReason VARCHAR(100) NULL,

    DeliveryDays TINYINT NOT NULL,

    CustomerTier VARCHAR(20) NOT NULL,
    CustomerSegment VARCHAR(30) NOT NULL,
    CityTier VARCHAR(20) NOT NULL,
    ChannelType VARCHAR(20) NOT NULL,

    IsFestivalPeriod BOOLEAN NOT NULL,
    FestivalName VARCHAR(50) NULL,

    IsWeekend BOOLEAN NOT NULL,

    ProductCategory VARCHAR(50) NOT NULL,

    HeroFlag BOOLEAN NOT NULL
);
