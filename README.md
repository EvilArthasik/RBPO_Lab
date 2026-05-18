# Task Management API

Тема проекта: управление задачами.

Сервис помогает вести проекты, задачи, пользователей, теги и комментарии. Задача принадлежит проекту, может быть назначена пользователю, может иметь несколько тегов и комментарии.

## Основные сущности

- `Project` - проект.
- `Task` - задача проекта.
- `User` - пользователь, которому назначаются задачи и который используется для входа.
- `Tag` - тег для маркировки задач.
- `Comment` - комментарий к задаче.

## Безопасность

В проект подключен Spring Security:

- включен HTTP Basic Auth;
- пользователи хранятся в таблице `app_users`;
- пароли сохраняются только в виде BCrypt-хеша;
- регистрация доступна по `POST /api/auth/register`;
- первый зарегистрированный пользователь получает роль `ADMIN`, следующие пользователи получают роль `USER`;
- подготовлен `UserDetailsService`, который загружает пользователя по `username` или `email`;
- CSRF включен, токен можно получить через `GET /api/auth/csrf`;
- `POST`, `PUT`, `PATCH` и `DELETE` запросы, кроме регистрации, должны передавать CSRF-токен.

Требования к паролю при регистрации:

- минимум 8 символов;
- минимум одна цифра;
- минимум один спецсимвол.

Пример регистрации:

```http
POST http://localhost:8080/api/auth/register
Content-Type: application/json

{
  "username": "admin",
  "email": "admin@example.com",
  "password": "Strong#123"
}
```

Пример получения CSRF-токена:

```http
GET http://localhost:8080/api/auth/csrf
Authorization: Basic admin Strong#123
```

Для изменяющих запросов передавайте Basic Auth, cookie `XSRF-TOKEN` и заголовок `X-XSRF-TOKEN`. Готовые примеры есть в `requests.http`.

## Права доступа

- `GET /api/projects/**`, `GET /api/tasks/**`, `GET /api/tags/**`, `GET /api/comments/**` - любой авторизованный пользователь.
- `POST/PUT /api/projects/**`, `POST/PUT/DELETE /api/tasks/**`, `POST/PUT /api/tags/**` - `MANAGER` или `ADMIN`.
- `DELETE /api/projects/**`, `DELETE /api/tags/**`, все `/api/users/**` - только `ADMIN`.
- `POST /api/comments/**`, `POST /api/operations/tasks/{id}/comments`, `GET /api/operations/projects/{id}/summary` - любой авторизованный пользователь.
- Остальные `/api/operations/**` - `MANAGER` или `ADMIN`.

## Что умеет сервис

CRUD для каждой сущности:

- `POST` - создать запись.
- `GET` - получить список.
- `GET /{id}` - получить запись по id.
- `PUT /{id}` - изменить запись.
- `DELETE /{id}` - удалить запись.

Бизнес-операции:

- назначить задачу пользователю;
- добавить тег к задаче;
- удалить тег у задачи;
- изменить статус задачи с проверкой перехода `OPEN -> IN_PROGRESS -> DONE`;
- добавить комментарий к задаче;
- получить статистику задач проекта.

## Что нужно установить

1. JDK 21.
2. PostgreSQL для Windows: https://www.postgresql.org/download/windows/
3. Желательно pgAdmin, он обычно ставится вместе с PostgreSQL.
4. Для проверки запросов можно использовать IntelliJ IDEA HTTP Client, Postman, VS Code REST Client или PowerShell.

Maven отдельно устанавливать не нужно: в проекте уже есть `mvnw.cmd`.

## Настройка PostgreSQL

После установки PostgreSQL открой `pgAdmin` или `psql` и создай пользователя и базу:

```sql
CREATE USER task_user WITH PASSWORD 'task_password';
CREATE DATABASE task_manager OWNER task_user;
GRANT ALL PRIVILEGES ON DATABASE task_manager TO task_user;
```

Пароль можно выбрать свой. В код его записывать не нужно.

## Переменные окружения

В проекте чувствительные данные не хранятся. Их нужно задать через переменные окружения.

PowerShell:

```powershell
$env:DB_URL="jdbc:postgresql://localhost:5432/task_manager"
$env:DB_USERNAME="task_user"
$env:DB_PASSWORD="task_password"
```

Эти команды задают переменные только для текущего окна терминала. Пример переменных есть в `.env.example`.

## Запуск

Из корня проекта:

```powershell
cd "C:\Users\golov\Desktop\RBPO Labs\demo"
$env:JAVA_HOME="C:\Program Files\Eclipse Adoptium\jdk-21.0.11.10-hotspot"
.\mvnw.cmd spring-boot:run
```

При первом запуске Spring Boot создаст таблицы по JPA-сущностям и добавит только справочные записи проектов и тегов из `src/main/resources/data.sql`. Пользователи не добавляются через SQL или код.

## Проверка

Проверить сборку:

```powershell
$env:JAVA_HOME="C:\Program Files\Eclipse Adoptium\jdk-21.0.11.10-hotspot"
.\mvnw.cmd test
```

Порядок ручной проверки API:

1. Зарегистрировать первого пользователя через `POST /api/auth/register`.
2. Получить CSRF-токен через `GET /api/auth/csrf` с Basic Auth.
3. Выполнить нужные запросы из `requests.http`, передавая Basic Auth и CSRF-токен.

## Таблицы и ограничения

Таблицы создаются из JPA-сущностей:

- `projects`
- `app_users`
- `tags`
- `tasks`
- `task_tags`
- `task_comments`

Добавлены ограничения:

- уникальное имя проекта;
- уникальные `username` и `email` пользователя;
- BCrypt-хеш пароля пользователя для аккаунтов, созданных через регистрацию;
- роль пользователя: `USER`, `MANAGER` или `ADMIN`;
- уникальное имя тега;
- уникальное название задачи внутри одного проекта;
- уникальная пара `task_id` + `tag_id`;
- уникальный одинаковый комментарий одного автора к одной задаче.
