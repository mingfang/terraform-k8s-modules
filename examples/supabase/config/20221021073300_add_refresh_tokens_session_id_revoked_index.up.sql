create index if not exists refresh_tokens_session_id_revoked_idx on auth.refresh_tokens (session_id, revoked);
