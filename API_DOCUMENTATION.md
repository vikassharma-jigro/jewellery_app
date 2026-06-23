# API Documentation

This document outlines the REST APIs consumed by the frontend application. The Base URL is defined in `ApiEndpoints.baseUrl` (e.g., `http://157.20.51.180:4007/api`).

All endpoints (except login) require a standard Authorization header:
`Authorization: Bearer <access_token>`

---

## 1. Authentication APIs

### Login
- **Endpoint:** `/auth/login`
- **Method:** `POST`
- **Purpose:** Authenticates a user and returns JWT tokens.
- **Request Body:**
  ```json
  {
    "userId": "string",
    "password": "password123"
  }
  ```
- **Success Response (200 OK):**
  ```json
  {
    "data": {
      "accessToken": "eyJhbG...",
      "refreshToken": "eyJhbG...",
      "user": {
        "id": "1",
        "username": "admin",
        "role": "admin"
      }
    }
  }
  ```
- **Error Cases:** `401 Unauthorized` (Invalid credentials), `400 Bad Request` (Missing fields).

---

## 2. Customer APIs

### Get All Customers
- **Endpoint:** `/customers`
- **Method:** `GET`
- **Purpose:** Retrieves a list of all customers.
- **Response:**
  ```json
  {
    "data": [
      {
        "_id": "60d5ec...",
        "name": "John Doe",
        "mobile": "9876543210",
        "goldBalance": 10.5,
        "jewelleryBalance": 0,
        "paymentDue": 5000
      }
    ]
  }
  ```

### Create Customer
- **Endpoint:** `/customers`
- **Method:** `POST`
- **Purpose:** Creates a new customer profile.
- **Request Body:**
  ```json
  {
    "name": "John Doe",
    "mobile": "9876543210",
    "address": "123 Main St",
    "aadhaar": "123456789012",
    "gst": "22AAAAA0000A1Z5",
    "goldBalance": 0,
    "jewelleryBalance": 0,
    "paymentDue": 0
  }
  ```

### Update Customer
- **Endpoint:** `/customers/:id`
- **Method:** `PATCH`
- **Purpose:** Updates specific fields of an existing customer.

### Delete Customer
- **Endpoint:** `/customers/:id`
- **Method:** `DELETE`
- **Purpose:** Deletes a customer.

---

## 3. Transaction APIs

### Create Transaction
- **Endpoint:** `/transactions`
- **Method:** `POST`
- **Purpose:** Records a stock movement (IN/OUT) or a payment (IN/OUT).
- **Request Body Example (Stock In):**
  ```json
  {
    "customerId": "60d5ec...",
    "type": "STOCK_IN",
    "metalType": "GOLD",
    "weight": 15.5,
    "remark": "Initial deposit",
    "currency": "INR"
  }
  ```
- **Request Body Example (Payment In):**
  ```json
  {
    "customerId": "60d5ec...",
    "type": "PAYMENT_IN",
    "amount": 25000,
    "currency": "INR"
  }
  ```

### Get Customer Transactions
- **Endpoint:** `/transactions/customer/:customerId`
- **Method:** `GET`
- **Purpose:** Retrieves the ledger/history for a specific customer.

---

## 4. Dashboard & Reports APIs

### Dashboard Summary
- **Endpoint:** `/dashboard/summary` (or similar derived from `ApiConstants.dashboardSummary`)
- **Method:** `GET`
- **Purpose:** Fetches global metrics for the home screen.
- **Response Example:**
  ```json
  {
    "data": {
      "totalReceivables": 150000,
      "totalPayables": 50000,
      "goldStock": 150.5,
      "jewelleryStock": 45.2,
      "recentTransactions": [ ... ]
    }
  }
  ```

### Get Daily Report
- **Endpoint:** `/reports/daily-transactions`
- **Method:** `GET`
- **Query Parameters:** `?date=YYYY-MM-DD`
- **Response:** Aggregates transactions into `IN` and `OUT` summaries with total quantities and amounts.

### Export Monthly Report
- **Endpoint:** `/reports/monthly-sales/export`
- **Method:** `GET`
- **Query Parameters:** `?month=10&year=2023`
- **Response:** Returns a binary stream (Excel file `.xlsx`).
