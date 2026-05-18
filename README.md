# Task Management API

Тема проекта: управление задачами.

Сервис помогает вести проекты, задачи, пользователей, теги и комментарии. Задача принадлежит проекту, может быть назначена пользователю, может иметь несколько тегов и комментарии.

## Основные сущности

- `Project` - проект.
- `Task` - задача проекта.
- `User` - пользователь, которому назначаются задачи.
- `Tag` - тег для маркировки задач.
- `Comment` - комментарий к задаче.

## Что умеет сервис

CRUD для каждой сущности:

- `POST` - создать запись.
- `GET` - получить список.
- `GET /{id}` - получить запись по id.
- `PUT /{id}` - изменить запись.
- `DELETE /{id}` - удалить запись.

Бизнес-операции:

- Назначить задачу пользователю.
- Добавить тег к задаче.
- Удалить тег у задачи.
- Изменить статус задачи с проверкой перехода `OPEN -> IN_PROGRESS -> DONE`.
- Добавить комментарий к задаче.
- Получить статистику задач проекта.

## Что нужно установить

1. JDK 21.
2. PostgreSQL для Windows: https://www.postgresql.org/download/windows/
3. Желательно pgAdmin, он обычно ставится вместе с PostgreSQL.
4. Для проверки запросов можно использовать один из вариантов:
   - Postman;
   - IntelliJ IDEA HTTP Client;
   - VS Code + расширение REST Client;
   - PowerShell `Invoke-RestMethod`.

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

Эти команды задают переменные только для текущего окна терминала. Если хочешь сохранить их постоянно:

```powershell
[Environment]::SetEnvironmentVariable("DB_URL", "jdbc:postgresql://localhost:5432/task_manager", "User")
[Environment]::SetEnvironmentVariable("DB_USERNAME", "task_user", "User")
[Environment]::SetEnvironmentVariable("DB_PASSWORD", "task_password", "User")
```

После постоянной настройки нужно закрыть и открыть терминал заново.

Пример переменных есть в `.env.example`.

## Запуск

Из корня проекта:

```powershell
cd "C:\Users\golov\Desktop\RBPO Labs\demo"
.\mvnw.cmd spring-boot:run
```

При первом запуске Spring Boot создаст таблицы по JPA-сущностям и добавит тестовые записи из `src/main/resources/data.sql`.

## Проверка

Проверить сборку:

```powershell
.\mvnw.cmd test
```

Проверить API в браузере:

```text
http://localhost:8080/api/projects
http://localhost:8080/api/tasks
http://localhost:8080/api/users
http://localhost:8080/api/tags
http://localhost:8080/api/comments
```

Для `POST`, `PUT`, `PATCH`, `DELETE` используй файл `requests.http` в корне проекта или Postman.

Пример создания задачи:

```http
POST http://localhost:8080/api/tasks
Content-Type: application/json

{
  "title": "Check API collection",
  "description": "Run all HTTP requests from requests.http",
  "status": "OPEN",
  "projectId": 1,
  "userId": 1,
  "tagIds": [1]
}
```

Пример бизнес-операции:

```http
PATCH http://localhost:8080/api/operations/tasks/1/assign/2
```

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
- уникальное имя тега;
- уникальное название задачи внутри одного проекта;
- уникальная пара `task_id` + `tag_id`;
- уникальный одинаковый комментарий одного автора к одной задаче.
