# Campus Club Management System (CCMS)
> **A Full-Stack College Web Application built with Java (Spring Boot) and MySQL**

---

## 📌 Project Overview
The **Campus Club Management System (CCMS)** is an end-to-end college web platform designed to streamline student club registrations, event organization, attendance tracking, and administrative governance.

The system is built to replicate the **9-screen reference interface**:

| # | Screen Name | Role | Primary Features |
|---|---|---|---|
| **1** | **Login / Sign Up** | Public / All | Campus hero banner, tabbed Login/Sign-up modal, password visibility toggle, 1-click demo logins |
| **2** | **Admin Dashboard** | Admin | 4 Stat cards (Clubs, Students, Members, Events), Recent Events status tracker |
| **3** | **Admin – Manage Clubs** | Admin | Instant live search, "+ Add Club" modal, club category badges, View/Edit/Delete actions |
| **4** | **Admin – Manage Students** | Admin | Roll number & name directory, department tags, "+ Add Student" modal, profile inspections |
| **5** | **Student Dashboard** | Student | Personalized welcome ("Welcome, Mokshagna!"), club count, upcoming event table, joined clubs |
| **6** | **Student – Club Registration** | Student | 3-step interactive wizard: (1) Basic Details &rarr; (2) Select Club &rarr; (3) Confirmation summary |
| **7** | **Club Coordinator Dashboard** | Coordinator | Total members, upcoming events, registrations count, recent events list with attendees |
| **8** | **Create / Update Event** | Coordinator | Form to schedule workshops, tech talks, dates (`dd-mm-yyyy`), venues, and club assignments |
| **9** | **View Registrations / Member List** | Coordinator / Admin | Event filter dropdown, roll-number attendance sheet, real-time registration status tags |

---

## 🎨 Role-Based Theming
Each role features a custom color system matching the reference design:
- 🔵 **Admin Portal**: Deep Navy (`#0f172a`) sidebar with Royal Blue active highlights (`#2563eb`).
- 🟢 **Student Portal**: Emerald / Forest Teal (`#064e3b`) sidebar with Mint Green highlights (`#059669`).
- 🟣 **Club Coordinator Portal**: Deep Violet (`#3b185f`) sidebar with Purple highlights (`#7c3aed`).

---

## 🛠️ Technology Stack
- **Backend**: Java 17+ / Java 21+ / Java 26, Spring Boot 3.2.4
  - `spring-boot-starter-web` (REST APIs & MVC Controllers)
  - `spring-boot-starter-data-jpa` (Hibernate ORM)
  - `spring-boot-starter-thymeleaf` (Server-Side HTML Rendering)
  - `mysql-connector-j` (Official MySQL Database Driver)
  - `h2database` (Embedded fallback for immediate offline demonstration)
- **Frontend**: HTML5, CSS3, Bootstrap 5.3.3, Bootstrap Icons, Plus Jakarta Sans
- **Database**: MySQL 8.0+ (Schema: `campus_club_db`)

---

## ⚡ Default Demo Credentials

| Role | Email / Username | Password | Notes |
|---|---|---|---|
| **Admin** | `admin@campus.edu` | `admin123` | Full access to clubs, students, reports, and notices |
| **Student** | `mokshagna@student.campus.edu` | `student123` | Logged-in student from Screen 5 (Roll No: `23CS010`) |
| **Coordinator** | `coordinator@campus.edu` | `coord123` | Coordinator for Coding Club & Events |

> 💡 **Tip**: The login page includes a **"Quick 1-Click Demo Logins"** bar for instant autofill!

---

## 🚀 How to Run the Application

### Option A: Running with MySQL (Recommended for College Submission)

1. **Import Database Schema**:
   Open MySQL Workbench or MySQL Command Line and run the script:
   ```sql
   source C:/Users/Badrinath/.gemini/antigravity/scratch/campus-club-management/database.sql;
   ```
   *(Or copy-paste the contents of `database.sql` into MySQL Workbench and click Execute).*

2. **Verify `application.properties`**:
   Ensure `src/main/resources/application.properties` matches your local MySQL credentials:
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/campus_club_db?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
   spring.datasource.username=root
   spring.datasource.password=your_mysql_password
   ```

3. **Start the Application**:
   Open a terminal in `campus-club-management` and run:
   ```powershell
   .\mvnw.cmd spring-boot:run
   ```

---

### Option B: Zero-Setup In-Memory Mode (H2)
If your local MySQL service is not currently running and you want to test or demonstrate the interface immediately:
```powershell
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=h2"
```

Once started, open your web browser at:
👉 **`http://localhost:8080`**

---

## 🗂️ Project Directory Structure

```
campus-club-management/
├── database.sql                        # Complete MySQL DDL & Seed Script
├── pom.xml                             # Maven Dependencies & Plugins
├── mvnw & mvnw.cmd                     # Maven Wrapper (no pre-installed Maven required)
├── README.md                           # Documentation & Submission Guide
└── src/
    └── main/
        ├── java/com/campus/club/
        │   ├── CampusClubApplication.java
        │   ├── config/
        │   │   ├── AuthInterceptor.java # Role-based route guard
        │   │   └── WebConfig.java
        │   ├── controller/
        │   │   ├── AdminController.java       # Screens 2, 3, 4
        │   │   ├── AuthController.java        # Screen 1
        │   │   ├── CoordinatorController.java # Screens 7, 8, 9
        │   │   ├── StudentController.java     # Screens 5, 6
        │   │   └── ReportController.java      # CSV Exporter
        │   ├── model/
        │   │   ├── Club.java
        │   │   ├── ClubMember.java
        │   │   ├── Event.java
        │   │   ├── EventRegistration.java
        │   │   ├── Announcement.java
        │   │   ├── ActivityLog.java
        │   │   └── User.java
        │   ├── repository/             # Spring Data JPA Repositories
        │   └── service/
        │       ├── DataInitializer.java # Seeds exact sample data matching UI
        │       ├── UserService.java
        │       ├── ClubService.java
        │       ├── EventService.java
        │       ├── AnnouncementService.java
        │       └── ReportService.java
        └── resources/
            ├── application.properties
            ├── application-h2.properties
            ├── static/
            │   ├── css/styles.css      # Custom UI theme & responsive rules
            │   └── js/main.js          # Tab switching, wizard stepper, search
            └── templates/
                ├── index.html
                ├── login.html           # Screen 1
                ├── admin/
                │   ├── dashboard.html   # Screen 2
                │   ├── clubs.html       # Screen 3
                │   ├── club_form.html
                │   ├── students.html    # Screen 4
                │   ├── members.html
                │   ├── events.html
                │   ├── reports.html
                │   └── announcements.html
                ├── student/
                │   ├── dashboard.html         # Screen 5
                │   ├── club_registration.html # Screen 6
                │   ├── clubs.html
                │   ├── events.html
                │   ├── announcements.html
                │   └── participation.html
                └── coordinator/
                    ├── dashboard.html     # Screen 7
                    ├── event_form.html    # Screen 8
                    ├── registrations.html # Screen 9
                    ├── events.html
                    ├── members.html
                    ├── announcements.html
                    └── activities.html
```
