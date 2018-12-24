CREATE TABLE IF NOT EXISTS person (
	id SERIAL PRIMARY KEY,
	email VARCHAR(255),
	name VARCHAR(255),
	about TEXT,
	url VARCHAR(255),
	slug VARCHAR(255),
	context_id INTEGER,
	created TIMESTAMP
);
CREATE INDEX IF NOT EXISTS person_idx ON person (email, slug);
CREATE UNIQUE INDEX IF NOT EXISTS person_slug_idx ON person (slug);

CREATE TABLE IF NOT EXISTS context (
	id SERIAL PRIMARY KEY,
	parent_id INTEGER,
	name VARCHAR(255),
	slug VARCHAR(255),
	topic TEXT,
	created TIMESTAMP
);
CREATE UNIQUE INDEX IF NOT EXISTS context_slug_idx ON context (slug);

CREATE TABLE IF NOT EXISTS member (
	id SERIAL PRIMARY KEY,
	person_id INTEGER,
	context_id INTEGER,
	invited_by INTEGER,
	leave_slug VARCHAR(255),
	invite_slug VARCHAR(255),
	active BOOLEAN DEFAULT true,
	created TIMESTAMP,
	updated TIMESTAMP
);
CREATE UNIQUE INDEX IF NOT EXISTS member_idx ON member (person_id, context_id);
CREATE UNIQUE INDEX IF NOT EXISTS member_leave_idx ON member (leave_slug);
CREATE UNIQUE INDEX IF NOT EXISTS member_invite_idx ON member (invite_slug);

CREATE TABLE IF NOT EXISTS message (
	id SERIAL PRIMARY KEY,
	context_id INTEGER,
	in_reply_to INTEGER,
	person_id INTEGER,
	content TEXT,
	created TIMESTAMP,
	updated TIMESTAMP
);
CREATE INDEX IF NOT EXISTS message_idx ON message (id, context_id, in_reply_to, created);

CREATE TABLE IF NOT EXISTS facet (
	target_id INTEGER NOT NULL,
	target_type VARCHAR(255) NOT NULL,
	facet_type VARCHAR(255) NOT NULL,
	facet_num INTEGER,
	content TEXT,
	created TIMESTAMP,
	updated TIMESTAMP
);
CREATE INDEX facet_idx ON facet (target_id, target_type, facet_type, facet_num);

CREATE TABLE IF NOT EXISTS email_tx (
	id VARCHAR(255) PRIMARY KEY,
	context_id INTEGER,
	message_id INTEGER,
	person_id INTEGER,
	created TIMESTAMP
);

CREATE TABLE IF NOT EXISTS email_rx (
	id VARCHAR(255) PRIMARY KEY,
	context_id INTEGER,
	message_id INTEGER,
	person_id INTEGER,
	reply_json TEXT,
	created TIMESTAMP
);

CREATE TABLE IF NOT EXISTS route (
	slug VARCHAR(255),
	target_id INTEGER NOT NULL,
	target_type VARCHAR(255) NOT NULL,
	type VARCHAR(255) DEFAULT 'active',
	updated TIMESTAMP,
	created TIMESTAMP
);
CREATE INDEX route_idx ON route (slug, target_id, target_type);
