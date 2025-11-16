# 📚 Library Management System

A comprehensive web-based Library Management System built with Java Servlets, JDBC, and vanilla JavaScript. This system streamlines library operations including book catalog management, issuance tracking, fine calculation, and role-based access control.

## ✨ Features

### Core Functionality
- **Book Catalog Management**: Add, update, delete, and search books by title, author, or ISBN
- **Book Issuance & Return**: Track book borrowing with automatic due date calculation (14 days default)
- **Overdue & Fine Calculation**: Automatic fine calculation ($5 per day) using database triggers
- **User Authentication**: Secure role-based login for Librarians and Students
- **Student Records**: Complete history of books issued by each student
- **Reports**: Available, issued, and overdue book reports
- **Notifications**: Due date reminders and overdue alerts

### Technical Features
- RESTful API design with JSON responses
- Connection pooling with Apache Commons DBCP
- Database triggers for automatic book availability management
- Stored procedures for fine calculations
- Responsive web interface

## 🛠️ Technology Stack

**Backend:**
- Java 11
- Servlets (javax.servlet-api 4.0.1)
- JDBC (MySQL Connector 8.0.33)
- Gson for JSON processing
- Apache Commons DBCP2 for connection pooling

**Frontend:**
- HTML5, CSS3, JavaScript (Vanilla)
- Responsive design with gradients

**Database:**
- MySQL 8.0+
- Stored Procedures & Triggers

**Build Tool:**
- Maven 3.6+

**Server:**
- Apache Tomcat 9+

## 📋 Prerequisites

Before setting up the project, ensure you have:

- ✅ JDK 11 or higher installed
- ✅ MySQL 8.0+ installed and running
- ✅ Apache Tomcat 9+ installed
- ✅ Maven 3.6+ installed
- ✅ Git (optional, for cloning)

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/SachinKumarGupta04/library-management-system.git
cd library-management-system
```

### 2. Database Setup

**Create the database:**

```bash
mysql -u root -p
```

```sql
CREATE DATABASE library_db;
QUIT;
```

**Run the schema file:**

```bash
mysql -u root -p library_db < database/schema.sql
```

This will create:
- 5 tables (users, books, issuances, fines, notifications)
- 1 stored procedure (CalculateFine)
- 2 triggers (automatic book availability management)
- Sample data (2 users, 5 books)

### 3. Configure Database Connection

Edit `src/main/resources/db.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/library_db?useSSL=false&serverTimezone=UTC
db.username=root
db.password=YOUR_MYSQL_PASSWORD
db.driver=com.mysql.cj.jdbc.Driver
```

### 4. Build the Project

```bash
mvn clean install
```

This will:
- Download all dependencies
- Compile Java source files
- Run tests (if any)
- Package the application as a WAR file in `target/` directory

### 5. Deploy to Tomcat

**Option A: Manual Deployment**

```bash
cp target/library-management-system.war $TOMCAT_HOME/webapps/
```

**Option B: Using Maven Tomcat Plugin**

Add to `pom.xml` and run:

```bash
mvn tomcat7:deploy
```

### 6. Start Tomcat

**Windows:**
```bash
%TOMCAT_HOME%\bin\startup.bat
```

**Linux/Mac:**
```bash
$TOMCAT_HOME/bin/startup.sh
```

### 7. Access the Application

Open your browser and navigate to:

```
http://localhost:8080/library-management-system/
```

## 👤 Default Credentials

### Librarian Account
- **Username**: `admin`
- **Password**: `admin123`
- **Role**: LIBRARIAN

### Student Account
- **Username**: `student1`
- **Password**: `student123`
- **Role**: STUDENT

## 📁 Project Structure

```
library-management-system/
├── database/
│   └── schema.sql              # Database schema with sample data
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/library/
│   │   │       ├── config/    # Database configuration
│   │   │       ├── model/     # POJOs (Book, User, Issuance, Fine)
│   │   │       ├── dao/       # Data Access Objects
│   │   │       ├── service/   # Business logic layer
│   │   │       ├── servlet/   # Servlet controllers
│   │   │       └── util/      # Utility classes
│   │   ├── resources/
│   │   │   └── db.properties  # Database configuration
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml    # Servlet mappings
│   │       ├── index.html     # Login page
│   │       ├── librarian-dashboard.html
│   │       ├── student-dashboard.html
│   │       └── css/
│   │           └── styles.css
│   └── test/java/             # Unit tests
├── pom.xml                     # Maven configuration
├── .gitignore
└── README.md
```

## 🔧 Configuration

### Fine Settings

Edit `src/main/resources/db.properties`:

```properties
fine.perDayAmount=5.00      # Fine amount per day
loan.defaultDays=14         # Default loan period in days
```

### Connection Pool Settings

```properties
db.pool.initialSize=5
db.pool.maxTotal=20
db.pool.maxIdle=10
db.pool.minIdle=5
```

## 📊 Database Schema

### Tables

1. **users**: Stores librarian and student accounts
2. **books**: Book catalog with ISBN, title, author, availability
3. **issuances**: Book borrowing records with dates and status
4. **fines**: Overdue fines with payment status
5. **notifications**: User notifications for due dates and fines

### Relationships

- User → Issuances (One-to-Many)
- Book → Issuances (One-to-Many)
- Issuance → Fine (One-to-One)
- User → Notifications (One-to-Many)

## 🧪 Testing

Run unit tests:

```bash
mvn test
```

## 📝 API Endpoints (To be implemented)

### Authentication
- `POST /api/login` - User authentication

### Books
- `GET /api/books` - List all books
- `GET /api/books/:id` - Get book details
- `POST /api/books` - Add new book (Librarian only)
- `PUT /api/books/:id` - Update book (Librarian only)
- `DELETE /api/books/:id` - Delete book (Librarian only)
- `GET /api/books/search?q=query` - Search books

### Issuances
- `POST /api/issuance` - Issue a book
- `POST /api/return` - Return a book
- `GET /api/issuance/student/:id` - Get student's borrowing history

### Reports
- `GET /api/reports/available` - Available books
- `GET /api/reports/issued` - Currently issued books
- `GET /api/reports/overdue` - Overdue books

### Fines
- `GET /api/fines/student/:id` - Get student's fines
- `POST /api/fines/:id/pay` - Mark fine as paid

## 🚧 Troubleshooting

### Common Issues

**1. Database Connection Failed**
- Verify MySQL is running: `systemctl status mysql`
- Check credentials in `db.properties`
- Ensure database `library_db` exists

**2. Port 8080 Already in Use**
- Change Tomcat port in `$TOMCAT_HOME/conf/server.xml`
- Or stop the process using port 8080

**3. ClassNotFoundException: com.mysql.cj.jdbc.Driver**
- Rebuild project: `mvn clean install`
- Ensure MySQL connector dependency in pom.xml

**4. 404 Error**
- Check WAR file deployed: `ls $TOMCAT_HOME/webapps/`
- Verify context path matches URL
- Check Tomcat logs: `tail -f $TOMCAT_HOME/logs/catalina.out`

## 📈 Future Enhancements

- [ ] Email notifications for due dates
- [ ] Book reservation system
- [ ] Advanced search with filters
- [ ] Export reports to PDF/Excel
- [ ] Mobile app integration
- [ ] Barcode/QR code scanning
- [ ] Integration with external library APIs

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Sachin Kumar Gupta**
- GitHub: [@SachinKumarGupta04](https://github.com/SachinKumarGupta04)

## 🙏 Acknowledgments

- Built as a learning project for Java web development
- Inspired by real-world library management requirements
- Thanks to the open-source community for tools and libraries

---

**⭐ Star this repository if you found it helpful!**
