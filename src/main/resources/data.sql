INSERT INTO projects (name, description)
VALUES
    ('RBPO Labs', 'Project for laboratory task tracking'),
    ('Course Work', 'Course work preparation')
ON CONFLICT (name) DO NOTHING;

INSERT INTO app_users (username, email)
VALUES
    ('ivan', 'ivan@example.com'),
    ('anna', 'anna@example.com'),
    ('maria', 'maria@example.com')
ON CONFLICT (username) DO NOTHING;

INSERT INTO tags (name, color)
VALUES
    ('backend', '#2563EB'),
    ('urgent', '#DC2626'),
    ('docs', '#16A34A')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tasks (title, description, status, project_id, user_id, created_at)
SELECT 'Connect PostgreSQL', 'Move CRUD operations from memory to database', 'OPEN', p.id, u.id, CURRENT_TIMESTAMP
FROM projects p
JOIN app_users u ON u.username = 'ivan'
WHERE p.name = 'RBPO Labs'
ON CONFLICT ON CONSTRAINT uk_tasks_project_title DO NOTHING;

INSERT INTO tasks (title, description, status, project_id, user_id, created_at)
SELECT 'Prepare README', 'Describe service entities and operations', 'IN_PROGRESS', p.id, u.id, CURRENT_TIMESTAMP
FROM projects p
JOIN app_users u ON u.username = 'anna'
WHERE p.name = 'RBPO Labs'
ON CONFLICT ON CONSTRAINT uk_tasks_project_title DO NOTHING;

INSERT INTO task_tags (task_id, tag_id)
SELECT t.id, tag.id
FROM tasks t
JOIN tags tag ON tag.name = 'backend'
WHERE t.title = 'Connect PostgreSQL'
ON CONFLICT ON CONSTRAINT uk_task_tags_task_tag DO NOTHING;

INSERT INTO task_tags (task_id, tag_id)
SELECT t.id, tag.id
FROM tasks t
JOIN tags tag ON tag.name = 'docs'
WHERE t.title = 'Prepare README'
ON CONFLICT ON CONSTRAINT uk_task_tags_task_tag DO NOTHING;

INSERT INTO task_comments (task_id, user_id, content, created_at)
SELECT t.id, u.id, 'Initial test comment', CURRENT_TIMESTAMP
FROM tasks t
JOIN app_users u ON u.username = 'maria'
WHERE t.title = 'Connect PostgreSQL'
ON CONFLICT ON CONSTRAINT uk_comments_task_author_content DO NOTHING;
