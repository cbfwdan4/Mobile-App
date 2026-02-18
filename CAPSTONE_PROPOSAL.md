# INFT 425 CAPSTONE PROJECT PROPOSAL

## Student Information
- **Name:** Kwao Daniel Kwabena
- **Student ID:** 224CS02001286
- **Date:** February 10, 2026
- **Proposal ID:** CS_Kwabena_736


## 1. Project Concept
**Project Title:** CampusConnect Marketplace


**Problem Statement:**
University students often struggle to buy and sell used items such as textbooks, electronics, hostel items, and accessories within campus. Most students rely on informal WhatsApp groups or word-of-mouth, which makes it difficult to:

Reach the right buyers
Trust sellers
Track listings efficiently
Organize transactions safely

There is no centralized, secure, and structured digital marketplace specifically designed for campus students.


**Target Users:**
University students
Student entrepreneurs
Campus clubs selling merchandise


**Unique Aspect:**
What makes this different:

Restricted to verified university students only
Clean mobile-first design
Built-in chat between buyer and seller
Organized by categories (Books, Electronics, Hostel Items, Fashion, etc.)
Simple and secure posting with photo upload


Unlike WhatsApp groups, this app provides structure, search, and accountability.


## 2. Technical Requirements
Platform & Technologies

Frontend: Flutter (Mobile Application)
Backend: C# ASP.NET Web API
Database: Firebase Firestore
Authentication: Firebase Email & Password Authentication


**Core Features (MVP - Must Have):**
1. ✅ User Authentication
Email & Password login
User registration
Logout functionality

2. ✅ Database Operations
Store user profiles
Store product listings
Store messages

3. ✅ Device API Integration
Camera integration for uploading product images

4. ✅ CRUD Operations
Create listing
Read listings
Update listing
Delete listing

5. ✅ At least 5 Connected Screens



**Advanced Features (Nice to Have):**
Push notifications for new messages
Search and filter system
Dark mode support



## 3. Screen Layout
1. **Login/Register Screen** – User authentication
2. **Home/Dashboard Screen**  – View latest listings
3. **Create Listing Screen** – Add new product (Camera integration)
4. **Listing Details Screen** – View item details
5. **Chat Screen** – Buyer & seller messaging
4. **Profile/Settings** Screen – User account management





## 4. Data Structure
The app will store the following data:


1. **User Profiles**
userId (String)
fullName (String)
email (String)
phoneNumber (String)
profileImage (String URL)
dateJoined (Timestamp)



2. **Product Listings**
listingId (String)
title (String)
description (String)
category (String)
price (Double)
imageUrl (String)
sellerId (String)
datePosted (Timestamp)
isAvailable (Boolean)



3. **Messages**
messageId (String)
senderId (String)
receiverId (String)
listingId (String)
messageText (String)
timestamp (Timestamp)


## 5. Questions/Concerns

Possible technical challenges anticipated:

Integrating Flutter frontend with C# ASP.NET backend
Managing real-time updates in Firestore
Implementing secure authentication
Handling image upload and storage efficiently
Managing state in Flutter (Provider or Riverpod)





Why This Project Makes Sense


✔ Uses Flutter (which you’ve been working with)
✔ Includes backend logic using C# (good for your programming strength)
✔ Uses Firebase (modern and scalable)
✔ Includes authentication, CRUD, API integration
✔ Real-world useful system
✔ Strong enough for capstone level